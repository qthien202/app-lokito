import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lokito/core/constants/supabase_constants.dart';
import 'package:lokito/core/provider/supabase_provider.dart';
import 'package:lokito/core/services/media_storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'post_mapper.dart';
import '../domain/post_model.dart';

abstract class FeedRepository {
  Future<List<PostModel>> getPosts({int page = 0, int limit = 10});
  Future<PostModel> toggleLike(String postId, bool isLiked);
  Future<void> deletePost(String postId);
  Future<PostModel> createPost({required PostModel post});
}

class FeedRepositoryImpl implements FeedRepository {
  final SupabaseClient _supabaseClient;
  final CloudinaryService _cloudinary;

  FeedRepositoryImpl(this._supabaseClient, this._cloudinary);

  @override
  Future<List<PostModel>> getPosts({int page = 0, int limit = 10}) async {
    final from = page * limit;
    final to = from + limit - 1;

    try {
      final response = await _supabaseClient
          .from(SupabaseConstants.postsTable)
          .select('*, profiles(username, avatar_url)')
          .order('created_at', ascending: false)
          .range(from, to);

      final List<dynamic> data = response as List<dynamic>;
      final posts = PostMapper.fromSupabaseList(data);

      return posts
          .map(
            (post) =>
                post.copyWith(imageUrl: _cloudinary.getPostImageUrl(post.id)),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  @override
  Future<PostModel> toggleLike(String postId, bool isLiked) async {
    try {
      // Basic implementation: update likes_count on posts table
      // In a real app, logic would be:
      // 1. Add/Remove row in 'reactions' table
      // 2. Refresh likes_count (usually via DB trigger)

      // For now, let's just update the count directly as a placeholder
      // and return the updated post (simplified)

      final currentPostResponse = await _supabaseClient
          .from(SupabaseConstants.postsTable)
          .select('likes_count')
          .eq('id', postId)
          .single();

      int currentLikes = currentPostResponse['likes_count'] ?? 0;
      int newLikes = isLiked
          ? currentLikes + 1
          : (currentLikes - 1).clamp(0, 999999);

      await _supabaseClient
          .from(SupabaseConstants.postsTable)
          .update({'likes_count': newLikes})
          .eq('id', postId);

      // Fetch full post to return
      final posts = await getPosts(page: 0, limit: 100);
      return posts.firstWhere((p) => p.id == postId);
    } catch (e) {
      throw Exception('Failed to toggle like: $e');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await _supabaseClient
          .from(SupabaseConstants.postsTable)
          .delete()
          .eq('id', postId);

      // Also delete from Cloudinary
      await _cloudinary.deletePostMedia(postId);
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  @override
  Future<PostModel> createPost({required PostModel post}) async {
    final currentUser = _supabaseClient.auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not logged in');
    }

    try {
      final postData = {
        'id': post.id,
        'profile_id': currentUser.id,
        'content': post.content,
        'image_url': post
            .imageUrl, // We store the real URL but getPosts will optimize it
      };

      await _supabaseClient.from(SupabaseConstants.postsTable).insert(postData);
      return post;
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }
}

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  final cloudinary = ref.watch(cloudinaryServiceProvider);
  return FeedRepositoryImpl(supabaseClient, cloudinary);
});
