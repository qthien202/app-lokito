import '../domain/post_model.dart';

class PostMapper {
  /// Maps a single Supabase post row (with joined profiles) to a PostModel.
  static PostModel fromSupabase(Map<String, dynamic> json) {
    final profile = json['profiles'] as Map<String, dynamic>?;
    final postId = json['id'] as String;
    final rawImageUrl = json['image_url'] as String;

    return PostModel(
      id: postId,
      authorName: profile?['username'] ?? 'Unknown',
      authorAvatar: profile?['avatar_url'] ?? '',
      content: json['content'] ?? '',
      imageUrl: rawImageUrl, // Default to raw, will be optimized via copyWith
      fullImageUrl: rawImageUrl,
      likes: json['likes_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      isLiked:
          false, // In a real app, this would be determined by a join with 'reactions'
    );
  }

  /// Maps a list of Supabase post rows to a list of PostModels.
  static List<PostModel> fromSupabaseList(List<dynamic> data) {
    return data
        .map((json) => fromSupabase(json as Map<String, dynamic>))
        .toList();
  }
}
