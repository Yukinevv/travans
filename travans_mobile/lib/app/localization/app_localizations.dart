import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const List<Locale> supportedLocales = [Locale('pl'), Locale('en')];

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
      'authKicker': 'Witaj w Travans',
      'loginTitle': 'Logowanie',
      'loginSubtitle':
          'Zaloguj sie, aby zarzadzac planem treningowym i synchronizacja Stravy.',
      'registerTitle': 'Zaloz konto',
      'registerSubtitle':
          'Utworz konto, aby budowac plan treningowy i rozwijac mobilna wersje Travans.',
      'email': 'Email',
      'password': 'Haslo',
      'displayName': 'Nazwa uzytkownika',
      'rememberMe': 'Zapamietaj mnie',
      'signIn': 'Zaloguj',
      'signUp': 'Zaloz konto',
      'orSeparator': 'LUB',
      'googleSignIn': 'Zaloguj sie przez Google',
      'googleSignUp': 'Zarejestruj sie przez Google',
      'goToRegister': 'Nie masz konta? Utworz je',
      'goToLogin': 'Masz juz konto? Zaloguj sie',
      'dashboard': 'Dashboard',
      'plans': 'Plany',
      'integrations': 'Integracje',
      'account': 'Konto',
      'integrationsTitle': 'Polaczenie ze Strava',
      'integrationsSubtitle':
          'Polacz konto, synchronizuj aktywnosci i sprawdzaj dopasowane treningi.',
      'integrationsConnectionTitle': 'Polaczenie konta',
      'integrationsConnected': 'Polaczono',
      'integrationsDisconnected': 'Nie polaczono',
      'integrationsConnectAction': 'Polacz ze Strava',
      'integrationsSyncAction': 'Synchronizuj',
      'integrationsSyncing': 'Synchronizacja...',
      'integrationsLastSync': 'Ostatnia synchronizacja',
      'integrationsAthleteId': 'ID atleta',
      'integrationsActivitiesTitle': 'Treningi pobrane ze Stravy',
      'integrationsFilterAll': 'Wszystkie',
      'integrationsActivitiesEmpty': 'Brak pobranych aktywnosci dla tego filtra.',
      'integrationsMatched': 'DOPASOWANO',
      'integrationsUnmatched': 'BEZ DOPASOWANIA',
      'integrationsUnmatchedDescription':
          'Ta aktywnosc nie zostala jeszcze powiazana z zadnym dniem planu.',
      'integrationsResultTitle': 'Wynik synchronizacji',
      'integrationsImportedActivities': 'Zaimportowane aktywnosci',
      'integrationsMatchedDays': 'Dopasowane dni treningowe',
      'integrationsRedirectHint':
          'Polacz Strave, aby pobierac aktywnosci i synchronizowac je z planem treningowym.',
      'integrationsDistance': 'Dystans',
      'integrationsDuration': 'Czas',
      'integrationsAverageSpeed': 'Srednia predkosc',
      'integrationsAveragePace': 'Srednie tempo',
      'integrationsElevation': 'Przewyzszenie',
      'integrationsHeartRate': 'Tetno',
      'integrationsMatchSection': 'Dopasowanie do planu',
      'integrationsActivityLoadError':
          'Nie udalo sie pobrac szczegolow aktywnosci.',
      'activityRun': 'Bieg',
      'activityRide': 'Rower',
      'activitySwim': 'Plywanie',
      'activityWalk': 'Marsz',
      'activityWorkout': 'Trening',
      'activityStrength': 'Silownia',
      'activityOther': 'Inna aktywnosc',
      'logout': 'Wyloguj',
      'language': 'Jezyk',
      'tryAgain': 'Sprobuj ponownie',
      'loading': 'Ladowanie...',
      'requiredField': 'To pole jest wymagane.',
      'invalidEmail': 'Podaj poprawny adres email.',
      'passwordTooShort': 'Haslo musi miec co najmniej 8 znakow.',
      'genericAuthError': 'Nie udalo sie wykonac operacji autoryzacji.',
      'dashboardPlaceholder':
          'Tu pojawi sie dashboard z planem i statystykami.',
      'plansPlaceholder': 'Tu pojawi sie lista planow i edytor.',
      'integrationsPlaceholder': 'Tu pojawi sie integracja ze Strava.',
      'accountPlaceholder': 'Tu pojawi sie profil uzytkownika.',
      'sessionExpired': 'Sesja wygasla. Zaloguj sie ponownie.',
      'welcomeBack': 'Masz juz gotowy fundament aplikacji mobilnej.',
      'switchLanguage': 'Przelacz jezyk',
      'shellOpenMenu': 'Otworz menu',
      'shellNavigation': 'Nawigacja',
      'shellQuickActions': 'Szybkie akcje',
      'shellSignedInAs': 'Zalogowano jako',
      'shellNotConnected': 'Brak aktywnego polaczenia ze Strava',
      'shellGoToAccount': 'Przejdz do konta',
      'shellSectionDashboard': 'Podsumowanie',
      'shellSectionPlans': 'Plany treningowe',
      'shellSectionIntegrations': 'Polaczenia',
      'shellSectionAccount': 'Profil i sesja',
      'emptyStateTitle': 'Jeszcze nic tu nie ma',
      'errorStateTitle': 'Cos poszlo nie tak',
      'pullToRefresh': 'Pociagnij, aby odswiezyc',
      'accountSectionLanguage': 'Jezyk',
      'accountSectionSession': 'Sesja',
      'accountConnectedProvider': 'Metoda logowania',
      'accountOpenProfile':
          'Ustawienia konta rozszerzymy w kolejnym sprincie.',
      'authProviderLocal': 'Email i haslo',
      'authProviderGoogle': 'Google',
      'invalidActivityId': 'Nieprawidlowe id aktywnosci',
      'helloUser': 'Witaj, {name}',
    },
    'en': {
      'appTitle': 'Travans',
      'authKicker': 'Welcome to Travans',
      'loginTitle': 'Sign in',
      'loginSubtitle':
          'Sign in to manage your training plan and Strava synchronization.',
      'registerTitle': 'Create account',
      'registerSubtitle':
          'Create an account to build your training plan and continue the mobile Travans experience.',
      'email': 'Email',
      'password': 'Password',
      'displayName': 'Display name',
      'rememberMe': 'Remember me',
      'signIn': 'Sign in',
      'signUp': 'Create account',
      'orSeparator': 'OR',
      'googleSignIn': 'Sign in with Google',
      'googleSignUp': 'Sign up with Google',
      'goToRegister': 'No account yet? Create one',
      'goToLogin': 'Already have an account? Sign in',
      'dashboard': 'Dashboard',
      'plans': 'Plans',
      'integrations': 'Integrations',
      'account': 'Account',
      'integrationsTitle': 'Strava connection',
      'integrationsSubtitle':
          'Connect your account, sync activities, and inspect matched workouts.',
      'integrationsConnectionTitle': 'Account connection',
      'integrationsConnected': 'Connected',
      'integrationsDisconnected': 'Disconnected',
      'integrationsConnectAction': 'Connect Strava',
      'integrationsSyncAction': 'Sync',
      'integrationsSyncing': 'Syncing...',
      'integrationsLastSync': 'Last sync',
      'integrationsAthleteId': 'Athlete ID',
      'integrationsActivitiesTitle': 'Activities imported from Strava',
      'integrationsFilterAll': 'All',
      'integrationsActivitiesEmpty': 'No imported activities for this filter.',
      'integrationsMatched': 'MATCHED',
      'integrationsUnmatched': 'UNMATCHED',
      'integrationsUnmatchedDescription':
          'This activity has not been linked to any training day yet.',
      'integrationsResultTitle': 'Sync result',
      'integrationsImportedActivities': 'Imported activities',
      'integrationsMatchedDays': 'Matched training days',
      'integrationsRedirectHint':
          'Connect Strava to download activities and sync them with your training plan.',
      'integrationsDistance': 'Distance',
      'integrationsDuration': 'Duration',
      'integrationsAverageSpeed': 'Average speed',
      'integrationsAveragePace': 'Average pace',
      'integrationsElevation': 'Elevation',
      'integrationsHeartRate': 'Heart rate',
      'integrationsMatchSection': 'Plan match',
      'integrationsActivityLoadError': 'Failed to load activity details.',
      'activityRun': 'Run',
      'activityRide': 'Ride',
      'activitySwim': 'Swim',
      'activityWalk': 'Walk',
      'activityWorkout': 'Workout',
      'activityStrength': 'Strength',
      'activityOther': 'Other activity',
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
      'welcomeBack': 'You already have the mobile app foundation in place.',
      'switchLanguage': 'Switch language',
      'shellOpenMenu': 'Open menu',
      'shellNavigation': 'Navigation',
      'shellQuickActions': 'Quick actions',
      'shellSignedInAs': 'Signed in as',
      'shellNotConnected': 'No active Strava connection',
      'shellGoToAccount': 'Go to account',
      'shellSectionDashboard': 'Overview',
      'shellSectionPlans': 'Training plans',
      'shellSectionIntegrations': 'Connections',
      'shellSectionAccount': 'Profile and session',
      'emptyStateTitle': 'Nothing here yet',
      'errorStateTitle': 'Something went wrong',
      'pullToRefresh': 'Pull to refresh',
      'accountSectionLanguage': 'Language',
      'accountSectionSession': 'Session',
      'accountConnectedProvider': 'Connected provider',
      'accountOpenProfile':
          'Account settings will be expanded in the next sprint.',
      'authProviderLocal': 'Email and password',
      'authProviderGoogle': 'Google',
      'invalidActivityId': 'Invalid activity id',
      'helloUser': 'Hello, {name}',
    },
  };

  String _string(String key) {
    return _strings[locale.languageCode]?[key] ?? _strings['en']![key]!;
  }

  String get appTitle => _string('appTitle');
  String get authKicker => _string('authKicker');
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
  String get orSeparator => _string('orSeparator');
  String get googleSignIn => _string('googleSignIn');
  String get googleSignUp => _string('googleSignUp');
  String get goToRegister => _string('goToRegister');
  String get goToLogin => _string('goToLogin');
  String get dashboard => _string('dashboard');
  String get plans => _string('plans');
  String get integrations => _string('integrations');
  String get account => _string('account');
  String get integrationsTitle => _string('integrationsTitle');
  String get integrationsSubtitle => _string('integrationsSubtitle');
  String get integrationsConnectionTitle =>
      _string('integrationsConnectionTitle');
  String get integrationsConnected => _string('integrationsConnected');
  String get integrationsDisconnected => _string('integrationsDisconnected');
  String get integrationsConnectAction => _string('integrationsConnectAction');
  String get integrationsSyncAction => _string('integrationsSyncAction');
  String get integrationsSyncing => _string('integrationsSyncing');
  String get integrationsLastSync => _string('integrationsLastSync');
  String get integrationsAthleteId => _string('integrationsAthleteId');
  String get integrationsActivitiesTitle =>
      _string('integrationsActivitiesTitle');
  String get integrationsFilterAll => _string('integrationsFilterAll');
  String get integrationsActivitiesEmpty =>
      _string('integrationsActivitiesEmpty');
  String get integrationsMatched => _string('integrationsMatched');
  String get integrationsUnmatched => _string('integrationsUnmatched');
  String get integrationsUnmatchedDescription =>
      _string('integrationsUnmatchedDescription');
  String get integrationsResultTitle => _string('integrationsResultTitle');
  String get integrationsImportedActivities =>
      _string('integrationsImportedActivities');
  String get integrationsMatchedDays => _string('integrationsMatchedDays');
  String get integrationsRedirectHint => _string('integrationsRedirectHint');
  String get integrationsDistance => _string('integrationsDistance');
  String get integrationsDuration => _string('integrationsDuration');
  String get integrationsAverageSpeed => _string('integrationsAverageSpeed');
  String get integrationsAveragePace => _string('integrationsAveragePace');
  String get integrationsElevation => _string('integrationsElevation');
  String get integrationsHeartRate => _string('integrationsHeartRate');
  String get integrationsMatchSection => _string('integrationsMatchSection');
  String get integrationsActivityLoadError =>
      _string('integrationsActivityLoadError');
  String get activityRun => _string('activityRun');
  String get activityRide => _string('activityRide');
  String get activitySwim => _string('activitySwim');
  String get activityWalk => _string('activityWalk');
  String get activityWorkout => _string('activityWorkout');
  String get activityStrength => _string('activityStrength');
  String get activityOther => _string('activityOther');
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
  String get shellOpenMenu => _string('shellOpenMenu');
  String get shellNavigation => _string('shellNavigation');
  String get shellQuickActions => _string('shellQuickActions');
  String get shellSignedInAs => _string('shellSignedInAs');
  String get shellNotConnected => _string('shellNotConnected');
  String get shellGoToAccount => _string('shellGoToAccount');
  String get shellSectionDashboard => _string('shellSectionDashboard');
  String get shellSectionPlans => _string('shellSectionPlans');
  String get shellSectionIntegrations => _string('shellSectionIntegrations');
  String get shellSectionAccount => _string('shellSectionAccount');
  String get emptyStateTitle => _string('emptyStateTitle');
  String get errorStateTitle => _string('errorStateTitle');
  String get pullToRefresh => _string('pullToRefresh');
  String get accountSectionLanguage => _string('accountSectionLanguage');
  String get accountSectionSession => _string('accountSectionSession');
  String get accountConnectedProvider => _string('accountConnectedProvider');
  String get accountOpenProfile => _string('accountOpenProfile');
  String get authProviderLocal => _string('authProviderLocal');
  String get authProviderGoogle => _string('authProviderGoogle');
  String get invalidActivityId => _string('invalidActivityId');

  String helloUser(String name) {
    return _string('helloUser').replaceFirst('{name}', name);
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['pl', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
