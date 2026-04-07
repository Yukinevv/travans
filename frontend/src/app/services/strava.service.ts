import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';

import { StravaConnectionStatus, StravaSyncResult } from '../models/strava.model';
import { API_BASE_URL } from './api-base';

@Injectable({ providedIn: 'root' })
export class StravaService {
  private readonly http = inject(HttpClient);

  getStatus(): Observable<StravaConnectionStatus> {
    return this.http.get<StravaConnectionStatus>(`${API_BASE_URL}/integrations/strava/status`);
  }

  exchangeToken(code: string): Observable<void> {
    return this.http.post<void>(`${API_BASE_URL}/integrations/strava/exchange-token?code=${encodeURIComponent(code)}`, {});
  }

  sync(athleteId: number): Observable<StravaSyncResult> {
    return this.http.patch<StravaSyncResult>(`${API_BASE_URL}/integrations/strava/sync?athleteId=${athleteId}`, {});
  }
}
