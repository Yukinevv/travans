import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const List<Locale> supportedLocales = [
    Locale('pl'),
    Locale('en'),
  ];

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    _AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static AppLocalizations of(BuildContext context) {
    final localization = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    assert(localization != null, 'AppLocalizations not found in context');
    return localization!;
  }

  static const Map<String, Map<String, String>> _strings = {
    'pl': {
      'appTitle': 'Travans',
      'loginTitle': 'Zaloguj się',
      'loginSubtitle': 'Wejdź do mobilnej wersji Travans.',
      'registerTitle': 'Utwórz konto',
      'registerSubtitle': 'Załóż konto i zacznij budować plan treningowy.',
      'email': 'Email',
      'password': 'Hasło',
      'displayName': 'Nazwa użytkownika',
      'rememberMe': 'Zapamiętaj mnie',
      'signIn': 'Zaloguj',
      'signUp': 'Załóż konto',
      'goToRegister': 'Nie masz konta? Utwórz je',
      'goToLogin': 'Masz już konto? Zaloguj się',
      'dashboard': 'Dashboard',
      'plans': 'Plany',
      'integrations': 'Integracje',
      'account': 'Konto',
      'logout': 'Wyloguj',
      'language': 'Język',
      'tryAgain': 'Spróbuj ponownie',
      'loading': 'Ładowanie...',
      'requiredField': 'To pole jest wymagane.',
      'invalidEmail': 'Podaj poprawny adres email.',
      'passwordTooShort': 'Hasło musi mieć co najmniej 8 znaków.',
      'genericAuthError': 'Nie udało się wykonać operacji autoryzacji.',
      'dashboardPlaceholder':
          'Tu pojawi się dashboard z planem i statystykami.',
      'plansPlaceholder': 'Tu pojawi się lista planów i edytor.',
      'integrationsPlaceholder': 'Tu pojawi się integracja ze Stravą.',
      'accountPlaceholder': 'Tu pojawi się profil użytkownika.',
      'sessionExpired': 'Sesja wygasła. Zaloguj się ponownie.',
      'helloUser': 'Witaj, {name}',
      'welcomeBack': 'Masz już gotowy fundament aplikacji mobilnej.',
      'switchLanguage': 'Przełącz język',
    },
    'en': {
      'appTitle': 'Travans',
      'loginTitle': 'Sign in',
      'loginSubtitle': 'Access the mobile version of Travans.',
      'registerTitle': 'Create account',
      'registerSubtitle':
          'Create an account and start building your training plan.',
      'email': 'Email',
      'password': 'Password',
      'displayName': 'Display name',
      'rememberMe': 'Remember me',
      'signIn': 'Sign in',
      'signUp': 'Create account',
      'goToRegister': 'No account yet? Create one',
      'goToLogin': 'Already have an account? Sign in',
      'dashboard': 'Dashboard',
      'plans': 'Plans',
      'integrations': 'Integrations',
      'account': 'Account',
      'logout': 'Log out',
      'language': 'Language',
      'tryAgain': 'Try again',
      'loading': 'Loading...',
      'requiredField': 'This field is required.',
      'invalidEmail': 'Enter a valid email address.',
      'passwordTooShort': 'Password must be at least 8 characters.',
      'genericAuthError': 'Authentication request failed.',
      'dashboardPlaceholder':
          'Dashboard with plan progress and stats will live here.',
      'plansPlaceholder': 'Plans list and editor will live here.',
      'integrationsPlaceholder': 'Strava integration will live here.',
      'accountPlaceholder': 'User profile will live here.',
      'sessionExpired': 'Your session expired. Sign in again.',
      'helloUser': 'Hello, {name}',
      'welcomeBack': 'You already have the mobile app foundation in place.',
      'switchLanguage': 'Switch language',
    },
  };

  String _string(String key) {
    return _strings[locale.languageCode]?[key] ?? _strings['en']![key]!;
  }

  String get appTitle => _string('appTitle');
  String get loginTitle => _string('loginTitle');
  String get loginSubtitle => _string('loginSubtitle');
  String get registerTitle => _string('registerTitle');
  String get registerSubtitle => _string('registerSubtitle');
  String get email => _string('email');
  String get password => _string('password');
  String get displayName => _string('displayName');
  String get rememberMe => _string('rememberMe');
  String get signIn => _string('signIn');
  String get signUp => _string('signUp');
  String get goToRegister => _string('goToRegister');
  String get goToLogin => _string('goToLogin');
  String get dashboard => _string('dashboard');
  String get plans => _string('plans');
  String get integrations => _string('integrations');
  String get account => _string('account');
  String get logout => _string('logout');
  String get language => _string('language');
  String get tryAgain => _string('tryAgain');
  String get loading => _string('loading');
  String get requiredField => _string('requiredField');
  String get invalidEmail => _string('invalidEmail');
  String get passwordTooShort => _string('passwordTooShort');
  String get genericAuthError => _string('genericAuthError');
  String get dashboardPlaceholder => _string('dashboardPlaceholder');
  String get plansPlaceholder => _string('plansPlaceholder');
  String get integrationsPlaceholder => _string('integrationsPlaceholder');
  String get accountPlaceholder => _string('accountPlaceholder');
  String get sessionExpired => _string('sessionExpired');
  String get welcomeBack => _string('welcomeBack');
  String get switchLanguage => _string('switchLanguage');

  String helloUser(String name) {
    return _string('helloUser').replaceFirst('{name}', name);
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['pl', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
