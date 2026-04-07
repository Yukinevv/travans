import { CommonModule, DecimalPipe } from '@angular/common';
import { Component, OnInit, inject } from '@angular/core';

import { DashboardSummary } from '../models/dashboard.model';
import { DashboardService } from '../services/dashboard.service';

@Component({
  selector: 'app-dashboard-page',
  standalone: true,
  imports: [CommonModule, DecimalPipe],
  template: `
    <section class="page">
      <header class="header">
        <div>
          <p class="kicker">Dashboard</p>
          <h2>Postep realizacji planu</h2>
        </div>
      </header>

      <div class="stats" *ngIf="summary">
        <article class="card">
          <span>Zaplanowane</span>
          <strong>{{ summary.totalPlanned }}</strong>
        </article>
        <article class="card success">
          <span>Wykonane</span>
          <strong>{{ summary.completed }}</strong>
        </article>
        <article class="card warn">
          <span>Czesciowo</span>
          <strong>{{ summary.partiallyCompleted }}</strong>
        </article>
        <article class="card danger">
          <span>Pominiete</span>
          <strong>{{ summary.missed }}</strong>
        </article>
      </div>

      <article class="panel" *ngIf="summary">
        <p class="panel-label">Skutecznosc</p>
        <div class="progress-row">
          <strong>{{ summary.completionRate | number:'1.0-1' }}%</strong>
          <div class="progress-track">
            <div class="progress-bar" [style.width.%]="summary.completionRate"></div>
          </div>
        </div>
      </article>
    </section>
  `,
  styles: [`
    .page {
      display: grid;
      gap: 24px;
    }

    .header h2 {
      margin: 6px 0 0;
      font-size: 2rem;
    }

    .kicker,
    .panel-label {
      margin: 0;
      text-transform: uppercase;
      letter-spacing: 0.12em;
      color: var(--accent-dark);
      font-size: 0.75rem;
      font-weight: 700;
    }

    .stats {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap: 16px;
    }

    .card,
    .panel {
      border: 1px solid var(--border);
      background: var(--surface);
      border-radius: 24px;
      padding: 24px;
      box-shadow: var(--shadow);
    }

    .card strong {
      display: block;
      margin-top: 12px;
      font-size: 2.2rem;
    }

    .success strong { color: var(--success); }
    .warn strong { color: var(--warn); }
    .danger strong { color: var(--danger); }

    .progress-row {
      display: grid;
      gap: 16px;
      margin-top: 16px;
    }

    .progress-track {
      height: 16px;
      border-radius: 999px;
      background: rgba(31, 28, 23, 0.08);
      overflow: hidden;
    }

    .progress-bar {
      height: 100%;
      background: linear-gradient(90deg, var(--accent) 0%, #de8a3e 100%);
    }

    @media (max-width: 960px) {
      .stats {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }
    }

    @media (max-width: 640px) {
      .stats {
        grid-template-columns: 1fr;
      }
    }
  `]
})
export class DashboardPageComponent implements OnInit {
  private readonly dashboardService = inject(DashboardService);

  summary?: DashboardSummary;

  ngOnInit(): void {
    this.dashboardService.getSummary().subscribe((summary) => {
      this.summary = summary;
    });
  }
}
