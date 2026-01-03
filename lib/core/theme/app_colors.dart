import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ====== Primary Colors ======
  static const seedColor = Color(0xFF2F80ED);
  static const primaryLight = Color(0xFF2F80ED); // same as web
  static const primaryDark = Color(0xFF5C9DFF); // bạn đã có

  // ====== Background ======
  static const backgroundLight = Color(0xFFF8F9FE);
  static const backgroundDark = Color(0xFF0F0F16);

  // ====== Surfaces ======
  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF1E1E2E);

  // ====== Text (tự giữ nguyên vì phù hợp Material3) ======
  static const textLight = Color(0xFF1A1C1E);
  static const textDark = Color(0xFFE2E2E6);

  // ====== Input Fills ======
  static const inputFillLight = Color(0xFFE7E0EC);
  static const inputFillDark = Color(0xFF323242);

  // ====== Border Colors (primary transparency) ======
  static const borderPrimaryLight = Color(0x332F80ED); // primary 20%
  static const borderPrimaryDark = Color(0x662F80ED); // primary 40%

  // ====== Slate Tones (lấy từ code UI) ======
  static const slate400 = Color(0xFF94A3B8);
  static const slate500 = Color(0xFF64748B);
  static const slate600 = Color(0xFF475569);
  static const slate700 = Color(0xFF334155);
  static const slate800 = Color(0xFF1E293B);
  static const slate900 = Color(0xFF0F172A);
}
