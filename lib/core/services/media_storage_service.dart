import 'dart:io';

// ignore: implementation_imports
import 'package:cloudinary_api/src/request/model/params/resource_type.dart'
    as cloudinary_params;
// ignore: implementation_imports
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
// ignore: implementation_imports
import 'package:cloudinary_api/src/response/upload_result.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_api/uploader/uploader.dart';
import 'package:cloudinary_api/uploader/uploader_response.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_url_gen/transformation/delivery/delivery.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/cloudinary_constants.dart';
import '../environment/env.dart';

abstract class MediaStorageService {
  /// Upload media for a post (image/video).
  /// Returns the secure URL of the uploaded media.
  Future<String?> uploadPostMedia(
    File file,
    String postId, {
    void Function(int count, int total)? onProgress,
  });

  /// Upload user avatar.
  Future<String?> uploadAvatar(File file, String userId);

  /// Upload user cover photo.
  Future<String?> uploadCoverPhoto(File file, String userId);

  /// Delete post media.
  Future<bool> deletePostMedia(String postId);
}

class CloudinaryService implements MediaStorageService {
  static CloudinaryService? _instance;
  static CloudinaryService get instance {
    _instance ??= CloudinaryService._();
    return _instance!;
  }

  CloudinaryService._();

  late final Cloudinary _cloudinary;
  late final Uploader _uploader;

  // Initialize Cloudinary
  static Future<void> initialize() async {
    final cloudinary = Cloudinary.fromStringUrl(
      'cloudinary://${Env.cloudinaryApiKey}:${Env.cloudinaryApiSecret}@${Env.cloudinaryCloudName}',
    );

    instance._cloudinary = cloudinary;
    instance._uploader = cloudinary.uploader();
  }

  // Getters
  Cloudinary get client => _cloudinary;
  Uploader get uploader => _uploader;

  // --- Interface Implementation ---

  @override
  Future<String?> uploadPostMedia(
    File file,
    String postId, {
    void Function(int count, int total)? onProgress,
  }) async {
    // For now we assume image. In future check mime type for video.
    final response = await uploadPostImage(
      file,
      postId,
      onProgress: onProgress,
    );
    return response.data?.secureUrl;
  }

  @override
  Future<String?> uploadAvatar(File file, String userId) async {
    final response = await _uploadAvatar(file, userId);
    return response.data?.secureUrl;
  }

  @override
  Future<String?> uploadCoverPhoto(File file, String userId) async {
    final response = await _uploadCoverPhoto(file, userId);
    return response.data?.secureUrl;
  }

  @override
  Future<bool> deletePostMedia(String postId) async {
    return deletePostImage(postId);
  }

  // --- Specific Cloudinary Implementation ---

  // Upload image to Cloudinary
  Future<UploaderResponse<UploadResult>> uploadImage({
    required File file,
    String? folder,
    String? publicId,
    List<String>? tags,
    bool useFilename = false,
    bool uniqueFilename = true,
    cloudinary_params.ResourceType resourceType =
        cloudinary_params.ResourceType.image,
    void Function(int count, int total)? onProgress,
  }) async {
    try {
      final params = UploadParams(
        folder: folder,
        publicId: publicId,
        tags: tags,
        useFilename: useFilename,
        uniqueFilename: uniqueFilename,
        resourceType: resourceType.name,
      );

      final response = await _uploader.upload(
        file,
        params: params,
        progressCallback: onProgress,
      );

      if (response != null &&
          response.responseCode >= 200 &&
          response.responseCode < 300) {
        return response;
      } else {
        throw CloudinaryException(
          'Upload failed: ${response?.error?.toString() ?? "Unknown error"}',
        );
      }
    } catch (e) {
      throw CloudinaryException('Upload error: $e');
    }
  }

  // Delete image from Cloudinary
  Future<bool> deleteImage(
    String publicId, {
    cloudinary_params.ResourceType resourceType =
        cloudinary_params.ResourceType.image,
  }) async {
    try {
      final response = await _uploader.destroy(
        DestroyParams(
          publicId: publicId,
          resourceType: resourceType.name,
          invalidate: true,
        ),
      );

      return response.responseCode >= 200 && response.responseCode < 300;
    } catch (e) {
      throw CloudinaryException('Delete error: $e');
    }
  }

