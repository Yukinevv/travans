import { TrainingDay } from './training-plan.model';

export interface DashboardDetailedStats {
  daysMeetingDistanceGoal: number;
  daysMeetingDurationGoal: number;
  daysMeetingPaceGoal: number;
  daysWithExtraDistance: number;
  daysWithTimeSaved: number;
  totalDistanceOverMeters: number;
  totalDurationOverSeconds: number;
  totalTimeSavedSeconds: number;
}

export interface DashboardSummary {
  totalPlanned: number;
  completed: number;
  partiallyCompleted: number;
  missed: number;
  completionRate: number;
  currentPlanId: number | null;
  currentPlanName: string | null;
  trainingDays: TrainingDay[];
  detailedStats: DashboardDetailedStats;
}
