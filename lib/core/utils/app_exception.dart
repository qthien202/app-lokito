import 'package:flutter/material.dart';
import 'package:lokito/i18n/strings.g.dart';

class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => message;
}

class AppAuthException extends AppException {
  AppAuthException(super.message, [super.code]);
}

extension AppExceptionX on BuildContext {
  String mapErrorMessage(String error) {
    switch (error) {
      case 'errorInvalidCredentials':
        return t.auth.errors.invalidCredentials;
      case 'errorEmailTaken':
        return t.auth.errors.emailTaken;
      case 'errorUsernameTaken':
        return t.auth.errors.usernameTaken;
      case 'errorNetwork':
        return t.common.errors.network;
      case 'errorTooManyRequests':
        return t.common.errors.tooManyRequests;
      case 'errorEmailNotConfirmed':
        return t.auth.errors.emailNotConfirmed;
      case 'errorExpiredOtp':
        return t.auth.errors.expiredOtp;
      case 'invalidOtp':
        return t.auth.invalidOtp;
      case 'errorUnknown':
        return t.common.errors.unknown;
      default:
        // Try to check if it's a raw Supabase error or something else
        return t.auth.errors.defaultAuth(message: error);
    }
  }
}
