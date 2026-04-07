import { TrainingDay } from './training-plan.model';

export interface DashboardSummary {
  totalPlanned: number;
  completed: number;
  partiallyCompleted: number;
  missed: number;
  completionRate: number;
  currentPlanId: number | null;
  currentPlanName: string | null;
  trainingDays: TrainingDay[];
}
