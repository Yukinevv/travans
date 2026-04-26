import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/localization/language_controller.dart';
import '../../auth/application/auth_controller.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authControllerProvider);
    final userName = authState.user?.displayName ?? 'User';
    final locale = ref.watch(languageControllerProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.account, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.helloUser(userName),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(authState.user?.email ?? ''),
                  const SizedBox(height: 16),
                  Text(l10n.accountPlaceholder),
                  const SizedBox(height: 24),
                  Text(
                    l10n.switchLanguage,
                    style: Theme.of(context).textTheme.titleMedium,
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
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () {
                      ref.read(authControllerProvider.notifier).logout();
                    },
                    child: Text(l10n.logout),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
