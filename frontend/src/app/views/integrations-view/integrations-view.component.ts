import { HttpErrorResponse } from '@angular/common/http';
import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ActivatedRoute } from '@angular/router';

import { StravaService } from '../../core/services/strava.service';
import { ActivityType } from '../../core/types/training-plan.model';
import { StravaActivity, StravaConnectionStatus, StravaSyncResult } from '../../core/types/strava.model';
import { getActivityTypeLabel } from '../../core/utils/training-labels';

@Component({
  selector: 'app-integrations-view',
  standalone: false,
  templateUrl: './integrations-view.component.html',
  styleUrls: ['./integrations-view.component.scss']
})
export class IntegrationsViewComponent implements OnInit {
  status?: StravaConnectionStatus;
  syncResult?: StravaSyncResult;
  activities: StravaActivity[] = [];
  errorMessage = '';
  reconnectRequired = false;
  loading = true;
  activitiesLoading = false;
  syncInProgress = false;
  selectedActivityType: ActivityType | '' = '';
  readonly activityTypes: Array<{ value: ActivityType | ''; label: string }> = [
    { value: '', label: 'Wszystkie' },
    { value: 'RUN', label: 'Bieganie' },
    { value: 'RIDE', label: 'Rower' },
    { value: 'SWIM', label: 'Plywanie' },
    { value: 'WALK', label: 'Marsz' },
    { value: 'WORKOUT', label: 'Trening' },
    { value: 'STRENGTH', label: 'Silownia' },
    { value: 'OTHER', label: 'Inne' }
  ];

  constructor(
    private readonly stravaService: StravaService,
    private readonly route: ActivatedRoute,
    private readonly router: Router,
    private readonly changeDetectorRef: ChangeDetectorRef
  ) {}

  ngOnInit(): void {
    this.route.queryParamMap.subscribe((params) => {
      const code = params.get('code');

      if (code) {
        this.stravaService.exchangeToken(code).subscribe(() => {
          this.loadStatus(true);
        });
        return;
      }

      this.loadStatus();
    });
  }

  sync(athleteId: number): void {
    this.syncInProgress = true;
    this.stravaService.sync(athleteId).subscribe({
      next: (result) => {
        this.syncResult = result;
        this.errorMessage = '';
        this.reconnectRequired = false;
        this.syncInProgress = false;
        this.loadStatus();
        this.loadActivities(true);
      },
      error: (error: HttpErrorResponse) => {
        this.errorMessage = this.resolveErrorMessage(error, 'Nie udalo sie zsynchronizowac danych ze Strava');
        this.reconnectRequired = error.error?.code === 'STRAVA_RECONNECT_REQUIRED';
        if (this.reconnectRequired) {
          this.activities = [];
        }
        this.syncInProgress = false;
        this.changeDetectorRef.detectChanges();
      }
    });
  }

  onActivityTypeChange(value: string): void {
    this.selectedActivityType = value as ActivityType | '';
    this.loadActivities();
  }

  retryLoadStatus(): void {
    this.errorMessage = '';
    this.reconnectRequired = false;
    this.loadStatus();
  }

  canConnectToStrava(): boolean {
    return !!this.status?.authorizationUrl;
  }

  trackByActivity(_: number, activity: StravaActivity): number {
    return activity.id;
  }

  openActivityDetails(activity: StravaActivity): void {
    this.router.navigate(['/integrations/activities', activity.id]);
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

  getActivityTypeLabel(activityType: ActivityType): string {
    return getActivityTypeLabel(activityType);
  }

  private loadStatus(autoSyncAfterConnect = false): void {
    this.loading = true;
    this.stravaService.getStatus().subscribe({
      next: (status) => {
        this.status = status;
        this.errorMessage = '';
        this.reconnectRequired = false;
        this.loading = false;
        if (status.connected) {
          if (autoSyncAfterConnect && status.athleteId) {
            this.sync(status.athleteId);
          }
          this.loadActivities(autoSyncAfterConnect);
        } else {
          this.activities = [];
        }
        this.changeDetectorRef.detectChanges();
      },
      error: () => {
        this.status = {
          connected: false,
          athleteId: null,
          lastSyncAt: null,
          authorizationUrl: ''
        };
        this.activities = [];
        this.errorMessage = 'Nie udalo sie pobrac statusu integracji';
        this.loading = false;
        this.changeDetectorRef.detectChanges();
      }
    });
  }

  private loadActivities(forceRefresh = false): void {
    if (!this.status?.connected) {
      this.activities = [];
      return;
    }

    this.activitiesLoading = true;
    this.stravaService.getActivities(this.selectedActivityType, forceRefresh).subscribe({
      next: (activities) => {
        this.activities = activities;
        this.activitiesLoading = false;
        this.changeDetectorRef.detectChanges();
      },
      error: (error: HttpErrorResponse) => {
        this.errorMessage = this.resolveErrorMessage(error, 'Nie udalo sie pobrac aktywnosci ze Stravy');
        this.reconnectRequired = error.error?.code === 'STRAVA_RECONNECT_REQUIRED';
        if (this.reconnectRequired) {
          this.activities = [];
        }
        this.activitiesLoading = false;
        this.changeDetectorRef.detectChanges();
      }
    });
  }

  private resolveErrorMessage(error: HttpErrorResponse, fallback: string): string {
    const message = error.error?.message;
    return typeof message === 'string' && message.trim() ? message : fallback;
  }
}
