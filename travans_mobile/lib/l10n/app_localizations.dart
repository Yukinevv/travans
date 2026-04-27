import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Travans'**
  String get appTitle;

  /// No description provided for @authKicker.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Travans'**
  String get authKicker;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage your training plan and Strava synchronization.'**
  String get loginSubtitle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create an account to build your training plan and continue the mobile Travans experience.'**
  String get registerSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get displayName;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get signUp;

  /// No description provided for @orSeparator.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orSeparator;

  /// No description provided for @googleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get googleSignIn;

  /// No description provided for @googleSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Google'**
  String get googleSignUp;

  /// No description provided for @goToRegister.
  ///
  /// In en, this message translates to:
  /// **'No account yet? Create one'**
  String get goToRegister;

  /// No description provided for @goToLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get goToLogin;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @plans.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get plans;

  /// No description provided for @integrations.
  ///
  /// In en, this message translates to:
  /// **'Integrations'**
  String get integrations;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @integrationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Strava connection'**
  String get integrationsTitle;

  /// No description provided for @integrationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect your account, sync activities, and inspect matched workouts.'**
  String get integrationsSubtitle;

  /// No description provided for @integrationsConnectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Account connection'**
  String get integrationsConnectionTitle;

  /// No description provided for @integrationsConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get integrationsConnected;

  /// No description provided for @integrationsDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get integrationsDisconnected;

  /// No description provided for @integrationsConnectAction.
  ///
  /// In en, this message translates to:
  /// **'Connect Strava'**
  String get integrationsConnectAction;

  /// No description provided for @integrationsSyncAction.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get integrationsSyncAction;

  /// No description provided for @integrationsSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get integrationsSyncing;

  /// No description provided for @integrationsLastSync.
  ///
  /// In en, this message translates to:
  /// **'Last sync'**
  String get integrationsLastSync;

  /// No description provided for @integrationsAthleteId.
  ///
  /// In en, this message translates to:
  /// **'Athlete ID'**
  String get integrationsAthleteId;

  /// No description provided for @integrationsActivitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Activities imported from Strava'**
  String get integrationsActivitiesTitle;

  /// No description provided for @integrationsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get integrationsFilterAll;

  /// No description provided for @integrationsActivitiesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No imported activities for this filter.'**
  String get integrationsActivitiesEmpty;

  /// No description provided for @integrationsMatched.
  ///
  /// In en, this message translates to:
  /// **'MATCHED'**
  String get integrationsMatched;

  /// No description provided for @integrationsUnmatched.
  ///
  /// In en, this message translates to:
  /// **'UNMATCHED'**
  String get integrationsUnmatched;

  /// No description provided for @integrationsUnmatchedDescription.
  ///
  /// In en, this message translates to:
  /// **'This activity has not been linked to any training day yet.'**
  String get integrationsUnmatchedDescription;

  /// No description provided for @integrationsResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync result'**
  String get integrationsResultTitle;

  /// No description provided for @integrationsImportedActivities.
  ///
  /// In en, this message translates to:
  /// **'Imported activities'**
  String get integrationsImportedActivities;

  /// No description provided for @integrationsMatchedDays.
  ///
  /// In en, this message translates to:
  /// **'Matched training days'**
  String get integrationsMatchedDays;

  /// No description provided for @integrationsRedirectHint.
  ///
  /// In en, this message translates to:
  /// **'Connect Strava to download activities and sync them with your training plan.'**
  String get integrationsRedirectHint;

  /// No description provided for @integrationsDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get integrationsDistance;

  /// No description provided for @integrationsDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get integrationsDuration;

  /// No description provided for @integrationsAverageSpeed.
  ///
  /// In en, this message translates to:
  /// **'Average speed'**
  String get integrationsAverageSpeed;

  /// No description provided for @integrationsAveragePace.
  ///
  /// In en, this message translates to:
  /// **'Average pace'**
  String get integrationsAveragePace;

  /// No description provided for @integrationsElevation.
  ///
  /// In en, this message translates to:
  /// **'Elevation'**
  String get integrationsElevation;

  /// No description provided for @integrationsHeartRate.
  ///
  /// In en, this message translates to:
  /// **'Heart rate'**
  String get integrationsHeartRate;

  /// No description provided for @integrationsMatchSection.
  ///
  /// In en, this message translates to:
  /// **'Plan match'**
  String get integrationsMatchSection;

  /// No description provided for @integrationsActivityLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load activity details.'**
  String get integrationsActivityLoadError;

  /// No description provided for @activityRun.
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get activityRun;

  /// No description provided for @activityRide.
  ///
  /// In en, this message translates to:
  /// **'Ride'**
  String get activityRide;

  /// No description provided for @activitySwim.
  ///
  /// In en, this message translates to:
  /// **'Swim'**
  String get activitySwim;

  /// No description provided for @activityWalk.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get activityWalk;

  /// No description provided for @activityWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get activityWorkout;

  /// No description provided for @activityStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get activityStrength;

  /// No description provided for @activityOther.
  ///
  /// In en, this message translates to:
  /// **'Other activity'**
  String get activityOther;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get requiredField;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get passwordTooShort;

  /// No description provided for @genericAuthError.
  ///
  /// In en, this message translates to:
  /// **'Authentication request failed.'**
  String get genericAuthError;

  /// No description provided for @dashboardPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Dashboard with plan progress and stats will live here.'**
  String get dashboardPlaceholder;

  /// No description provided for @plansPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Plans list and editor will live here.'**
  String get plansPlaceholder;

  /// No description provided for @integrationsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Strava integration will live here.'**
  String get integrationsPlaceholder;

  /// No description provided for @accountPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'User profile will live here.'**
  String get accountPlaceholder;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session expired. Sign in again.'**
  String get sessionExpired;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'You already have the mobile app foundation in place.'**
  String get welcomeBack;

  /// No description provided for @switchLanguage.
  ///
  /// In en, this message translates to:
  /// **'Switch language'**
  String get switchLanguage;

  /// No description provided for @shellOpenMenu.
  ///
  /// In en, this message translates to:
  /// **'Open menu'**
  String get shellOpenMenu;

  /// No description provided for @shellNavigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get shellNavigation;

  /// No description provided for @shellQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get shellQuickActions;

  /// No description provided for @shellSignedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as'**
  String get shellSignedInAs;

  /// No description provided for @shellNotConnected.
  ///
  /// In en, this message translates to:
  /// **'No active Strava connection'**
  String get shellNotConnected;

  /// No description provided for @shellGoToAccount.
  ///
  /// In en, this message translates to:
  /// **'Go to account'**
  String get shellGoToAccount;

  /// No description provided for @shellSectionDashboard.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get shellSectionDashboard;

  /// No description provided for @shellSectionPlans.
  ///
  /// In en, this message translates to:
  /// **'Training plans'**
  String get shellSectionPlans;

  /// No description provided for @shellSectionIntegrations.
  ///
  /// In en, this message translates to:
  /// **'Connections'**
  String get shellSectionIntegrations;

  /// No description provided for @shellSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Profile and session'**
  String get shellSectionAccount;

  /// No description provided for @emptyStateTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyStateTitle;

  /// No description provided for @errorStateTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorStateTitle;

  /// No description provided for @pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get pullToRefresh;

  /// No description provided for @accountSectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get accountSectionLanguage;

  /// No description provided for @accountSectionSession.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get accountSectionSession;

  /// No description provided for @accountConnectedProvider.
  ///
  /// In en, this message translates to:
  /// **'Connected provider'**
  String get accountConnectedProvider;

  /// No description provided for @accountOpenProfile.
  ///
  /// In en, this message translates to:
  /// **'Account settings will be expanded in the next sprint.'**
  String get accountOpenProfile;

  /// No description provided for @authProviderLocal.
  ///
  /// In en, this message translates to:
  /// **'Email and password'**
  String get authProviderLocal;

  /// No description provided for @authProviderGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get authProviderGoogle;

  /// No description provided for @invalidActivityId.
  ///
  /// In en, this message translates to:
  /// **'Invalid activity id'**
  String get invalidActivityId;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String helloUser(String name);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
