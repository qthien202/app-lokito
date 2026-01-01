import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lokito/core/core.dart';
import 'package:lokito/features/auth/presentation/controllers/auth_controller.dart';
import 'package:lokito/features/auth/presentation/widgets/auth_header.dart';
import 'package:lokito/i18n/strings.g.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  static const path = '/reset-password';
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref
            .read(authControllerProvider.notifier)
            .resetPassword(_newPasswordController.text);

        if (mounted) {
          SnackbarUtils.showSuccess(context, t.auth.passwordResetSuccess);
          // Clear the reset email from state
          ref.read(authControllerProvider.notifier).setResetEmail(null);
          // Navigate to login
          context.go(AppRoutes.login);
        }
      } catch (e) {
        // Error is handled by listener
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (next.error != null && !next.isLoading) {
        SnackbarUtils.showError(context, context.mapErrorMessage(next.error!));
        ref.read(authControllerProvider.notifier).clearError();
      }
    });

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
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthHeader(
                    title: t.auth.resetPasswordTitle,
                    subtitle: t.auth.resetPasswordSubtitle,
                  ),
                  const SizedBox(height: 48),
                  GlassCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomTextField(
                            label: t.auth.newPassword,
                            hint: t.auth.newPasswordHint,
                            controller: _newPasswordController,
                            isPassword: true,
                            prefixIcon: Icons.lock_outline_rounded,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return t.auth.validation.passwordRequired;
                              }
                              if (val.length < 6) {
                                return t.auth.validation.passwordTooShort;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            label: t.auth.confirmPassword,
                            hint: t.auth.confirmPasswordHint,
                            controller: _confirmPasswordController,
                            isPassword: true,
                            prefixIcon: Icons.lock_outline_rounded,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return t
                                    .auth
                                    .validation
                                    .confirmPasswordRequired;
                              }
                              if (val != _newPasswordController.text) {
                                return t.auth.passwordMismatch;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),
                          PrimaryButton(
                            text: t.auth.resetPassword,
                            isLoading: authState.isLoading,
                            onPressed: _submit,
                          ),
                        ],
                      ),
                    ),
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
