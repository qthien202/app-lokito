# Localization Guide with Slang

The Lokito project uses the **Slang** library for internationalization. Slang provides a type-safe solution, supports namespaces, and does not depend on `BuildContext` in many cases.

## 1. Directory Structure

All language files are located in `lib/i18n/`. We use a **Feature-based Namespaces** structure:

- `auth_en.i18n.json`, `auth_vi.i18n.json`: Translations for the Auth feature.
- `onboarding_en.i18n.json`, `onboarding_vi.i18n.json`: Translations for the Onboarding screen.
- `common_en.i18n.json`, `common_vi.i18n.json`: Common strings used throughout the app.
- `strings.g.dart`: Automatically generated code containing all translations.

## 2. Adding/Editing Content

To add a new string:
1. Open the relevant JSON file (e.g., `auth_en.i18n.json`).
2. Add the key and its value.
3. Update the corresponding Vietnamese file (`auth_vi.i18n.json`).

### Using Parameters (Variables)
Use `$variableName` or `${variableName}` syntax in the JSON file:
```json
"verifySubtitle": "We have sent a verification code to $email"
```

## 3. Code Generation

The project is configured to automatically generate code. Every time you change a `.json` file, run the following command:

```bash
dart run slang
```
Or if you want it to run continuously on save:
```bash
dart run build_runner watch --delete-conflicting-outputs
```

## 4. Usage in Flutter Code

### Accessing via the Global `t` Object
Since `t` is declared globally in `strings.g.dart`, you can call it directly anywhere:

```dart
import 'package:lokito/i18n/strings.g.dart';

// Inside a Widget or Logic
print(t.auth.signIn);
print(t.common.email);

// With parameters
print(t.auth.verifySubtitle(email: 'user@example.com'));
```

### Changing Locales
Use `LocaleSettings`:

```dart
// Switch to Vietnamese
LocaleSettings.setLocale(AppLocale.vi);

// Get current locale
AppLocale current = LocaleSettings.currentLocale;
```

## 5. Technical Configuration (`slang.yaml`)

The Slang configuration file is located at the root of the project with important options:
- `namespaces: true`: Allows splitting files by feature.
- `input_directory: lib/i18n`: Directory containing source files.
- `output_file_name: strings.g.dart`: Consolidates everything into a single file.

---
*Lokito Documentation - Updated 2026*
