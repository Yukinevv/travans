import { ChangeDetectorRef, Component, OnInit } from '@angular/core';

import { CommonStrings, CommonStringsLoader } from '../../core/misc';
import { CurrentPlanService } from '../../core/services/current-plan.service';
import { DashboardSummary } from '../../core/types/dashboard.model';
import { DashboardService } from '../../core/services/dashboard.service';
import { ActivityType, TrainingDay, TrainingPlan } from '../../core/types/training-plan.model';
import { TrainingPlanService } from '../../core/services/training-plan.service';
import { getActivityTypeLabel, getTrainingDayStatusLabel } from '../../core/utils/training-labels';
import { ModuleStrings, strings } from './strings';

@Component({
  selector: 'app-dashboard-view',
  standalone: false,
  templateUrl: './dashboard-view.component.html',
  styleUrls: ['./dashboard-view.component.scss']
})
export class DashboardViewComponent implements OnInit {
  plans: TrainingPlan[] = [];
  summary?: DashboardSummary;
  selectedPlanId: number | null = null;
  expandedDayId: number | string | null = null;
  animatedCompletionRate = 0;
  errorMessage = '';
  loading = true;
  loadingPlans = true;
  readonly commonStrings: CommonStrings = CommonStringsLoader.strings;
  readonly moduleStrings: ModuleStrings = strings;

  constructor(
    private readonly dashboardService: DashboardService,
    private readonly trainingPlanService: TrainingPlanService,
    private readonly currentPlanService: CurrentPlanService,
    private readonly changeDetectorRef: ChangeDetectorRef
  ) {}

  ngOnInit(): void {
    this.trainingPlanService.getPlans().subscribe({
      next: (plans) => {
        this.plans = plans;
        this.loadingPlans = false;

        const storedPlanId = this.currentPlanService.getSelectedPlanId();
        const hasStoredPlan = storedPlanId !== null && this.plans.some((plan) => plan.id === storedPlanId);
        this.selectedPlanId = hasStoredPlan ? storedPlanId : null;

        if (storedPlanId !== this.selectedPlanId) {
          this.currentPlanService.setSelectedPlanId(this.selectedPlanId);
        }

        this.loadSummary(this.selectedPlanId);
      },
      error: () => {
        this.errorMessage = this.moduleStrings.errors.loadPlans;
        this.loading = false;
        this.loadingPlans = false;
        this.changeDetectorRef.detectChanges();
      }
    });
  }

  onSelectedPlanChange(value: string): void {
    const nextPlanId = value ? Number(value) : null;
    this.selectedPlanId = Number.isFinite(nextPlanId) ? nextPlanId : null;
    this.currentPlanService.setSelectedPlanId(this.selectedPlanId);
    this.loadSummary(this.selectedPlanId);
  }

  trackByDay(_: number, day: TrainingDay): number | string {
    return day.id ?? `${day.scheduledDate}-${day.title}`;
  }

  toggleDayDetails(day: TrainingDay): void {
    const dayKey = this.trackByDay(0, day);
    this.expandedDayId = this.expandedDayId === dayKey ? null : dayKey;
  }

  onDayCardKeydown(event: KeyboardEvent, day: TrainingDay): void {
    if (event.key !== 'Enter' && event.key !== ' ') {
      return;
    }

    event.preventDefault();
    this.toggleDayDetails(day);
  }

  isDayExpanded(day: TrainingDay): boolean {
    return this.expandedDayId === this.trackByDay(0, day);
  }

  getDayDetailsToggleLabel(day: TrainingDay): string {
    return this.isDayExpanded(day)
      ? this.moduleStrings.details.hideDetails
      : this.moduleStrings.details.showDetails;
  }

  getActivityTypeLabel(activityType: TrainingDay['activityType']): string {
    return getActivityTypeLabel(activityType);
  }

  getTrainingDayStatusLabel(status: TrainingDay['status']): string {
    return getTrainingDayStatusLabel(status);
  }

  hasCurrentPlan(): boolean {
    return !!this.summary?.currentPlanId;
  }

  isPlanType(...planTypes: ActivityType[]): boolean {
    const currentPlanType = this.summary?.currentPlanType;
    return !!currentPlanType && planTypes.includes(currentPlanType);
  }

  formatDistance(distanceMeters: number | null | undefined): string {
    if (!distanceMeters) {
      return this.commonStrings.metrics.none;
    }
    return `${(distanceMeters / 1000).toFixed(1)} km`;
  }

  formatDuration(seconds: number | null | undefined): string {
    if (!seconds) {
      return this.commonStrings.metrics.none;
    }

    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);

    if (hours > 0) {
      return `${hours}h ${minutes}m`;
    }

    return `${minutes} min`;
  }

  formatSpeed(speedKph: number | null | undefined): string {
    if (!speedKph) {
      return this.commonStrings.metrics.none;
    }

    return `${speedKph.toFixed(1)} km/h`;
  }

  formatPace(secondsPerKm: number | null | undefined): string {
    if (!secondsPerKm) {
      return this.commonStrings.metrics.none;
    }

    const minutes = Math.floor(secondsPerKm / 60);
    const seconds = Math.round(secondsPerKm % 60);
    return `${minutes}:${String(seconds).padStart(2, '0')} min/km`;
  }

  getStatusLabel(value: boolean | null | undefined): string {
    if (value === null || value === undefined) {
      return this.commonStrings.metrics.noCriteria;
    }

    return value ? this.commonStrings.states.achieved : this.commonStrings.states.notAchieved;
  }

  private loadSummary(planId: number | null): void {
    this.loading = true;
    this.animatedCompletionRate = 0;
    this.dashboardService.getSummary(planId ?? undefined).subscribe({
      next: (summary) => {
        this.summary = summary;
        this.expandedDayId = null;
        this.errorMessage = '';
        this.loading = false;

        if (summary.currentPlanId !== this.selectedPlanId) {
          this.selectedPlanId = summary.currentPlanId;
          this.currentPlanService.setSelectedPlanId(summary.currentPlanId);
        }

        this.changeDetectorRef.detectChanges();
        requestAnimationFrame(() => {
          requestAnimationFrame(() => {
            this.animatedCompletionRate = summary.completionRate;
            this.changeDetectorRef.detectChanges();
          });
        });
      },
      error: () => {
        this.errorMessage = this.moduleStrings.errors.loadSummary;
        this.loading = false;
        this.changeDetectorRef.detectChanges();
      }
    });
  }
}
