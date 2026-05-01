class ApiEndpoints {
  const ApiEndpoints._();

  static const auth = _AuthEndpoints._();
  static const plans = _PlansEndpoints._();
  static const dashboard = _DashboardEndpoints._();
  static const strava = _StravaEndpoints._();
}

class _AuthEndpoints {
  const _AuthEndpoints._();

  final String login = '/auth/login';
  final String google = '/auth/google';
  final String register = '/auth/register';
  final String me = '/auth/me';
  final String refresh = '/auth/refresh';
  final String changePassword = '/auth/change-password';
  final String avatar = '/auth/avatar';
}

class _PlansEndpoints {
  const _PlansEndpoints._();

  final String collection = '/plans';
  final String import = '/plans/import';

  String detail(int planId) => '/plans/$planId';
}

class _DashboardEndpoints {
  const _DashboardEndpoints._();

  final String summary = '/dashboard/summary';
}

class _StravaEndpoints {
  const _StravaEndpoints._();

  final String status = '/integrations/strava/status';
  final String activities = '/integrations/strava/activities';
  final String exchangeToken = '/integrations/strava/exchange-token';
  final String sync = '/integrations/strava/sync';

  String activityDetail(int activityId) =>
      '/integrations/strava/activities/$activityId';
}
