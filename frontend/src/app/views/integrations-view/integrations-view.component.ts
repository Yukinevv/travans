import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

import { StravaService } from '../../core/services/strava.service';
import { StravaConnectionStatus, StravaSyncResult } from '../../core/types/strava.model';

@Component({
  selector: 'app-integrations-view',
  standalone: false,
  templateUrl: './integrations-view.component.html',
  styleUrls: ['./integrations-view.component.scss']
})
export class IntegrationsViewComponent implements OnInit {
  status?: StravaConnectionStatus;
  syncResult?: StravaSyncResult;
  errorMessage = '';
  loading = true;

  constructor(
    private readonly stravaService: StravaService,
    private readonly route: ActivatedRoute,
    private readonly changeDetectorRef: ChangeDetectorRef
  ) {}

  ngOnInit(): void {
    this.route.queryParamMap.subscribe((params) => {
      const code = params.get('code');

      if (code) {
        this.stravaService.exchangeToken(code).subscribe(() => {
          this.loadStatus();
        });
        return;
      }

      this.loadStatus();
    });
  }

  sync(athleteId: number): void {
    this.stravaService.sync(athleteId).subscribe({
      next: (result) => {
        this.syncResult = result;
        this.errorMessage = '';
        this.loadStatus();
      },
      error: () => {
        this.errorMessage = 'Nie udalo sie zsynchronizowac danych ze Strava';
      }
    });
  }

  private loadStatus(): void {
    this.loading = true;
    this.stravaService.getStatus().subscribe({
      next: (status) => {
        this.status = status;
        this.errorMessage = '';
        this.loading = false;
        this.changeDetectorRef.detectChanges();
      },
      error: () => {
        this.errorMessage = 'Nie udalo sie pobrac statusu integracji';
        this.loading = false;
        this.changeDetectorRef.detectChanges();
      }
    });
  }
}
