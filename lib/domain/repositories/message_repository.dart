import 'package:slack_clone_gautam_manwani/domain/entities/message_entity.dart';

/// Abstract repository for message operations
abstract class MessageRepository {
  /// Get messages stream for a channel (real-time)
  Stream<List<MessageEntity>> getMessagesStream(
    String workspaceId,
    String channelId,
  );

  /// Send a message
  Future<void> sendMessage(
    String workspaceId,
    String channelId,
    MessageEntity message,
  );

  /// Add reaction to message
  Future<void> addReaction(
    String workspaceId,
    String channelId,
    String messageId,
    ReactionEntity reaction,
  );

  /// Remove reaction from message
  Future<void> removeReaction(
    String workspaceId,
    String channelId,
    String messageId,
    String userId,
    String emoji,
  );

  /// Update typing status
  Future<void> updateTypingStatus(
    String workspaceId,
    String userId,
    String userName,
    String channelId,
    bool isTyping,
  );

  /// Get typing users stream (real-time)
  Stream<List<String>> getTypingUsersStream(
    String workspaceId,
    String channelId,
  );
}
