import { ChangeDetectorRef, Component, OnInit } from '@angular/core';

import { CurrentPlanService } from '../../core/services/current-plan.service';
import { DashboardSummary } from '../../core/types/dashboard.model';
import { DashboardService } from '../../core/services/dashboard.service';
import { TrainingDay, TrainingPlan } from '../../core/types/training-plan.model';
import { TrainingPlanService } from '../../core/services/training-plan.service';
import { getActivityTypeLabel, getTrainingDayStatusLabel } from '../../core/utils/training-labels';

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
  errorMessage = '';
  loading = true;
  loadingPlans = true;

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
        this.errorMessage = 'Nie udalo sie pobrac listy planow';
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

  isDayExpanded(day: TrainingDay): boolean {
    return this.expandedDayId === this.trackByDay(0, day);
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

  formatDistance(distanceMeters: number | null | undefined): string {
    if (!distanceMeters) {
      return '-';
    }
    return `${(distanceMeters / 1000).toFixed(1)} km`;
  }

  formatDuration(seconds: number | null | undefined): string {
    if (!seconds) {
      return '-';
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
      return '-';
    }

    return `${speedKph.toFixed(1)} km/h`;
  }

  formatPace(secondsPerKm: number | null | undefined): string {
    if (!secondsPerKm) {
      return '-';
    }

    const minutes = Math.floor(secondsPerKm / 60);
    const seconds = Math.round(secondsPerKm % 60);
    return `${minutes}:${String(seconds).padStart(2, '0')} min/km`;
  }

  getStatusLabel(value: boolean | null | undefined): string {
    if (value === null || value === undefined) {
      return 'Brak kryterium';
    }

    return value ? 'Osiagniete' : 'Nieosigniete';
  }

  private loadSummary(planId: number | null): void {
    this.loading = true;
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
      },
      error: () => {
        this.errorMessage = 'Nie udalo sie pobrac danych dashboardu';
        this.loading = false;
        this.changeDetectorRef.detectChanges();
      }
    });
  }
}
