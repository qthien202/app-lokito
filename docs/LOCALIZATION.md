# Hướng dẫn đa ngôn ngữ (Localization - L10n)

Tài liệu này hướng dẫn cách quản lý và thêm mới các chuỗi ngôn ngữ trong dự án Lokito.

## 1. Cấu trúc thư mục
Các file liên quan đến ngôn ngữ nằm tại `lib/l10n/`:
- `app_en.arb`: File nguồn tiếng Anh (mặc định).
- `app_vi.arb`: File nguồn tiếng Việt.
- `app_localizations.dart`: File code được tự động tạo ra (Generated code).

## 2. Cách thêm ngôn ngữ mới hoặc sửa nội dung
Để thêm một chuỗi văn bản mới, bạn chỉ cần chỉnh sửa các file `.arb`. Định dạng là JSON:

**Ví dụ trong `app_en.arb`:**
```json
{
  "loginTitle": "Login",
  "welcomeMessage": "Welcome back, {username}"
}
```

**Ví dụ trong `app_vi.arb`:**
```json
{
  "loginTitle": "Đăng nhập",
  "welcomeMessage": "Chào mừng quay trở lại, {username}"
}
```

## 3. Cập nhật Code (Generation)
Sau khi chỉnh sửa file `.arb`, bạn cần chạy lệnh sau để Flutter cập nhật lại class `AppLocalizations`:

```bash
flutter gen-l10n
```

*Lưu ý: Dự án đã được cấu hình `generate: true` trong `pubspec.yaml`, nên lệnh này thường tự chạy khi bạn lưu file hoặc chạy ứng dụng.*

## 4. Cách sử dụng trong Flutter Code

### Khai báo trong Widget:
```dart
import 'package:lokito/l10n/app_localizations.dart';

// ... trong hàm build
@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  return Text(l10n.loginTitle);
}
```

### Sử dụng với biến truyền vào:
Nếu trong file `.arb` bạn có định nghĩa biến như `{username}`, bạn có thể dùng như sau:
```dart
Text(l10n.welcomeMessage('Quang Thiên'))
```

## 5. Cấu hình hệ thống (l10n.yaml)
Dự án sử dụng file `l10n.yaml` ở thư mục gốc để cấu hình:
- `arb-dir`: Thư mục chứa các file .arb.
- `template-arb-file`: File mẫu dùng để tạo class cha.
- `output-localization-file`: Tên file code đầu ra.
- `synthetic-package: false`: Xuất code trực tiếp vào thư mục `lib/l10n` để dễ quản lý import.

---
*Lokito Documentation - 2025*
