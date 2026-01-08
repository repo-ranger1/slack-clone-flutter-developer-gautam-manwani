import 'package:slack_clone_gautam_manwani/data/models/message_model.dart';
import 'package:slack_clone_gautam_manwani/domain/entities/message_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Message data source using Firebase Firestore
class MessageDataSource {
  final FirebaseFirestore _firestore;

  MessageDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get messages stream for a channel (real-time)
  Stream<List<MessageModel>> getMessagesStream(
    String workspaceId,
    String channelId,
  ) {
    return _firestore
        .collection('workspaces/$workspaceId/channels/$channelId/messages')
        .orderBy('timestamp', descending: true)
        .limit(100) // Limit to last 100 messages for performance
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Send a message
  Future<void> sendMessage(
    String workspaceId,
    String channelId,
    MessageModel message,
  ) async {
    final messagesCollection = _firestore
        .collection('workspaces/$workspaceId/channels/$channelId/messages');

    // Send the message
    if (message.id.isEmpty) {
      // Auto-generate ID
      await messagesCollection.add(message.toFirestore());
    } else {
      // Use provided ID
      await messagesCollection.doc(message.id).set(message.toFirestore());
    }

    // Increment unread count for all workspace users except sender
    // Get all users in the workspace
    try {
      final usersSnapshot = await _firestore
          .collection('users')
          .get();

      final batch = _firestore.batch();

      for (final userDoc in usersSnapshot.docs) {
        final userId = userDoc.id;

        // Skip the message sender
        if (userId == message.senderId) continue;

        // Increment unread count for this user
        final unreadDocRef = _firestore
            .collection('workspaces/$workspaceId/channelMetadata/$channelId/unreadCount')
            .doc(userId);

        // Use FieldValue.increment to atomically increment the count
        batch.set(
          unreadDocRef,
          {'count': FieldValue.increment(1)},
          SetOptions(merge: true),
        );
      }

      // Commit the batch
      await batch.commit();
    } catch (e) {
      // If unread count update fails, don't fail the message send
      debugPrint('Failed to update unread counts: $e');
    }
  }

  /// Add reaction to message
  Future<void> addReaction(
    String workspaceId,
    String channelId,
    String messageId,
    ReactionEntity reaction,
  ) async {
    final messageRef = _firestore
        .collection('workspaces/$workspaceId/channels/$channelId/messages')
        .doc(messageId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(messageRef);

      if (!snapshot.exists) {
        throw Exception('Message not found');
      }

      final data = snapshot.data()!;
      final reactions = List<Map<String, dynamic>>.from(
        data['reactions'] as List<dynamic>? ?? [],
      );

      // Check if user already reacted with this emoji
      final existingIndex = reactions.indexWhere(
        (r) => r['userId'] == reaction.userId && r['emoji'] == reaction.emoji,
      );

      if (existingIndex == -1) {
        // Add new reaction
        reactions.add({
          'emoji': reaction.emoji,
          'userId': reaction.userId,
          'userName': reaction.userName,
        });

        transaction.update(messageRef, {'reactions': reactions});
      }
    });
  }

  /// Remove reaction from message
  Future<void> removeReaction(
    String workspaceId,
    String channelId,
    String messageId,
    String userId,
    String emoji,
  ) async {
    final messageRef = _firestore
        .collection('workspaces/$workspaceId/channels/$channelId/messages')
        .doc(messageId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(messageRef);

      if (!snapshot.exists) {
        throw Exception('Message not found');
      }

      final data = snapshot.data()!;
      final reactions = List<Map<String, dynamic>>.from(
        data['reactions'] as List<dynamic>? ?? [],
      );

      // Remove the reaction
      reactions.removeWhere(
        (r) => r['userId'] == userId && r['emoji'] == emoji,
      );

      transaction.update(messageRef, {'reactions': reactions});
    });
  }

  /// Update typing status
  Future<void> updateTypingStatus(
    String workspaceId,
    String userId,
    String userName,
    String channelId,
    bool isTyping,
  ) async {
    await _firestore.collection('workspaces/$workspaceId/users').doc(userId).set(
      {
        'name': userName,
        'typing': {
          'isTyping': isTyping,
          'channelId': channelId,
          'timestamp': FieldValue.serverTimestamp(),
        }
      },
      SetOptions(merge: true),
    );
  }

  /// Get typing users stream (real-time)
  Stream<List<String>> getTypingUsersStream(
    String workspaceId,
    String channelId,
  ) {
    return _firestore
        .collection('workspaces/$workspaceId/users')
        .where('typing.isTyping', isEqualTo: true)
        .where('typing.channelId', isEqualTo: channelId)
        .snapshots()
        .map((snapshot) {
      // Filter out users whose typing status is older than 5 seconds
      final now = DateTime.now();
      final typingUsers = <String>[];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final typingData = data['typing'] as Map<String, dynamic>?;

        if (typingData != null) {
          final timestamp = typingData['timestamp'] as Timestamp?;
          if (timestamp != null) {
            final typingTime = timestamp.toDate();
            // Only include if typing status is less than 5 seconds old
            if (now.difference(typingTime).inSeconds < 5) {
              String userName = data['name'] as String? ?? '';
              // Extract name from email if name is empty
              if (userName.isEmpty) {
                final email = data['email'] as String?;
                if (email != null && email.contains('@')) {
                  userName = email.split('@')[0];
                } else {
                  userName = 'Someone';
                }
              }
              typingUsers.add(userName);
            }
          }
        }
      }

      return typingUsers;
    });
  }
}
