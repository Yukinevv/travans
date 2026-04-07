import { Component, OnInit } from '@angular/core';
import { FormArray, FormBuilder, FormGroup, Validators } from '@angular/forms';

import { TrainingPlanService } from '../../core/services/training-plan.service';
import { TrainingPlan } from '../../core/types/training-plan.model';

@Component({
  selector: 'app-plans-view',
  standalone: false,
  templateUrl: './plans-view.component.html',
  styleUrls: ['./plans-view.component.scss']
})
export class PlansViewComponent implements OnInit {
  plans: TrainingPlan[] = [];
  errorMessage = '';
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

  constructor(
    private readonly fb: FormBuilder,
    private readonly trainingPlanService: TrainingPlanService
  ) {}

  get trainingDays(): FormArray<FormGroup> {
    return this.form.get('trainingDays') as FormArray<FormGroup>;
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
      this.errorMessage = '';
      this.loadPlans();
    }, () => {
      this.errorMessage = 'Nie udalo sie zapisac planu';
    });
  }

  importJson(): void {
    const payload = JSON.parse(this.jsonInput) as TrainingPlan;
    this.trainingPlanService.importPlan(payload).subscribe(() => {
      this.errorMessage = '';
      this.loadPlans();
    }, () => {
      this.errorMessage = 'Nie udalo sie zaimportowac planu';
    });
  }

  private loadPlans(): void {
    this.trainingPlanService.getPlans().subscribe({
      next: (plans) => {
        this.plans = plans;
        this.errorMessage = '';
      },
      error: () => {
        this.errorMessage = 'Nie udalo sie pobrac planow';
      }
    });
  }

  private createTrainingDayGroup(): FormGroup {
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
