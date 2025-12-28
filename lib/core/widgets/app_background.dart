import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        // 1. Solid Clean Background
        Container(
          color: isDark ? const Color(0xFF0F0F16) : const Color(0xFFFFFFFF),
        ),

        // 2. High-Performance Gradient Blobs (No BackdropFilter)
        // We use simple stacked containers with radial gradients.
        // For Social App vibe (Locket), we want very soft, large-scale glows.

        // Top Right Glow
        Positioned(
          top: -200,
          right: -100,
          child: _GlowOrb(
            size: 600,
            color: theme.colorScheme.primary.withOpacity(isDark ? 0.15 : 0.08),
          ),
        ),

        // Bottom Left Glow
        Positioned(
          bottom: -200,
          left: -150,
          child: _GlowOrb(
            size: 700,
            color: const Color(0xFF00C8FF).withOpacity(isDark ? 0.1 : 0.05),
          ),
        ),

        // Center Left Accent
        Positioned(
          top: 300,
          left: -100,
          child: _GlowOrb(
            size: 400,
            color: Colors.purpleAccent.withOpacity(isDark ? 0.08 : 0.03),
          ),
        ),

        // Content
        SafeArea(child: child),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.5,
          colors: [color, color.withOpacity(0)],
          stops: const [0.2, 1.0], // Sharper inner, smoother outer
        ),
      ),
    );
  }
}
