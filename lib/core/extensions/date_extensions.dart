import 'package:slack_clone_gautam_manwani/core/constants/datetime_constants.dart';

/// DateTime extensions for easy formatting
extension DateExtensions on DateTime {
  /// Format as display date (e.g., "Jan 06, 2025")
  String toDisplayDate() => DateTimeC.toDisplayDate(date: this);

  /// Format as display time (e.g., "2:30 PM")
  String toDisplayTime() => DateTimeC.toDisplayTime(date: this);

  /// Format as display date time (e.g., "Jan 06, 2025 2:30 PM")
  String toDisplayDateTime() => DateTimeC.toDisplayDateTime(date: this);

  /// Format as message time (Today, Yesterday, or date)
  String toMessageTime() => DateTimeC.toMessageTimeFormat(this);

  /// Check if this date is today
  bool get isToday => DateTimeC.isToday(this);

  /// Check if this date is yesterday
  bool get isYesterday => DateTimeC.isYesterday(this);

  /// Check if this date is same as another date
  bool isSameDate(DateTime other) => DateTimeC.isSameDate(this, other);
}
