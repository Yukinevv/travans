import { ChangeDetectorRef, Component, OnInit } from '@angular/core';

import { DashboardSummary } from '../../core/types/dashboard.model';
import { DashboardService } from '../../core/services/dashboard.service';
import { TrainingDay } from '../../core/types/training-plan.model';

@Component({
  selector: 'app-dashboard-view',
  standalone: false,
  templateUrl: './dashboard-view.component.html',
  styleUrls: ['./dashboard-view.component.scss']
})
export class DashboardViewComponent implements OnInit {
  summary?: DashboardSummary;
  errorMessage = '';
  loading = true;

  constructor(
    private readonly dashboardService: DashboardService,
    private readonly changeDetectorRef: ChangeDetectorRef
  ) {}

  ngOnInit(): void {
    this.dashboardService.getSummary().subscribe({
      next: (summary) => {
        this.summary = summary;
        this.errorMessage = '';
        this.loading = false;
        this.changeDetectorRef.detectChanges();
      },
      error: () => {
        this.errorMessage = 'Nie udalo sie pobrac danych dashboardu';
        this.loading = false;
        this.changeDetectorRef.detectChanges();
      }
    });
  }

  trackByDay(_: number, day: TrainingDay): number | string {
    return day.id ?? `${day.scheduledDate}-${day.title}`;
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
}
