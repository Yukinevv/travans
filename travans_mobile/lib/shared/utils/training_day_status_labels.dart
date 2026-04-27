import 'package:flutter/widgets.dart';

import '../../app/localization/app_localizations.dart';
import '../models/training_day_status.dart';

String trainingDayStatusLabel(BuildContext context, TrainingDayStatus status) {
  final l10n = AppLocalizations.of(context);

  switch (status) {
    case TrainingDayStatus.planned:
      return l10n.trainingStatusPlanned;
    case TrainingDayStatus.completed:
      return l10n.trainingStatusCompleted;
    case TrainingDayStatus.partiallyCompleted:
      return l10n.trainingStatusPartial;
    case TrainingDayStatus.missed:
      return l10n.trainingStatusMissed;
  }
}
