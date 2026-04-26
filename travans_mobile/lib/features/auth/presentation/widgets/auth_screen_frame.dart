import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../app/theme/app_colors.dart';

class AuthScreenFrame extends StatelessWidget {
  const AuthScreenFrame({
    required this.title,
    required this.subtitle,
    required this.isLogin,
    required this.googleLabel,
    required this.onGooglePressed,
    required this.form,
    required this.footer,
    this.googleLoading = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool isLogin;
  final String googleLabel;
  final Future<void> Function() onGooglePressed;
  final Widget form;
  final Widget footer;
  final bool googleLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, Color(0xFFF7F2E8)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: AppColors.border),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1F472C16),
                        blurRadius: 40,
                        offset: Offset(0, 18),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.authKicker.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.accentDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.8,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 26),
                      _AuthModeSwitcher(isLogin: isLogin),
                      const SizedBox(height: 24),
                      _GoogleButton(
                        label: googleLabel,
                        isLoading: googleLoading,
                        onPressed: onGooglePressed,
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: Text(
                          l10n.orSeparator,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 14,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      form,
                      const SizedBox(height: 18),
                      Align(alignment: Alignment.centerRight, child: footer),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthModeSwitcher extends StatelessWidget {
  const _AuthModeSwitcher({required this.isLogin});

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: _ModeButton(
            label: l10n.signIn,
            isActive: isLogin,
            onTap: () => context.go('/login'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ModeButton(
            label: l10n.signUp,
            isActive: !isLogin,
            onTap: () => context.go('/register'),
          ),
        ),
      ],
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? AppColors.accent : AppColors.surfaceStrong,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isActive ? AppColors.accent : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.white : AppColors.text,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
  });

  final String label;
  final Future<void> Function() onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : () => onPressed(),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        foregroundColor: AppColors.text,
        backgroundColor: AppColors.surfaceStrong,
        disabledForegroundColor: AppColors.text,
        disabledBackgroundColor: AppColors.surfaceStrong,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.accent,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    'G',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(color: AppColors.text, fontSize: 16),
                ),
              ],
            ),
    );
  }
}

class AuthFieldLabel extends StatelessWidget {
  const AuthFieldLabel({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.text,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
