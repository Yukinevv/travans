import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return _FeaturePlaceholder(
      title: l10n.dashboard,
      message: l10n.dashboardPlaceholder,
    );
  }
}

class _FeaturePlaceholder extends StatelessWidget {
  const _FeaturePlaceholder({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(message),
            ),
          ),
        ],
      ),
    );
  }
}
