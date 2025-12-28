// core/services/supabase_service.dart

import 'package:lokito/core/environment/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/supabase_constants.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }

  SupabaseService._();

  SupabaseClient get client => Supabase.instance.client;

  // Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: Env.supabaseURL,
      anonKey: Env.supabaseKey,
      debug: true, // Enable logging
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );
  }

  // Getter
  User? get currentUser => client.auth.currentUser;
  String? get currentUserId => client.auth.currentUser?.id;
  bool get isAuthenticated => client.auth.currentUser != null;

  // Auth state stream
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // Quick access to tables
  SupabaseQueryBuilder get profiles =>
      client.from(SupabaseConstants.profilesTable);

  SupabaseQueryBuilder get posts => client.from(SupabaseConstants.postsTable);

  SupabaseQueryBuilder get friendships =>
      client.from(SupabaseConstants.friendshipsTable);

  SupabaseQueryBuilder get reactions =>
      client.from(SupabaseConstants.reactionsTable);

  SupabaseQueryBuilder get notifications =>
      client.from(SupabaseConstants.notificationsTable);

  // Storage buckets
  SupabaseStorageClient get storage => client.storage;

  StorageFileApi get avatarsStorage =>
      storage.from(SupabaseConstants.avatarsBucket);

  StorageFileApi get postsStorage =>
      storage.from(SupabaseConstants.postsBucket);
}
