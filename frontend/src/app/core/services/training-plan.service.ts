import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { TrainingPlan } from '../types/training-plan.model';
import { API_ENDPOINTS } from './api-endpoints';

@Injectable({ providedIn: 'root' })
export class TrainingPlanService {
  constructor(private readonly http: HttpClient) {}

  getPlans(): Observable<TrainingPlan[]> {
    return this.http.get<TrainingPlan[]>(API_ENDPOINTS.plans.collection);
  }

  getPlan(planId: number): Observable<TrainingPlan> {
    return this.http.get<TrainingPlan>(API_ENDPOINTS.plans.detail(planId));
  }

  createPlan(payload: TrainingPlan): Observable<TrainingPlan> {
    return this.http.post<TrainingPlan>(API_ENDPOINTS.plans.collection, payload);
  }

  updatePlan(planId: number, payload: TrainingPlan): Observable<TrainingPlan> {
    return this.http.put<TrainingPlan>(API_ENDPOINTS.plans.detail(planId), payload);
  }

  deletePlan(planId: number): Observable<void> {
    return this.http.delete<void>(API_ENDPOINTS.plans.detail(planId));
  }

  importPlan(payload: TrainingPlan): Observable<TrainingPlan> {
    return this.http.post<TrainingPlan>(API_ENDPOINTS.plans.import, payload);
  }
}
