import 'package:flutter/material.dart';
import 'package:slack_clone_gautam_manwani/core/constants/color_constants.dart';
import 'package:slack_clone_gautam_manwani/core/constants/size_constants.dart';

/// Application theme configuration with light and dark modes
/// Slack-inspired design
abstract class AppTheme {
  // Font family
  static const String _fontFamily = 'Roboto';

  /// Light theme configuration
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: _fontFamily,

    colorScheme: const ColorScheme.light(
      primary: ColorC.slackPurple,
      secondary: ColorC.slackGreen,
      surface: Color(0xFFFFFFFF),
      surfaceContainerHighest: Color(0xFFF8F8F8),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1D1C1D),
      error: ColorC.slackRed,
    ),

    scaffoldBackgroundColor: Colors.white,

    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: ColorC.slackPurple,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        fontFamily: _fontFamily,
        color: Colors.white,
      ),
    ),

    cardTheme: CardThemeData(
      elevation: SizeC.elevationS,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeC.radiusM),
      ),
      color: const Color(0xFFF8F8F8),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: SizeC.paddingM,
        vertical: SizeC.paddingS,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeC.radiusM),
        borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeC.radiusM),
        borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeC.radiusM),
        borderSide: const BorderSide(color: ColorC.slackPurple, width: 2),
      ),
      hintStyle: const TextStyle(color: Color(0xFF616061)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorC.slackPurple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: SizeC.paddingL,
          vertical: SizeC.paddingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeC.radiusM),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorC.slackPurple,
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ColorC.slackPurple,
      foregroundColor: Colors.white,
    ),

    dividerTheme: const DividerThemeData(
      color: Color(0xFFEEEEEE),
      thickness: 1,
    ),
  );

  /// Dark theme configuration
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: _fontFamily,

    colorScheme: const ColorScheme.dark(
      primary: ColorC.slackPurpleLight,
      secondary: ColorC.slackGreen,
      surface: Color(0xFF1A1D21),
      surfaceContainerHighest: Color(0xFF232529),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFFFFFFFF),
      error: ColorC.slackRed,
    ),

    scaffoldBackgroundColor: const Color(0xFF1A1D21),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Color(0xFF232529),
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        fontFamily: _fontFamily,
        color: Colors.white,
      ),
    ),

    cardTheme: CardThemeData(
      elevation: SizeC.elevationS,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeC.radiusM),
      ),
      color: const Color(0xFF232529),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF232529),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: SizeC.paddingM,
        vertical: SizeC.paddingS,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeC.radiusM),
        borderSide: const BorderSide(color: Color(0xFF3F3F46)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeC.radiusM),
        borderSide: const BorderSide(color: Color(0xFF3F3F46)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeC.radiusM),
        borderSide: const BorderSide(color: ColorC.slackPurpleLight, width: 2),
      ),
      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorC.slackPurpleLight,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: SizeC.paddingL,
          vertical: SizeC.paddingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeC.radiusM),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorC.slackPurpleLight,
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ColorC.slackPurpleLight,
      foregroundColor: Colors.white,
    ),

    dividerTheme: const DividerThemeData(
      color: Color(0xFF3F3F46),
      thickness: 1,
    ),
  );
}
