import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class CurrentPlanService {
  private readonly storageKey = 'travans-dashboard-plan-id';
  private readonly selectedPlanIdSubject = new BehaviorSubject<number | null>(this.readSelectedPlanId());

  readonly selectedPlanId$ = this.selectedPlanIdSubject.asObservable();

  getSelectedPlanId(): number | null {
    return this.selectedPlanIdSubject.value;
  }

  setSelectedPlanId(planId: number | null): void {
    if (planId === null) {
      localStorage.removeItem(this.storageKey);
    } else {
      localStorage.setItem(this.storageKey, String(planId));
    }

    this.selectedPlanIdSubject.next(planId);
  }

  private readSelectedPlanId(): number | null {
    const storedValue = localStorage.getItem(this.storageKey);
    if (!storedValue) {
      return null;
    }

    const parsedValue = Number(storedValue);
    return Number.isFinite(parsedValue) ? parsedValue : null;
  }
}
