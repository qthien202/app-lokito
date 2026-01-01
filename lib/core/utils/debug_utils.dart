import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DebugUtils {
  static bool get isDebugMode => kDebugMode;
  
  static void log(String message) {
    if (isDebugMode) {
      debugPrint('[DEBUG] $message');
    }
  }
  
  static void logError(String message, [Object? error, StackTrace? stackTrace]) {
    if (isDebugMode) {
      debugPrint('[ERROR] $message');
      if (error != null) debugPrint('Error: $error');
      if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
    }
  }
  
  // Test skeleton loading by adding delay
  static Future<void> simulateLoading({int seconds = 3}) async {
    if (isDebugMode) {
      log('Simulating loading for $seconds seconds...');
      await Future.delayed(Duration(seconds: seconds));
      log('Loading simulation complete');
    }
  }
  
  // Show debug overlay for skeleton testing
  static Widget debugOverlay({
    required Widget child,
    String? label,
  }) {
    if (!isDebugMode) return child;
    
    return Stack(
      children: [
        child,
        if (label != null)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}