  // Generate optimized image URL
  String getOptimizedUrl(
    String publicId, {
    int? width,
    int? height,
    String quality = 'auto',
    String format = 'auto',
  }) {
    final image = _cloudinary.image(publicId);
    final transformation = Transformation();

    if (width != null || height != null) {
      transformation.resize(
        Resize.scale()
          ..width(width)
          ..height(height),
      );
    }

    transformation.delivery(Delivery.quality(quality));
    transformation.delivery(Delivery.format(format));

    image.transformation(transformation);
    return image.toString();
  }

  // Generate thumbnail URL
  String getThumbnailUrl(
    String publicId, {
    int size = CloudinaryConstants.thumbnailSize,
  }) {
    final image = _cloudinary.image(publicId);
    final transformation = Transformation();

    transformation.resize(
      Resize.fill()
        ..width(size)
        ..height(size),
    );
    transformation.delivery(Delivery.quality('auto:good'));
    transformation.delivery(Delivery.format('auto'));

    image.transformation(transformation);
    return image.toString();
  }

  Future<UploaderResponse<UploadResult>> _uploadAvatar(
    File file,
    String userId,
  ) {
    return uploadImage(
      file: file,
      folder: CloudinaryConstants.avatarsFolder,
      publicId: userId,
      tags: ['avatar'],
    );
  }

  Future<UploaderResponse<UploadResult>> uploadPostImage(
    File file,
    String postId, {
    void Function(int count, int total)? onProgress,
  }) {
    return uploadImage(
      file: file,
      folder: CloudinaryConstants.postsFolder,
      publicId: postId,
      tags: ['post'],
      onProgress: onProgress,
    );
  }

  Future<UploaderResponse<UploadResult>> _uploadCoverPhoto(
    File file,
    String userId,
  ) {
    return uploadImage(
      file: file,
      folder: CloudinaryConstants.coverPhotosFolder,
      publicId: userId,
      tags: ['cover'],
    );
  }

  // Delete methods for different types
  Future<bool> deleteAvatar(String userId) {
    return deleteImage('${CloudinaryConstants.avatarsFolder}/$userId');
  }

  Future<bool> deletePostImage(String postId) {
    return deleteImage('${CloudinaryConstants.postsFolder}/$postId');
  }

  Future<bool> deleteCoverPhoto(String userId) {
    return deleteImage('${CloudinaryConstants.coverPhotosFolder}/$userId');
  }

  // Get URL methods
  String getAvatarUrl(
    String userId, {
    int size = CloudinaryConstants.avatarSize,
  }) {
    return getThumbnailUrl(
      '${CloudinaryConstants.avatarsFolder}/$userId',
      size: size,
    );
  }

  String getPostImageUrl(String postId, {int? width, int? height}) {
    return getOptimizedUrl(
      '${CloudinaryConstants.postsFolder}/$postId',
      width: width ?? CloudinaryConstants.postImageWidth,
      height: height,
    );
  }

  String getCoverPhotoUrl(String userId, {int? width, int? height}) {
    return getOptimizedUrl(
      '${CloudinaryConstants.coverPhotosFolder}/$userId',
      width: width,
      height: height,
    );
  }

  // Get raw Cloudinary URL (no transformation)
  String getRawUrl(String publicId) {
    return _cloudinary.image(publicId).toString();
  }

  // Check if image exists
  Future<bool> imageExists(String publicId) async {
    try {
      final response = await _uploader.explicit(ExplicitParams(publicId));
      return response.responseCode >= 200 && response.responseCode < 300;
    } catch (e) {
      return false;
    }
  }
}

// Custom exception
class CloudinaryException implements Exception {
  final String message;
  CloudinaryException(this.message);

  @override
  String toString() => 'CloudinaryException: $message';
}

final cloudinaryServiceProvider = Provider<CloudinaryService>(
  (ref) => CloudinaryService.instance,
);

// Map the abstract provider to this implementation
final mediaStorageProvider = Provider<MediaStorageService>((ref) {
  return ref.watch(cloudinaryServiceProvider);
});
