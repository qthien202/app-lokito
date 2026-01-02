import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lokito/core/utils/gradient_utils.dart';

class GradientController extends Notifier<GradientType> {
  static const String _gradientKey = 'profile_gradient';

  @override
  GradientType build() {
    // Initialize with modern gradient and load saved gradient
    state = GradientType.neonBlue; // Default to modern Neon Blue
    _loadGradient();
    return state;
  }

  Future<void> _loadGradient() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final gradientIndex = prefs.getInt(_gradientKey);
      if (gradientIndex != null && gradientIndex < GradientType.values.length) {
        state = GradientType.values[gradientIndex];
      }
    } catch (e) {
      // If there's an error loading gradient, keep random default
    }
  }

  Future<void> setGradient(GradientType gradient) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_gradientKey, gradient.index);
      state = gradient;
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> setRandomGradient() async {
    final randomGradient = GradientUtils.getRandomGradient();
    await setGradient(randomGradient);
  }

  String get currentGradientName {
    return GradientUtils.getGradientName(state);
  }

  String get currentGradientNameVi {
    return GradientUtils.getGradientNameVi(state);
  }
}

// Riverpod provider
final gradientControllerProvider = NotifierProvider<GradientController, GradientType>(
  GradientController.new,
);