import 'package:slack_clone_gautam_manwani/domain/entities/channel_entity.dart';

/// Abstract repository for channel operations
abstract class ChannelRepository {
  /// Get all channels for a workspace
  Future<List<ChannelEntity>> getChannels(String workspaceId);

  /// Get channel by ID
  Future<ChannelEntity> getChannelById(String workspaceId, String channelId);

  /// Get unread count for a channel
  Future<int> getUnreadCount(String workspaceId, String channelId, String userId);

  /// Mark channel as read
  Future<void> markAsRead(String workspaceId, String channelId, String userId);

  /// Increment unread count
  Future<void> incrementUnreadCount(String workspaceId, String channelId, String userId);

  /// Get unread count stream for real-time updates
  Stream<int> getUnreadCountStream(String workspaceId, String channelId, String userId);
}
