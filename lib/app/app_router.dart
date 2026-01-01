import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lokito/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:lokito/core/core.dart';
import 'package:lokito/features/auth/presentation/screens/login_screen.dart';
import 'package:lokito/features/auth/presentation/screens/register_screen.dart';
import 'package:lokito/features/auth/presentation/screens/otp_screen.dart';
import 'package:lokito/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:lokito/features/auth/presentation/screens/forgot_password_otp_screen.dart';
import 'package:lokito/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:lokito/features/auth/presentation/controllers/auth_controller.dart';
import 'package:lokito/features/feed/presentation/screens/feed_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ref.watch(routerRefreshListenableProvider);

  return GoRouter(
    initialLocation: AppRoutes.feed,
    debugLogDiagnostics: true,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      // Use read here to avoid rebuilding the router in a watch
      final authState = ref.read(authControllerProvider);

      // Nếu chưa khởi tạo xong (đang check login cũ), KHÔNG chuyển đi đâu cả
      if (!authState.isInitialized) return null;

      final isLoggedIn = authState.user != null;
      final isVerificationRequired = authState.isVerificationRequired;

      // Các màn hình thuộc luồng đăng ký/đăng nhập
      final isAuthRoute =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register ||
          state.matchedLocation == AppRoutes.onboarding ||
          state.matchedLocation == AppRoutes.otp ||
          state.matchedLocation == AppRoutes.forgotPassword ||
          state.matchedLocation == AppRoutes.forgotPasswordOtp ||
          state.matchedLocation == AppRoutes.resetPassword;

      if (isLoggedIn && isAuthRoute) {
        return AppRoutes.feed;
      }

      if (isVerificationRequired && state.matchedLocation != AppRoutes.otp) {
        // Chỉ cho phép quay lại Login nếu muốn, còn lại ép vào OTP
        if (state.matchedLocation == AppRoutes.login) return null;
        return AppRoutes.otp;
      }

      if (!isLoggedIn && !isAuthRoute && !isVerificationRequired) {
        return AppRoutes.onboarding;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.feed,
        name: 'feed',
        builder: (context, state) => const FeedScreen(),
      ),
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
    ],
    // Màn hình hiển thị khi lỗi hoặc đang chờ khởi tạo
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: CircularProgressIndicator())),
  );
});

class RouterRefreshListenable extends ChangeNotifier {
  RouterRefreshListenable(Ref ref) {
    ref.listen(authControllerProvider, (previous, next) {
      notifyListeners();
    });
  }
}

final routerRefreshListenableProvider = Provider<Listenable>((ref) {
  return RouterRefreshListenable(ref);
});
