import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slack_clone_gautam_manwani/core/utils/storage/app_storage.dart';

/// Theme Cubit for managing dark/light mode
class ThemeCubit extends Cubit<bool> {
  final AppStorage _storage;

  ThemeCubit({AppStorage? storage})
      : _storage = storage ?? AppStorage(),
        super(false) {
    _loadTheme();
  }

  /// Load theme from storage
  void _loadTheme() {
    final isDarkMode = _storage.isDarkMode.v ?? false;
    emit(isDarkMode);
  }

  /// Toggle theme
  void toggleTheme() {
    final newValue = !state;
    _storage.isDarkMode.v = newValue;
    emit(newValue);
  }

  /// Set theme explicitly
  void setTheme(bool isDark) {
    _storage.isDarkMode.v = isDark;
    emit(isDark);
  }
}
