import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final preferencesServiceProvider = Provider<PreferencesService>(
  (ref) => PreferencesService(),
);

class PreferencesService {
  static const _languageKey = 'travans.language';
  static const _preferredLocaleKey = 'travans.preferred_locale';

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
}
