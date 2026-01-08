import 'package:slack_clone_gautam_manwani/data/models/channel_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Channel data source using Firebase Firestore
class ChannelDataSource {
  final FirebaseFirestore _firestore;

  ChannelDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get all channels for a workspace
  Future<List<ChannelModel>> getChannels(String workspaceId) async {
    final snapshot = await _firestore
        .collection('workspaces/$workspaceId/channels')
        .orderBy('createdAt', descending: false)
        .get();

    return snapshot.docs
        .map((doc) => ChannelModel.fromFirestore(doc))
        .toList();
  }

  /// Get channel by ID
  Future<ChannelModel> getChannelById(
    String workspaceId,
    String channelId,
  ) async {
    final doc = await _firestore
        .collection('workspaces/$workspaceId/channels')
        .doc(channelId)
        .get();

    if (!doc.exists) {
      throw Exception('Channel not found');
    }

    return ChannelModel.fromFirestore(doc);
  }

  /// Get unread count for a channel
  Future<int> getUnreadCount(
    String workspaceId,
    String channelId,
    String userId,
  ) async {
    try {
      final doc = await _firestore
          .collection('workspaces/$workspaceId/channelMetadata/$channelId/unreadCount')
          .doc(userId)
          .get();

      if (!doc.exists) return 0;

      final data = doc.data();
      return (data?['count'] as int?) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Mark channel as read (reset unread count)
  Future<void> markAsRead(
    String workspaceId,
    String channelId,
    String userId,
  ) async {
    await _firestore
        .collection('workspaces/$workspaceId/channelMetadata/$channelId/unreadCount')
        .doc(userId)
        .set({'count': 0});
  }

  /// Increment unread count
  Future<void> incrementUnreadCount(
    String workspaceId,
    String channelId,
    String userId,
  ) async {
    final docRef = _firestore
        .collection('workspaces/$workspaceId/channelMetadata/$channelId/unreadCount')
        .doc(userId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      final currentCount = snapshot.exists
          ? ((snapshot.data()?['count'] as int?) ?? 0)
          : 0;

      transaction.set(docRef, {'count': currentCount + 1});
    });
  }

  /// Get unread count stream for real-time updates
  Stream<int> getUnreadCountStream(
    String workspaceId,
    String channelId,
    String userId,
  ) {
    return _firestore
        .collection('workspaces/$workspaceId/channelMetadata/$channelId/unreadCount')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return 0;
      final data = snapshot.data();
      return (data?['count'] as int?) ?? 0;
    });
  }
}
