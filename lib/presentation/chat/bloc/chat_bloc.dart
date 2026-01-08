import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slack_clone_gautam_manwani/domain/entities/message_entity.dart';
import 'package:slack_clone_gautam_manwani/domain/repositories/message_repository.dart';
import 'package:slack_clone_gautam_manwani/presentation/chat/bloc/chat_event.dart';
import 'package:slack_clone_gautam_manwani/presentation/chat/bloc/chat_state.dart';

/// Chat Bloc for managing chat messages and real-time updates
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final MessageRepository _msgRepo;
  StreamSubscription<List<MessageEntity>>? _msgSub;
  StreamSubscription<List<String>>? _typingSub;

  ChatBloc({required MessageRepository messageRepository})
      : _msgRepo = messageRepository,
        super(const ChatInitial()) {
    on<ChatMessagesSubscribed>(_onMessagesSubscribed);
    on<ChatMessagesReceived>(_onMessagesReceived);
    on<ChatMessageSent>(_onMessageSent);
    on<ChatReactionAdded>(_onReactionAdded);
    on<ChatReactionRemoved>(_onReactionRemoved);
    on<ChatTypingUpdated>(_onTypingUpdated);
    on<ChatTypingUsersReceived>(_onTypingUsersReceived);
    on<ChatDisposed>(_onDisposed);
  }

  /// Subscribe to real-time messages stream
  Future<void> _onMessagesSubscribed(
    ChatMessagesSubscribed event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatLoading());

    try {
      // Cancel existing subscriptions
      await _msgSub?.cancel();
      await _typingSub?.cancel();

      // Subscribe to messages stream
      _msgSub = _msgRepo
          .getMessagesStream(event.workspaceId, event.channelId)
          .listen(
            (messages) => add(ChatMessagesReceived(messages: messages)),
            onError: (error) => add(ChatMessagesReceived(messages: [])),
          );

      // Subscribe to typing users stream
      _typingSub = _msgRepo
          .getTypingUsersStream(event.workspaceId, event.channelId)
          .listen(
            (typingUsers) => add(ChatTypingUsersReceived(typingUsers: typingUsers)),
          );
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }

  /// Handle received messages from stream
  void _onMessagesReceived(
    ChatMessagesReceived event,
    Emitter<ChatState> emit,
  ) {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;

      // Get optimistic messages (status = sending)
      final optimisticMessages = currentState.messages
          .where((msg) => msg.status == MessageStatus.sending)
          .toList();

      // Filter out optimistic messages that have been confirmed by the stream
      // Match by text, senderId, and timestamp (within 10 seconds)
      final unconfirmedOptimistic = optimisticMessages.where((optimistic) {
        final hasMatch = event.messages.any((streamMsg) {
          final isSameText = streamMsg.text == optimistic.text;
          final isSameSender = streamMsg.senderId == optimistic.senderId;
          final timeDiff = streamMsg.timestamp.difference(optimistic.timestamp).abs();
          final isCloseInTime = timeDiff.inSeconds <= 10;

          return isSameText && isSameSender && isCloseInTime;
        });

        return !hasMatch; // Keep only if NO match found in stream
      }).toList();

      // Combine: unconfirmed optimistic messages first, then stream messages
      final mergedMessages = [
        ...unconfirmedOptimistic,
        ...event.messages,
      ];

      emit(currentState.copyWith(
        messages: mergedMessages,
        isSending: unconfirmedOptimistic.isNotEmpty,
      ));
    } else {
      emit(ChatLoaded(messages: event.messages));
    }
  }

  /// Handle sending a message (with optimistic UI)
  Future<void> _onMessageSent(
    ChatMessageSent event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatLoaded) return;

    final currentState = state as ChatLoaded;

    // Create optimistic message with temporary ID
    final optimisticMessage = MessageEntity(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      text: event.text,
      senderId: event.userId,
      senderName: event.userName,
      timestamp: DateTime.now(),
      status: MessageStatus.sending, // Mark as sending
    );

    // Add optimistic message to UI immediately
    emit(currentState.copyWith(
      messages: [optimisticMessage, ...currentState.messages],
      isSending: true,
    ));

    try {
      // Send message to Firestore (with empty ID for auto-generation)
      final firestoreMessage = MessageEntity(
        id: '', // Firestore will generate this
        text: event.text,
        senderId: event.userId,
        senderName: event.userName,
        timestamp: DateTime.now(),
        status: MessageStatus.sent,
      );

      await _msgRepo.sendMessage(
        event.workspaceId,
        event.channelId,
        firestoreMessage,
      );

      // Success! The stream will pick up the real message
      // The optimistic message will be filtered out when the real one arrives
    } catch (e) {
      // On error, update the optimistic message to show failed status
      final updatedMessages = currentState.messages.map((msg) {
        if (msg.id == optimisticMessage.id) {
          return msg.copyWith(status: MessageStatus.failed);
        }
        return msg;
      }).toList();

      emit(currentState.copyWith(
        messages: updatedMessages,
        isSending: false,
      ));
    }
  }

  /// Handle adding a reaction
  Future<void> _onReactionAdded(
    ChatReactionAdded event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final reaction = ReactionEntity(
        emoji: event.emoji,
        userId: event.userId,
        userName: event.userName,
      );

      await _msgRepo.addReaction(
        event.workspaceId,
        event.channelId,
        event.messageId,
        reaction,
      );
    } catch (e) {
      emit(ChatError(message: 'Failed to add reaction: ${e.toString()}'));
    }
  }

  /// Handle removing a reaction
  Future<void> _onReactionRemoved(
    ChatReactionRemoved event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _msgRepo.removeReaction(
        event.workspaceId,
        event.channelId,
        event.messageId,
        event.userId,
        event.emoji,
      );
    } catch (e) {
      emit(ChatError(message: 'Failed to remove reaction: ${e.toString()}'));
    }
  }

  /// Handle updating typing status
  Future<void> _onTypingUpdated(
    ChatTypingUpdated event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _msgRepo.updateTypingStatus(
        event.workspaceId,
        event.userId,
        event.userName,
        event.channelId,
        event.isTyping,
      );
    } catch (e) {
      // Silently fail for typing status updates
    }
  }

  /// Handle receiving typing users from stream
  void _onTypingUsersReceived(
    ChatTypingUsersReceived event,
    Emitter<ChatState> emit,
  ) {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      emit(currentState.copyWith(typingUsers: event.typingUsers));
    }
  }

  /// Handle disposal
  Future<void> _onDisposed(
    ChatDisposed event,
    Emitter<ChatState> emit,
  ) async {
    await _msgSub?.cancel();
    await _typingSub?.cancel();
  }

  @override
  Future<void> close() {
    _msgSub?.cancel();
    _typingSub?.cancel();
    return super.close();
  }
}
