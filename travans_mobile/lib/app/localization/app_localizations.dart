import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'strings/app_strings_en.dart';
import 'strings/app_strings_pl.dart';

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

  static const Map<String, Map<String, String>> _strings = {
    'pl': appStringsPl,
    'en': appStringsEn,
  };

  static AppLocalizations of(BuildContext context) {
    final localization = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    assert(localization != null, 'AppLocalizations not found in context');
    return localization!;
  }

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
