import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/preferences_service.dart';

final languageControllerProvider =
    StateNotifierProvider<LanguageController, Locale>((ref) {
      final controller = LanguageController(
        ref.watch(preferencesServiceProvider),
      );
      controller.load();
      return controller;
    });

class LanguageController extends StateNotifier<Locale> {
  LanguageController(this._preferencesService) : super(const Locale('pl'));

  final PreferencesService _preferencesService;

  Future<void> load() async {
    final languageCode = await _preferencesService.readLanguageCode();
    if (languageCode == null) {
      return;
    }

    state = Locale(languageCode);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _preferencesService.saveLanguageCode(locale.languageCode);
  }
}
