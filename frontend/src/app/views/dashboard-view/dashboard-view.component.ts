import { ChangeDetectorRef, Component, OnInit } from '@angular/core';

import { DashboardSummary } from '../../core/types/dashboard.model';
import { DashboardService } from '../../core/services/dashboard.service';

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
}
