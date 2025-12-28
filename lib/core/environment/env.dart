import 'package:envied/envied.dart';

import '../constants/app_constants.dart';

part 'env.g.dart';

@Envied(path: AppConstants.env)
abstract class Env {
  @EnviedField(varName: 'SUPABASE_URL')
  static const String supabaseURL = _Env.supabaseURL;
  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  static const String supabaseKey = _Env.supabaseKey;
}
