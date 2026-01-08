import 'package:slack_clone_gautam_manwani/domain/entities/message_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Reaction model for data layer
class ReactionModel extends ReactionEntity {
  const ReactionModel({
    required super.emoji,
    required super.userId,
    required super.userName,
  });

  factory ReactionModel.fromMap(Map<String, dynamic> map) {
    return ReactionModel(
      emoji: map['emoji'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'emoji': emoji,
      'userId': userId,
      'userName': userName,
    };
  }

  ReactionEntity toEntity() {
    return ReactionEntity(
      emoji: emoji,
      userId: userId,
      userName: userName,
    );
  }
}

/// Message model for data layer (DTO)
class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.text,
    required super.senderId,
    required super.senderName,
    required super.timestamp,
    super.status,
    super.reactions,
  });

  /// Create MessageModel from Entity
  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      text: entity.text,
      senderId: entity.senderId,
      senderName: entity.senderName,
      timestamp: entity.timestamp,
      status: entity.status,
      reactions: entity.reactions,
    );
  }

  /// Create MessageModel from Firestore document
  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final reactionsData = data['reactions'] as List<dynamic>? ?? [];

    return MessageModel(
      id: doc.id,
      text: data['text'] ?? '',
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      status: _statusFromString(data['status'] ?? 'sent'),
      reactions: reactionsData
          .map((r) => ReactionModel.fromMap(r as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Convert status string to enum
  static MessageStatus _statusFromString(String status) {
    switch (status) {
      case 'sending':
        return MessageStatus.sending;
      case 'failed':
        return MessageStatus.failed;
      case 'sent':
      default:
        return MessageStatus.sent;
    }
  }

  /// Convert status enum to string
  static String _statusToString(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return 'sending';
      case MessageStatus.failed:
        return 'failed';
      case MessageStatus.sent:
        return 'sent';
    }
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'timestamp': Timestamp.fromDate(timestamp),
      'status': _statusToString(status),
      'reactions': reactions
          .map((r) => ReactionModel(
                emoji: r.emoji,
                userId: r.userId,
                userName: r.userName,
              ).toMap())
          .toList(),
    };
  }

  /// Convert to Entity
  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      text: text,
      senderId: senderId,
      senderName: senderName,
      timestamp: timestamp,
      status: status,
      reactions: reactions,
    );
  }
}
