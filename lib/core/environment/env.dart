import 'package:envied/envied.dart';

import '../constants/app_constants.dart';

part 'env.g.dart';

@Envied(path: AppConstants.env)
abstract class Env {
  @EnviedField(varName: 'SUPABASE_URL')
  static const String supabaseURL = _Env.supabaseURL;
  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  static const String supabaseKey = _Env.supabaseKey;

  // Cloudinary variables
  @EnviedField(varName: 'CLOUDINARY_CLOUD_NAME')
  static const String cloudinaryCloudName = _Env.cloudinaryCloudName;

  @EnviedField(varName: 'CLOUDINARY_API_KEY')
  static const String cloudinaryApiKey = _Env.cloudinaryApiKey;

  @EnviedField(varName: 'CLOUDINARY_API_SECRET')
  static const String cloudinaryApiSecret = _Env.cloudinaryApiSecret;
}
