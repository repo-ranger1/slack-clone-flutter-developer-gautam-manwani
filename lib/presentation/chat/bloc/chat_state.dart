import 'package:equatable/equatable.dart';
import 'package:slack_clone_gautam_manwani/domain/entities/message_entity.dart';

/// Base chat state
abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ChatInitial extends ChatState {
  const ChatInitial();
}

/// Loading state
class ChatLoading extends ChatState {
  const ChatLoading();
}

/// Loaded state with real-time messages
class ChatLoaded extends ChatState {
  final List<MessageEntity> messages;
  final List<String> typingUsers;
  final bool isSending;

  const ChatLoaded({
    required this.messages,
    this.typingUsers = const [],
    this.isSending = false,
  });

  /// Create a copy with updated fields
  ChatLoaded copyWith({
    List<MessageEntity>? messages,
    List<String>? typingUsers,
    bool? isSending,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      typingUsers: typingUsers ?? this.typingUsers,
      isSending: isSending ?? this.isSending,
    );
  }

  @override
  List<Object?> get props => [messages, typingUsers, isSending];
}

/// Error state
class ChatError extends ChatState {
  final String message;

  const ChatError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Sending state (optimistic UI)
class ChatSending extends ChatState {
  final MessageEntity message;

  const ChatSending({required this.message});

  @override
  List<Object?> get props => [message];
}
