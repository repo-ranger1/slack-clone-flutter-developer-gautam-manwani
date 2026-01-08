import 'package:slack_clone_gautam_manwani/core/constants/key_constants.dart';
import 'package:slack_clone_gautam_manwani/core/utils/storage/local_storage.dart';

/// Central storage manager for the application
/// Manages all local storage values using SharedPreferences
class AppStorage {
  AppStorage._();

  static final AppStorage _instance = AppStorage._();
  factory AppStorage() => _instance;

  final LocalStorageSync _ls = LocalStorageSync();

  /// Initialize storage
  Future<void> init() async {
    await _ls.init();
    _initializeValues();
  }

  // Theme
  late LocalValue<bool> isDarkMode;

  // Authentication
  late LocalValue<bool> isLoggedIn;
  late LocalValue<bool> rememberUser;
  late LocalValue<String> userEmail;
  late LocalValue<String> userId;
  late LocalValue<String> userName;
  late LocalValue<String> accessToken;

  // Workspace
  late LocalValue<String> workspaceId;
  late LocalValue<String> workspaceName;

  // Current channel
  late LocalValue<String> currentChannelId;

  // Offline queue
  late LocalValue<String> offlineMessageQueue;
  late LocalValue<String> lastSyncTimestamp;

  /// Initialize all LocalValue instances
  void _initializeValues() {
    isDarkMode = LocalValue(key: KeyC.isDarkMode, ls: _ls);
    isLoggedIn = LocalValue(key: KeyC.isLoggedIn, ls: _ls);
    rememberUser = LocalValue(key: KeyC.rememberUser, ls: _ls);
    userEmail = LocalValue(key: KeyC.userEmail, ls: _ls);
    userId = LocalValue(key: KeyC.userId, ls: _ls);
    userName = LocalValue(key: KeyC.userName, ls: _ls);
    accessToken = LocalValue(key: KeyC.accessToken, ls: _ls);
    workspaceId = LocalValue(key: KeyC.workspaceId, ls: _ls);
    workspaceName = LocalValue(key: KeyC.workspaceName, ls: _ls);
    currentChannelId = LocalValue(key: KeyC.currentChannelId, ls: _ls);
    offlineMessageQueue = LocalValue(key: KeyC.offlineMessageQueue, ls: _ls);
    lastSyncTimestamp = LocalValue(key: KeyC.lastSyncTimestamp, ls: _ls);
  }

  /// Clear all storage
  Future<void> clearAll() => _ls.clearAll();
}
