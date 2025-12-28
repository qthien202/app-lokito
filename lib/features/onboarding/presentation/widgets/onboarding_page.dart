import 'package:flutter/material.dart';
import 'package:lokito/features/onboarding/domain/onboarding_item.dart';
import 'package:lottie/lottie.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          children: [
            // Animation Box
            Container(
              height: size.height * 0.28,
              constraints: const BoxConstraints(maxHeight: 280),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Center(
                child: LottieBuilder.asset(
                  item.lottieAsset,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.auto_awesome_rounded,
                    size: 64,
                    color: theme.colorScheme.primary.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Text
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
