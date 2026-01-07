import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lokito/core/core.dart';
import 'package:lokito/features/auth/presentation/controllers/auth_controller.dart';
import 'package:lokito/features/feed/presentation/widgets/post_list.dart';
import 'package:lokito/i18n/strings.g.dart';

import '../controllers/feed_controller.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    final maxScrollExtent = position.maxScrollExtent;
    final currentPixels = position.pixels;

    // Load more when user scrolls to 80% of current content
    // This provides smooth experience without being too aggressive
    final loadThreshold = maxScrollExtent * 0.8;

    if (currentPixels >= loadThreshold && maxScrollExtent > 0) {
      ref.read(feedControllerProvider.notifier).loadMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final feedState = ref.watch(feedControllerProvider);
    final user = authState.user;
    final brightness = MediaQuery.platformBrightnessOf(context);
    final isDark = brightness == Brightness.dark;
    final theme = Theme.of(context);

    ref.listen(feedControllerProvider, (previous, next) {
      if (next.error != null &&
          !next.isLoading &&
          !next.isLoadingMore &&
          !next.isRefreshing) {
        SnackbarUtils.showError(context, context.mapErrorMessage(next.error!));
        ref.read(feedControllerProvider.notifier).clearError();
      }

      // Scroll to top when a new uploading post is added
      if (next.posts.isNotEmpty) {
        final firstPost = next.posts.first;
        final previousFirstPost =
            (previous != null && previous.posts.isNotEmpty)
            ? previous.posts.first
            : null;

        // Check if the top post is new and is in uploading state (optimistic)
        if (firstPost.isUploading &&
            (previousFirstPost == null ||
                previousFirstPost.id != firstPost.id)) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        }
      }
    });

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(feedControllerProvider.notifier).refreshPosts();
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            appBar(theme: theme, context: context),
            PostList(),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  SliverAppBar appBar({
    required ThemeData theme,
    required BuildContext context,
  }) {
    return SliverAppBar(
      pinned: true,
      centerTitle: false,
      elevation: 0,
      backgroundColor: theme.colorScheme.background.withOpacity(0.6),

      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            color: theme.colorScheme.background.withOpacity(0.3),
          ),
        ),
      ),

      actionsPadding: EdgeInsets.symmetric(horizontal: 10),
      title: Text(t.feed.title, style: TextStyle(fontWeight: FontWeight.w700)),

      actions: [],
    );
  }
}
