import '../domain/post_model.dart';

class PostMapper {
  /// Maps a single Supabase post row (with joined profiles) to a PostModel.
  static PostModel fromSupabase(
    Map<String, dynamic> json, {
    bool isLiked = false,
  }) {
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
      isLiked: isLiked,
    );
  }

  /// Maps a list of Supabase post rows to a list of PostModels.
  static List<PostModel> fromSupabaseList(
    List<dynamic> data, {
    Set<String> likedPostIds = const {},
  }) {
    return data.map((json) {
      final map = json as Map<String, dynamic>;
      final id = map['id'] as String;
      return fromSupabase(map, isLiked: likedPostIds.contains(id));
    }).toList();
  }
}
