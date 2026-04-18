import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

import { TrainingPlanService } from '../../core/services/training-plan.service';
import { TrainingDay, TrainingPlan } from '../../core/types/training-plan.model';

@Component({
  selector: 'app-plan-list-view',
  standalone: false,
  templateUrl: './plan-list-view.component.html',
  styleUrls: ['./plan-list-view.component.scss']
})
export class PlanListViewComponent implements OnInit {
  plans: TrainingPlan[] = [];
  expandedPlanId: number | null = null;
  errorMessage = '';
  loading = true;

  constructor(
    private readonly trainingPlanService: TrainingPlanService,
    private readonly changeDetectorRef: ChangeDetectorRef,
    private readonly router: Router
  ) {}

  ngOnInit(): void {
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
      return 'Brak dystansu';
    }

    return `${(distanceMeters / 1000).toFixed(distanceMeters % 1000 === 0 ? 0 : 1)} km`;
  }

  formatDuration(durationSeconds?: number | null): string {
    if (!durationSeconds) {
      return 'Brak czasu';
    }

    const minutes = Math.round(durationSeconds / 60);
    return `${minutes} min`;
  }

  getStatusLabel(day: TrainingDay): string {
    switch (day.status) {
      case 'COMPLETED':
        return 'Wykonany';
      case 'PARTIALLY_COMPLETED':
        return 'Czesciowo wykonany';
      case 'MISSED':
        return 'Pominiety';
      default:
        return 'Zaplanowany';
    }
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

    const confirmed = window.confirm(`Czy na pewno chcesz usunac plan "${plan.name}"?`);
    if (!confirmed) {
      return;
    }

    this.trainingPlanService.deletePlan(plan.id).subscribe({
      next: () => {
        this.plans = this.plans.filter((candidate) => candidate.id !== plan.id);
        if (this.expandedPlanId === plan.id) {
          this.expandedPlanId = null;
        }
        this.errorMessage = '';
        this.changeDetectorRef.detectChanges();
      },
      error: () => {
        this.errorMessage = 'Nie udalo sie usunac planu';
        this.changeDetectorRef.detectChanges();
      }
    });
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
        this.errorMessage = 'Nie udalo sie pobrac planow';
        this.loading = false;
        this.changeDetectorRef.detectChanges();
      }
    });
  }

  private getPlanKey(plan: TrainingPlan): number {
    return plan.id ?? this.plans.indexOf(plan);
  }
}
