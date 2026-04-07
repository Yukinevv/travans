import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';

import { DashboardSummary } from '../models/dashboard.model';
import { API_BASE_URL } from './api-base';

@Injectable({ providedIn: 'root' })
export class DashboardService {
  private readonly http = inject(HttpClient);

  getSummary(planId?: number): Observable<DashboardSummary> {
    const url = planId ? `${API_BASE_URL}/dashboard/summary?planId=${planId}` : `${API_BASE_URL}/dashboard/summary`;
    return this.http.get<DashboardSummary>(url);
  }
}
