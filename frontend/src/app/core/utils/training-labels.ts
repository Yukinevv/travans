import { strings as commonStrings } from '../misc/common-strings';
import { ActivityType, TrainingDayStatus } from '../types/training-plan.model';

const activityTypeLabels: Record<ActivityType, string> = commonStrings.training.activityTypes;

const trainingDayStatusLabels: Record<TrainingDayStatus, string> = commonStrings.training.dayStatuses;

export function getActivityTypeLabel(activityType: ActivityType | null | undefined): string {
  if (!activityType) {
    return commonStrings.metrics.none;
  }

  return activityTypeLabels[activityType] ?? activityType;
}

export function getTrainingDayStatusLabel(status: TrainingDayStatus | null | undefined): string {
  if (!status) {
    return commonStrings.metrics.none;
  }

  return trainingDayStatusLabels[status] ?? status;
}
