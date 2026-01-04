import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lokito/core/services/cloudinary_services.dart';

import '../domain/post_model.dart';
import 'mock_posts_data.dart';

abstract class FeedRepository {
  Future<List<PostModel>> getPosts({int page = 0, int limit = 10});
  Future<PostModel> toggleLike(String postId, bool isLiked);
  Future<void> deletePost(String postId);
  Future<PostModel> createPost({
    required String content,
    File imageFile, // ← Changed from imageUrl to imageFile
  });
}

class FeedRepositoryImpl implements FeedRepository {
  final CloudinaryService _cloudinaryService;

  FeedRepositoryImpl(this._cloudinaryService);

  // Simulate network delay
  Future<void> _simulateDelay() async {
    await Future.delayed(
      Duration(
        milliseconds: 800 + (DateTime.now().millisecondsSinceEpoch % 400),
      ),
    );
  }

  @override
  Future<List<PostModel>> getPosts({int page = 0, int limit = 10}) async {
    await _simulateDelay();

    if (page == 0) {
      // Return initial posts (first 10 from 50 posts)
      final posts = MockPostsData.posts;
      return posts.take(limit).toList();
    } else {
      // Return paginated posts, but limit to total 50 posts
      final allPosts = MockPostsData.posts;
      final startIndex = page * limit;

      // If we've reached the end of our 50 posts, return empty list
      if (startIndex >= allPosts.length) {
        return [];
      }

      // Return remaining posts up to the limit
      final endIndex = (startIndex + limit).clamp(0, allPosts.length);
      return allPosts.sublist(startIndex, endIndex);
    }
  }

  @override
  Future<PostModel> toggleLike(String postId, bool isLiked) async {
    await _simulateDelay();

    // Find the post and toggle like
    final posts = MockPostsData.posts;
    final postIndex = posts.indexWhere((post) => post.id == postId);

    if (postIndex != -1) {
      final post = posts[postIndex];
      final updatedPost = post.copyWith(
        isLiked: isLiked,
        likes: isLiked ? post.likes + 1 : post.likes - 1,
      );

      // Update the mock data (in real app, this would be API call)
      posts[postIndex] = updatedPost;
      return updatedPost;
    }

    throw Exception('Post not found');
  }

  @override
  Future<void> deletePost(String postId) async {
    await _simulateDelay();

    // Delete from mock data
    final posts = MockPostsData.posts;
    posts.removeWhere((post) => post.id == postId);

    // Delete image from Cloudinary
    try {
      await _cloudinaryService.deletePostImage(postId);
    } catch (e) {
      print('Failed to delete image from Cloudinary: $e');
      // Don't throw error, post is already deleted from data
    }
  }

  @override
  Future<PostModel> createPost({
    required String content,
    File? imageFile, // ← Fixed parameter
  }) async {
    await _simulateDelay();

    String? imageUrl;

    // Upload image if provided
    if (imageFile != null) {
      try {
        final postId = DateTime.now().millisecondsSinceEpoch.toString();
        final response = await _cloudinaryService.uploadPostImage(
          imageFile,
          postId,
        );

        if (response.data != null) {
          imageUrl = response.data!.secureUrl;
        }
      } catch (e) {
        print('Failed to upload image: $e');
        throw Exception('Failed to upload image: $e');
      }
    }

    final newPost = PostModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorName: 'Current User', // In real app, get from auth
      authorAvatar:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      imageUrl: imageUrl!,
      content: content,
      isLiked: false,
      likes: 0,
      createdAt: DateTime.now(),
    );

    // Add to beginning of mock data
    MockPostsData.posts.insert(0, newPost);
    return newPost;
  }
}

// Riverpod provider with proper DI
final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  final cloudinaryService = ref.watch(cloudinaryServiceProvider);
  return FeedRepositoryImpl(cloudinaryService);
});
