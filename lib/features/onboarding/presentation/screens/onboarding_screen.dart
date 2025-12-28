import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lokito/core/constants/app_routes.dart';
import 'package:lokito/core/core.dart';
import 'package:lokito/features/onboarding/domain/onboarding_item.dart';
import 'package:lokito/features/onboarding/presentation/widgets/onboarding_page.dart';
import 'package:lokito/l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  static const path = '/';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingItem> _getItems(AppLocalizations l10n) => [
    OnboardingItem(
      title: l10n.onboarding1Title,
      subtitle: l10n.onboarding1Subtitle,
      lottieAsset: 'assets/lotties/connection.json',
    ),
    OnboardingItem(
      title: l10n.onboarding2Title,
      subtitle: l10n.onboarding2Subtitle,
      lottieAsset: 'assets/lotties/share.json',
    ),
    OnboardingItem(
      title: l10n.onboarding3Title,
      subtitle: l10n.onboarding3Subtitle,
      lottieAsset: 'assets/lotties/onboarding.json',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final items = _getItems(l10n);

    return Scaffold(
      body: AppBackground(
        child: Column(
          children: [
            _buildTopBar(context, theme, l10n),
            _buildPageView(items),
            _buildBottomBar(theme, context, l10n, items.length),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => context.push(AppRoutes.login),
            child: Text(
              l10n.skip,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageView(List<OnboardingItem> items) {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
        itemCount: items.length,
        itemBuilder: (context, index) {
          return OnboardingPage(item: items[index]);
        },
      ),
    );
  }

  Widget _buildBottomBar(
    ThemeData theme,
    BuildContext context,
    AppLocalizations l10n,
    int itemCount,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIndicators(theme, itemCount),
          const SizedBox(height: 32),
          PrimaryButton(
            text: _currentPage == itemCount - 1 ? l10n.getStarted : l10n.next,
            onPressed: () {
              if (_currentPage < itemCount - 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              } else {
                context.push(AppRoutes.login);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIndicators(ThemeData theme, int itemCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: _currentPage == index ? 20 : 6,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? theme.colorScheme.primary
                : theme.colorScheme.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}
