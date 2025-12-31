// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Lokito';

  @override
  String get welcomeBack => 'Welcome\nBack';

  @override
  String get signInSubtitle => 'Sign in to see what your friends are up to.';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => '••••••••';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get newUser => 'New here? ';

  @override
  String get joinLokito => 'Join Lokito';

  @override
  String get createAccount => 'Create\nAccount';

  @override
  String get signUpSubtitle => 'Share your life with those you love.';

  @override
  String get username => 'Username';

  @override
  String get usernameHint => 'lokito_user';

  @override
  String get alreadyMember => 'Already a member? ';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get onboarding1Title => 'Connect with\nFriends';

  @override
  String get onboarding1Subtitle =>
      'Stay close to the people who matter most, anytime, anywhere.';

  @override
  String get onboarding2Title => 'Share Your\nMoments';

  @override
  String get onboarding2Subtitle =>
      'Capture and share your daily life with your inner circle.';

  @override
  String get onboarding3Title => 'Real-time\nUpdates';

  @override
  String get onboarding3Subtitle =>
      'Get notified instantly when your friends share something new.';

  @override
  String get verifyEmail => 'Verify\nEmail';

  @override
  String verifySubtitle(Object email) {
    return 'We\'ve sent a 6-digit code to $email';
  }

  @override
  String get otpHint => '000000';

  @override
  String get verify => 'Verify';

  @override
  String get resendCode => 'Resend Code';

  @override
  String get invalidOtp => 'Invalid OTP. Please try again.';

  @override
  String get otpSent => 'OTP sent successfully!';

  @override
  String get errorInvalidCredentials => 'Invalid email or password.';

  @override
  String get errorEmailTaken => 'This email is already registered.';

  @override
  String get errorUsernameTaken => 'This username is already taken.';

  @override
  String get errorNetwork => 'Network error. Please check your connection.';

  @override
  String get errorUnknown => 'An unknown error occurred.';

  @override
  String get errorTooManyRequests =>
      'Too many requests. Please try again later.';

  @override
  String get errorEmailNotConfirmed =>
      'Please confirm your email before signing in.';

  @override
  String get errorExpiredOtp => 'Search code has expired.';

  @override
  String errorDefaultAuth(Object message) {
    return 'Authentication error: $message';
  }
}
