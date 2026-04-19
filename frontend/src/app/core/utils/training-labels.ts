import { ActivityType, TrainingDayStatus } from '../types/training-plan.model';

const activityTypeLabels: Record<ActivityType, string> = {
  RUN: 'Bieg',
  RIDE: 'Rower',
  SWIM: 'Plywanie',
  WALK: 'Marsz',
  WORKOUT: 'Trening',
  STRENGTH: 'Silownia',
  OTHER: 'Inna aktywnosc'
};

const trainingDayStatusLabels: Record<TrainingDayStatus, string> = {
  PLANNED: 'Zaplanowany',
  COMPLETED: 'Wykonany',
  PARTIALLY_COMPLETED: 'Czesciowo wykonany',
  MISSED: 'Pominiety'
};

export function getActivityTypeLabel(activityType: ActivityType | null | undefined): string {
  if (!activityType) {
    return '-';
  }

  return activityTypeLabels[activityType] ?? activityType;
}

export function getTrainingDayStatusLabel(status: TrainingDayStatus | null | undefined): string {
  if (!status) {
    return '-';
  }

  return trainingDayStatusLabels[status] ?? status;
}
