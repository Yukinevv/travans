import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/localization/language_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/networking/api_exception.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/application/auth_state.dart';
import '../../auth/data/auth_models.dart';
import '../../auth/data/auth_repository.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  final _imagePicker = ImagePicker();

  bool _profileInitialized = false;
  bool _profileSubmitting = false;
  bool _passwordSubmitting = false;
  bool _avatarSubmitting = false;

  String? _profileError;
  String? _profileSuccess;
  String? _passwordError;
  String? _passwordSuccess;
  String? _avatarError;

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final locale = ref.watch(languageControllerProvider);

    if (!_profileInitialized && user != null) {
      _displayNameController.text = user.displayName;
      _emailController.text = user.email;
      _profileInitialized = true;
    }

    if (authState.status == AuthStatus.loading && user == null) {
      return Center(child: LoadingView(label: l10n.accountLoading));
    }

    if (user == null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: ErrorView(
          message: l10n.resolveError(
            authState.errorMessage,
            fallback: l10n.errorAccountProfileLoad,
          ),
          onRetry: () {
            ref.read(authControllerProvider.notifier).refreshProfile();
          },
        ),
      );
    }

    final providerLabel = user.authProvider == 'GOOGLE'
        ? l10n.authProviderGoogle
        : l10n.authProviderLocal;
    final isGoogleManaged = user.authProvider == 'GOOGLE';

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.accountHeaderKicker.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.accentDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.accountHeaderTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.accountHeaderSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AvatarButton(
                      user: user,
                      isLoading: _avatarSubmitting,
                      onTap: _avatarSubmitting ? null : _pickAndUploadAvatar,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.helloUser(user.displayName),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(user.email),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _InfoChip(
                                label: l10n.accountConnectedProvider,
                                value: providerLabel,
                              ),
                              _InfoChip(
                                label: l10n.language,
                                value: locale.languageCode.toUpperCase(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.accountProfileAvatarHint,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.muted,
                  ),
                ),
                if (_avatarError != null) ...[
                  const SizedBox(height: 10),
                  _InlineMessage(
                    message: l10n.resolveError(
                      _avatarError,
                      fallback: l10n.errorAccountAvatarUpload,
                    ),
                    color: AppColors.danger,
                  ),
                ],
                if (_avatarSubmitting) ...[
                  const SizedBox(height: 10),
                  _InlineMessage(
                    message: l10n.accountProfileAvatarUploading,
                    color: AppColors.accentDark,
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _profileFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.accountSectionProfile,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.accountProfileDescription,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _displayNameController,
                    decoration: InputDecoration(labelText: l10n.displayName),
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return l10n.requiredField;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: l10n.email),
                    validator: (value) {
                      final trimmed = (value ?? '').trim();
                      if (trimmed.isEmpty) {
                        return l10n.requiredField;
                      }
                      final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                      if (!emailRegex.hasMatch(trimmed)) {
                        return l10n.invalidEmail;
                      }
                      return null;
                    },
                  ),
                  if (_profileError != null) ...[
                    const SizedBox(height: 12),
                    _InlineMessage(
                      message: l10n.resolveError(
                        _profileError,
                        fallback: l10n.errorAccountProfileUpdate,
                      ),
                      color: AppColors.danger,
                    ),
                  ],
                  if (_profileSuccess != null) ...[
                    const SizedBox(height: 12),
                    _InlineMessage(
                      message: _profileSuccess!,
                      color: AppColors.success,
                    ),
                  ],
                  const SizedBox(height: 14),
                  PrimaryButton(
                    label: l10n.accountProfileSave,
                    isLoading: _profileSubmitting,
                    onPressed: _submitProfile,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _passwordFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.accountSectionSecurity,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isGoogleManaged
                        ? l10n.accountSecurityGoogleManaged
                        : l10n.accountSecurityDescription,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                  if (!isGoogleManaged) ...[
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _currentPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: l10n.accountSecurityCurrentPassword,
                      ),
                      validator: (value) {
                        if ((value ?? '').isEmpty) {
                          return l10n.requiredField;
                        }
                        if ((value ?? '').length < 8) {
                          return l10n.passwordTooShort;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: l10n.accountSecurityNewPassword,
                      ),
                      validator: (value) {
                        if ((value ?? '').isEmpty) {
                          return l10n.requiredField;
                        }
                        if ((value ?? '').length < 8) {
                          return l10n.passwordTooShort;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _repeatPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: l10n.accountSecurityRepeatPassword,
                      ),
                      validator: (value) {
                        if ((value ?? '').isEmpty) {
                          return l10n.requiredField;
                        }
                        if ((value ?? '').length < 8) {
                          return l10n.passwordTooShort;
                        }
                        return null;
                      },
                    ),
                    if (_passwordError != null) ...[
                    const SizedBox(height: 12),
                      _InlineMessage(
                        message: l10n.resolveError(
                          _passwordError,
                          fallback: l10n.errorAccountPasswordChange,
                        ),
                        color: AppColors.danger,
                      ),
                    ],
                    if (_passwordSuccess != null) ...[
                    const SizedBox(height: 12),
                      _InlineMessage(
                        message: _passwordSuccess!,
                        color: AppColors.success,
                      ),
                    ],
                    const SizedBox(height: 14),
                    PrimaryButton(
                      label: l10n.accountSecurityChangePassword,
                      isLoading: _passwordSubmitting,
                      onPressed: _submitPassword,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.accountSectionLanguage,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                SegmentedButton<Locale>(
                  segments: const [
                    ButtonSegment(value: Locale('pl'), label: Text('PL')),
                    ButtonSegment(value: Locale('en'), label: Text('EN')),
                  ],
                  selected: {locale},
                  onSelectionChanged: (selection) {
                    ref
                        .read(languageControllerProvider.notifier)
                        .setLocale(selection.first);
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.accountSectionSession,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    ref.read(authControllerProvider.notifier).logout();
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: Text(l10n.logout),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submitProfile() async {
    final l10n = AppLocalizations.of(context);
    FocusScope.of(context).unfocus();

    if (!_profileFormKey.currentState!.validate()) {
      setState(() {
        _profileError = l10n.errorAccountProfileUpdate;
        _profileSuccess = null;
      });
      return;
    }

    setState(() {
      _profileSubmitting = true;
      _profileError = null;
      _profileSuccess = null;
    });

    try {
      final session = await ref.read(authRepositoryProvider).updateProfile(
        UpdateProfilePayload(
          displayName: _displayNameController.text.trim(),
          email: _emailController.text.trim(),
        ),
      );
      ref.read(authControllerProvider.notifier).setAuthenticatedUser(session.user);
      if (!mounted) {
        return;
      }
      setState(() {
        _displayNameController.text = session.user.displayName;
        _emailController.text = session.user.email;
        _profileSuccess = l10n.accountProfileSaved;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _profileError = _extractErrorValue(error);
      });
    } finally {
      if (mounted) {
        setState(() {
          _profileSubmitting = false;
        });
      }
    }
  }

  Future<void> _submitPassword() async {
    final l10n = AppLocalizations.of(context);
    FocusScope.of(context).unfocus();

    if (!_passwordFormKey.currentState!.validate()) {
      setState(() {
        _passwordError = l10n.errorAccountPasswordChange;
        _passwordSuccess = null;
      });
      return;
    }

    if (_newPasswordController.text != _repeatPasswordController.text) {
      setState(() {
        _passwordError = l10n.accountSecurityPasswordMismatch;
        _passwordSuccess = null;
      });
      return;
    }

    setState(() {
      _passwordSubmitting = true;
      _passwordError = null;
      _passwordSuccess = null;
    });

    try {
      await ref.read(authRepositoryProvider).changePassword(
        ChangePasswordPayload(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        ),
      );
      if (!mounted) {
        return;
      }
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _repeatPasswordController.clear();
      setState(() {
        _passwordSuccess = l10n.accountSecurityPasswordChanged;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _passwordError = _extractErrorValue(error);
      });
    } finally {
      if (mounted) {
        setState(() {
          _passwordSubmitting = false;
        });
      }
    }
  }

  Future<void> _pickAndUploadAvatar() async {
    final l10n = AppLocalizations.of(context);
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (pickedFile == null || !mounted) {
      return;
    }

    final lowerName = pickedFile.name.toLowerCase();
    final isSupportedType =
        lowerName.endsWith('.jpg') ||
        lowerName.endsWith('.jpeg') ||
        lowerName.endsWith('.png') ||
        lowerName.endsWith('.webp') ||
        lowerName.endsWith('.gif');
    final fileSize = await File(pickedFile.path).length();
    if (!isSupportedType || fileSize > 5 * 1024 * 1024) {
      setState(() {
        _avatarError = l10n.accountAvatarInvalid;
        _profileSuccess = null;
      });
      return;
    }

    setState(() {
      _avatarSubmitting = true;
      _avatarError = null;
      _profileSuccess = null;
    });

    try {
      final session = await ref.read(authRepositoryProvider).uploadAvatar(
        pickedFile.path,
      );
      ref.read(authControllerProvider.notifier).setAuthenticatedUser(session.user);
      if (!mounted) {
        return;
      }
      setState(() {
        _profileSuccess = l10n.accountProfileSaved;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _avatarError = _extractErrorValue(error);
      });
    } finally {
      if (mounted) {
        setState(() {
          _avatarSubmitting = false;
        });
      }
    }
  }

  String _extractErrorValue(Object error) {
    if (error is ApiException) {
      if (error.code != null && error.code!.isNotEmpty) {
        return error.code!;
      }
      if (error.message.isNotEmpty) {
        return error.message;
      }
    }

    return 'errorGenericTaskFailed';
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceStrong,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarButton extends StatelessWidget {
  const _AvatarButton({
    required this.user,
    required this.isLoading,
    required this.onTap,
  });

  final UserProfile user;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final initials = user.displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part.substring(0, 1).toUpperCase())
        .join();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: AppColors.accent.withValues(alpha: 0.16),
              backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                  ? NetworkImage(user.avatarUrl!)
                  : null,
              child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                  ? Text(
                      initials.isEmpty ? '?' : initials,
                      style: const TextStyle(
                        color: AppColors.accentDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                    )
                  : null,
            ),
            if (!isLoading)
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  size: 14,
                  color: AppColors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InlineMessage extends StatelessWidget {
  const _InlineMessage({required this.message, required this.color});

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        message,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
