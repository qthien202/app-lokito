import 'package:go_router/go_router.dart';
import 'package:lokito/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:lokito/core/core.dart';
import 'package:lokito/features/auth/presentation/screens/login_screen.dart';
import 'package:lokito/features/auth/presentation/screens/register_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.onboarding,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      return null;
    },
    routes: [
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
    ],
  );
}
