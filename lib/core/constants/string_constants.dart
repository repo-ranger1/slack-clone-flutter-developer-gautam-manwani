/// String constants for the Slack Clone messaging app
class StringC {
  StringC._();

  /// App
  static const String appName = 'Slack Clone by Gautam Manwani';
  static const String workspace = 'Workspace';
  static const String defaultWorkspace = 'My Workspace';

  /// Authentication
  static const String login = 'Login';
  static const String email = 'Email';
  static const String emailHint = 'e.g. john@example.com';
  static const String emailValidation = 'Please enter a valid email';
  static const String password = 'Password';
  static const String passwordHint = '••••••••';
  static const String passwordValidation = 'Password must not be empty';
  static const String rememberMe = 'Remember me';
  static const String continueTxt = 'Continue';
  static const String successfulLogin = 'Successfully logged in';
  static const String loginError = 'Login failed. Please try again';
  static const String logout = 'Logout';
  static const String logoutMessage = 'Are you sure you want to logout?';
  static const String yes = 'Yes';
  static const String no = 'No';

  /// Channels
  static const String channels = 'Channels';
  static const String general = '#general';
  static const String random = '#random';
  static const String channelListTitle = 'Channels';
  static const String noChannelsPlaceholder = 'No channels available';

  /// Messages
  static const String typeMessage = 'Type a message...';
  static const String sendMessage = 'Send';
  static const String noMessagesPlaceholder = 'No messages yet. Start the conversation!';
  static const String messageEmpty = 'Message cannot be empty';
  static const String sending = 'Sending...';
  static const String sent = 'Sent';
  static const String failed = 'Failed';
  static const String isTyping = 'is typing...';
  static const String areTyping = 'are typing...';

  /// Reactions
  static const String addReaction = 'Add reaction';
  static const String thumbsUp = '👍';
  static const String heart = '❤️';

  /// Status & States
  static const String loading = 'Loading...';
  static const String retry = 'Retry';
  static const String error = 'Error';
  static const String noInternet = 'No internet connection';
  static const String offline = 'Offline';
  static const String online = 'Online';
  static const String connecting = 'Connecting...';

  /// Settings
  static const String settings = 'Settings';
  static const String theme = 'Theme';
  static const String light = 'Light';
  static const String dark = 'Dark';
  static const String darkMode = 'Dark Mode';

  /// Date & Time formats
  static const String timeFormat = 'h:mm a';
  static const String dateFormat = 'MMM dd, yyyy';
  static const String dateTimeFormat = 'MMM dd, yyyy h:mm a';
  static const String todayFormat = "'Today at' h:mm a";
  static const String yesterdayFormat = "'Yesterday at' h:mm a";

  /// Regex patterns
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
}
