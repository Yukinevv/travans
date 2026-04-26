import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/account/presentation/account_screen.dart';
import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/integrations/presentation/integrations_screen.dart';
import '../../features/plans/presentation/plans_screen.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/loading_view.dart';
import 'route_guards.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      return resolveRedirect(
        authState: authState,
        location: state.matchedLocation,
      );
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const _SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return AppScaffold(location: state.matchedLocation, child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/plans',
            builder: (context, state) => const PlansScreen(),
          ),
          GoRoute(
            path: '/integrations',
            builder: (context, state) => const IntegrationsScreen(),
          ),
          GoRoute(
            path: '/account',
            builder: (context, state) => const AccountScreen(),
          ),
        ],
      ),
    ],
  );
});

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Center(child: LoadingView())),
    );
  }
}
