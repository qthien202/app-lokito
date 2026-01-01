import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:lokito/features/main/presentation/widgets/bottom_bar.dart';
import 'package:lokito/i18n/strings.g.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final isDark = brightness == Brightness.dark;
    return Scaffold(
      body: navigationShell,

      bottomNavigationBar: LiquidGlassBottomBar(
        fake: false,
        selectedIndex: navigationShell.currentIndex,
        onTabSelected: _goBranch,
        tabs: [
          LiquidGlassBottomBarTab(label: t.common.nav.home, icon: Iconsax.home),
          LiquidGlassBottomBarTab(
            label: t.common.nav.search,
            icon: Iconsax.search_normal,
          ),
          LiquidGlassBottomBarTab(
            label: t.common.nav.chat,
            icon: Iconsax.message,
          ),
          LiquidGlassBottomBarTab(
            label: t.common.nav.profile,
            icon: Iconsax.user,
          ),
        ],
        glassSettings: LiquidGlassSettings(
          refractiveIndex: 1.25,
          thickness: 35,
          blur: 30,
          saturation: 1.7,
          lightIntensity: isDark ? 0.8 : 1.2,
          ambientStrength: isDark ? 0.3 : 0.6,
          lightAngle: math.pi / 4,
          chromaticAberration: 0.4,
          glassColor: CupertinoTheme.of(
            context,
          ).barBackgroundColor.withValues(alpha: 0.7), // Tăng opacity
        ),
      ),
    );
  }
}
