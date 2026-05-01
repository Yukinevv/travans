import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/localization/language_controller.dart';
import '../../app/theme/app_colors.dart';
import '../../features/auth/application/auth_controller.dart';

class AppScaffold extends ConsumerWidget {
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

  String _titleForLocation(AppLocalizations l10n) {
    if (location.startsWith('/plans')) {
      return l10n.plans;
    }
    if (location.startsWith('/integrations')) {
      return l10n.integrations;
    }
    if (location.startsWith('/account')) {
      return l10n.account;
    }
    return l10n.dashboard;
  }

  String _subtitleForLocation(AppLocalizations l10n) {
    if (location.startsWith('/plans')) {
      return l10n.shellSectionPlans;
    }
    if (location.startsWith('/integrations')) {
      return l10n.shellSectionIntegrations;
    }
    if (location.startsWith('/account')) {
      return l10n.shellSectionAccount;
    }
    return l10n.shellSectionDashboard;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authControllerProvider);
    final locale = ref.watch(languageControllerProvider);
    final user = authState.user;
    final title = _titleForLocation(l10n);
    final subtitle = _subtitleForLocation(l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            tooltip: l10n.shellOpenMenu,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => context.go('/account'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (MediaQuery.sizeOf(context).width > 390) ...[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              user.displayName,
                              style: const TextStyle(
                                color: AppColors.text,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                      ],
                      _AvatarBubble(userName: user.displayName),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceStrong,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _AvatarBubble(userName: user?.displayName ?? 'T'),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.displayName ?? l10n.appTitle,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user?.email ?? l10n.shellNotConnected,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.shellSignedInAs,
                        style: const TextStyle(
                          color: AppColors.accentDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  l10n.shellNavigation,
                  style: const TextStyle(
                    color: AppColors.accentDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _DrawerNavTile(
                icon: Icons.dashboard_outlined,
                label: l10n.dashboard,
                selected: _indexForLocation() == 0,
                onTap: () => context.go('/'),
              ),
              _DrawerNavTile(
                icon: Icons.event_note_outlined,
                label: l10n.plans,
                selected: _indexForLocation() == 1,
                onTap: () => context.go('/plans'),
              ),
              _DrawerNavTile(
                icon: Icons.sync_outlined,
                label: l10n.integrations,
                selected: _indexForLocation() == 2,
                onTap: () => context.go('/integrations'),
              ),
              _DrawerNavTile(
                icon: Icons.person_outline,
                label: l10n.account,
                selected: _indexForLocation() == 3,
                onTap: () => context.go('/account'),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  l10n.shellQuickActions,
                  style: const TextStyle(
                    color: AppColors.accentDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SegmentedButton<Locale>(
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
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ref.read(authControllerProvider.notifier).logout();
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: Text(l10n.logout),
                ),
              ),
            ],
          ),
        ),
      ),
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

class _AvatarBubble extends StatelessWidget {
  const _AvatarBubble({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    final trimmed = userName.trim();
    final initials = trimmed.isEmpty
        ? 'T'
        : trimmed
              .split(RegExp(r'\s+'))
              .take(2)
              .map((part) => part[0])
              .join()
              .toUpperCase();

    return CircleAvatar(
      radius: 17,
      backgroundColor: AppColors.accent,
      foregroundColor: AppColors.white,
      child: Text(
        initials,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _DrawerNavTile extends StatelessWidget {
  const _DrawerNavTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -1),
        leading: Icon(icon, color: selected ? AppColors.accent : null),
        selected: selected,
        selectedTileColor: AppColors.surfaceStrong,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(label),
        onTap: () {
          Navigator.of(context).pop();
          onTap();
        },
      ),
    );
  }
}
