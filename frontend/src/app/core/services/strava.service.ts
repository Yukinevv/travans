import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { StravaConnectionStatus, StravaSyncResult } from '../types/strava.model';
import { API_BASE_URL } from './api-base';

@Injectable({ providedIn: 'root' })
export class StravaService {
  constructor(private readonly http: HttpClient) {}

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
