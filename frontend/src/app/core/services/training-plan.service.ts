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

  getPlan(planId: number): Observable<TrainingPlan> {
    return this.http.get<TrainingPlan>(`${API_BASE_URL}/plans/${planId}`);
  }

  createPlan(payload: TrainingPlan): Observable<TrainingPlan> {
    return this.http.post<TrainingPlan>(`${API_BASE_URL}/plans`, payload);
  }

  updatePlan(planId: number, payload: TrainingPlan): Observable<TrainingPlan> {
    return this.http.put<TrainingPlan>(`${API_BASE_URL}/plans/${planId}`, payload);
  }

  deletePlan(planId: number): Observable<void> {
    return this.http.delete<void>(`${API_BASE_URL}/plans/${planId}`);
  }

  importPlan(payload: TrainingPlan): Observable<TrainingPlan> {
    return this.http.post<TrainingPlan>(`${API_BASE_URL}/plans/import`, payload);
  }
}
