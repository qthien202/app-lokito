import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/feed_repository.dart';
import 'feed_state.dart';

class FeedController extends Notifier<FeedState> {
  late final FeedRepository _repository;

  @override
  FeedState build() {
    _repository = ref.watch(feedRepositoryProvider);

    // Initialize with initializing state
    state = const FeedState(isInitializing: true, isLoading: true);
    _loadInitialPosts();

    return state;
  }

  Future<void> _loadInitialPosts() async {
    try {
      final posts = await _repository.getPosts(page: 0, limit: 10);
      state = state.copyWith(
        posts: posts,
        isLoading: false,
        isInitializing: false, // Mark initialization complete
        currentPage: 0,
        hasReachedMax: posts.length < 10,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isInitializing: false, // Mark initialization complete even on error
        error: 'errorFailedToLoadPosts',
      );
    }
  }

  Future<void> loadInitialPosts() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, isInitializing: true, error: null);
    await _loadInitialPosts();
  }

  Future<void> loadMorePosts() async {
    if (state.isLoadingMore || state.hasReachedMax) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final newPosts = await _repository.getPosts(page: nextPage, limit: 10);

      state = state.copyWith(
        posts: [...state.posts, ...newPosts],
        isLoadingMore: false,
        currentPage: nextPage,
        hasReachedMax: newPosts.length < 10,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: 'errorFailedToLoadPosts',
      );
    }
  }

  Future<void> refreshPosts() async {
    if (state.isRefreshing) return;

    state = state.copyWith(isRefreshing: true, error: null);

    try {
      final posts = await _repository.getPosts(page: 0, limit: 10);
      state = state.copyWith(
        posts: posts,
        isRefreshing: false,
        currentPage: 0,
        hasReachedMax: posts.length < 10,
      );
    } catch (e) {
      state = state.copyWith(
        isRefreshing: false,
        error: 'errorFailedToLoadPosts',
      );
    }
  }

  Future<void> toggleLike(String postId) async {
    final postIndex = state.posts.indexWhere((post) => post.id == postId);
    if (postIndex == -1) return;

    final post = state.posts[postIndex];
    final newLikedState = !post.isLiked;

    // Optimistic update
    final updatedPosts = [...state.posts];
    updatedPosts[postIndex] = post.copyWith(
      isLiked: newLikedState,
      likes: newLikedState ? post.likes + 1 : post.likes - 1,
    );
    state = state.copyWith(posts: updatedPosts);

    try {
      final updatedPost = await _repository.toggleLike(postId, newLikedState);

      // Update with server response
      final finalPosts = [...state.posts];
      final finalIndex = finalPosts.indexWhere((p) => p.id == postId);
      if (finalIndex != -1) {
        finalPosts[finalIndex] = updatedPost;
        state = state.copyWith(posts: finalPosts);
      }
    } catch (e) {
      // Revert optimistic update on error
      final revertedPosts = [...state.posts];
      revertedPosts[postIndex] = post;
      state = state.copyWith(
        posts: revertedPosts,
        error: 'errorFailedToUpdateLike',
      );
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _repository.deletePost(postId);

      final updatedPosts = state.posts
          .where((post) => post.id != postId)
          .toList();
      state = state.copyWith(posts: updatedPosts);
    } catch (e) {
      state = state.copyWith(error: 'errorFailedToDeletePost');
    }
  }

  Future<void> createPost({
    required String content,
    required File imagFile,
  }) async {
    try {
      final newPost = await _repository.createPost(
        content: content,
        imageFile: imagFile,
      );

      state = state.copyWith(posts: [newPost, ...state.posts]);
    } catch (e) {
      state = state.copyWith(error: 'errorFailedToCreatePost');
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Riverpod provider
final feedControllerProvider = NotifierProvider<FeedController, FeedState>(
  FeedController.new,
);
