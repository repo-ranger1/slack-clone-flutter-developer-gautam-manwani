import 'package:slack_clone_gautam_manwani/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// User model for data layer (DTO)
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.isTyping,
    super.typingChannelId,
  });

  /// Create UserModel from Entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      isTyping: entity.isTyping,
      typingChannelId: entity.typingChannelId,
    );
  }

  /// Create UserModel from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final typingData = data['typing'] as Map<String, dynamic>?;

    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      isTyping: typingData?['isTyping'] as bool?,
      typingChannelId: typingData?['channelId'] as String?,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      if (isTyping != null || typingChannelId != null)
        'typing': {
          'isTyping': isTyping ?? false,
          'channelId': typingChannelId,
        },
    };
  }

  /// Convert to Entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      isTyping: isTyping,
      typingChannelId: typingChannelId,
    );
  }
}
