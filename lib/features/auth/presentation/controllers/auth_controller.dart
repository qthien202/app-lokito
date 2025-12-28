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
    state = const AuthState(isLoading: true);

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
        state = state.copyWith(user: user, isLoading: false);
      } catch (e) {
        // If profile fetch fails, we might still be logged in, but with no profile data
        // For now, let's treat it as an error
        state = state.copyWith(error: e.toString(), isLoading: false);
      }
    } else {
      state = state.copyWith(isLoading: false);
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
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repository.signUpWithEmail(
        email: email,
        password: password,
        username: username,
      );
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.signOut();
      state = const AuthState(isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
