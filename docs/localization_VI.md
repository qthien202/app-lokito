# Hướng dẫn Đa ngôn ngữ với Slang

Dự án Lokito sử dụng thư viện **Slang** để xử lý đa ngôn ngữ. Slang cung cấp giải pháp kiểu safe-type, hỗ trợ namespace và không phụ thuộc vào `BuildContext` trong nhiều trường hợp.

## 1. Cấu trúc Thư mục

Tất cả các tệp ngôn ngữ nằm trong `lib/i18n/`. Chúng ta sử dụng cấu trúc **Namespace theo tính năng**:

- `auth_en.i18n.json`, `auth_vi.i18n.json`: Bản dịch cho tính năng Auth.
- `onboarding_en.i18n.json`, `onboarding_vi.i18n.json`: Bản dịch cho màn hình Onboarding.
- `common_en.i18n.json`, `common_vi.i18n.json`: Các chuỗi dùng chung trong toàn ứng dụng.
- `strings.g.dart`: Mã nguồn được tạo tự động chứa tất cả các bản dịch.

## 2. Thêm/Sửa Nội dung

Để thêm một chuỗi mới:
1. Mở tệp JSON tương ứng (ví dụ: `auth_en.i18n.json`).
2. Thêm key và giá trị của nó.
3. Cập nhật tệp Tiếng Việt tương ứng (`auth_vi.i18n.json`).

### Sử dụng Tham số (Biến)
Sử dụng cú pháp `$variableName` hoặc `${variableName}` trong tệp JSON:
```json
"verifySubtitle": "Chúng tôi đã gửi mã xác minh tới $email"
```

## 3. Tạo mã (Code Generation)

Dự án được cấu hình để tự động tạo mã. Mỗi khi bạn thay đổi tệp `.json`, hãy chạy lệnh:

```bash
dart run slang
```
Hoặc nếu bạn muốn nó tự chạy khi lưu file:
```bash
dart run build_runner watch --delete-conflicting-outputs
```

## 4. Sử dụng trong mã Flutter

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
// Chuyển sang Tiếng Việt
LocaleSettings.setLocale(AppLocale.vi);

// Lấy ngôn ngữ hiện tại
AppLocale current = LocaleSettings.currentLocale;
```

## 5. Cấu hình Kỹ thuật (`slang.yaml`)

Tệp cấu hình Slang nằm ở gốc dự án với các tùy chọn quan trọng:
- `namespaces: true`: Cho phép chia tệp theo tính năng.
- `input_directory: lib/i18n`: Thư mục chứa tệp nguồn.
- `output_file_name: strings.g.dart`: Gộp tất cả vào một tệp duy nhất.

---
*Tài liệu Lokito - Cập nhật 2026*
