import 'package:equatable/equatable.dart';

/// Message status enum
enum MessageStatus {
  sending,
  sent,
  failed,
}

/// Reaction entity for message reactions
class ReactionEntity extends Equatable {
  final String emoji;
  final String userId;
  final String userName;

  const ReactionEntity({
    required this.emoji,
    required this.userId,
    required this.userName,
  });

  @override
  List<Object?> get props => [emoji, userId, userName];
}

/// Message entity representing a chat message
class MessageEntity extends Equatable {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final DateTime timestamp;
  final MessageStatus status;
  final List<ReactionEntity> reactions;

  const MessageEntity({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.reactions = const [],
  });

  /// Create a copy with updated fields
  MessageEntity copyWith({
    String? id,
    String? text,
    String? senderId,
    String? senderName,
    DateTime? timestamp,
    MessageStatus? status,
    List<ReactionEntity>? reactions,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      text: text ?? this.text,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      reactions: reactions ?? this.reactions,
    );
  }

  /// Check if message is from current user
  bool isFromUser(String userId) => senderId == userId;

  /// Check if user has reacted with emoji
  bool hasUserReacted(String userId, String emoji) {
    return reactions.any((r) => r.userId == userId && r.emoji == emoji);
  }

  /// Get count for specific emoji
  int getReactionCount(String emoji) {
    return reactions.where((r) => r.emoji == emoji).length;
  }

  @override
  List<Object?> get props => [
        id,
        text,
        senderId,
        senderName,
        timestamp,
        status,
        reactions,
      ];
}
