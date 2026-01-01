import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lokito/core/core.dart';
import 'package:lokito/features/auth/presentation/controllers/auth_controller.dart';
import 'package:lokito/features/auth/presentation/widgets/auth_header.dart';
import 'package:lokito/i18n/strings.g.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  static const path = '/forgot-password';
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref
            .read(authControllerProvider.notifier)
            .sendPasswordResetCode(_emailController.text.trim());

        if (mounted) {
          SnackbarUtils.showSuccess(context, t.auth.codeSentSuccess);
          context.push(AppRoutes.forgotPasswordOtp);
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
                    title: t.auth.forgotPasswordTitle,
                    subtitle: t.auth.forgotPasswordSubtitle,
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
                            label: t.common.email,
                            hint: t.common.emailHint,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.alternate_email_rounded,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return t.auth.validation.emailRequired;
                              }
                              if (!val.contains('@')) {
                                return t.auth.validation.emailInvalid;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),
                          PrimaryButton(
                            text: t.auth.sendCode,
                            isLoading: authState.isLoading,
                            onPressed: _submit,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      t.auth.backToLogin,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
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
