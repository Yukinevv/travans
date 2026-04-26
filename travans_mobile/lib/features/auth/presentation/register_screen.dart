import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/primary_button.dart';
import '../application/auth_controller.dart';
import '../application/auth_state.dart';
import 'widgets/auth_screen_frame.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = true;

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authControllerProvider);
    final isSubmitting = authState.status == AuthStatus.loading;

    return Scaffold(
      body: AuthScreenFrame(
        title: l10n.registerTitle,
        subtitle: l10n.registerSubtitle,
        isLogin: false,
        googleLabel: l10n.googleSignUp,
        footer: TextButton(
          onPressed: () => context.go('/login'),
          child: Text(l10n.goToLogin),
        ),
        form: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthFieldLabel(label: l10n.displayName),
              const SizedBox(height: 8),
              TextFormField(
                controller: _displayNameController,
                decoration: const InputDecoration(hintText: 'Jan Kowalski'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.requiredField;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              AuthFieldLabel(label: l10n.email),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'janek@gmail.com'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.requiredField;
                  }
                  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return l10n.invalidEmail;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              AuthFieldLabel(label: l10n.password),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(hintText: '••••••••'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.requiredField;
                  }
                  if (value.length < 8) {
                    return l10n.passwordTooShort;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? true;
                      });
                    },
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.rememberMe,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              if (authState.errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  authState.errorMessage!,
                  style: const TextStyle(color: AppColors.danger, fontSize: 15),
                ),
              ],
              const SizedBox(height: 18),
              PrimaryButton(
                label: l10n.signUp,
                isLoading: isSubmitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await ref
        .read(authControllerProvider.notifier)
        .register(
          displayName: _displayNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          rememberMe: _rememberMe,
        );
  }
}
