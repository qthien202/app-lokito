import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:lokito/i18n/strings.g.dart';

import '../widgets/bottom_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    return Scaffold(
      // KHÔNG đặt bottomNavigationBar nữa
      body: Stack(
        children: [
          /// ----------- LAYER 1: CONTENT -----------
          Positioned.fill(child: navigationShell),

          /// ----------- LAYER 2: BOTTOM BAR (FROSTED) -----------
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRect(
              child: LiquidGlassBottomBar(
                fake: false,
                selectedIndex: navigationShell.currentIndex,
                onTabSelected: _goBranch,
                tabs: [
                  LiquidGlassBottomBarTab(
                    label: t.common.nav.home,
                    icon: Iconsax.home,
                  ),
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

                  // màu glass bên trong bottom bar
                  glassColor: CupertinoTheme.of(
                    context,
                  ).barBackgroundColor.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
