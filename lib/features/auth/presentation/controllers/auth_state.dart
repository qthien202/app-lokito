import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lokito/features/auth/domain/user_model.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    UserModel? user,
    required bool isLoading,
    String? error,
  }) = _AuthState;
}
