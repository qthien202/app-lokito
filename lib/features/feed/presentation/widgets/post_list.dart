import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lokito/features/feed/presentation/widgets/empty_feed_state.dart';
import 'package:lokito/features/feed/presentation/widgets/post_card.dart';
import 'package:lokito/features/feed/presentation/widgets/post_list_skeleton.dart';
import 'package:lokito/i18n/strings.g.dart';

import '../controllers/feed_controller.dart';

class PostList extends ConsumerStatefulWidget {
  const PostList({super.key});

  @override
  ConsumerState<PostList> createState() => _PostListState();
}

class _PostListState extends ConsumerState<PostList> {
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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(feedControllerProvider.notifier).loadMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedControllerProvider);
    
    // Show skeleton loading during initial load
    if (feedState.isInitializing) {
      return const PostListSkeleton();
    }

    // Show empty state when no posts and not loading
    if (feedState.posts.isEmpty && !feedState.isLoading) {
      return EmptyFeedState(
        onRefresh: () {
          ref.read(feedControllerProvider.notifier).refreshPosts();
        },
      );
    }

    // Show error state when error and no posts
    if (feedState.error != null && feedState.posts.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Text(
                  t.feed.errorOccurred,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  feedState.error!,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(feedControllerProvider.notifier)
                        .loadInitialPosts();
                  },
                  child: Text(t.feed.tryAgain),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Show posts list
    return SliverList.builder(
      itemCount: feedState.posts.length + (feedState.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= feedState.posts.length) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 8),
                  Text(
                    t.feed.loadingMore,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        }

        final post = feedState.posts[index];
        return PostCard(
          post: post,
          onLike: () {
            ref.read(feedControllerProvider.notifier).toggleLike(post.id);
          },
          onDelete: () {
            ref.read(feedControllerProvider.notifier).deletePost(post.id);
          },
        );
      },
    );
  }
}
