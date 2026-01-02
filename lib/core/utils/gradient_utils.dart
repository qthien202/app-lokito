import 'package:flutter/material.dart';
import 'dart:math';

enum GradientType {
  neonBlue,
  purpleHaze,
  sunsetVibes,
  mintFresh,
  coralDream,
  deepSpace,
  goldenHour,
  oceanBreeze,
  lavenderMist,
  fireGlow,
  emeraldShine,
  rosePetal,
}

class GradientUtils {
  static final Random _random = Random();

  static const Map<GradientType, List<Color>> _gradientColors = {
    GradientType.neonBlue: [
      Color(0xFF667eea),
      Color(0xFF764ba2),
      Color(0xFF4facfe),
      Color(0xFF00f2fe),
    ],
    GradientType.purpleHaze: [
      Color(0xFF8B5CF6),
      Color(0xFFA855F7),
      Color(0xFFEC4899),
      Color(0xFFF472B6),
    ],
    GradientType.sunsetVibes: [
      Color(0xFFFF6B6B),
      Color(0xFFFFE66D),
      Color(0xFFFF8E53),
      Color(0xFFFF6B9D),
    ],
    GradientType.mintFresh: [
      Color(0xFF06FFA5),
      Color(0xFF00D4AA),
      Color(0xFF4FACFE),
      Color(0xFF00F2FE),
    ],
    GradientType.coralDream: [
      Color(0xFFFF9A8B),
      Color(0xFFFECFEF),
      Color(0xFFFFB199),
      Color(0xFFFF719A),
    ],
    GradientType.deepSpace: [
      Color(0xFF1A1A2E),
      Color(0xFF16213E),
      Color(0xFF0F3460),
      Color(0xFF533483),
    ],
    GradientType.goldenHour: [
      Color(0xFFFECA57),
      Color(0xFFFF9F43),
      Color(0xFFFF6B6B),
      Color(0xFFEE5A24),
    ],
    GradientType.oceanBreeze: [
      Color(0xFF74B9FF),
      Color(0xFF0984E3),
      Color(0xFF6C5CE7),
      Color(0xFFA29BFE),
    ],
    GradientType.lavenderMist: [
      Color(0xFFDDA0DD),
      Color(0xFFE6E6FA),
      Color(0xFFD8BFD8),
      Color(0xFFBA55D3),
    ],
    GradientType.fireGlow: [
      Color(0xFFFF512F),
      Color(0xFFDD2476),
      Color(0xFFFF6B6B),
      Color(0xFFFFE66D),
    ],
    GradientType.emeraldShine: [
      Color(0xFF00B894),
      Color(0xFF00CEC9),
      Color(0xFF55EFC4),
      Color(0xFF81ECEC),
    ],
    GradientType.rosePetal: [
      Color(0xFFFD79A8),
      Color(0xFFE84393),
      Color(0xFFFF7675),
      Color(0xFFFAB1A0),
    ],
  };

  static const Map<GradientType, String> _gradientNames = {
    GradientType.neonBlue: 'Neon Blue',
    GradientType.purpleHaze: 'Purple Haze',
    GradientType.sunsetVibes: 'Sunset Vibes',
    GradientType.mintFresh: 'Mint Fresh',
    GradientType.coralDream: 'Coral Dream',
    GradientType.deepSpace: 'Deep Space',
    GradientType.goldenHour: 'Golden Hour',
    GradientType.oceanBreeze: 'Ocean Breeze',
    GradientType.lavenderMist: 'Lavender Mist',
    GradientType.fireGlow: 'Fire Glow',
    GradientType.emeraldShine: 'Emerald Shine',
    GradientType.rosePetal: 'Rose Petal',
  };

  static const Map<GradientType, String> _gradientNamesVi = {
    GradientType.neonBlue: 'Xanh Neon',
    GradientType.purpleHaze: 'Tím Mộng Mơ',
    GradientType.sunsetVibes: 'Hoàng Hôn',
    GradientType.mintFresh: 'Bạc Hà Tươi',
    GradientType.coralDream: 'San Hô Mộng',
    GradientType.deepSpace: 'Vũ Trụ Sâu',
    GradientType.goldenHour: 'Giờ Vàng',
    GradientType.oceanBreeze: 'Gió Biển',
    GradientType.lavenderMist: 'Sương Lavender',
    GradientType.fireGlow: 'Ánh Lửa',
    GradientType.emeraldShine: 'Ngọc Lục Bảo',
    GradientType.rosePetal: 'Cánh Hồng',
  };

  /// Get a random gradient type
  static GradientType getRandomGradient() {
    final gradients = GradientType.values;
    return gradients[_random.nextInt(gradients.length)];
  }

  /// Get gradient colors for a specific type
  static List<Color> getGradientColors(GradientType type) {
    return _gradientColors[type] ?? _gradientColors[GradientType.neonBlue]!;
  }

  /// Get gradient name in English
  static String getGradientName(GradientType type) {
    return _gradientNames[type] ?? 'Neon Blue';
  }

  /// Get gradient name in Vietnamese
  static String getGradientNameVi(GradientType type) {
    return _gradientNamesVi[type] ?? 'Xanh Neon';
  }

  /// Create a LinearGradient from gradient type
  static LinearGradient createGradient(GradientType type) {
    final colors = getGradientColors(type);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
      stops: _generateStops(colors.length),
    );
  }

  /// Generate evenly distributed stops for gradient colors
  static List<double> _generateStops(int colorCount) {
    if (colorCount <= 1) return [0.0];
    
    final stops = <double>[];
    for (int i = 0; i < colorCount; i++) {
      stops.add(i / (colorCount - 1));
    }
    return stops;
  }

  /// Get the primary color from gradient (first color) for UI elements like AppBar
  static Color getPrimaryColor(GradientType type) {
    final colors = getGradientColors(type);
    return colors.first;
  }

  /// Get a darker version of primary color for better contrast
  static Color getPrimaryColorDark(GradientType type) {
    final primaryColor = getPrimaryColor(type);
    return Color.lerp(primaryColor, Colors.black, 0.2) ?? primaryColor;
  }

  /// Get all available gradient types
  static List<GradientType> getAllGradients() {
    return GradientType.values;
  }

  /// Create a preview gradient (smaller version for selection)
  static Widget createGradientPreview(GradientType type, {double size = 40}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: createGradient(type),
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
      ),
    );
  }
}