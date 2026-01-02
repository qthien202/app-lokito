import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/post_model.dart';
import 'mock_posts_data.dart';

abstract class FeedRepository {
  Future<List<PostModel>> getPosts({int page = 0, int limit = 10});
  Future<PostModel> toggleLike(String postId, bool isLiked);
  Future<void> deletePost(String postId);
  Future<PostModel> createPost({
    required String content,
    String? imageUrl,
  });
}

class FeedRepositoryImpl implements FeedRepository {
  // Simulate network delay
  Future<void> _simulateDelay() async {
    await Future.delayed(Duration(milliseconds: 800 + (DateTime.now().millisecondsSinceEpoch % 400)));
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
    
    // In real app, this would be API call to delete post
    final posts = MockPostsData.posts;
    posts.removeWhere((post) => post.id == postId);
  }

  @override
  Future<PostModel> createPost({
    required String content,
    String? imageUrl,
  }) async {
    await _simulateDelay();
    
    final newPost = PostModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorName: 'Current User', // In real app, get from auth
      authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      imageUrl: imageUrl ?? 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=400&fit=crop',
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

// Riverpod provider
final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return FeedRepositoryImpl();
});