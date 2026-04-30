import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { DashboardSummary } from '../types/dashboard.model';
import { API_ENDPOINTS } from './api-endpoints';

@Injectable({ providedIn: 'root' })
export class DashboardService {
  constructor(private readonly http: HttpClient) {}

  getSummary(planId?: number): Observable<DashboardSummary> {
    const url = planId
      ? `${API_ENDPOINTS.dashboard.summary}?planId=${planId}`
      : API_ENDPOINTS.dashboard.summary;
    return this.http.get<DashboardSummary>(url);
  }
}
