import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lokito/core/localization/language_controller.dart';
import 'package:lokito/core/theme/theme_controller.dart';
import 'package:lokito/i18n/strings.g.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ProfileSettingsSection extends ConsumerWidget {
  const ProfileSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeController = ref.watch(themeControllerProvider.notifier);
    final themeState = ref.watch(themeControllerProvider);
    final languageController = ref.watch(languageControllerProvider.notifier);
    final currentLanguage = ref.watch(languageControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.profile.settings,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Theme Selection Card
        Card(
          child: ListTile(
            leading: Icon(
              themeController.currentThemeIcon,
              color: theme.colorScheme.primary,
            ),
            title: Text(t.profile.theme),
            subtitle: Text(_getLocalizedThemeName(themeState.themeMode)),
            trailing: themeState.isLoading 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(LucideIcons.chevronRight),
            onTap: themeState.isLoading ? null : () {
              _showThemeActionSheet(context, ref);
            },
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Language Card
        Card(
          child: ListTile(
            leading: Icon(
              LucideIcons.globe,
              color: theme.colorScheme.primary,
            ),
            title: Text(t.profile.language),
            subtitle: Text(languageController.currentLanguageNativeName),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: () {
              _showLanguageActionSheet(context, ref);
            },
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Notifications Card
        Card(
          child: ListTile(
            leading: Icon(
              LucideIcons.bell,
              color: theme.colorScheme.primary,
            ),
            title: Text(t.profile.notifications),
            subtitle: Text(t.profile.manageNotifications),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: () {
              // TODO: Implement notifications settings
            },
          ),
        ),
      ],
    );
  }

  String _getLocalizedThemeName(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return t.profile.themeLight;
      case ThemeMode.dark:
        return t.profile.themeDark;
      case ThemeMode.system:
        return t.profile.themeSystem;
    }
  }
  
  void _showThemeActionSheet(BuildContext context, WidgetRef ref) {
    final themeController = ref.read(themeControllerProvider.notifier);
    final themeState = ref.read(themeControllerProvider);
    
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          t.profile.selectTheme,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              themeController.setTheme(ThemeMode.light);
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.light_mode, color: CupertinoColors.systemBlue),
                    const SizedBox(width: 12),
                    Text(_getLocalizedThemeName(ThemeMode.light)),
                  ],
                ),
                if (themeState.themeMode == ThemeMode.light)
                  const Icon(Icons.check, color: CupertinoColors.systemBlue),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              themeController.setTheme(ThemeMode.dark);
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.dark_mode, color: CupertinoColors.systemBlue),
                    const SizedBox(width: 12),
                    Text(_getLocalizedThemeName(ThemeMode.dark)),
                  ],
                ),
                if (themeState.themeMode == ThemeMode.dark)
                  const Icon(Icons.check, color: CupertinoColors.systemBlue),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              themeController.setTheme(ThemeMode.system);
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.brightness_auto, color: CupertinoColors.systemBlue),
                    const SizedBox(width: 12),
                    Text(_getLocalizedThemeName(ThemeMode.system)),
                  ],
                ),
                if (themeState.themeMode == ThemeMode.system)
                  const Icon(Icons.check, color: CupertinoColors.systemBlue),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          isDefaultAction: true,
          child: Text(t.common.cancel),
        ),
      ),
    );
  }
  
  void _showLanguageActionSheet(BuildContext context, WidgetRef ref) {
    final languageController = ref.read(languageControllerProvider.notifier);
    final currentLanguage = ref.read(languageControllerProvider);
    
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          t.profile.selectLanguage,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              languageController.setLanguage(AppLocale.en);
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('🇺🇸', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    const Text('English'),
                  ],
                ),
                if (currentLanguage == AppLocale.en)
                  const Icon(Icons.check, color: CupertinoColors.systemBlue),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              languageController.setLanguage(AppLocale.vi);
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('🇻🇳', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    const Text('Tiếng Việt'),
                  ],
                ),
                if (currentLanguage == AppLocale.vi)
                  const Icon(Icons.check, color: CupertinoColors.systemBlue),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          isDefaultAction: true,
          child: Text(t.common.cancel),
        ),
      ),
    );
  }
}