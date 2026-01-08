import 'package:equatable/equatable.dart';

/// Channel entity representing a messaging channel
class ChannelEntity extends Equatable {
  final String id;
  final String name;
  final DateTime createdAt;
  final int unreadCount;
  final bool isActive;

  const ChannelEntity({
    required this.id,
    required this.name,
    required this.createdAt,
    this.unreadCount = 0,
    this.isActive = false,
  });

  /// Create a copy with updated fields
  ChannelEntity copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    int? unreadCount,
    bool? isActive,
  }) {
    return ChannelEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      unreadCount: unreadCount ?? this.unreadCount,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, name, createdAt, unreadCount, isActive];
}
