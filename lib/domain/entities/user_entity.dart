import 'package:equatable/equatable.dart';

/// User entity representing a user in the system
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final bool? isTyping;
  final String? typingChannelId;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.isTyping,
    this.typingChannelId,
  });

  /// Create a copy with updated fields
  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    bool? isTyping,
    String? typingChannelId,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isTyping: isTyping ?? this.isTyping,
      typingChannelId: typingChannelId ?? this.typingChannelId,
    );
  }

  @override
  List<Object?> get props => [id, name, email, isTyping, typingChannelId];
}
