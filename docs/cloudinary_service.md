# Cloudinary Media Storage Service

The `CloudinaryService` (implementing `MediaStorageService`) is a core utility in Lokito responsible for managing media assets. It provides a clean API for uploading, deleting, and dynamically transforming images.

## Configuration

The service leverages credentials defined in the `Env` class. Ensure your `.env` file is properly configured:

```env
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
```

## Initialization

Initialize the service during the application bootstrap process:

```dart
// main.dart
await CloudinaryService.initialize();
```

## Core Functionality

Access the service using Riverpod or the singleton instance:

```dart
final mediaStorage = ref.watch(mediaStorageProvider);
```

### 1. Media Uploads

- **Optimistic Post Upload**:
  ```dart
  await mediaStorage.uploadPostMedia(file, postId, onProgress: (c, t) => ...);
  ```
- **Profile Assets**:
  - `uploadAvatar(file, userId)`
  - `uploadCoverPhoto(file, userId)`

### 2. URL Generation & Transformations

Cloudinary supports powerful on-the-fly transformations:

- **Optimized Distribution**:
  ```dart
  String url = cloudinary.getOptimizedUrl(publicId, width: 1080);
  ```
- **Contextual Thumbnails**:
  ```dart
  String thumbUrl = cloudinary.getThumbnailUrl(publicId, size: 200);
  ```

## Best Practices

1. **Pre-upload Compression**: Always use `MediaUtils.compressImage` before calling the upload service to minimize data usage.
2. **Predictable Public IDs**: Use domain entities (User IDs, Post IDs) as `publicId` to ensure idempotency and easy cleanup.
3. **Determinate Progress**: Leverage the `onProgress` callback to provide real-time UI feedback for a premium feel.

## Error Handling

All methods throw `CloudinaryException` for network or configuration failures. Always wrap calls in `try-catch` blocks at the controller level.
