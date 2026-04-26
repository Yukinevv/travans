import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/localization/app_localizations.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({required this.location, required this.child, super.key});

  final String location;
  final Widget child;

  int _indexForLocation() {
    if (location.startsWith('/plans')) {
      return 1;
    }
    if (location.startsWith('/integrations')) {
      return 2;
    }
    if (location.startsWith('/account')) {
      return 3;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexForLocation(),
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/plans');
              break;
            case 2:
              context.go('/integrations');
              break;
            case 3:
              context.go('/account');
              break;
          }
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.dashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.event_note_outlined),
            selectedIcon: const Icon(Icons.event_note),
            label: l10n.plans,
          ),
          NavigationDestination(
            icon: const Icon(Icons.sync_outlined),
            selectedIcon: const Icon(Icons.sync),
            label: l10n.integrations,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.account,
          ),
        ],
      ),
    );
  }
}
