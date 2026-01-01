import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lokito/app/app.dart';
import 'package:lokito/core/core.dart';
import 'package:lokito/i18n/strings.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  LocaleSettings.useDeviceLocale(); // Set locale to device language
  runApp(TranslationProvider(child: const ProviderScope(child: App())));
}
