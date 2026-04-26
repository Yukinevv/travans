import 'package:flutter/widgets.dart';

import '../../app/localization/app_localizations.dart';
import '../models/activity_type.dart';

String activityTypeLabel(BuildContext context, ActivityType type) {
  final l10n = AppLocalizations.of(context);

  switch (type) {
    case ActivityType.run:
      return l10n.activityRun;
    case ActivityType.ride:
      return l10n.activityRide;
    case ActivityType.swim:
      return l10n.activitySwim;
    case ActivityType.walk:
      return l10n.activityWalk;
    case ActivityType.workout:
      return l10n.activityWorkout;
    case ActivityType.strength:
      return l10n.activityStrength;
    case ActivityType.other:
      return l10n.activityOther;
  }
}
