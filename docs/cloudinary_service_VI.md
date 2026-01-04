# Dịch vụ Lưu trữ Media Cloudinary

`CloudinaryService` (hiện thực `MediaStorageService`) là một tiện ích cốt lõi trong Lokito chịu trách nhiệm quản lý tài nguyên media. Nó cung cấp API sạch để tải lên, xóa và biến đổi hình ảnh một cách linh hoạt.

## Cấu hình

Dịch vụ sử dụng các thông tin xác thực được định nghĩa trong lớp `Env`. Đảm bảo tệp `.env` của bạn được cấu hình đúng:

```env
CLOUDINARY_CLOUD_NAME=tên_cloud_của_bạn
CLOUDINARY_API_KEY=api_key_của_bạn
CLOUDINARY_API_SECRET=api_secret_của_bạn
```

## Khởi tạo

Khởi tạo dịch vụ trong quá trình khởi động ứng dụng:

```dart
// main.dart
await CloudinaryService.initialize();
```

## Các tính năng chính

Truy cập dịch vụ bằng Riverpod hoặc instance singleton:

```dart
final mediaStorage = ref.watch(mediaStorageProvider);
```

### 1. Tải lên Media

- **Tải lên bài viết Optimistic**:
  ```dart
  await mediaStorage.uploadPostMedia(file, postId, onProgress: (c, t) => ...);
  ```
- **Tài sản Hồ sơ**:
  - `uploadAvatar(file, userId)`
  - `uploadCoverPhoto(file, userId)`

### 2. Tạo URL & Biến đổi

Cloudinary hỗ trợ các biến đổi mạnh mẽ ngay tức thì:

- **Phân phối Tối ưu**:
  ```dart
  String url = cloudinary.getOptimizedUrl(publicId, width: 1080);
  ```
- **Hình thu nhỏ (Thumbnail)**:
  ```dart
  String thumbUrl = cloudinary.getThumbnailUrl(publicId, size: 200);
  ```

## Thực hành tốt nhất

1. **Nén trước khi tải**: Luôn sử dụng `MediaUtils.compressImage` trước khi gọi dịch vụ tải lên để giảm thiểu sử dụng dữ liệu.
2. **Public ID có thể dự đoán**: Sử dụng các thực thể domain (User IDs, Post IDs) làm `publicId` để đảm bảo tính nhất quán và dễ dàng dọn dẹp.
3. **Tiến trình xác định (Determinate Progress)**: Sử dụng callback `onProgress` để cung cấp phản hồi giao diện thời gian thực nhằm mang lại cảm giác cao cấp.

## Xử lý lỗi

Tất cả các phương thức đều ném ra `CloudinaryException` khi có lỗi mạng hoặc cấu hình. Luôn bọc các lời gọi trong khối `try-catch` ở cấp độ controller.
