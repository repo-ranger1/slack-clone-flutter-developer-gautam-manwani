import 'package:equatable/equatable.dart';
import 'package:slack_clone_gautam_manwani/domain/entities/message_entity.dart';

/// Base chat event
abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

/// Load messages event (real-time stream)
class ChatMessagesSubscribed extends ChatEvent {
  final String workspaceId;
  final String channelId;

  const ChatMessagesSubscribed({
    required this.workspaceId,
    required this.channelId,
  });

  @override
  List<Object?> get props => [workspaceId, channelId];
}

/// Messages received from stream
class ChatMessagesReceived extends ChatEvent {
  final List<MessageEntity> messages;

  const ChatMessagesReceived({required this.messages});

  @override
  List<Object?> get props => [messages];
}

/// Send message event
class ChatMessageSent extends ChatEvent {
  final String workspaceId;
  final String channelId;
  final String text;
  final String userId;
  final String userName;

  const ChatMessageSent({
    required this.workspaceId,
    required this.channelId,
    required this.text,
    required this.userId,
    required this.userName,
  });

  @override
  List<Object?> get props => [workspaceId, channelId, text, userId, userName];
}

/// Add reaction event
class ChatReactionAdded extends ChatEvent {
  final String workspaceId;
  final String channelId;
  final String messageId;
  final String emoji;
  final String userId;
  final String userName;

  const ChatReactionAdded({
    required this.workspaceId,
    required this.channelId,
    required this.messageId,
    required this.emoji,
    required this.userId,
    required this.userName,
  });

  @override
  List<Object?> get props => [
        workspaceId,
        channelId,
        messageId,
        emoji,
        userId,
        userName,
      ];
}

/// Remove reaction event
class ChatReactionRemoved extends ChatEvent {
  final String workspaceId;
  final String channelId;
  final String messageId;
  final String userId;
  final String emoji;

  const ChatReactionRemoved({
    required this.workspaceId,
    required this.channelId,
    required this.messageId,
    required this.userId,
    required this.emoji,
  });

  @override
  List<Object?> get props => [workspaceId, channelId, messageId, userId, emoji];
}

/// Update typing status event
class ChatTypingUpdated extends ChatEvent {
  final String workspaceId;
  final String userId;
  final String userName;
  final String channelId;
  final bool isTyping;

  const ChatTypingUpdated({
    required this.workspaceId,
    required this.userId,
    required this.userName,
    required this.channelId,
    required this.isTyping,
  });

  @override
  List<Object?> get props => [workspaceId, userId, userName, channelId, isTyping];
}

/// Typing users received from stream
class ChatTypingUsersReceived extends ChatEvent {
  final List<String> typingUsers;

  const ChatTypingUsersReceived({required this.typingUsers});

  @override
  List<Object?> get props => [typingUsers];
}

/// Dispose/cleanup event
class ChatDisposed extends ChatEvent {
  const ChatDisposed();
}
