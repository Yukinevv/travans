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
