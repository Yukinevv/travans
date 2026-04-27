import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../shared/widgets/empty_state.dart';

class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: EmptyState(
        icon: Icons.event_note_outlined,
        title: l10n.emptyStateTitle,
        message: l10n.plansPlaceholder,
        actionLabel: l10n.dashboard,
        onAction: () => context.go('/'),
      ),
    );
  }
}
