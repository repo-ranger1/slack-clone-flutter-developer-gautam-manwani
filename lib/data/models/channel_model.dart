import 'package:slack_clone_gautam_manwani/domain/entities/channel_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Channel model for data layer (DTO)
class ChannelModel extends ChannelEntity {
  const ChannelModel({
    required super.id,
    required super.name,
    required super.createdAt,
    super.unreadCount,
    super.isActive,
  });

  /// Create ChannelModel from Entity
  factory ChannelModel.fromEntity(ChannelEntity entity) {
    return ChannelModel(
      id: entity.id,
      name: entity.name,
      createdAt: entity.createdAt,
      unreadCount: entity.unreadCount,
      isActive: entity.isActive,
    );
  }

  /// Create ChannelModel from Firestore document
  factory ChannelModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ChannelModel(
      id: doc.id,
      name: data['name'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      unreadCount: 0,
      isActive: false,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Convert to Entity
  ChannelEntity toEntity() {
    return ChannelEntity(
      id: id,
      name: name,
      createdAt: createdAt,
      unreadCount: unreadCount,
      isActive: isActive,
    );
  }
}
