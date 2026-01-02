import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_state.dart';

class ThemeController extends Notifier<ThemeState> {
  static const String _themeKey = 'theme_mode';

  @override
  ThemeState build() {
    // Initialize with system theme and load saved theme
    state = const ThemeState();
    _loadTheme();
    return state;
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 0;
      final themeMode = ThemeMode.values[themeIndex];
      state = state.copyWith(themeMode: themeMode);
    } catch (e) {
      // If there's an error loading theme, keep system default
      state = state.copyWith(error: 'errorFailedToLoadTheme');
    }
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, themeMode.index);
      state = state.copyWith(
        themeMode: themeMode,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'errorFailedToSaveTheme',
      );
    }
  }

  Future<void> toggleTheme() async {
    switch (state.themeMode) {
      case ThemeMode.light:
        await setTheme(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        await setTheme(ThemeMode.light);
        break;
      case ThemeMode.system:
        // If system, toggle to light first
        await setTheme(ThemeMode.light);
        break;
    }
  }

  String get currentThemeName {
    switch (state.themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  IconData get currentThemeIcon {
    switch (state.themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Riverpod provider
final themeControllerProvider = NotifierProvider<ThemeController, ThemeState>(
  ThemeController.new,
);