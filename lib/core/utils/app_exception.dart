import 'package:flutter/material.dart';
import 'package:lokito/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(this)!;
    
    switch (error) {
      case 'errorInvalidCredentials':
        return l10n.errorInvalidCredentials;
      case 'errorEmailTaken':
        return l10n.errorEmailTaken;
      case 'errorUsernameTaken':
        return l10n.errorUsernameTaken;
      case 'errorNetwork':
        return l10n.errorNetwork;
      case 'errorTooManyRequests':
        return l10n.errorTooManyRequests;
      case 'errorEmailNotConfirmed':
        return l10n.errorEmailNotConfirmed;
      case 'errorExpiredOtp':
        return l10n.errorExpiredOtp;
      case 'invalidOtp':
        return l10n.invalidOtp;
      case 'errorUnknown':
        return l10n.errorUnknown;
      default:
        // Try to check if it's a raw Supabase error or something else
        return l10n.errorDefaultAuth(error);
    }
  }
}
