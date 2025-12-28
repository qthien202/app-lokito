// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'Lokito';

  @override
  String get welcomeBack => 'Chào mừng\nQuay lại';

  @override
  String get signInSubtitle => 'Đăng nhập để xem bạn bè của bạn đang làm gì.';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'email@cua-ban.com';

  @override
  String get password => 'Mật khẩu';

  @override
  String get passwordHint => '••••••••';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get newUser => 'Mới tham gia? ';

  @override
  String get joinLokito => 'Tham gia Lokito';

  @override
  String get createAccount => 'Tạo\nTài khoản';

  @override
  String get signUpSubtitle =>
      'Chia sẻ cuộc sống với những người bạn yêu thương.';

  @override
  String get username => 'Tên người dùng';

  @override
  String get usernameHint => 'nguoidung_lokito';

  @override
  String get alreadyMember => 'Đã có tài khoản? ';

  @override
  String get skip => 'Bỏ qua';

  @override
  String get next => 'Tiếp theo';

  @override
  String get getStarted => 'Bắt đầu ngay';

  @override
  String get onboarding1Title => 'Kết nối\nBạn bè';

  @override
  String get onboarding1Subtitle =>
      'Luôn gần gũi với những người quan trọng nhất, mọi lúc, mọi nơi.';

  @override
  String get onboarding2Title => 'Chia sẻ\nKhoảnh khắc';

  @override
  String get onboarding2Subtitle =>
      'Ghi lại và chia sẻ cuộc sống hàng ngày với vòng bạn bè của bạn.';

  @override
  String get onboarding3Title => 'Cập nhật\nThời gian thực';

  @override
  String get onboarding3Subtitle =>
      'Nhận thông báo ngay lập tức khi bạn bè chia sẻ điều gì đó mới.';
}
