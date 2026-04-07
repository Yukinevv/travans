import { ActivityType } from './training-plan.model';

export interface StravaConnectionStatus {
  connected: boolean;
  athleteId: number | null;
  lastSyncAt: string | null;
  authorizationUrl: string;
}

export interface StravaSyncResult {
  athleteId: number;
  importedActivities: number;
  matchedTrainingDays: number;
}

export interface StravaActivity {
  id: number;
  externalActivityId: number;
  name: string;
  activityType: ActivityType;
  activityDate: string;
  startedAt: string;
  distanceMeters: number | null;
  movingTimeSeconds: number | null;
  matchedToPlan: boolean;
  matchedTrainingDayId: number | null;
  matchedTrainingDayTitle: string | null;
  matchedPlanId: number | null;
  matchedPlanName: string | null;
}
