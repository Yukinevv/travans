import { HttpErrorResponse } from '@angular/common/http';
import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Router } from '@angular/router';

import { CommonStrings, CommonStringsLoader } from '../../core/misc';
import { StravaService } from '../../core/services/strava.service';
import { ActivityType } from '../../core/types/training-plan.model';
import { StravaActivity, StravaConnectionStatus, StravaSyncResult } from '../../core/types/strava.model';
import { getActivityTypeLabel } from '../../core/utils/training-labels';
import { ModuleStrings, strings } from './strings';

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
  syncConfirmationOpen = false;
  selectedActivityType: ActivityType | '' = '';
  readonly commonStrings: CommonStrings = CommonStringsLoader.strings;
  readonly moduleStrings: ModuleStrings = strings;

  constructor(
    private readonly stravaService: StravaService,
    private readonly route: ActivatedRoute,
    private readonly router: Router,
    private readonly changeDetectorRef: ChangeDetectorRef
  ) {}

  get activityTypes(): Array<{ value: ActivityType | ''; label: string }> {
    return [
      { value: '', label: this.moduleStrings.filters.all },
      { value: 'RUN', label: this.commonStrings.training.activityTypes.RUN },
      { value: 'RIDE', label: this.commonStrings.training.activityTypes.RIDE },
      { value: 'SWIM', label: this.commonStrings.training.activityTypes.SWIM },
      { value: 'WALK', label: this.commonStrings.training.activityTypes.WALK },
      { value: 'WORKOUT', label: this.commonStrings.training.activityTypes.WORKOUT },
      { value: 'STRENGTH', label: this.moduleStrings.filters.strength },
      { value: 'OTHER', label: this.commonStrings.training.activityTypes.OTHER }
    ];
  }

  ngOnInit(): void {
    this.route.queryParamMap.subscribe((params) => {
      const code = params.get('code');
      const error = params.get('error');

      if (error) {
        this.errorMessage = this.moduleStrings.errors.connect;
        this.loading = false;
        this.changeDetectorRef.detectChanges();
        return;
      }

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
        this.errorMessage = this.resolveErrorMessage(error, this.moduleStrings.errors.sync);
        this.reconnectRequired = error.error?.code === 'STRAVA_RECONNECT_REQUIRED';
        if (this.reconnectRequired) {
          this.activities = [];
        }
        this.syncInProgress = false;
        this.changeDetectorRef.detectChanges();
      }
    });
  }

  openSyncConfirmation(): void {
    if (!this.status?.connected || !this.status.athleteId || this.reconnectRequired || this.syncInProgress) {
      return;
    }

    this.syncConfirmationOpen = true;
  }

  closeSyncConfirmation(): void {
    this.syncConfirmationOpen = false;
  }

  confirmSync(): void {
    if (!this.status?.athleteId) {
      this.syncConfirmationOpen = false;
      return;
    }

    this.syncConfirmationOpen = false;
    this.sync(this.status.athleteId);
  }

  onActivityTypeChange(value: string): void {
    this.selectedActivityType = value as ActivityType | '';
    this.loadActivities();
  }

  retryLoadStatus(): void {
    this.errorMessage = '';
    this.reconnectRequired = false;
    this.syncConfirmationOpen = false;
    this.loadStatus();
  }

  canConnectToStrava(): boolean {
    return !!this.status?.authorizationUrl;
  }

  trackByActivity(_: number, activity: StravaActivity): number {
    return activity.id;
  }

  openActivityDetails(activity: StravaActivity): void {
    this.syncConfirmationOpen = false;
    this.router.navigate(['/integrations/activities', activity.id]);
  }

  formatDistance(distanceMeters: number | null): string {
    if (!distanceMeters) {
      return this.commonStrings.metrics.none;
    }

    return `${(distanceMeters / 1000).toFixed(1)} km`;
  }

  formatDuration(movingTimeSeconds: number | null): string {
    if (!movingTimeSeconds) {
      return this.commonStrings.metrics.none;
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
        this.errorMessage = this.moduleStrings.errors.loadStatus;
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
        this.errorMessage = this.resolveErrorMessage(error, this.moduleStrings.errors.loadActivities);
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
