import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final preferencesServiceProvider = Provider<PreferencesService>(
  (ref) => PreferencesService(),
);

class PreferencesService {
  static const _languageKey = 'travans.language';
  static const _preferredLocaleKey = 'travans.preferred_locale';
  static const _dashboardPlanIdKey = 'travans-dashboard-plan-id';

  Future<String?> readLanguageCode() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_preferredLocaleKey) ??
        preferences.getString(_languageKey);
  }

  Future<void> saveLanguageCode(String code) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_preferredLocaleKey, code);
    await preferences.setString(_languageKey, code);
  }

  Future<int?> readSelectedPlanId() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getInt(_dashboardPlanIdKey);
  }

  Future<void> saveSelectedPlanId(int? planId) async {
    final preferences = await SharedPreferences.getInstance();
    if (planId == null) {
      await preferences.remove(_dashboardPlanIdKey);
      return;
    }

    await preferences.setInt(_dashboardPlanIdKey, planId);
  }
}
