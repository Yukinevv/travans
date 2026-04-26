import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/application/auth_controller.dart';
import 'localization/app_localizations.dart';
import 'localization/language_controller.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class TravansApp extends ConsumerWidget {
  const TravansApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(languageControllerProvider);

    return MaterialApp.router(
      title: 'Travans',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: router,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}
