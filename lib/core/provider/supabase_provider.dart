import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_services.dart';

// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return SupabaseService.instance.client;
});

// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  return SupabaseService.instance.currentUser;
});

// Current user ID provider
final currentUserIdProvider = Provider<String?>((ref) {
  return SupabaseService.instance.currentUserId;
});

// Auth state stream provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  return SupabaseService.instance.authStateChanges;
});

// Is authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  return SupabaseService.instance.isAuthenticated;
});
