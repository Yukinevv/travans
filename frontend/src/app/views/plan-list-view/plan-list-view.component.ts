import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

import { CommonStrings, CommonStringsLoader } from '../../core/misc';
import { CurrentPlanService } from '../../core/services/current-plan.service';
import { TrainingPlanService } from '../../core/services/training-plan.service';
import { TrainingDay, TrainingPlan } from '../../core/types/training-plan.model';
import { getActivityTypeLabel, getTrainingDayStatusLabel } from '../../core/utils/training-labels';
import { ModuleStrings, strings } from './strings';

@Component({
  selector: 'app-plan-list-view',
  standalone: false,
  templateUrl: './plan-list-view.component.html',
  styleUrls: ['./plan-list-view.component.scss']
})
export class PlanListViewComponent implements OnInit {
  plans: TrainingPlan[] = [];
  expandedPlanId: number | null = null;
  selectedDashboardPlanId: number | null = null;
  errorMessage = '';
  loading = true;
  readonly commonStrings: CommonStrings = CommonStringsLoader.strings;
  readonly moduleStrings: ModuleStrings = strings;

  constructor(
    private readonly trainingPlanService: TrainingPlanService,
    private readonly changeDetectorRef: ChangeDetectorRef,
    private readonly currentPlanService: CurrentPlanService,
    private readonly router: Router
  ) {}

  ngOnInit(): void {
    this.selectedDashboardPlanId = this.currentPlanService.getSelectedPlanId();
    this.loadPlans();
  }

  togglePlan(plan: TrainingPlan): void {
    const planKey = this.getPlanKey(plan);
    this.expandedPlanId = this.expandedPlanId === planKey ? null : planKey;
  }

  isExpanded(plan: TrainingPlan): boolean {
    return this.expandedPlanId === this.getPlanKey(plan);
  }

  formatDistance(distanceMeters?: number | null): string {
    if (!distanceMeters) {
      return this.commonStrings.metrics.noDistance;
    }

    return `${(distanceMeters / 1000).toFixed(distanceMeters % 1000 === 0 ? 0 : 1)} km`;
  }

  formatDuration(durationSeconds?: number | null): string {
    if (!durationSeconds) {
      return this.commonStrings.metrics.noDuration;
    }

    const minutes = Math.round(durationSeconds / 60);
    return `${minutes} min`;
  }

  getStatusLabel(day: TrainingDay): string {
    return getTrainingDayStatusLabel(day.status);
  }

  getActivityTypeLabel(activityType: TrainingDay['activityType']): string {
    return getActivityTypeLabel(activityType);
  }

  editPlan(plan: TrainingPlan, event: Event): void {
    event.stopPropagation();
    if (!plan.id) {
      return;
    }

    this.router.navigate(['/plans', plan.id, 'edit']);
  }

  deletePlan(plan: TrainingPlan, event: Event): void {
    event.stopPropagation();
    if (!plan.id) {
      return;
    }

    const confirmed = window.confirm(this.moduleStrings.plan.deleteConfirmation.replace('%s', plan.name));
    if (!confirmed) {
      return;
    }

    this.trainingPlanService.deletePlan(plan.id).subscribe({
      next: () => {
        this.plans = this.plans.filter((candidate) => candidate.id !== plan.id);
        if (this.expandedPlanId === plan.id) {
          this.expandedPlanId = null;
        }
        if (this.selectedDashboardPlanId === plan.id) {
          this.selectedDashboardPlanId = null;
          this.currentPlanService.setSelectedPlanId(null);
        }
        this.errorMessage = '';
        this.changeDetectorRef.detectChanges();
      },
      error: () => {
        this.errorMessage = this.moduleStrings.errors.deletePlan;
        this.changeDetectorRef.detectChanges();
      }
    });
  }

  showOnDashboard(plan: TrainingPlan, event: Event): void {
    event.stopPropagation();
    if (!plan.id) {
      return;
    }

    this.selectedDashboardPlanId = plan.id;
    this.currentPlanService.setSelectedPlanId(plan.id);
    this.router.navigate(['/']);
  }

  isSelectedForDashboard(plan: TrainingPlan): boolean {
    return !!plan.id && this.selectedDashboardPlanId === plan.id;
  }

  private loadPlans(): void {
    this.loading = true;
    this.trainingPlanService.getPlans().subscribe({
      next: (plans) => {
        this.plans = plans;
        this.errorMessage = '';
        this.loading = false;
        this.changeDetectorRef.detectChanges();
      },
      error: () => {
        this.errorMessage = this.moduleStrings.errors.loadPlans;
        this.loading = false;
        this.changeDetectorRef.detectChanges();
      }
    });
  }

  private getPlanKey(plan: TrainingPlan): number {
    return plan.id ?? this.plans.indexOf(plan);
  }
}
