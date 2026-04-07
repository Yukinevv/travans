import { CommonModule } from '@angular/common';
import { Component, OnInit, inject } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

import { StravaConnectionStatus, StravaSyncResult } from '../models/strava.model';
import { StravaService } from '../services/strava.service';

@Component({
  selector: 'app-integrations-page',
  standalone: true,
  imports: [CommonModule],
  template: `
    <section class="page">
      <article class="panel" *ngIf="status">
        <p class="kicker">Strava</p>
        <h2>Polaczenie konta</h2>

        <div class="status-row">
          <strong [class.connected]="status.connected">
            {{ status.connected ? 'Polaczono' : 'Nie polaczono' }}
          </strong>
          <span *ngIf="status.athleteId">Athlete ID: {{ status.athleteId }}</span>
        </div>

        <div class="actions">
          <a class="button" [href]="status.authorizationUrl">Polacz ze Strava</a>
          <button *ngIf="status.connected && status.athleteId" type="button" (click)="sync(status.athleteId)">Synchronizuj</button>
        </div>

        <p class="muted" *ngIf="status.lastSyncAt">Ostatnia synchronizacja: {{ status.lastSyncAt }}</p>
      </article>

      <article class="panel" *ngIf="syncResult">
        <p class="kicker">Wynik</p>
        <h2>Ostatni sync</h2>
        <p>Zaimportowane aktywnosci: <strong>{{ syncResult.importedActivities }}</strong></p>
        <p>Dopasowane dni planu: <strong>{{ syncResult.matchedTrainingDays }}</strong></p>
      </article>
    </section>
  `,
  styles: [`
    .page {
      display: grid;
      gap: 24px;
    }

    .panel {
      border: 1px solid var(--border);
      background: var(--surface);
      border-radius: 24px;
      padding: 24px;
      box-shadow: var(--shadow);
    }

    .kicker {
      margin: 0;
      text-transform: uppercase;
      letter-spacing: 0.12em;
      color: var(--accent-dark);
      font-size: 0.75rem;
      font-weight: 700;
    }

    h2 {
      margin: 8px 0 20px;
    }

    .status-row {
      display: flex;
      gap: 16px;
      align-items: center;
      flex-wrap: wrap;
    }

    .connected {
      color: var(--success);
    }

    .muted {
      color: var(--muted);
    }

    .actions {
      display: flex;
      gap: 12px;
      margin: 20px 0;
    }

    .button,
    button {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      border: 0;
      border-radius: 999px;
      padding: 12px 18px;
      background: var(--accent);
      color: white;
      text-decoration: none;
      cursor: pointer;
    }
  `]
})
export class IntegrationsPageComponent implements OnInit {
  private readonly stravaService = inject(StravaService);
  private readonly route = inject(ActivatedRoute);

  status?: StravaConnectionStatus;
  syncResult?: StravaSyncResult;

  ngOnInit(): void {
    this.route.queryParamMap.subscribe((params) => {
      const code = params.get('code');
      if (code) {
        this.stravaService.exchangeToken(code).subscribe(() => this.loadStatus());
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
