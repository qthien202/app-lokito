import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lokito/core/core.dart';
import 'package:lokito/features/auth/presentation/controllers/auth_controller.dart';
import 'package:lokito/features/auth/presentation/widgets/auth_header.dart';
import 'package:lokito/features/auth/presentation/widgets/resend_timer_button.dart';
import 'package:lokito/i18n/strings.g.dart';
import 'package:pinput/pinput.dart';

class ForgotPasswordOtpScreen extends ConsumerStatefulWidget {
  static const path = '/forgot-password-otp';
  const ForgotPasswordOtpScreen({super.key});

  @override
  ConsumerState<ForgotPasswordOtpScreen> createState() =>
      _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState
    extends ConsumerState<ForgotPasswordOtpScreen> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _submit(String pin) async {
    if (pin.length == 6) {
      try {
        await ref
            .read(authControllerProvider.notifier)
            .verifyPasswordResetOtp(token: pin);

        if (mounted) {
          context.push(AppRoutes.resetPassword);
        }
      } catch (e) {
        // Error is handled by listener
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    ref.listen(authControllerProvider, (previous, next) {
      if (next.error != null && !next.isLoading) {
        SnackbarUtils.showError(context, context.mapErrorMessage(next.error!));
        ref.read(authControllerProvider.notifier).clearError();
      }
    });

    // Pinput styling
    final defaultPinTheme = PinTheme(
      width: 52,
      height: 60,
      textStyle: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: theme.colorScheme.primary, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: theme.colorScheme.primary.withOpacity(0.05),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: AppBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthHeader(
                    title: t.auth.verifyResetCode,
                    subtitle: t.auth.verifyResetCodeSubtitle(
                      email: authState.verificationEmail ?? '',
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Pinput library implementation
                  Pinput(
                    length: 6,
                    controller: _pinController,
                    focusNode: _focusNode,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: _submit,
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 22,
                          height: 1,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  PrimaryButton(
                    text: t.auth.verify,
                    isLoading: authState.isLoading,
                    onPressed: () => _submit(_pinController.text),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive code? ",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      ResendTimerButton(
                        onResend: () async {
                          final email = authState.verificationEmail;
                          if (email != null) {
                            try {
                              await ref
                                  .read(authControllerProvider.notifier)
                                  .sendPasswordResetCode(email);
                              if (context.mounted) {
                                SnackbarUtils.showSuccess(
                                  context,
                                  t.auth.codeSentSuccess,
                                );
                              }
                            } catch (e) {
                              // Error handled by listener
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
