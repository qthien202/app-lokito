import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lokito/core/core.dart';
import 'package:lokito/core/services/media_storage_service.dart';
import 'package:lokito/features/auth/presentation/controllers/auth_controller.dart';

import '../../data/feed_repository.dart';
import '../../domain/post_model.dart';
import 'feed_state.dart';

class FeedController extends Notifier<FeedState> {
  late final FeedRepository _repository;
  late final MediaStorageService _mediaStorage;

  @override
  FeedState build() {
    _repository = ref.watch(feedRepositoryProvider);
    _mediaStorage = ref.watch(mediaStorageProvider);

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
      await _repository.toggleLike(postId, newLikedState);
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

  void addNewPost(PostModel post) {
    state = state.copyWith(posts: [post, ...state.posts]);
  }

  Future<void> createPost({required String content, required File file}) async {
    final user = ref.read(authControllerProvider).user;
    if (user == null) return;

    final tempId = IdGenerator.generate();

    // 1. Create Optimistic Post (Uploading State)
    final tempPost = PostModel(
      id: tempId,
      authorName: user.username,
      authorAvatar: user.avatarUrl ?? '',
      content: content,
      imageUrl: file.path, // Use local path initially
      fullImageUrl: file.path,
      localImagePath: file.path,
      createdAt: DateTime.now(),
      isUploading: true,
    );

    // Update UI immediately (Optimistic add)
    state = state.copyWith(posts: [tempPost, ...state.posts]);

    try {
      // 2. Compress & Upload
      final compressed = await MediaUtils.compressImage(file);
      final remoteUrl = await _mediaStorage.uploadPostMedia(
        compressed ?? file,
        tempId,
        onProgress: (count, total) {
          final progress = count / total;
          state = state.copyWith(
            posts: state.posts.map((p) {
              if (p.id == tempId) {
                return p.copyWith(uploadProgress: progress);
              }
              return p;
            }).toList(),
          );
        },
      );

      if (remoteUrl == null) throw Exception('Upload failed');

      // 3. Create in DB (using the same ID)
      final finalPost = tempPost.copyWith(
        imageUrl: remoteUrl,
        isUploading: false,
        // Keep localImagePath to prevent flicker during transition to network image
      );

      await _repository.createPost(post: finalPost);

      // 4. Update UI with final post (Replace temp post)
      state = state.copyWith(
        posts: state.posts.map((p) => p.id == tempId ? finalPost : p).toList(),
      );
    } catch (e) {
      // On failure, remove the temp post
      // In a real app, we might set isError=true and allow retry
      state = state.copyWith(
        posts: state.posts.where((p) => p.id != tempId).toList(),
      );
      print('Create post failed: $e');
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
