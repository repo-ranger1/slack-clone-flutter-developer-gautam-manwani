import 'package:slack_clone_gautam_manwani/domain/entities/user_entity.dart';

/// In-memory session storage for runtime data
/// This data is cleared when the app is closed
class AppSession {
  AppSession._();

  static final AppSession _instance = AppSession._();
  factory AppSession() => _instance;

  /// Current logged-in user
  UserEntity? user;

  /// Current workspace ID
  String? workspaceId;

  /// Current channel ID
  String? currentChannelId;

  /// Flag to track if user is typing
  bool isTyping = false;

  /// Last typing timestamp
  DateTime? lastTypingTime;

  /// Check if user is authenticated
  bool get isAuthenticated => user != null;

  /// Clear all session data
  void clear() {
    user = null;
    workspaceId = null;
    currentChannelId = null;
    isTyping = false;
    lastTypingTime = null;
  }
}
