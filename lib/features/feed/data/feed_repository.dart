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
    final currentUser = _supabaseClient.auth.currentUser;

    try {
      final response = await _supabaseClient
          .from(SupabaseConstants.postsTable)
          .select('*, profiles(username, avatar_url)')
          .order('created_at', ascending: false)
          .range(from, to);

      final List<dynamic> data = response as List<dynamic>;
      final postIds = data.map((json) => json['id'] as String).toList();

      // Fetch liked post IDs for current user
      final Set<String> likedPostIds = {};
      if (currentUser != null && postIds.isNotEmpty) {
        final reactionsResponse = await _supabaseClient
            .from(SupabaseConstants.reactionsTable)
            .select('post_id')
            .eq('profile_id', currentUser.id)
            .inFilter('post_id', postIds);

        for (final row in reactionsResponse as List) {
          likedPostIds.add(row['post_id'] as String);
        }
      }

      final posts = PostMapper.fromSupabaseList(
        data,
        likedPostIds: likedPostIds,
      );

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
    final currentUser = _supabaseClient.auth.currentUser;
    if (currentUser == null) throw Exception('User not logged in');

    try {
      if (isLiked) {
        // Add like
        await _supabaseClient.from(SupabaseConstants.reactionsTable).insert({
          'post_id': postId,
          'profile_id': currentUser.id,
          'type': 'like',
        });
      } else {
        // Remove like
        await _supabaseClient
            .from(SupabaseConstants.reactionsTable)
            .delete()
            .eq('post_id', postId)
            .eq('profile_id', currentUser.id);
      }

      // Fetch updated post data
      final response = await _supabaseClient
          .from(SupabaseConstants.postsTable)
          .select('*, profiles(username, avatar_url)')
          .eq('id', postId)
          .single();

      final post = PostMapper.fromSupabase(response, isLiked: isLiked);
      return post.copyWith(imageUrl: _cloudinary.getPostImageUrl(post.id));
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
