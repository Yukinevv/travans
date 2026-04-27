// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Travans';

  @override
  String get authKicker => 'Witaj w Travans';

  @override
  String get loginTitle => 'Logowanie';

  @override
  String get loginSubtitle =>
      'Zaloguj sie, aby zarzadzac planem treningowym i synchronizacja Stravy.';

  @override
  String get registerTitle => 'Zaloz konto';

  @override
  String get registerSubtitle =>
      'Utworz konto, aby budowac plan treningowy i rozwijac mobilna wersje Travans.';

  @override
  String get email => 'Email';

  @override
  String get password => 'Haslo';

  @override
  String get displayName => 'Nazwa uzytkownika';

  @override
  String get rememberMe => 'Zapamietaj mnie';

  @override
  String get signIn => 'Zaloguj';

  @override
  String get signUp => 'Zaloz konto';

  @override
  String get orSeparator => 'LUB';

  @override
  String get googleSignIn => 'Zaloguj sie przez Google';

  @override
  String get googleSignUp => 'Zarejestruj sie przez Google';

  @override
  String get goToRegister => 'Nie masz konta? Utworz je';

  @override
  String get goToLogin => 'Masz juz konto? Zaloguj sie';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get plans => 'Plany';

  @override
  String get integrations => 'Integracje';

  @override
  String get account => 'Konto';

  @override
  String get integrationsTitle => 'Polaczenie ze Strava';

  @override
  String get integrationsSubtitle =>
      'Polacz konto, synchronizuj aktywnosci i sprawdzaj dopasowane treningi.';

  @override
  String get integrationsConnectionTitle => 'Polaczenie konta';

  @override
  String get integrationsConnected => 'Polaczono';

  @override
  String get integrationsDisconnected => 'Nie polaczono';

  @override
  String get integrationsConnectAction => 'Polacz ze Strava';

  @override
  String get integrationsSyncAction => 'Synchronizuj';

  @override
  String get integrationsSyncing => 'Synchronizacja...';

  @override
  String get integrationsLastSync => 'Ostatnia synchronizacja';

  @override
  String get integrationsAthleteId => 'ID atleta';

  @override
  String get integrationsActivitiesTitle => 'Treningi pobrane ze Stravy';

  @override
  String get integrationsFilterAll => 'Wszystkie';

  @override
  String get integrationsActivitiesEmpty =>
      'Brak pobranych aktywnosci dla tego filtra.';

  @override
  String get integrationsMatched => 'DOPASOWANO';

  @override
  String get integrationsUnmatched => 'BEZ DOPASOWANIA';

  @override
  String get integrationsUnmatchedDescription =>
      'Ta aktywnosc nie zostala jeszcze powiazana z zadnym dniem planu.';

  @override
  String get integrationsResultTitle => 'Wynik synchronizacji';

  @override
  String get integrationsImportedActivities => 'Zaimportowane aktywnosci';

  @override
  String get integrationsMatchedDays => 'Dopasowane dni treningowe';

  @override
  String get integrationsRedirectHint =>
      'Polacz Strave, aby pobierac aktywnosci i synchronizowac je z planem treningowym.';

  @override
  String get integrationsDistance => 'Dystans';

  @override
  String get integrationsDuration => 'Czas';

  @override
  String get integrationsAverageSpeed => 'Srednia predkosc';

  @override
  String get integrationsAveragePace => 'Srednie tempo';

  @override
  String get integrationsElevation => 'Przewyzszenie';

  @override
  String get integrationsHeartRate => 'Tetno';

  @override
  String get integrationsMatchSection => 'Dopasowanie do planu';

  @override
  String get integrationsActivityLoadError =>
      'Nie udalo sie pobrac szczegolow aktywnosci.';

  @override
  String get activityRun => 'Bieg';

  @override
  String get activityRide => 'Rower';

  @override
  String get activitySwim => 'Plywanie';

  @override
  String get activityWalk => 'Marsz';

  @override
  String get activityWorkout => 'Trening';

  @override
  String get activityStrength => 'Silownia';

  @override
  String get activityOther => 'Inna aktywnosc';

  @override
  String get logout => 'Wyloguj';

  @override
  String get language => 'Jezyk';

  @override
  String get tryAgain => 'Sprobuj ponownie';

  @override
  String get loading => 'Ladowanie...';

  @override
  String get requiredField => 'To pole jest wymagane.';

  @override
  String get invalidEmail => 'Podaj poprawny adres email.';

  @override
  String get passwordTooShort => 'Haslo musi miec co najmniej 8 znakow.';

  @override
  String get genericAuthError => 'Nie udalo sie wykonac operacji autoryzacji.';

  @override
  String get dashboardPlaceholder =>
      'Tu pojawi sie dashboard z planem i statystykami.';

  @override
  String get plansPlaceholder => 'Tu pojawi sie lista planow i edytor.';

  @override
  String get integrationsPlaceholder => 'Tu pojawi sie integracja ze Strava.';

  @override
  String get accountPlaceholder => 'Tu pojawi sie profil uzytkownika.';

  @override
  String get sessionExpired => 'Sesja wygasla. Zaloguj sie ponownie.';

  @override
  String get welcomeBack => 'Masz juz gotowy fundament aplikacji mobilnej.';

  @override
  String get switchLanguage => 'Przelacz jezyk';

  @override
  String get shellOpenMenu => 'Otworz menu';

  @override
  String get shellNavigation => 'Nawigacja';

  @override
  String get shellQuickActions => 'Szybkie akcje';

  @override
  String get shellSignedInAs => 'Zalogowano jako';

  @override
  String get shellNotConnected => 'Brak aktywnego polaczenia ze Strava';

  @override
  String get shellGoToAccount => 'Przejdz do konta';

  @override
  String get shellSectionDashboard => 'Podsumowanie';

  @override
  String get shellSectionPlans => 'Plany treningowe';

  @override
  String get shellSectionIntegrations => 'Polaczenia';

  @override
  String get shellSectionAccount => 'Profil i sesja';

  @override
  String get emptyStateTitle => 'Jeszcze nic tu nie ma';

  @override
  String get errorStateTitle => 'Cos poszlo nie tak';

  @override
  String get pullToRefresh => 'Pociagnij, aby odswiezyc';

  @override
  String get accountSectionLanguage => 'Jezyk';

  @override
  String get accountSectionSession => 'Sesja';

  @override
  String get accountConnectedProvider => 'Metoda logowania';

  @override
  String get accountOpenProfile =>
      'Ustawienia konta rozszerzymy w kolejnym sprincie.';

  @override
  String get authProviderLocal => 'Email i haslo';

  @override
  String get authProviderGoogle => 'Google';

  @override
  String get invalidActivityId => 'Nieprawidlowe id aktywnosci';

  @override
  String helloUser(String name) {
    return 'Witaj, $name';
  }
}
