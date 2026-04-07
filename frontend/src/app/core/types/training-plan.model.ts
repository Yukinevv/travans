export type ActivityType = 'RUN' | 'RIDE' | 'SWIM' | 'WALK' | 'WORKOUT' | 'STRENGTH' | 'OTHER';
export type TrainingDayStatus = 'PLANNED' | 'COMPLETED' | 'PARTIALLY_COMPLETED' | 'MISSED';

export interface TrainingDay {
  id?: number;
  scheduledDate: string;
  title: string;
  activityType: ActivityType;
  plannedDistanceMeters?: number | null;
  plannedDurationSeconds?: number | null;
  notes?: string | null;
  status?: TrainingDayStatus;
  matchedActivityId?: number | null;
}

export interface TrainingPlan {
  id?: number;
  name: string;
  description?: string | null;
  startDate: string;
  createdAt?: string;
  trainingDays: TrainingDay[];
}
