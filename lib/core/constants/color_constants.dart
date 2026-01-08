import 'package:flutter/material.dart';

/// Color constants for the Slack Clone messaging app
class ColorC {
  ColorC._();

  // Primary colors (Slack-inspired)
  static const Color slackPurple = Color(0xFF611f69);
  static const Color slackPurpleLight = Color(0xFF4A154B);
  static const Color slackGreen = Color(0xFF2BAC76);
  static const Color slackBlue = Color(0xFF1264A3);
  static const Color slackRed = Color(0xFFE01E5A);
  static const Color slackYellow = Color(0xFFECB22E);

  // Message status colors
  static const Color messageSent = Color(0xFF4CAF50);
  static const Color messagePending = Color(0xFFFFA726);
  static const Color messageFailed = Color(0xFFE53935);

  // Online status
  static const Color online = Color(0xFF2BAC76);
  static const Color offline = Color(0xFF9E9E9E);
  static const Color away = Color(0xFFECB22E);

  // Unread badge
  static const Color unreadBadge = Color(0xFFE01E5A);

  // Typing indicator
  static const Color typingIndicator = Color(0xFF757575);
}
