import 'package:equatable/equatable.dart';

/// Base channel event
abstract class ChannelEvent extends Equatable {
  const ChannelEvent();

  @override
  List<Object?> get props => [];
}

/// Load channels event
class ChannelLoadRequested extends ChannelEvent {
  final String workspaceId;

  const ChannelLoadRequested({required this.workspaceId});

  @override
  List<Object?> get props => [workspaceId];
}

/// Select channel event
class ChannelSelected extends ChannelEvent {
  final String channelId;

  const ChannelSelected({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

/// Update unread count event
class ChannelUnreadUpdated extends ChannelEvent {
  final String channelId;
  final int unreadCount;

  const ChannelUnreadUpdated({
    required this.channelId,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [channelId, unreadCount];
}

/// Subscribe to unread counts event
class ChannelUnreadCountsSubscribed extends ChannelEvent {
  final String workspaceId;
  final String userId;

  const ChannelUnreadCountsSubscribed({
    required this.workspaceId,
    required this.userId,
  });

  @override
  List<Object?> get props => [workspaceId, userId];
}
