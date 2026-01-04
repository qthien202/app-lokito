# Lokito App

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Riverpod](https://img.shields.io/badge/Riverpod-%2302569B.svg?style=flat)](https://riverpod.dev)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=flat&logo=supabase&logoColor=white)](https://supabase.com)

A modern, high-performance social media application built with Flutter, focusing on premium aesthetics and seamless user experience.

[🇻🇳 Tiếng Việt](README_VI.md)

## 🚀 Key Features

- **Modern Social UI**: Edge-to-edge design with "Social Spotlight" aura, optimized for 2025 aesthetics.
- **Glassmorphism**: Sophisticated blur effects and glass-textured cards for a premium feel.
- **Optimistic Post Creation**: Immediate visual feedback when posting, with background upload progress.
- **Media Capture**: Integrated custom camera and gallery picker for seamless content sharing.
- **Dark Mode**: Fully implemented true-dark theme for enhanced visual comfort.
- **Localization**: Full support for English and Vietnamese using Slang.

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [Riverpod](https://riverpod.dev)
- **Backend**: [Supabase](https://supabase.com) (Authentication, Database, Real-time)
- **Image Storage**: [Cloudinary](https://cloudinary.com)
- **Routing**: [GoRouter](https://pub.dev/packages/go_router)
- **Architecture**: Clean Architecture (Feature-first)

## 📁 Documentation

Detailed guides and technical specifications:

- [🔐 Auth & Profile Schema](docs/schema_auth.md)
- [📝 Feed & Post Schema](docs/schema_feed.md)
- [☁️ Cloudinary Integration](docs/cloudinary_service.md)
- [🛤 Auth Flow](docs/auth_flow.md)
- [🌍 Localization Guide](docs/localization.md)

## 🏗 Getting Started

1. **Clone the repository**:
   ```bash
   git clone https://github.com/qthien202/app-lokito.git
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Global Code Generation**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the application**:
   ```bash
   flutter run
   ```

---
*Developed by [Quang Thiên](https://github.com/qthien202)*
