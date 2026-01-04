import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
abstract class PostModel with _$PostModel {
  const factory PostModel({
    required String id,
    required String authorName,
    required String authorAvatar,
    required String imageUrl,
    required String content,
    @Default(false) bool isLiked,
    @Default(0) int likes,
    @Default(false) bool isUploading, // New field for optimistic UI
    @Default(0.0) double uploadProgress, // Upload progress (0.0 to 1.0)
    @JsonKey(includeFromJson: false, includeToJson: false)
    String? localImagePath, // Path to local file for display before upload
    required DateTime createdAt,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}
