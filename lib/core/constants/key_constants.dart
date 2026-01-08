/// Storage key constants for SharedPreferences and session management
class KeyC {
  KeyC._();

  // Theme
  static const String theme = 'theme';
  static const String isDarkMode = 'isDarkMode';

  // Authentication
  static const String isLoggedIn = 'isLoggedIn';
  static const String rememberUser = 'rememberUser';
  static const String userEmail = 'userEmail';
  static const String userId = 'userId';
  static const String userName = 'userName';
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';

  // Workspace
  static const String workspaceId = 'workspaceId';
  static const String workspaceName = 'workspaceName';

  // Current channel
  static const String currentChannelId = 'currentChannelId';

  // Offline queue
  static const String offlineMessageQueue = 'offlineMessageQueue';
  static const String lastSyncTimestamp = 'lastSyncTimestamp';

  // Firebase/API keys
  static const String authorization = 'Authorization';
  static const String contentType = 'Content-Type';
  static const String bearer = 'Bearer';

  // Firestore collection names
  static const String workspacesCollection = 'workspaces';
  static const String channelsCollection = 'channels';
  static const String messagesCollection = 'messages';
  static const String usersCollection = 'users';
  static const String channelMetadataCollection = 'channelMetadata';
  static const String unreadCountCollection = 'unreadCount';

  // Message fields
  static const String messageId = 'id';
  static const String messageText = 'text';
  static const String messageSenderId = 'senderId';
  static const String messageSenderName = 'senderName';
  static const String messageTimestamp = 'timestamp';
  static const String messageStatus = 'status';
  static const String messageReactions = 'reactions';

  // User fields
  static const String userTyping = 'typing';
  static const String userIsTyping = 'isTyping';
  static const String userChannelId = 'channelId';

  // Channel fields
  static const String channelId = 'id';
  static const String channelName = 'name';
  static const String channelCreatedAt = 'createdAt';
}
