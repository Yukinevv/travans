import { Component, OnInit } from '@angular/core';
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

  constructor(
    private readonly stravaService: StravaService,
    private readonly route: ActivatedRoute
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
    this.stravaService.sync(athleteId).subscribe((result) => {
      this.syncResult = result;
      this.loadStatus();
    });
  }

  private loadStatus(): void {
    this.stravaService.getStatus().subscribe((status) => {
      this.status = status;
    });
  }
}
