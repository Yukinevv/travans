import { CommonModule } from '@angular/common';
import { Component, OnInit, inject } from '@angular/core';
import { FormArray, FormBuilder, FormsModule, ReactiveFormsModule, Validators } from '@angular/forms';

import { TrainingPlan } from '../models/training-plan.model';
import { TrainingPlanService } from '../services/training-plan.service';

@Component({
  selector: 'app-plans-page',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, FormsModule],
  template: `
    <section class="page">
      <article class="panel">
        <p class="kicker">Nowy plan</p>
        <h2>Dodaj plan recznie</h2>

        <form [formGroup]="form" (ngSubmit)="submit()">
          <div class="grid">
            <label>
              <span>Nazwa</span>
              <input formControlName="name" type="text">
            </label>
            <label>
              <span>Data startu</span>
              <input formControlName="startDate" type="date">
            </label>
          </div>

          <label>
            <span>Opis</span>
            <textarea formControlName="description" rows="3"></textarea>
          </label>

          <div formArrayName="trainingDays" class="day-list">
            <div class="day-card" *ngFor="let day of trainingDays.controls; let i = index" [formGroupName]="i">
              <div class="grid">
                <label>
                  <span>Dzien</span>
                  <input formControlName="scheduledDate" type="date">
                </label>
                <label>
                  <span>Tytul</span>
                  <input formControlName="title" type="text">
                </label>
                <label>
                  <span>Typ</span>
                  <select formControlName="activityType">
                    <option value="RUN">Bieg</option>
                    <option value="RIDE">Rower</option>
                    <option value="SWIM">Plywanie</option>
                    <option value="WALK">Marsz</option>
                    <option value="STRENGTH">Sila</option>
                    <option value="OTHER">Inne</option>
                  </select>
                </label>
              </div>
            </div>
          </div>

          <div class="actions">
            <button type="button" class="secondary" (click)="addTrainingDay()">Dodaj dzien</button>
            <button type="submit">Zapisz plan</button>
          </div>
        </form>
      </article>

      <article class="panel">
        <p class="kicker">Import JSON</p>
        <h2>Wklej plan w formacie JSON</h2>
        <textarea [(ngModel)]="jsonInput" [ngModelOptions]="{ standalone: true }" rows="12" class="json-box"></textarea>
        <div class="actions">
          <button type="button" (click)="importJson()">Importuj</button>
        </div>
      </article>

      <article class="panel">
        <p class="kicker">Lista</p>
        <h2>Zapisane plany</h2>
        <div class="saved-plan" *ngFor="let plan of plans">
          <strong>{{ plan.name }}</strong>
          <span>{{ plan.trainingDays.length }} dni</span>
        </div>
      </article>
    </section>
  `,
  styles: [`
    .page {
      display: grid;
      gap: 24px;
    }

    .panel {
      border: 1px solid var(--border);
      background: var(--surface);
      border-radius: 24px;
      padding: 24px;
      box-shadow: var(--shadow);
    }

    .kicker {
      margin: 0;
      text-transform: uppercase;
      letter-spacing: 0.12em;
      color: var(--accent-dark);
      font-size: 0.75rem;
      font-weight: 700;
    }

    h2 {
      margin: 8px 0 20px;
    }

    form,
    .day-list {
      display: grid;
      gap: 16px;
    }

    .grid {
      display: grid;
      grid-template-columns: repeat(3, minmax(0, 1fr));
      gap: 16px;
    }

    label {
      display: grid;
      gap: 8px;
    }

    input,
    select,
    textarea {
      width: 100%;
      padding: 12px 14px;
      border-radius: 14px;
      border: 1px solid var(--border);
      background: var(--surface-strong);
    }

    .day-card,
    .saved-plan {
      padding: 16px;
      border-radius: 18px;
      border: 1px solid var(--border);
      background: rgba(255, 255, 255, 0.7);
    }

    .saved-plan {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-top: 12px;
    }

    .actions {
      display: flex;
      gap: 12px;
      margin-top: 16px;
    }

    button {
      border: 0;
      border-radius: 999px;
      padding: 12px 18px;
      background: var(--accent);
      color: white;
      cursor: pointer;
    }

    button.secondary {
      background: var(--surface-strong);
      color: var(--text);
      border: 1px solid var(--border);
    }

    .json-box {
      margin-top: 12px;
      font-family: Consolas, monospace;
    }

    @media (max-width: 900px) {
      .grid {
        grid-template-columns: 1fr;
      }
    }
  `]
})
export class PlansPageComponent implements OnInit {
  private readonly fb = inject(FormBuilder);
  private readonly trainingPlanService = inject(TrainingPlanService);

  plans: TrainingPlan[] = [];
  jsonInput = `{
  "name": "Przykladowy plan 10 km",
  "description": "4 tygodnie pracy nad tempem",
  "startDate": "2026-04-13",
  "trainingDays": [
    {
      "scheduledDate": "2026-04-13",
      "title": "Easy run",
      "activityType": "RUN",
      "plannedDistanceMeters": 6000,
      "plannedDurationSeconds": 2100,
      "notes": "Lekko"
    }
  ]
}`;

  readonly form = this.fb.group({
    name: ['', Validators.required],
    description: [''],
    startDate: ['', Validators.required],
    trainingDays: this.fb.array([this.createTrainingDayGroup()])
  });

  get trainingDays(): FormArray {
    return this.form.get('trainingDays') as FormArray;
  }

  ngOnInit(): void {
    this.loadPlans();
  }

  addTrainingDay(): void {
    this.trainingDays.push(this.createTrainingDayGroup());
  }

  submit(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }

    this.trainingPlanService.createPlan(this.form.getRawValue() as TrainingPlan).subscribe(() => {
      this.form.reset();
      this.trainingDays.clear();
      this.addTrainingDay();
      this.loadPlans();
    });
  }

  importJson(): void {
    const payload = JSON.parse(this.jsonInput) as TrainingPlan;
    this.trainingPlanService.importPlan(payload).subscribe(() => this.loadPlans());
  }

  private loadPlans(): void {
    this.trainingPlanService.getPlans().subscribe((plans) => {
      this.plans = plans;
    });
  }

  private createTrainingDayGroup() {
    return this.fb.group({
      scheduledDate: ['', Validators.required],
      title: ['', Validators.required],
      activityType: ['RUN', Validators.required],
      plannedDistanceMeters: [null],
      plannedDurationSeconds: [null],
      notes: ['']
    });
  }
}
