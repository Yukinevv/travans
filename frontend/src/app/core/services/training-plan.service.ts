import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { TrainingPlan } from '../types/training-plan.model';
import { API_BASE_URL } from './api-base';

@Injectable({ providedIn: 'root' })
export class TrainingPlanService {
  constructor(private readonly http: HttpClient) {}

  getPlans(): Observable<TrainingPlan[]> {
    return this.http.get<TrainingPlan[]>(`${API_BASE_URL}/plans`);
  }

  createPlan(payload: TrainingPlan): Observable<TrainingPlan> {
    return this.http.post<TrainingPlan>(`${API_BASE_URL}/plans`, payload);
  }

  importPlan(payload: TrainingPlan): Observable<TrainingPlan> {
    return this.http.post<TrainingPlan>(`${API_BASE_URL}/plans/import`, payload);
  }
}
