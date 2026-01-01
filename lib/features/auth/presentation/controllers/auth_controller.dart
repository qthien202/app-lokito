import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lokito/features/auth/data/auth_repository.dart';
import 'package:lokito/features/auth/presentation/controllers/auth_state.dart';

class AuthController extends Notifier<AuthState> {
  late final AuthRepository _repository;

  StreamSubscription<sb.AuthState>? _authSubscription;

  @override
  AuthState build() {
    _repository = ref.watch(authRepositoryProvider);
    state = const AuthState(isLoading: false);

    _authSubscription = _repository.authStateChanges.listen((data) {
      final sb.AuthChangeEvent event = data.event;
      if (event == sb.AuthChangeEvent.signedIn) {
        _checkCurrentUser();
      } else if (event == sb.AuthChangeEvent.signedOut) {
        state = const AuthState(isLoading: false);
      }
    });

    ref.onDispose(() {
      _authSubscription?.cancel();
    });

    _checkCurrentUser();

    return state;
  }

  Future<void> _checkCurrentUser() async {
    final authUser = _repository.getCurrentAuthUser();
    if (authUser != null) {
      try {
        final user = await _repository.getUserProfile(authUser.id);
        if (user == null) {
          // Check if user is awaiting email confirmation
          final isEmailConfirmed = authUser.emailConfirmedAt != null;

          if (!isEmailConfirmed) {
            // User is awaiting verification, don't sign out
            state = state.copyWith(
              isLoading: false,
              isInitialized: true,
              isVerificationRequired: true,
              verificationEmail: authUser.email,
              verificationUsername:
                  authUser.userMetadata?['username'] as String?,
            );
            return;
          }

          // Local session exists but user is deleted from DB
          await signOut();
          return;
        }
        state = state.copyWith(
          user: user,
          isLoading: false,
          isInitialized: true,
        );
      } catch (e) {
        state = state.copyWith(
          error: e.toString(),
          isLoading: false,
          isInitialized: true,
        );
      }
    } else {
      state = state.copyWith(isLoading: false, isInitialized: true);
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repository.signInWithEmail(
        email: email,
        password: password,
      );
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      isVerificationRequired: false,
    );
    try {
      final user = await _repository.signUpWithEmail(
        email: email,
        password: password,
        username: username,
      );

      if (user == null) {
        // User created but verification required
        state = state.copyWith(
          isLoading: false,
          isVerificationRequired: true,
          verificationEmail: email,
          verificationUsername: username,
        );
      } else {
        state = state.copyWith(user: user, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> verifyOtp({
    required String token,
    required String username,
  }) async {
    final email = state.verificationEmail;
    if (email == null) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repository.verifyOtp(
        email: email,
        token: token,
        username: username,
      );
      state = state.copyWith(
        user: user,
        isLoading: false,
        isVerificationRequired: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> resendOtp() async {
    final email = state.verificationEmail;
    if (email == null) return;

    try {
      await _repository.resendOtp(email);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.signOut();
      state = const AuthState(isLoading: false, isInitialized: true);
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        isInitialized: true,
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  // Password reset flow methods
  Future<void> sendPasswordResetCode(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.sendPasswordResetOtp(email);
      state = state.copyWith(isLoading: false, verificationEmail: email);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<void> verifyPasswordResetOtp({required String token}) async {
    final email = state.verificationEmail;
    if (email == null) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.verifyPasswordResetOtp(email: email, token: token);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<void> resetPassword(String newPassword) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.updatePassword(newPassword);
      // After password update, we should have a session. Let's refresh profile.
      await _checkCurrentUser();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  void setResetEmail(String? email) {
    state = state.copyWith(verificationEmail: email);
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
