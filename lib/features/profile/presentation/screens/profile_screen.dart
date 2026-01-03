import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lokito/core/theme/theme_controller.dart';
import 'package:lokito/core/utils/app_exception.dart';
import 'package:lokito/core/utils/avatar_utils.dart';
import 'package:lokito/features/auth/presentation/controllers/auth_controller.dart';
import 'package:lokito/features/profile/presentation/widgets/index.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Show title when scrolled past 150px
    final showTitle = _scrollController.offset > 150;
    if (showTitle != _showAppBarTitle) {
      setState(() {
        _showAppBarTitle = showTitle;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeController = ref.watch(themeControllerProvider.notifier);
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;

    // Listen for theme errors
    ref.listen(themeControllerProvider, (previous, next) {
      if (next.error != null && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.mapErrorMessage(next.error!)),
            backgroundColor: theme.colorScheme.error,
          ),
        );
        themeController.clearError();
      }
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // Dynamic based on scroll position and theme
        statusBarIconBrightness: _showAppBarTitle 
          ? (isDark ? Brightness.light : Brightness.dark)  // Sticky: follow theme
          : Brightness.light,  // Expanded: always light on gradient
        statusBarBrightness: _showAppBarTitle 
          ? (isDark ? Brightness.dark : Brightness.light)  // For iOS
          : Brightness.dark,
      ),
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Profile Header with gradient AppBar
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              backgroundColor: theme.colorScheme.surface, // Solid background for sticky
              elevation: 0,
              flexibleSpace: ClipRect(
                child: Container(
                  decoration: BoxDecoration(
                    color: _showAppBarTitle 
                      ? theme.colorScheme.surface // Solid when sticky
                      : Colors.transparent, // Transparent when expanded (show gradient)
                  ),
                  child: FlexibleSpaceBar(
                    background: const ProfileHeader(),
                    collapseMode: CollapseMode.parallax,
                    title: _showAppBarTitle
                        ? Text(
                            AvatarUtils.getDisplayName(
                              username: user?.username,
                              email: user?.email,
                            ),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurface, // Theme text color
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
                    titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                  ),
                ),
              ),
            ),

            // Profile Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Settings Section
                    const ProfileSettingsSection(),

                    const SizedBox(height: 32),

                    // Account Section
                    const ProfileAccountSection(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 90)),
          ],
        ),
      ),
    );
  }
}
