[ 🇬🇧 English ](#english) | [ 🇻🇳 Tiếng Việt ](#vietnamese)

---

<a name="english"></a>
# Cloudinary Service Documentation

## Overview
The `CloudinaryService` (now implementing `MediaStorageService`) is a core utility in Lokito responsible for managing media assets. It provides a clean API for uploading, deleting, and transforming images using the Cloudinary platform.

## Configuration

The service relies on credentials defined in the `Env` class. Ensure your `.env` file contains:

```env
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
```

## Initialization

The service must be initialized before use, typically during the application startup process:

```dart
await CloudinaryService.initialize();
```

## Usage

Access the service via its provider or singleton instance:

```dart
final mediaStorage = ref.watch(mediaStorageProvider);
// or
final cloudinary = CloudinaryService.instance;
```

### 1. Uploading Images

The service provides general and specialized upload methods:

- **General Upload**:
  ```dart
  final response = await cloudinary.uploadImage(
    file: imageFile,
    folder: 'my_folder',
    tags: ['tag1', 'tag2'],
  );
  ```

- **Specialized Methods**:
  - `uploadAvatar(file, userId)`: Uploads to the `avatars` folder with the user's ID as public ID.
  - `uploadPostMedia(file, postId)`: Uploads to the `posts` folder.
  - `uploadCoverPhoto(file, userId)`: Uploads to the `covers` folder.

### 2. Deleting Images

- `deleteImage(publicId)`: Deletes an asset by its public ID.
- `deleteAvatar(userId)`, `deletePostMedia(postId)`, etc.

### 3. URL Generation & Transformations

Cloudinary's power lies in dynamic transformations. The service provides optimized URL generation:

- **Optimized URL**:
  ```dart
  String url = cloudinary.getOptimizedUrl(
    publicId, 
    width: 800, 
    height: 600,
    quality: 'auto', // 'auto', 'best', 'good', 'low'
    format: 'auto',  // webp, jpg, etc.
  );
  ```

- **Thumbnails**:
  ```dart
  String thumbUrl = cloudinary.getThumbnailUrl(publicId, size: 200);
  ```

## Best Practices

1. **Compression**: Always compress images using `MediaUtils` before uploading to save bandwidth and storage.
2. **Naming**: Use meaningful Folder names and Public IDs (e.g., User IDs or Post IDs) to keep the Cloudinary storage organized.
3. **Lazy Loading**: Use the generated URLs with `CachedNetworkImage` for better performance on mobile.

## Constants

Default values for sizes and folders are defined in `lib/core/constants/cloudinary_constants.dart`.

## Error Handling

All methods may throw a `CloudinaryException`. It is recommended to wrap calls in try-catch blocks:

```dart
try {
  await cloudinary.uploadAvatar(file, userId);
} catch (e) {
  print('Failed to upload: $e');
}
```

---

<a name="vietnamese"></a>
# Tài liệu Dịch vụ Cloudinary

## Tổng quan
`CloudinaryService` (hiện thực thi `MediaStorageService`) là một tiện ích cốt lõi trong Lokito chịu trách nhiệm quản lý tài nguyên media. Nó cung cấp API gọn gàng để tải lên, xóa và chuyển đổi hình ảnh bằng nền tảng Cloudinary.

## Cấu hình

Dịch vụ dựa vào thông tin đăng nhập được định nghĩa trong lớp `Env`. Đảm bảo file `.env` của bạn chứa:

```env
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
```

## Khởi tạo

Dịch vụ phải được khởi tạo trước khi sử dụng, thường là trong quá trình khởi động ứng dụng:

```dart
await CloudinaryService.initialize();
```

## Cách dùng

Truy cập dịch vụ thông qua provider hoặc singleton instance của nó:

```dart
final mediaStorage = ref.watch(mediaStorageProvider);
// hoặc
final cloudinary = CloudinaryService.instance;
```

### 1. Tải lên Hình ảnh

Dịch vụ cung cấp các phương thức tải lên chung và chuyên biệt:

- **Tải lên Chung**:
  ```dart
  final response = await cloudinary.uploadImage(
    file: imageFile,
    folder: 'my_folder',
    tags: ['tag1', 'tag2'],
  );
  ```

- **Phương thức Chuyên biệt**:
  - `uploadAvatar(file, userId)`: Tải lên thư mục `avatars` với ID người dùng làm public ID.
  - `uploadPostImage(file, postId)`: Tải lên thư mục `posts`.
  - `uploadCoverPhoto(file, userId)`: Tải lên thư mục `covers`.

### 2. Xóa Hình ảnh

- `deleteImage(publicId)`: Xóa tài nguyên theo public ID.
- `deleteAvatar(userId)`, `deletePostImage(postId)`, v.v.

### 3. Tạo URL & Chuyển đổi

Sức mạnh của Cloudinary nằm ở khả năng chuyển đổi động. Dịch vụ cung cấp tính năng tạo URL được tối ưu hóa:

- **URL Tối ưu**:
  ```dart
  String url = cloudinary.getOptimizedUrl(
    publicId, 
    width: 800, 
    height: 600,
    quality: 'auto', // 'auto', 'best', 'good', 'low'
    format: 'auto',  // webp, jpg, etc.
  );
  ```

- **Thumbnails (Hình thu nhỏ)**:
  ```dart
  String thumbUrl = cloudinary.getThumbnailUrl(publicId, size: 200);
  ```

## Thực hành Tốt nhất (Best Practices)

1. **Nén ảnh**: Luôn nén ảnh bằng `MediaUtils` trước khi tải lên để tiết kiệm băng thông và dung lượng lưu trữ.
2. **Đặt tên**: Sử dụng tên Thư mục và Public ID có ý nghĩa (ví dụ: User ID hoặc Post ID) để giữ cho kho lưu trữ Cloudinary được ngăn nắp.
3. **Lazy Loading**: Sử dụng các URL được tạo với `CachedNetworkImage` để có hiệu suất tốt hơn trên thiết bị di động.

## Hằng số

Các giá trị mặc định cho kích thước và thư mục được định nghĩa trong `lib/core/constants/cloudinary_constants.dart`.

## Xử lý Lỗi

Tất cả các phương thức có thể ném ra `CloudinaryException`. Khuyến khích bọc các lệnh gọi trong khối try-catch:

```dart
try {
  await cloudinary.uploadAvatar(file, userId);
} catch (e) {
  print('Failed to upload: $e');
}
```
