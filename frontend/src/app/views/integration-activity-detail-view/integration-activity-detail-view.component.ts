import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';

import { StravaService } from '../../core/services/strava.service';
import { StravaActivity } from '../../core/types/strava.model';
import { getActivityTypeLabel } from '../../core/utils/training-labels';

@Component({
  selector: 'app-integration-activity-detail-view',
  standalone: false,
  templateUrl: './integration-activity-detail-view.component.html',
  styleUrls: ['./integration-activity-detail-view.component.scss']
})
export class IntegrationActivityDetailViewComponent implements OnInit {
  activity?: StravaActivity;
  loading = true;
  errorMessage = '';

  constructor(
    private readonly route: ActivatedRoute,
    private readonly router: Router,
    private readonly stravaService: StravaService,
    private readonly changeDetectorRef: ChangeDetectorRef
  ) {}

  ngOnInit(): void {
    const activityId = Number(this.route.snapshot.paramMap.get('activityId'));
    if (!activityId) {
      this.errorMessage = 'Nie znaleziono identyfikatora aktywnosci';
      this.loading = false;
      return;
    }

    this.stravaService.getActivity(activityId).subscribe({
      next: (activity) => {
        this.activity = activity;
        this.loading = false;
        this.errorMessage = '';
        this.changeDetectorRef.detectChanges();
      },
      error: () => {
        this.errorMessage = 'Nie udalo sie pobrac szczegolow aktywnosci';
        this.loading = false;
        this.changeDetectorRef.detectChanges();
      }
    });
  }

  backToIntegrations(): void {
    this.router.navigate(['/integrations']);
  }

  formatDistance(distanceMeters: number | null): string {
    if (!distanceMeters) {
      return '-';
    }

    return `${(distanceMeters / 1000).toFixed(1)} km`;
  }

  formatDuration(movingTimeSeconds: number | null): string {
    if (!movingTimeSeconds) {
      return '-';
    }

    const totalMinutes = Math.round(movingTimeSeconds / 60);
    if (totalMinutes >= 60) {
      const hours = Math.floor(totalMinutes / 60);
      const minutes = totalMinutes % 60;
      return minutes > 0 ? `${hours} h ${minutes} min` : `${hours} h`;
    }

    return `${totalMinutes} min`;
  }

  getActivityTypeLabel(activityType: StravaActivity['activityType']): string {
    return getActivityTypeLabel(activityType);
  }
}
