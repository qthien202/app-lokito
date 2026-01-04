import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lokito/core/constants/supabase_constants.dart';
import 'package:lokito/core/provider/supabase_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/post_model.dart';
import 'mock_posts_data.dart';

abstract class FeedRepository {
  Future<List<PostModel>> getPosts({int page = 0, int limit = 10});
  Future<PostModel> toggleLike(String postId, bool isLiked);
  Future<void> deletePost(String postId);
  Future<PostModel> createPost({required PostModel post});
}

class FeedRepositoryImpl implements FeedRepository {
  final SupabaseClient _supabaseClient;

  FeedRepositoryImpl(this._supabaseClient);

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
    try {} catch (e) {
      print('Failed to delete image from Cloudinary: $e');
      // Don't throw error, post is already deleted from data
    }
  }

  @override
  Future<PostModel> createPost({required PostModel post}) async {
    final currentUser = _supabaseClient.auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not logged in');
    }

    try {
      // Insert post into Supabase
      // Note: We need to match the table schema.
      // Usually: id, profile_id, content, image_url, created_at
      final postData = {
        'id': post.id,
        'profile_id': currentUser.id, // Assumes relation to profiles table
        'content': post.content,
        'image_url': post.imageUrl,
      };

      await _supabaseClient.from(SupabaseConstants.postsTable).insert(postData);
      MockPostsData.posts.insert(0, post);

      return post;
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }
}

// Riverpod provider with proper DI
final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return FeedRepositoryImpl(supabaseClient);
});
