import { strings as commonStrings } from '../misc/common-strings';
import { ActivityType, TrainingDayStatus } from '../types/training-plan.model';

export function getActivityTypeLabel(activityType: ActivityType | null | undefined): string {
  if (!activityType) {
    return commonStrings.metrics.none;
  }

  return commonStrings.training.activityTypes[activityType] ?? activityType;
}

export function getTrainingDayStatusLabel(status: TrainingDayStatus | null | undefined): string {
  if (!status) {
    return commonStrings.metrics.none;
  }

  return commonStrings.training.dayStatuses[status] ?? status;
}
