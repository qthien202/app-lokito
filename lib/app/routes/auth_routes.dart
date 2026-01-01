import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lokito/core/core.dart';
import 'package:lokito/features/auth/presentation/screens/login_screen.dart';
import 'package:lokito/features/auth/presentation/screens/register_screen.dart';
import 'package:lokito/features/auth/presentation/screens/otp_screen.dart';
import 'package:lokito/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:lokito/features/auth/presentation/screens/forgot_password_otp_screen.dart';
import 'package:lokito/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:lokito/features/auth/presentation/controllers/auth_controller.dart';
import 'package:lokito/features/onboarding/presentation/screens/onboarding_screen.dart';

List<GoRoute> authRoutes(Ref ref) => [
  GoRoute(
    path: AppRoutes.onboarding,
    name: 'onboarding',
    builder: (context, state) => const OnboardingScreen(),
  ),
  GoRoute(
    path: AppRoutes.login,
    name: 'login',
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: AppRoutes.register,
    name: 'register',
    builder: (context, state) => const RegisterScreen(),
  ),
  GoRoute(
    path: AppRoutes.otp,
    name: 'otp',
    builder: (context, state) {
      final authState = ref.read(authControllerProvider);
      final username =
          state.extra as String? ?? authState.verificationUsername ?? '';
      return OtpScreen(username: username);
    },
  ),
  GoRoute(
    path: AppRoutes.forgotPassword,
    name: 'forgotPassword',
    builder: (context, state) => const ForgotPasswordScreen(),
  ),
  GoRoute(
    path: AppRoutes.forgotPasswordOtp,
    name: 'forgotPasswordOtp',
    builder: (context, state) => const ForgotPasswordOtpScreen(),
  ),
  GoRoute(
    path: AppRoutes.resetPassword,
    name: 'resetPassword',
    builder: (context, state) => const ResetPasswordScreen(),
  ),
];
