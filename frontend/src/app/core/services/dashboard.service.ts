import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { DashboardSummary } from '../types/dashboard.model';
import { API_BASE_URL } from './api-base';

@Injectable({ providedIn: 'root' })
export class DashboardService {
  constructor(private readonly http: HttpClient) {}

  getSummary(planId?: number): Observable<DashboardSummary> {
    const url = planId ? `${API_BASE_URL}/dashboard/summary?planId=${planId}` : `${API_BASE_URL}/dashboard/summary`;
    return this.http.get<DashboardSummary>(url);
  }
}
