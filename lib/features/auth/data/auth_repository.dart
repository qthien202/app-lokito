import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/core.dart';
import '../domain/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthRepository(supabase);
});

class AuthRepository {
  final SupabaseClient _supabase;

  AuthRepository(this._supabase);

  // Sign in with email
  Future<UserModel?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return await getUserProfile(response.user!.id);
      }
      return null;
    } on AuthException catch (e) {
      throw AppAuthException(_mapAuthError(e));
    } catch (e) {
      throw AppException('errorUnknown');
    }
  }

  // Sign up with email
  Future<UserModel?> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // 0. Check if username or email is taken
      final existingUser = await _supabase
          .from('profiles')
          .select('username, email')
          .or('username.eq.$username,email.eq.$email')
          .maybeSingle();

      if (existingUser != null) {
        if (existingUser['username'] == username) {
          throw AppAuthException('errorUsernameTaken');
        }
        if (existingUser['email'] == email) {
          throw AppAuthException('errorEmailTaken');
        }
      }

      // 1. Create auth user
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );

      // If email confirmation is enabled, session will be null
      if (response.user != null && response.session != null) {
        await _supabase.from('profiles').upsert({
          'id': response.user!.id,
          'username': username,
          'email': email,
        });
        return await getUserProfile(response.user!.id);
      }

      // If session is null, it means verification is required
      return null;
    } on AuthException catch (e) {
      throw AppAuthException(_mapAuthError(e));
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('errorUnknown');
    }
  }

  // Verify OTP
  Future<UserModel?> verifyOtp({
    required String email,
    required String token,
    required String username,
  }) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.signup,
      );

      if (response.user != null) {
        // Create profile after successful verification
        await _supabase.from('profiles').upsert({
          'id': response.user!.id,
          'username': username,
          'email': email,
        });
        return await getUserProfile(response.user!.id);
      }
      return null;
    } on AuthException catch (e) {
      throw AppAuthException(_mapAuthError(e));
    } catch (e) {
      throw AppException('errorUnknown');
    }
  }

  // Resend OTP
  Future<void> resendOtp(String email) async {
    try {
      await _supabase.auth.resend(type: OtpType.signup, email: email);
    } on AuthException catch (e) {
      throw AppAuthException(_mapAuthError(e));
    } catch (e) {
      throw AppException('errorUnknown');
    }
  }

  // Send password reset OTP
  Future<void> sendPasswordResetOtp(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw AppAuthException(_mapAuthError(e));
    } catch (e) {
      throw AppException('errorUnknown');
    }
  }

  // Verify password reset OTP
  Future<void> verifyPasswordResetOtp({
    required String email,
    required String token,
  }) async {
    try {
      await _supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.recovery,
      );
    } on AuthException catch (e) {
      throw AppAuthException(_mapAuthError(e));
    } catch (e) {
      throw AppException('errorUnknown');
    }
  }

  // Update password after OTP verification
  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));
    } on AuthException catch (e) {
      throw AppAuthException(_mapAuthError(e));
    } catch (e) {
      throw AppException('errorUnknown');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw AppException('errorUnknown');
    }
  }

  // Get current user
  User? getCurrentAuthUser() {
    return _supabase.auth.currentUser;
  }

  // Get user profile from database
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;
      return UserModel.fromJson(response);
    } catch (e) {
      throw AppException('errorUnknown');
    }
  }

  String _mapAuthError(AuthException e) {
    final message = e.message.toLowerCase();
    if (message.contains('invalid login credentials')) {
      return 'errorInvalidCredentials';
    }
    if (message.contains('user already registered')) {
      return 'errorEmailTaken';
    }
    if (message.contains('email not confirmed')) {
      return 'errorEmailNotConfirmed';
    }
    if (message.contains('token has expired') ||
        message.contains('otp expired')) {
      return 'errorExpiredOtp';
    }
    if (message.contains('invalid token') ||
        message.contains('incorrect otp')) {
      return 'invalidOtp';
    }
    if (message.contains('too many requests')) {
      return 'errorTooManyRequests';
    }
    if (message.contains('network error') || message.contains('connection')) {
      return 'errorNetwork';
    }

    return message;
  }

  // Update profile
  Future<void> updateProfile({
    required String userId,
    String? username,
    String? avatarUrl,
    String? bio,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (username != null) updates['username'] = username;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      if (bio != null) updates['bio'] = bio;

      await _supabase.from('profiles').update(updates).eq('id', userId);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Stream auth state changes
  Stream<AuthState> get authStateChanges {
    return _supabase.auth.onAuthStateChange;
  }
}
