import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lokito/i18n/strings.g.dart';

class LanguageController extends Notifier<AppLocale> {
  static const String _languageKey = 'app_language';

  @override
  AppLocale build() {
    // Initialize with system locale and load saved language
    state = AppLocale.vi; // Default to Vietnamese
    _loadLanguage();
    return state;
  }

  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);
      if (languageCode != null) {
        final locale = AppLocale.values.firstWhere(
          (locale) => locale.languageCode == languageCode,
          orElse: () => AppLocale.vi,
        );
        state = locale;
        LocaleSettings.setLocale(locale);
      }
    } catch (e) {
      // If there's an error loading language, keep default
    }
  }

  Future<void> setLanguage(AppLocale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, locale.languageCode);
      
      // Update state first
      state = locale;
      
      // Then update the global locale settings
      LocaleSettings.setLocale(locale);
    } catch (e) {
      // Handle error silently
    }
  }

  String get currentLanguageName {
    switch (state) {
      case AppLocale.en:
        return 'English';
      case AppLocale.vi:
        return 'Tiếng Việt';
    }
  }

  String get currentLanguageNativeName {
    switch (state) {
      case AppLocale.en:
        return 'English';
      case AppLocale.vi:
        return 'Tiếng Việt';
    }
  }
}

// Riverpod provider
final languageControllerProvider = NotifierProvider<LanguageController, AppLocale>(
  LanguageController.new,
);