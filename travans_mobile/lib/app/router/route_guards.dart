import '../../features/auth/application/auth_state.dart';

bool isPublicRoute(String location) {
  return location == '/login' || location == '/register';
}

String? resolveRedirect({
  required AuthState authState,
  required String location,
}) {
  if (authState.status == AuthStatus.loading && location != '/splash') {
    return '/splash';
  }

  if (authState.status == AuthStatus.unauthenticated && location == '/splash') {
    return '/login';
  }

  if (authState.status == AuthStatus.unauthenticated &&
      !isPublicRoute(location)) {
    return '/login';
  }

  if (authState.status == AuthStatus.authenticated &&
      (location == '/login' ||
          location == '/register' ||
          location == '/splash')) {
    return '/';
  }

  return null;
}
