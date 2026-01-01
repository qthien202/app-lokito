import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lokito/core/core.dart';
import 'package:lokito/features/onboarding/domain/onboarding_item.dart';
import 'package:lokito/features/onboarding/presentation/widgets/onboarding_page.dart';
import 'package:lokito/i18n/strings.g.dart';

class OnboardingScreen extends StatefulWidget {
  static const path = '/';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingItem> get _items => [
    OnboardingItem(
      title: t.onboarding.page1.title,
      subtitle: t.onboarding.page1.subtitle,
      lottieAsset: 'assets/lotties/connection.json',
    ),
    OnboardingItem(
      title: t.onboarding.page2.title,
      subtitle: t.onboarding.page2.subtitle,
      lottieAsset: 'assets/lotties/share.json',
    ),
    OnboardingItem(
      title: t.onboarding.page3.title,
      subtitle: t.onboarding.page3.subtitle,
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
    final items = _items;

    return Scaffold(
      body: AppBackground(
        child: Column(
          children: [
            _buildTopBar(context, theme),
            _buildPageView(items),
            _buildBottomBar(theme, context, items.length),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => context.push(AppRoutes.login),
            child: Text(
              t.common.skip,
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

  Widget _buildBottomBar(ThemeData theme, BuildContext context, int itemCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIndicators(theme, itemCount),
          const SizedBox(height: 32),
          PrimaryButton(
            text: _currentPage == itemCount - 1
                ? t.common.getStarted
                : t.common.next,
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
