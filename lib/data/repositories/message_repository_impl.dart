import 'package:slack_clone_gautam_manwani/data/datasources/message_datasource.dart';
import 'package:slack_clone_gautam_manwani/data/models/message_model.dart';
import 'package:slack_clone_gautam_manwani/domain/entities/message_entity.dart';
import 'package:slack_clone_gautam_manwani/domain/repositories/message_repository.dart';

/// Implementation of MessageRepository
class MessageRepositoryImpl implements MessageRepository {
  final MessageDataSource _dataSource;

  MessageRepositoryImpl({required MessageDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Stream<List<MessageEntity>> getMessagesStream(
    String workspaceId,
    String channelId,
  ) {
    try {
      return _dataSource
          .getMessagesStream(workspaceId, channelId)
          .map((models) => models.map((model) => model.toEntity()).toList());
    } catch (e) {
      throw Exception('Failed to get messages stream: ${e.toString()}');
    }
  }

  @override
  Future<void> sendMessage(
    String workspaceId,
    String channelId,
    MessageEntity message,
  ) async {
    try {
      final messageModel = MessageModel.fromEntity(message);
      await _dataSource.sendMessage(workspaceId, channelId, messageModel);
    } catch (e) {
      throw Exception('Failed to send message: ${e.toString()}');
    }
  }

  @override
  Future<void> addReaction(
    String workspaceId,
    String channelId,
    String messageId,
    ReactionEntity reaction,
  ) async {
    try {
      await _dataSource.addReaction(
        workspaceId,
        channelId,
        messageId,
        reaction,
      );
    } catch (e) {
      throw Exception('Failed to add reaction: ${e.toString()}');
    }
  }

  @override
  Future<void> removeReaction(
    String workspaceId,
    String channelId,
    String messageId,
    String userId,
    String emoji,
  ) async {
    try {
      await _dataSource.removeReaction(
        workspaceId,
        channelId,
        messageId,
        userId,
        emoji,
      );
    } catch (e) {
      throw Exception('Failed to remove reaction: ${e.toString()}');
    }
  }

  @override
  Future<void> updateTypingStatus(
    String workspaceId,
    String userId,
    String userName,
    String channelId,
    bool isTyping,
  ) async {
    try {
      await _dataSource.updateTypingStatus(
        workspaceId,
        userId,
        userName,
        channelId,
        isTyping,
      );
    } catch (e) {
      // Silently fail for typing status to not disrupt user experience
    }
  }

  @override
  Stream<List<String>> getTypingUsersStream(
    String workspaceId,
    String channelId,
  ) {
    try {
      return _dataSource.getTypingUsersStream(workspaceId, channelId);
    } catch (e) {
      return Stream.value([]);
    }
  }
}
