import 'package:slack_clone_gautam_manwani/data/datasources/channel_datasource.dart';
import 'package:slack_clone_gautam_manwani/domain/entities/channel_entity.dart';
import 'package:slack_clone_gautam_manwani/domain/repositories/channel_repository.dart';

/// Implementation of ChannelRepository
class ChannelRepositoryImpl implements ChannelRepository {
  final ChannelDataSource _dataSource;

  ChannelRepositoryImpl({required ChannelDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<List<ChannelEntity>> getChannels(String workspaceId) async {
    try {
      final channels = await _dataSource.getChannels(workspaceId);
      return channels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get channels: ${e.toString()}');
    }
  }

  @override
  Future<ChannelEntity> getChannelById(
    String workspaceId,
    String channelId,
  ) async {
    try {
      final channel = await _dataSource.getChannelById(workspaceId, channelId);
      return channel.toEntity();
    } catch (e) {
      throw Exception('Failed to get channel: ${e.toString()}');
    }
  }

  @override
  Future<int> getUnreadCount(
    String workspaceId,
    String channelId,
    String userId,
  ) async {
    try {
      return await _dataSource.getUnreadCount(workspaceId, channelId, userId);
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> markAsRead(
    String workspaceId,
    String channelId,
    String userId,
  ) async {
    try {
      await _dataSource.markAsRead(workspaceId, channelId, userId);
    } catch (e) {
      throw Exception('Failed to mark as read: ${e.toString()}');
    }
  }

  @override
  Future<void> incrementUnreadCount(
    String workspaceId,
    String channelId,
    String userId,
  ) async {
    try {
      await _dataSource.incrementUnreadCount(workspaceId, channelId, userId);
    } catch (e) {
      throw Exception('Failed to increment unread count: ${e.toString()}');
    }
  }

  @override
  Stream<int> getUnreadCountStream(
    String workspaceId,
    String channelId,
    String userId,
  ) {
    try {
      return _dataSource.getUnreadCountStream(workspaceId, channelId, userId);
    } catch (e) {
      return Stream.value(0);
    }
  }
}
