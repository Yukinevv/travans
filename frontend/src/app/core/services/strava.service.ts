import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, of, tap } from 'rxjs';

import { ActivityType } from '../types/training-plan.model';
import { StravaActivity, StravaConnectionStatus, StravaSyncResult } from '../types/strava.model';
import { API_ENDPOINTS } from './api-endpoints';

@Injectable({ providedIn: 'root' })
export class StravaService {
  private readonly activitiesCachePrefix = 'travans_strava_activities_';
  private readonly activityDetailCachePrefix = 'travans_strava_activity_detail_';
  private readonly activitiesCache = new Map<string, StravaActivity[]>();
  private readonly activityDetailsCache = new Map<number, StravaActivity>();

  constructor(private readonly http: HttpClient) {}

  getStatus(): Observable<StravaConnectionStatus> {
    return this.http.get<StravaConnectionStatus>(`${API_ENDPOINTS.strava.status}?platform=web`);
  }

  getActivities(activityType?: ActivityType | '', forceRefresh = false): Observable<StravaActivity[]> {
    const cacheKey = activityType || 'ALL';
    if (!forceRefresh) {
      const inMemory = this.activitiesCache.get(cacheKey);
      if (inMemory) {
        return of(inMemory);
      }

      const stored = sessionStorage.getItem(this.activitiesStorageKey(cacheKey));
      if (stored) {
        const activities = JSON.parse(stored) as StravaActivity[];
        this.activitiesCache.set(cacheKey, activities);
        return of(activities);
      }
    }

    const suffix = activityType ? `?activityType=${activityType}` : '';
    return this.http.get<StravaActivity[]>(`${API_ENDPOINTS.strava.activities}${suffix}`).pipe(
      tap((activities) => {
        this.activitiesCache.set(cacheKey, activities);
        sessionStorage.setItem(this.activitiesStorageKey(cacheKey), JSON.stringify(activities));
      })
    );
  }

  getActivity(activityId: number, forceRefresh = false): Observable<StravaActivity> {
    if (!forceRefresh) {
      const inMemory = this.activityDetailsCache.get(activityId);
      if (inMemory) {
        return of(inMemory);
      }

      const stored = sessionStorage.getItem(this.activityDetailStorageKey(activityId));
      if (stored) {
        const activity = JSON.parse(stored) as StravaActivity;
        this.activityDetailsCache.set(activityId, activity);
        return of(activity);
      }
    }

    return this.http.get<StravaActivity>(API_ENDPOINTS.strava.activityDetail(activityId)).pipe(
      tap((activity) => {
        this.activityDetailsCache.set(activityId, activity);
        sessionStorage.setItem(this.activityDetailStorageKey(activityId), JSON.stringify(activity));
      })
    );
  }

  exchangeToken(code: string): Observable<void> {
    return this.http.post<void>(`${API_ENDPOINTS.strava.exchangeToken}?code=${encodeURIComponent(code)}`, {});
  }

  sync(athleteId: number): Observable<StravaSyncResult> {
    return this.http.patch<StravaSyncResult>(`${API_ENDPOINTS.strava.sync}?athleteId=${athleteId}`, {}).pipe(
      tap(() => this.clearActivitiesCache())
    );
  }

  clearActivitiesCache(): void {
    Array.from({ length: sessionStorage.length })
      .map((_, index) => sessionStorage.key(index))
      .filter((key): key is string => !!key)
      .filter((key) => key.startsWith(this.activitiesCachePrefix) || key.startsWith(this.activityDetailCachePrefix))
      .forEach((key) => sessionStorage.removeItem(key));

    this.activitiesCache.clear();
    this.activityDetailsCache.clear();
  }

  private activitiesStorageKey(cacheKey: string): string {
    return `${this.activitiesCachePrefix}${cacheKey}`;
  }

  private activityDetailStorageKey(activityId: number): string {
    return `${this.activityDetailCachePrefix}${activityId}`;
  }
}
