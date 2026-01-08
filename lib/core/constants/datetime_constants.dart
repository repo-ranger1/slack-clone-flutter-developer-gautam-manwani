import 'package:intl/intl.dart';

/// DateTime utility constants and helper methods
abstract class DateTimeC {
  // Date format patterns
  static const String backendFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
  static const String displayDateFormat = "MMM dd, yyyy";
  static const String displayTimeFormat = "h:mm a";
  static const String displayDateTimeFormat = "MMM dd, yyyy h:mm a";

  /// Format DateTime to backend format (ISO 8601)
  static String toBackendFormat({DateTime? date}) =>
      DateFormat(backendFormat).format(date ?? DateTime.now());

  /// Format DateTime to display format (e.g., "Jan 06, 2025")
  static String toDisplayDate({DateTime? date}) =>
      DateFormat(displayDateFormat).format(date ?? DateTime.now());

  /// Format DateTime to time format (e.g., "2:30 PM")
  static String toDisplayTime({DateTime? date}) =>
      DateFormat(displayTimeFormat).format(date ?? DateTime.now());

  /// Format DateTime to full display format (e.g., "Jan 06, 2025 2:30 PM")
  static String toDisplayDateTime({DateTime? date}) =>
      DateFormat(displayDateTimeFormat).format(date ?? DateTime.now());

  /// Format timestamp for messages (Today, Yesterday, or date)
  static String toMessageTimeFormat(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return DateFormat("'Today at' h:mm a").format(date);
    } else if (messageDate == yesterday) {
      return DateFormat("'Yesterday at' h:mm a").format(date);
    } else {
      return DateFormat(displayDateTimeFormat).format(date);
    }
  }

  /// Parse backend format string to DateTime
  static DateTime? parseBackendFormat(String dateStr) {
    try {
      return DateFormat(backendFormat).parse(dateStr);
    } catch (_) {
      return DateTime.tryParse(dateStr);
    }
  }

  /// Check if two dates are on the same day
  static bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return isSameDate(date, now);
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDate(date, yesterday);
  }
}
