import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lokito/core/core.dart';
import 'package:lokito/app/routes/auth_routes.dart';
import 'package:lokito/app/routes/main_shell_route.dart';
import 'package:lokito/features/auth/presentation/controllers/auth_controller.dart';
import 'package:lokito/features/feed/presentation/screens/create_post_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ref.watch(routerRefreshListenableProvider);

  return GoRouter(
    initialLocation: AppRoutes.feed,
    debugLogDiagnostics: true,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      // Use read here to avoid rebuilding the router in a watch
      final authState = ref.read(authControllerProvider);

      if (!authState.isInitialized) return null;

      final isLoggedIn = authState.user != null;
      final isVerificationRequired = authState.isVerificationRequired;

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
        if (state.matchedLocation == AppRoutes.login) return null;
        return AppRoutes.otp;
      }

      if (!isLoggedIn && !isAuthRoute && !isVerificationRequired) {
        return AppRoutes.onboarding;
      }

      return null;
    },
    routes: [
      mainShellRoute(),
      GoRoute(
        path: AppRoutes.createPost,
        name: 'create-post',
        builder: (context, state) => const CreatePostScreen(),
      ),
      GoRoute(
        path: AppRoutes.fullscreenImage,
        name: 'fullscreen-image',
        builder: (context, state) {
          final imageUrl = state.uri.queryParameters['imageUrl'] ?? '';
          final postId = state.uri.queryParameters['postId'];
          final heroTag = state.uri.queryParameters['heroTag'];
          final title = state.uri.queryParameters['title'];
          final imageUrls = state.uri.queryParameters['imageUrls']?.split(',');
          final initialIndex =
              int.tryParse(state.uri.queryParameters['initialIndex'] ?? '0') ??
              0;

          return FullscreenImageViewer(
            imageUrl: imageUrl,
            postId: postId,
            heroTag: heroTag,
            title: title,
            imageUrls: imageUrls,
            initialIndex: initialIndex,
          );
        },
      ),
      ...authRoutes(ref),
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
