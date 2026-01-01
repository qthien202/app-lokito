# Hướng dẫn Đa ngôn ngữ (Localization) với Slang

Dự án Lokito sử dụng thư viện **Slang** để quản lý đa ngôn ngữ. Slang cung cấp giải pháp type-safe, hỗ trợ namespaces (không gian tên) và không phụ thuộc vào `BuildContext` trong nhiều trường hợp.

## 1. Cấu trúc thư mục

Tất cả các file ngôn ngữ nằm tại `lib/i18n/`. Chúng ta sử dụng cấu trúc **Feature-based Namespaces** (Namespace dựa trên tính năng):

- `auth_en.i18n.json`, `auth_vi.i18n.json`: Ngôn ngữ cho tính năng Auth.
- `onboarding_en.i18n.json`, `onboarding_vi.i18n.json`: Ngôn ngữ cho màn hình Onboarding.
- `common_en.i18n.json`, `common_vi.i18n.json`: Các chuỗi dùng chung toàn app.
- `strings.g.dart`: File code được tạo tự động chứa toàn bộ các bản dịch.

## 2. Cách thêm/sửa nội dung

Để thêm một chuỗi mới:
1. Mở file JSON tương ứng (ví dụ `auth_en.i18n.json`).
2. Thêm key và value.
3. Cập nhật tương ứng vào file tiếng Việt (`auth_vi.i18n.json`).

### Sử dụng tham số (Variables)
Sử dụng cú pháp `$variableName` hoặc `${variableName}` trong file JSON:
```json
"verifySubtitle": "Chúng tôi đã gửi mã xác nhận tới $email"
```

## 3. Cập nhật Code (Generation)

Dự án đã cấu hình Slang tự động tạo code. Mỗi khi bạn thay đổi file `.json`, hãy chạy lệnh sau:

```bash
dart run slang
```
Hoặc nếu muốn chạy liên tục khi lưu file:
```bash
dart run build_runner watch --delete-conflicting-outputs
```

## 4. Cách sử dụng trong Flutter Code

### Truy cập qua đối tượng toàn cục `t`
Vì `t` được khai báo toàn cục trong `strings.g.dart`, bạn có thể gọi trực tiếp ở bất kỳ đâu:

```dart
import 'package:lokito/i18n/strings.g.dart';

// Trong Widget hoặc Logic
print(t.auth.signIn);
print(t.common.email);

// Với tham số
print(t.auth.verifySubtitle(email: 'user@example.com'));
```

### Thay đổi ngôn ngữ
Sử dụng `LocaleSettings`:

```dart
// Chuyển sang tiếng Việt
LocaleSettings.setLocale(AppLocale.vi);

// Lấy ngôn ngữ hiện tại
AppLocale current = LocaleSettings.currentLocale;
```

## 5. Cấu hình kĩ thuật (`slang.yaml`)

File cấu hình Slang nằm ở gốc dự án với các tùy chọn quan trọng:
- `namespaces: true`: Cho phép chia nhỏ file theo tính năng.
- `input_directory: lib/i18n`: Thư mục chứa file nguồn.
- `output_file_name: strings.g.dart`: Gom tất cả vào một file duy nhất.

---
*Lokito Documentation - Updated 2026*
