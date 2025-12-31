import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lokito/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:lokito/core/core.dart';
import 'package:lokito/features/auth/presentation/screens/login_screen.dart';
import 'package:lokito/features/auth/presentation/screens/register_screen.dart';
import 'package:lokito/features/auth/presentation/screens/otp_screen.dart';
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
          state.matchedLocation == AppRoutes.otp;

      // 1. ĐÃ LOGIN mà lại ở các trang Auth -> Vào Feed
      if (isLoggedIn && isAuthRoute) {
        return AppRoutes.feed;
      }

      // 2. Đang trong luồng verification -> Cho phép ở OTP
      if (isVerificationRequired && state.matchedLocation != AppRoutes.otp) {
        // Nếu đang cần verify nhưng không ở trang OTP -> không redirect
        // (để RegisterScreen tự push sang OTP)
        return null;
      }

      // 3. CHƯA LOGIN và KHÔNG trong luồng verification -> Ra Onboarding
      if (!isLoggedIn && !isAuthRoute && !isVerificationRequired) {
        return AppRoutes.onboarding;
      }

      // Các trường hợp khác để GoRouter tự lo
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
          final username = state.extra as String? ?? '';
          return OtpScreen(username: username);
        },
      ),
    ],
    // Màn hình hiển thị khi lỗi hoặc đang chờ khởi tạo
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: CircularProgressIndicator())),
  );
});

class RouterRefreshListenable extends ChangeNotifier {
  RouterRefreshListenable(Ref ref) {
    ref.listen(authControllerProvider, (_, __) {
      notifyListeners();
    });
  }
}

final routerRefreshListenableProvider = Provider<Listenable>((ref) {
  return RouterRefreshListenable(ref);
});
