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
      'trainingStatusPlanned': 'Zaplanowane',
      'trainingStatusCompleted': 'Wykonane',
      'trainingStatusPartial': 'Czesciowo',
      'trainingStatusMissed': 'Pominiete',
      'dashboardHeaderKicker': 'Pulpit',
      'dashboardHeaderTitle': 'Postep realizacji planu',
      'dashboardDisplayedPlan': 'Wyswietlany plan',
      'dashboardAutoSelect': 'Automatycznie wybrany',
      'dashboardLoading': 'Ladowanie danych dashboardu...',
      'dashboardStatsPlanned': 'Zaplanowane',
      'dashboardStatsCompleted': 'Wykonane',
      'dashboardStatsPartial': 'Czesciowo',
      'dashboardStatsMissed': 'Pominiete',
      'dashboardStatsEffectiveness': 'Skutecznosc',
      'dashboardDetailsLabel': 'Statystyki szczegolowe',
      'dashboardDaysMeetingDistanceGoal': 'Dni z celem dystansu',
      'dashboardDaysMeetingDurationGoal': 'Dni z celem czasu',
      'dashboardDaysMeetingPaceGoal': 'Dni z celem tempa',
      'dashboardAverageRunPace': 'Srednie tempo biegu',
      'dashboardFastestRunPace': 'Najszybsze tempo biegu',
      'dashboardAverageRideSpeed': 'Srednia predkosc jazdy',
      'dashboardMaxRideSpeed': 'Maksymalna predkosc jazdy',
      'dashboardElevationGain': 'Przewyzszenie',
      'dashboardCurrentPlanLabel': 'Biezacy plan',
      'dashboardCurrentPlanEmptyTitle': 'Brak aktywnego planu',
      'dashboardCurrentPlanEmptyDescription':
          'Dodaj plan treningowy, a dashboard zacznie pokazywac postep i dopasowane treningi ze Stravy.',
      'dashboardPlanTypePrefix': 'Typ planu:',
      'dashboardPinnedMessage': 'Plan zostal przypiety do dashboardu.',
      'dashboardScheduledFor': 'Termin',
      'dashboardActivity': 'Aktywnosc',
      'dashboardPlannedSection': 'Plan',
      'dashboardCompletedSection': 'Wykonanie',
      'dashboardMatchedActivity': 'Powiazana aktywnosc:',
      'dashboardNotes': 'Notatki',
      'dashboardDistanceGoal': 'Cel dystansu',
      'dashboardDurationGoal': 'Cel czasu',
      'dashboardPaceGoal': 'Cel tempa',
      'dashboardAverageSpeed': 'Srednia predkosc',
      'dashboardMaxSpeed': 'Maks. predkosc',
      'dashboardAverageHeartrate': 'Srednie tetno',
      'dashboardMaxHeartrate': 'Maks. tetno',
      'dashboardAverageCadence': 'Srednia kadencja',
      'dashboardOverDistance': 'Nadwyzka dystansu',
      'dashboardOverDuration': 'Nadwyzka czasu',
      'dashboardSavedTime': 'Zysk czasu',
      'dashboardGoalAchieved': 'Osiagnieto',
      'dashboardGoalNotAchieved': 'Nie osiagnieto',
      'dashboardNoCriteria': 'Brak kryterium',
      'dashboardNoTrainingDays': 'Ten plan nie ma jeszcze dni treningowych.',
      'plansLoading': 'Ladowanie listy planow...',
      'plansHeaderKicker': 'Plany',
      'plansHeaderTitle': 'Twoje plany treningowe',
      'plansHeaderSubtitleZero': 'Nie masz jeszcze zadnych planow.',
      'plansHeaderSubtitleOne': 'Masz 1 zapisany plan treningowy.',
      'plansHeaderSubtitleMany': 'Masz {count} zapisanych planow treningowych.',
      'plansCreateAction': 'Nowy plan',
      'plansEmptyTitle': 'Brak planow treningowych',
      'plansEmptyDescription':
          'Gdy dodasz pierwszy plan, zobaczysz tu jego szczegoly i dni treningowe.',
      'plansTypeLabel': 'Typ',
      'plansDaysLabel': 'Dni',
      'plansStartDateLabel': 'Start',
      'plansCreatedAtLabel': 'Utworzono',
      'plansDescriptionLabel': 'Opis',
      'plansDaysSection': 'Dni treningowe',
      'plansNoTrainingDays': 'Ten plan nie ma jeszcze zdefiniowanych dni.',
      'plansVisibleOnDashboard': 'Na dashboardzie',
      'plansShowOnDashboard': 'Pokaz na dashboardzie',
      'plansDelete': 'Usun',
      'plansCancel': 'Anuluj',
      'plansDayPrefix': 'Dzien',
      'plansDistanceLabel': 'Dystans',
      'plansDurationLabel': 'Czas',
      'plansNotesLabel': 'Notatki',
      'plansMatchedActivityLabel': 'Powiazana aktywnosc',
      'plansPinDialogTitle': 'Wyswietlac ten plan na dashboardzie?',
      'plansPinDialogMessage':
          'Plan "{name}" zostanie przypiety jako glowny widok na dashboardzie.',
      'plansDeleteDialogTitle': 'Usunac plan?',
      'plansDeleteDialogMessage':
          'Plan "{name}" zostanie trwale usuniety wraz z lista dni treningowych.',
      'plansPinnedSnackbar':
          'Plan "{name}" jest teraz widoczny na dashboardzie.',
      'plansDeletedSnackbar': 'Plan "{name}" zostal usuniety.',
      'plansCreatedSnackbar': 'Plan "{name}" zostal utworzony.',
      'plansUpdatedSnackbar': 'Plan "{name}" zostal zaktualizowany.',
      'plansCreateTitle': 'Nowy plan treningowy',
      'plansEditTitle': 'Edytuj plan treningowy',
      'plansCreateSubtitle':
          'Zbuduj plan, dodaj dni treningowe i przygotuj go pod analize Stravy.',
      'plansEditSubtitle':
          'Zmien dane planu i uporzadkuj dni treningowe bez wychodzenia z aplikacji.',
      'plansEditorKicker': 'Edytor planu',
      'plansEditorLoading': 'Ladowanie formularza planu...',
      'plansEditorSectionPlan': 'Dane planu',
      'plansEditorSectionDays': 'Dni treningowe',
      'plansEditorDaysHint':
          'Ustaw kolejnosc dni, terminy i planowane wartosci treningowe.',
      'plansEditorAddDay': 'Dodaj dzien',
      'plansEditorAtLeastOneDay': 'Plan musi zawierac co najmniej jeden dzien treningowy.',
      'plansEditorName': 'Nazwa planu',
      'plansEditorDescription': 'Opis',
      'plansEditorStartDate': 'Data startu',
      'plansEditorStravaStartDate': 'Start oceny Strava',
      'plansEditorPlanType': 'Typ planu',
      'plansEditorDayDate': 'Termin',
      'plansEditorDayTitle': 'Tytul treningu',
      'plansEditorDayActivityType': 'Typ aktywnosci',
      'plansEditorDayDistance': 'Planowany dystans (m)',
      'plansEditorDayDuration': 'Planowany czas (s)',
      'plansEditorDayNotes': 'Notatki',
      'plansEditorValidationError':
          'Uzupelnij wymagane pola planu i wszystkich dni treningowych.',
      'plansEditorInvalidNumber': 'Podaj poprawna liczbe dodatnia lub zostaw pole puste.',
      'plansSavePlan': 'Zapisz plan',
      'plansSaveChanges': 'Zapisz zmiany',
      'plansInvalidPlanId': 'Nieprawidlowe id planu',
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
      'trainingStatusPlanned': 'Planned',
      'trainingStatusCompleted': 'Completed',
      'trainingStatusPartial': 'Partial',
      'trainingStatusMissed': 'Missed',
      'dashboardHeaderKicker': 'Dashboard',
      'dashboardHeaderTitle': 'Plan completion progress',
      'dashboardDisplayedPlan': 'Displayed plan',
      'dashboardAutoSelect': 'Automatically selected',
      'dashboardLoading': 'Loading dashboard data...',
      'dashboardStatsPlanned': 'Planned',
      'dashboardStatsCompleted': 'Completed',
      'dashboardStatsPartial': 'Partial',
      'dashboardStatsMissed': 'Missed',
      'dashboardStatsEffectiveness': 'Effectiveness',
      'dashboardDetailsLabel': 'Detailed stats',
      'dashboardDaysMeetingDistanceGoal': 'Days meeting distance goal',
      'dashboardDaysMeetingDurationGoal': 'Days meeting duration goal',
      'dashboardDaysMeetingPaceGoal': 'Days meeting pace goal',
      'dashboardAverageRunPace': 'Average run pace',
      'dashboardFastestRunPace': 'Fastest run pace',
      'dashboardAverageRideSpeed': 'Average ride speed',
      'dashboardMaxRideSpeed': 'Max ride speed',
      'dashboardElevationGain': 'Elevation gain',
      'dashboardCurrentPlanLabel': 'Current plan',
      'dashboardCurrentPlanEmptyTitle': 'No active plan',
      'dashboardCurrentPlanEmptyDescription':
          'Add a training plan and the dashboard will start showing progress and matched Strava workouts.',
      'dashboardPlanTypePrefix': 'Plan type:',
      'dashboardPinnedMessage': 'The plan has been pinned to the dashboard.',
      'dashboardScheduledFor': 'Scheduled for',
      'dashboardActivity': 'Activity',
      'dashboardPlannedSection': 'Plan',
      'dashboardCompletedSection': 'Completed',
      'dashboardMatchedActivity': 'Matched activity:',
      'dashboardNotes': 'Notes',
      'dashboardDistanceGoal': 'Distance goal',
      'dashboardDurationGoal': 'Duration goal',
      'dashboardPaceGoal': 'Pace goal',
      'dashboardAverageSpeed': 'Average speed',
      'dashboardMaxSpeed': 'Max speed',
      'dashboardAverageHeartrate': 'Average heart rate',
      'dashboardMaxHeartrate': 'Max heart rate',
      'dashboardAverageCadence': 'Average cadence',
      'dashboardOverDistance': 'Distance surplus',
      'dashboardOverDuration': 'Time surplus',
      'dashboardSavedTime': 'Time saved',
      'dashboardGoalAchieved': 'Achieved',
      'dashboardGoalNotAchieved': 'Not achieved',
      'dashboardNoCriteria': 'No criteria',
      'dashboardNoTrainingDays': 'This plan does not have any training days yet.',
      'plansLoading': 'Loading plans list...',
      'plansHeaderKicker': 'Plans',
      'plansHeaderTitle': 'Your training plans',
      'plansHeaderSubtitleZero': 'You do not have any plans yet.',
      'plansHeaderSubtitleOne': 'You have 1 saved training plan.',
      'plansHeaderSubtitleMany': 'You have {count} saved training plans.',
      'plansCreateAction': 'New plan',
      'plansEmptyTitle': 'No training plans',
      'plansEmptyDescription':
          'Once you add your first plan, you will see its details and training days here.',
      'plansTypeLabel': 'Type',
      'plansDaysLabel': 'Days',
      'plansStartDateLabel': 'Start',
      'plansCreatedAtLabel': 'Created at',
      'plansDescriptionLabel': 'Description',
      'plansDaysSection': 'Training days',
      'plansNoTrainingDays': 'This plan does not define any training days yet.',
      'plansVisibleOnDashboard': 'On dashboard',
      'plansShowOnDashboard': 'Show on dashboard',
      'plansDelete': 'Delete',
      'plansCancel': 'Cancel',
      'plansDayPrefix': 'Day',
      'plansDistanceLabel': 'Distance',
      'plansDurationLabel': 'Duration',
      'plansNotesLabel': 'Notes',
      'plansMatchedActivityLabel': 'Matched activity',
      'plansPinDialogTitle': 'Show this plan on the dashboard?',
      'plansPinDialogMessage':
          'The "{name}" plan will be pinned as the primary dashboard view.',
      'plansDeleteDialogTitle': 'Delete plan?',
      'plansDeleteDialogMessage':
          'The "{name}" plan will be permanently removed together with its training days.',
      'plansPinnedSnackbar':
          'The "{name}" plan is now visible on the dashboard.',
      'plansDeletedSnackbar': 'The "{name}" plan has been deleted.',
      'plansCreatedSnackbar': 'The "{name}" plan has been created.',
      'plansUpdatedSnackbar': 'The "{name}" plan has been updated.',
      'plansCreateTitle': 'New training plan',
      'plansEditTitle': 'Edit training plan',
      'plansCreateSubtitle':
          'Build a plan, add training days, and prepare it for Strava analysis.',
      'plansEditSubtitle':
          'Update plan details and reorder training days without leaving the app.',
      'plansEditorKicker': 'Plan editor',
      'plansEditorLoading': 'Loading plan form...',
      'plansEditorSectionPlan': 'Plan details',
      'plansEditorSectionDays': 'Training days',
      'plansEditorDaysHint':
          'Set the order of days, schedule dates, and planned workout values.',
      'plansEditorAddDay': 'Add day',
      'plansEditorAtLeastOneDay': 'A plan must contain at least one training day.',
      'plansEditorName': 'Plan name',
      'plansEditorDescription': 'Description',
      'plansEditorStartDate': 'Start date',
      'plansEditorStravaStartDate': 'Strava evaluation start',
      'plansEditorPlanType': 'Plan type',
      'plansEditorDayDate': 'Schedule date',
      'plansEditorDayTitle': 'Workout title',
      'plansEditorDayActivityType': 'Activity type',
      'plansEditorDayDistance': 'Planned distance (m)',
      'plansEditorDayDuration': 'Planned duration (s)',
      'plansEditorDayNotes': 'Notes',
      'plansEditorValidationError':
          'Fill in the required plan fields and all required training day fields.',
      'plansEditorInvalidNumber':
          'Enter a valid positive number or leave the field empty.',
      'plansSavePlan': 'Save plan',
      'plansSaveChanges': 'Save changes',
      'plansInvalidPlanId': 'Invalid plan id',
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
  String get trainingStatusPlanned => _string('trainingStatusPlanned');
  String get trainingStatusCompleted => _string('trainingStatusCompleted');
  String get trainingStatusPartial => _string('trainingStatusPartial');
  String get trainingStatusMissed => _string('trainingStatusMissed');
  String get dashboardHeaderKicker => _string('dashboardHeaderKicker');
  String get dashboardHeaderTitle => _string('dashboardHeaderTitle');
  String get dashboardDisplayedPlan => _string('dashboardDisplayedPlan');
  String get dashboardAutoSelect => _string('dashboardAutoSelect');
  String get dashboardLoading => _string('dashboardLoading');
  String get dashboardStatsPlanned => _string('dashboardStatsPlanned');
  String get dashboardStatsCompleted => _string('dashboardStatsCompleted');
  String get dashboardStatsPartial => _string('dashboardStatsPartial');
  String get dashboardStatsMissed => _string('dashboardStatsMissed');
  String get dashboardStatsEffectiveness =>
      _string('dashboardStatsEffectiveness');
  String get dashboardDetailsLabel => _string('dashboardDetailsLabel');
  String get dashboardDaysMeetingDistanceGoal =>
      _string('dashboardDaysMeetingDistanceGoal');
  String get dashboardDaysMeetingDurationGoal =>
      _string('dashboardDaysMeetingDurationGoal');
  String get dashboardDaysMeetingPaceGoal =>
      _string('dashboardDaysMeetingPaceGoal');
  String get dashboardAverageRunPace => _string('dashboardAverageRunPace');
  String get dashboardFastestRunPace => _string('dashboardFastestRunPace');
  String get dashboardAverageRideSpeed => _string('dashboardAverageRideSpeed');
  String get dashboardMaxRideSpeed => _string('dashboardMaxRideSpeed');
  String get dashboardElevationGain => _string('dashboardElevationGain');
  String get dashboardCurrentPlanLabel => _string('dashboardCurrentPlanLabel');
  String get dashboardCurrentPlanEmptyTitle =>
      _string('dashboardCurrentPlanEmptyTitle');
  String get dashboardCurrentPlanEmptyDescription =>
      _string('dashboardCurrentPlanEmptyDescription');
  String get dashboardPlanTypePrefix => _string('dashboardPlanTypePrefix');
  String get dashboardPinnedMessage => _string('dashboardPinnedMessage');
  String get dashboardScheduledFor => _string('dashboardScheduledFor');
  String get dashboardActivity => _string('dashboardActivity');
  String get dashboardPlannedSection => _string('dashboardPlannedSection');
  String get dashboardCompletedSection => _string('dashboardCompletedSection');
  String get dashboardMatchedActivity => _string('dashboardMatchedActivity');
  String get dashboardNotes => _string('dashboardNotes');
  String get dashboardDistanceGoal => _string('dashboardDistanceGoal');
  String get dashboardDurationGoal => _string('dashboardDurationGoal');
  String get dashboardPaceGoal => _string('dashboardPaceGoal');
  String get dashboardAverageSpeed => _string('dashboardAverageSpeed');
  String get dashboardMaxSpeed => _string('dashboardMaxSpeed');
  String get dashboardAverageHeartrate => _string('dashboardAverageHeartrate');
  String get dashboardMaxHeartrate => _string('dashboardMaxHeartrate');
  String get dashboardAverageCadence => _string('dashboardAverageCadence');
  String get dashboardOverDistance => _string('dashboardOverDistance');
  String get dashboardOverDuration => _string('dashboardOverDuration');
  String get dashboardSavedTime => _string('dashboardSavedTime');
  String get dashboardGoalAchieved => _string('dashboardGoalAchieved');
  String get dashboardGoalNotAchieved => _string('dashboardGoalNotAchieved');
  String get dashboardNoCriteria => _string('dashboardNoCriteria');
  String get dashboardNoTrainingDays => _string('dashboardNoTrainingDays');
  String get plansLoading => _string('plansLoading');
  String get plansHeaderKicker => _string('plansHeaderKicker');
  String get plansHeaderTitle => _string('plansHeaderTitle');
  String get plansCreateAction => _string('plansCreateAction');
  String get plansEmptyTitle => _string('plansEmptyTitle');
  String get plansEmptyDescription => _string('plansEmptyDescription');
  String get plansTypeLabel => _string('plansTypeLabel');
  String get plansDaysLabel => _string('plansDaysLabel');
  String get plansStartDateLabel => _string('plansStartDateLabel');
  String get plansCreatedAtLabel => _string('plansCreatedAtLabel');
  String get plansDescriptionLabel => _string('plansDescriptionLabel');
  String get plansDaysSection => _string('plansDaysSection');
  String get plansNoTrainingDays => _string('plansNoTrainingDays');
  String get plansVisibleOnDashboard => _string('plansVisibleOnDashboard');
  String get plansShowOnDashboard => _string('plansShowOnDashboard');
  String get plansDelete => _string('plansDelete');
  String get plansCancel => _string('plansCancel');
  String get plansDayPrefix => _string('plansDayPrefix');
  String get plansDistanceLabel => _string('plansDistanceLabel');
  String get plansDurationLabel => _string('plansDurationLabel');
  String get plansNotesLabel => _string('plansNotesLabel');
  String get plansMatchedActivityLabel => _string('plansMatchedActivityLabel');
  String get plansPinDialogTitle => _string('plansPinDialogTitle');
  String get plansDeleteDialogTitle => _string('plansDeleteDialogTitle');
  String get plansCreateTitle => _string('plansCreateTitle');
  String get plansEditTitle => _string('plansEditTitle');
  String get plansCreateSubtitle => _string('plansCreateSubtitle');
  String get plansEditSubtitle => _string('plansEditSubtitle');
  String get plansEditorKicker => _string('plansEditorKicker');
  String get plansEditorLoading => _string('plansEditorLoading');
  String get plansEditorSectionPlan => _string('plansEditorSectionPlan');
  String get plansEditorSectionDays => _string('plansEditorSectionDays');
  String get plansEditorDaysHint => _string('plansEditorDaysHint');
  String get plansEditorAddDay => _string('plansEditorAddDay');
  String get plansEditorAtLeastOneDay => _string('plansEditorAtLeastOneDay');
  String get plansEditorName => _string('plansEditorName');
  String get plansEditorDescription => _string('plansEditorDescription');
  String get plansEditorStartDate => _string('plansEditorStartDate');
  String get plansEditorStravaStartDate =>
      _string('plansEditorStravaStartDate');
  String get plansEditorPlanType => _string('plansEditorPlanType');
  String get plansEditorDayDate => _string('plansEditorDayDate');
  String get plansEditorDayTitle => _string('plansEditorDayTitle');
  String get plansEditorDayActivityType =>
      _string('plansEditorDayActivityType');
  String get plansEditorDayDistance => _string('plansEditorDayDistance');
  String get plansEditorDayDuration => _string('plansEditorDayDuration');
  String get plansEditorDayNotes => _string('plansEditorDayNotes');
  String get plansEditorValidationError =>
      _string('plansEditorValidationError');
  String get plansEditorInvalidNumber => _string('plansEditorInvalidNumber');
  String get plansSavePlan => _string('plansSavePlan');
  String get plansSaveChanges => _string('plansSaveChanges');
  String get plansInvalidPlanId => _string('plansInvalidPlanId');

  String helloUser(String name) {
    return _string('helloUser').replaceFirst('{name}', name);
  }

  String plansHeaderSubtitle(int count) {
    if (count == 0) {
      return _string('plansHeaderSubtitleZero');
    }
    if (count == 1) {
      return _string('plansHeaderSubtitleOne');
    }

    return _string('plansHeaderSubtitleMany').replaceFirst(
      '{count}',
      '$count',
    );
  }

  String plansPinDialogMessage(String name) {
    return _string('plansPinDialogMessage').replaceFirst('{name}', name);
  }

  String plansDeleteDialogMessage(String name) {
    return _string('plansDeleteDialogMessage').replaceFirst('{name}', name);
  }

  String plansPinnedSnackbar(String name) {
    return _string('plansPinnedSnackbar').replaceFirst('{name}', name);
  }

  String plansDeletedSnackbar(String name) {
    return _string('plansDeletedSnackbar').replaceFirst('{name}', name);
  }

  String plansCreatedSnackbar(String name) {
    return _string('plansCreatedSnackbar').replaceFirst('{name}', name);
  }

  String plansUpdatedSnackbar(String name) {
    return _string('plansUpdatedSnackbar').replaceFirst('{name}', name);
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
