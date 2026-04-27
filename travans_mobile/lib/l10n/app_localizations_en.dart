// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Travans';

  @override
  String get authKicker => 'Welcome to Travans';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle =>
      'Sign in to manage your training plan and Strava synchronization.';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerSubtitle =>
      'Create an account to build your training plan and continue the mobile Travans experience.';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get displayName => 'Display name';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get signIn => 'Sign in';

  @override
  String get signUp => 'Create account';

  @override
  String get orSeparator => 'OR';

  @override
  String get googleSignIn => 'Sign in with Google';

  @override
  String get googleSignUp => 'Sign up with Google';

  @override
  String get goToRegister => 'No account yet? Create one';

  @override
  String get goToLogin => 'Already have an account? Sign in';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get plans => 'Plans';

  @override
  String get integrations => 'Integrations';

  @override
  String get account => 'Account';

  @override
  String get integrationsTitle => 'Strava connection';

  @override
  String get integrationsSubtitle =>
      'Connect your account, sync activities, and inspect matched workouts.';

  @override
  String get integrationsConnectionTitle => 'Account connection';

  @override
  String get integrationsConnected => 'Connected';

  @override
  String get integrationsDisconnected => 'Disconnected';

  @override
  String get integrationsConnectAction => 'Connect Strava';

  @override
  String get integrationsSyncAction => 'Sync';

  @override
  String get integrationsSyncing => 'Syncing...';

  @override
  String get integrationsLastSync => 'Last sync';

  @override
  String get integrationsAthleteId => 'Athlete ID';

  @override
  String get integrationsActivitiesTitle => 'Activities imported from Strava';

  @override
  String get integrationsFilterAll => 'All';

  @override
  String get integrationsActivitiesEmpty =>
      'No imported activities for this filter.';

  @override
  String get integrationsMatched => 'MATCHED';

  @override
  String get integrationsUnmatched => 'UNMATCHED';

  @override
  String get integrationsUnmatchedDescription =>
      'This activity has not been linked to any training day yet.';

  @override
  String get integrationsResultTitle => 'Sync result';

  @override
  String get integrationsImportedActivities => 'Imported activities';

  @override
  String get integrationsMatchedDays => 'Matched training days';

  @override
  String get integrationsRedirectHint =>
      'Connect Strava to download activities and sync them with your training plan.';

  @override
  String get integrationsDistance => 'Distance';

  @override
  String get integrationsDuration => 'Duration';

  @override
  String get integrationsAverageSpeed => 'Average speed';

  @override
  String get integrationsAveragePace => 'Average pace';

  @override
  String get integrationsElevation => 'Elevation';

  @override
  String get integrationsHeartRate => 'Heart rate';

  @override
  String get integrationsMatchSection => 'Plan match';

  @override
  String get integrationsActivityLoadError =>
      'Failed to load activity details.';

  @override
  String get activityRun => 'Run';

  @override
  String get activityRide => 'Ride';

  @override
  String get activitySwim => 'Swim';

  @override
  String get activityWalk => 'Walk';

  @override
  String get activityWorkout => 'Workout';

  @override
  String get activityStrength => 'Strength';

  @override
  String get activityOther => 'Other activity';

  @override
  String get logout => 'Log out';

  @override
  String get language => 'Language';

  @override
  String get tryAgain => 'Try again';

  @override
  String get loading => 'Loading...';

  @override
  String get requiredField => 'This field is required.';

  @override
  String get invalidEmail => 'Enter a valid email address.';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters.';

  @override
  String get genericAuthError => 'Authentication request failed.';

  @override
  String get dashboardPlaceholder =>
      'Dashboard with plan progress and stats will live here.';

  @override
  String get plansPlaceholder => 'Plans list and editor will live here.';

  @override
  String get integrationsPlaceholder => 'Strava integration will live here.';

  @override
  String get accountPlaceholder => 'User profile will live here.';

  @override
  String get sessionExpired => 'Your session expired. Sign in again.';

  @override
  String get welcomeBack =>
      'You already have the mobile app foundation in place.';

  @override
  String get switchLanguage => 'Switch language';

  @override
  String get shellOpenMenu => 'Open menu';

  @override
  String get shellNavigation => 'Navigation';

  @override
  String get shellQuickActions => 'Quick actions';

  @override
  String get shellSignedInAs => 'Signed in as';

  @override
  String get shellNotConnected => 'No active Strava connection';

  @override
  String get shellGoToAccount => 'Go to account';

  @override
  String get shellSectionDashboard => 'Overview';

  @override
  String get shellSectionPlans => 'Training plans';

  @override
  String get shellSectionIntegrations => 'Connections';

  @override
  String get shellSectionAccount => 'Profile and session';

  @override
  String get emptyStateTitle => 'Nothing here yet';

  @override
  String get errorStateTitle => 'Something went wrong';

  @override
  String get pullToRefresh => 'Pull to refresh';

  @override
  String get accountSectionLanguage => 'Language';

  @override
  String get accountSectionSession => 'Session';

  @override
  String get accountConnectedProvider => 'Connected provider';

  @override
  String get accountOpenProfile =>
      'Account settings will be expanded in the next sprint.';

  @override
  String get authProviderLocal => 'Email and password';

  @override
  String get authProviderGoogle => 'Google';

  @override
  String get invalidActivityId => 'Invalid activity id';

  @override
  String helloUser(String name) {
    return 'Hello, $name';
  }
}
