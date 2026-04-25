import { HttpErrorResponse } from '@angular/common/http';
import { ChangeDetectorRef, Component, OnDestroy, OnInit } from '@angular/core';
import { FormArray, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { Subscription } from 'rxjs';

import { LanguageService } from '../../core/i18n/language.service';
import { CommonStrings, CommonStringsLoader } from '../../core/misc';
import { TrainingPlanService } from '../../core/services/training-plan.service';
import { ActivityType, TrainingDay, TrainingPlan } from '../../core/types/training-plan.model';
import { ModuleStrings, strings } from './strings';

@Component({
  selector: 'app-plans-view',
  standalone: false,
  templateUrl: './plans-view.component.html',
  styleUrls: ['./plans-view.component.scss']
})
export class PlansViewComponent implements OnInit, OnDestroy {
  importedFileName = '';
  isJsonPreviewExpanded = false;
  removeDayConfirmationOpen = false;
  jsonErrorMessage = '';
  submitErrorMessage = '';
  loadingPlan = false;
  isEditMode = false;
  editingPlanId: number | null = null;
  pendingRemoveDayIndex: number | null = null;
  jsonInput = strings.defaults.jsonInput;
  readonly commonStrings: CommonStrings = CommonStringsLoader.strings;
  readonly moduleStrings: ModuleStrings = strings;

  readonly form = this.fb.group({
    name: ['', Validators.required],
    description: [''],
    startDate: ['', Validators.required],
    stravaEvaluationStartDate: [''],
    planType: ['RUN', Validators.required],
    trainingDays: this.fb.array([this.createTrainingDayGroup()])
  });

  private syncingFormToJson = false;
  private syncingJsonToForm = false;
  private readonly subscriptions = new Subscription();
  private lastLocalizedDefaultJsonInput = strings.defaults.jsonInput;

  constructor(
    private readonly fb: FormBuilder,
    private readonly trainingPlanService: TrainingPlanService,
    private readonly changeDetectorRef: ChangeDetectorRef,
    private readonly route: ActivatedRoute,
    public readonly router: Router,
    private readonly languageService: LanguageService
  ) {}

  get trainingDays(): FormArray<FormGroup> {
    return this.form.get('trainingDays') as FormArray<FormGroup>;
  }

  getTrainingDayTitle(index: number): string {
    return this.moduleStrings.day.title.replace('%d', String(index + 1));
  }

  getRemoveTrainingDayConfirmationMessage(): string {
    const dayIndex = (this.pendingRemoveDayIndex ?? 0) + 1;
    return this.moduleStrings.day.removeConfirmation.replace('%d', `${dayIndex}`);
  }

  toggleJsonPreview(): void {
    this.isJsonPreviewExpanded = !this.isJsonPreviewExpanded;
  }

  ngOnInit(): void {
    this.subscriptions.add(this.languageService.languageChanges$.subscribe(() => {
      const nextDefaultJsonInput = this.moduleStrings.defaults.jsonInput;
      if (this.jsonInput === this.lastLocalizedDefaultJsonInput) {
        this.onJsonInputChange(nextDefaultJsonInput);
      }

      this.lastLocalizedDefaultJsonInput = nextDefaultJsonInput;
      this.changeDetectorRef.detectChanges();
    }));

    this.form.controls.startDate.valueChanges.subscribe((startDate) => {
      if (!this.form.controls.stravaEvaluationStartDate.value) {
        this.form.controls.stravaEvaluationStartDate.setValue(startDate ?? '', { emitEvent: false });
      }
    });

    this.form.valueChanges.subscribe(() => {
      if (this.syncingJsonToForm) {
        return;
      }

      this.syncingFormToJson = true;
      this.jsonInput = this.stringifyPlan(this.buildPlanFromForm());
      this.jsonErrorMessage = '';
      this.syncingFormToJson = false;
      this.changeDetectorRef.detectChanges();
    });

    this.route.paramMap.subscribe((params) => {
      const rawPlanId = params.get('planId');
      const planId = rawPlanId ? Number(rawPlanId) : NaN;

      if (!Number.isNaN(planId) && planId > 0) {
        this.loadPlanForEdit(planId);
        return;
      }

      this.isEditMode = false;
      this.editingPlanId = null;
      const initialPlan = this.parseJsonInput(this.jsonInput, false);
      if (initialPlan) {
        this.syncFormFromPlan(initialPlan);
      }
      this.changeDetectorRef.detectChanges();
    });
  }

  ngOnDestroy(): void {
    this.subscriptions.unsubscribe();
  }

  addTrainingDay(): void {
    this.trainingDays.push(this.createTrainingDayGroup());
    this.syncJsonFromForm();
  }

  moveTrainingDay(index: number, direction: -1 | 1): void {
    const targetIndex = index + direction;
    if (targetIndex < 0 || targetIndex >= this.trainingDays.length) {
      return;
    }

    const currentControl = this.trainingDays.at(index);
    const targetControl = this.trainingDays.at(targetIndex);

    this.trainingDays.setControl(index, targetControl, { emitEvent: false });
    this.trainingDays.setControl(targetIndex, currentControl, { emitEvent: false });

    this.syncJsonFromForm();
    this.changeDetectorRef.detectChanges();
  }

  openRemoveTrainingDayConfirmation(index: number): void {
    this.pendingRemoveDayIndex = index;
    this.removeDayConfirmationOpen = true;
  }

  closeRemoveTrainingDayConfirmation(): void {
    this.pendingRemoveDayIndex = null;
    this.removeDayConfirmationOpen = false;
  }

  confirmRemoveTrainingDay(): void {
    if (this.pendingRemoveDayIndex === null) {
      this.closeRemoveTrainingDayConfirmation();
      return;
    }

    this.trainingDays.removeAt(this.pendingRemoveDayIndex);

    if (this.trainingDays.length === 0) {
      this.trainingDays.push(this.createTrainingDayGroup());
    }

    this.closeRemoveTrainingDayConfirmation();
    this.syncJsonFromForm();
    this.changeDetectorRef.detectChanges();
  }

  submit(): void {
    this.submitErrorMessage = '';

    if (this.form.invalid) {
      this.form.markAllAsTouched();
      this.submitErrorMessage = this.moduleStrings.errors.submitRequired;
      this.changeDetectorRef.detectChanges();
      return;
    }

    const payload = this.buildPlanFromForm();
    const request = this.isEditMode && this.editingPlanId
      ? this.trainingPlanService.updatePlan(this.editingPlanId, payload)
      : this.trainingPlanService.createPlan(payload);

    request.subscribe(() => {
      this.resetEditor();
      this.submitErrorMessage = '';
      this.router.navigate(['/plans/list']);
    }, (error) => {
      this.submitErrorMessage = this.resolveApiErrorMessage(error, this.moduleStrings.errors.savePlan);
      this.changeDetectorRef.detectChanges();
    });
  }

  onJsonInputChange(value: string): void {
    this.jsonInput = value;
    this.importedFileName = '';

    if (this.syncingFormToJson) {
      return;
    }

    const parsedPlan = this.parseJsonInput(value, false);
    if (!parsedPlan) {
      this.changeDetectorRef.detectChanges();
      return;
    }

    this.syncFormFromPlan(parsedPlan);
    this.changeDetectorRef.detectChanges();
  }

  onJsonFileSelected(event: Event): void {
    const input = event.target as HTMLInputElement | null;
    const file = input?.files?.[0];
    if (!file) {
      return;
    }

    this.submitErrorMessage = '';
    this.jsonErrorMessage = '';

    const isJsonFile = file.type === 'application/json' || file.name.toLowerCase().endsWith('.json');
    if (!isJsonFile) {
      this.importedFileName = '';
      this.jsonErrorMessage = this.moduleStrings.errors.invalidJsonFile;
      if (input) {
        input.value = '';
      }
      this.changeDetectorRef.detectChanges();
      return;
    }

    const reader = new FileReader();
    reader.onload = () => {
      const content = typeof reader.result === 'string' ? reader.result : '';
      this.importedFileName = file.name;
      this.jsonInput = content;
      this.onJsonInputChange(content);
    };
    reader.onerror = () => {
      this.importedFileName = '';
      this.jsonErrorMessage = this.moduleStrings.errors.readJsonFile;
      this.changeDetectorRef.detectChanges();
    };

    reader.readAsText(file);
  }

  hasControlError(controlPath: string): boolean {
    const control = this.form.get(controlPath);
    return !!control && control.invalid && (control.touched || control.dirty);
  }

  getControlErrorMessage(controlPath: string, label: string): string {
    const control = this.form.get(controlPath);
    if (!control || !control.errors) {
      return '';
    }

    if (control.errors['required']) {
      return this.moduleStrings.errors.requiredField.replace('%s', label);
    }

    return this.moduleStrings.errors.invalidField.replace('%s', label);
  }

  private resolveApiErrorMessage(error: unknown, fallbackMessage: string): string {
    if (!(error instanceof HttpErrorResponse)) {
      return fallbackMessage;
    }

    const response = error.error as { message?: string; errors?: Record<string, string> } | null;
    if (response?.message) {
      const fieldErrors = response.errors ? Object.values(response.errors).filter(Boolean) : [];
      return fieldErrors.length > 0
        ? `${response.message} ${fieldErrors.join(' ')}`
        : response.message;
    }

    return fallbackMessage;
  }

  private syncFormFromPlan(plan: TrainingPlan): void {
    this.syncingJsonToForm = true;

    this.form.patchValue({
      name: plan.name,
      description: plan.description ?? '',
      startDate: plan.startDate,
      stravaEvaluationStartDate: plan.stravaEvaluationStartDate ?? plan.startDate,
      planType: plan.planType
    }, { emitEvent: false });

    this.trainingDays.clear({ emitEvent: false });
    const trainingDays = plan.trainingDays.length > 0 ? plan.trainingDays : [this.createEmptyTrainingDay()];
    trainingDays.forEach((day) => {
      this.trainingDays.push(this.createTrainingDayGroup(day), { emitEvent: false });
    });

    this.jsonErrorMessage = '';
    this.syncingJsonToForm = false;
  }

  private loadPlanForEdit(planId: number): void {
    this.loadingPlan = true;
    this.isEditMode = true;
    this.editingPlanId = planId;
    this.submitErrorMessage = '';

    this.trainingPlanService.getPlan(planId).subscribe({
      next: (plan) => {
        this.syncFormFromPlan(plan);
        this.syncJsonFromForm();
        this.loadingPlan = false;
        this.changeDetectorRef.detectChanges();
      },
      error: (error) => {
        this.submitErrorMessage = this.resolveApiErrorMessage(error, this.moduleStrings.errors.loadPlan);
        this.loadingPlan = false;
        this.changeDetectorRef.detectChanges();
      }
    });
  }

  private syncJsonFromForm(): void {
    if (this.syncingJsonToForm) {
      return;
    }

    this.syncingFormToJson = true;
    this.jsonInput = this.stringifyPlan(this.buildPlanFromForm());
    this.jsonErrorMessage = '';
    this.syncingFormToJson = false;
  }

  private buildPlanFromForm(): TrainingPlan {
    const value = this.form.getRawValue();

    return this.normalizePlan({
      name: value.name ?? '',
      description: value.description ?? '',
      startDate: value.startDate ?? '',
      stravaEvaluationStartDate: value.stravaEvaluationStartDate || value.startDate || '',
      planType: (value.planType as ActivityType | null) ?? 'RUN',
      trainingDays: (value.trainingDays ?? []) as TrainingDay[]
    });
  }

  private parseJsonInput(value: string, showError: boolean): TrainingPlan | null {
    try {
      const parsed = JSON.parse(value) as Partial<TrainingPlan>;
      return this.normalizePlan(parsed);
    } catch {
      if (showError || value.trim()) {
        this.jsonErrorMessage = this.moduleStrings.errors.invalidJson;
      }
      return null;
    }
  }

  private normalizePlan(plan: Partial<TrainingPlan>): TrainingPlan {
    return {
      id: plan.id,
      name: plan.name ?? '',
      description: plan.description ?? '',
      startDate: plan.startDate ?? '',
      stravaEvaluationStartDate: plan.stravaEvaluationStartDate ?? plan.startDate ?? '',
      planType: plan.planType ?? 'RUN',
      createdAt: plan.createdAt,
      trainingDays: Array.isArray(plan.trainingDays)
        ? plan.trainingDays.map((day) => ({
            id: day.id,
            scheduledDate: day.scheduledDate ?? '',
            title: day.title ?? '',
            activityType: day.activityType ?? 'RUN',
            plannedDistanceMeters: day.plannedDistanceMeters ?? null,
            plannedDurationSeconds: day.plannedDurationSeconds ?? null,
            notes: day.notes ?? '',
            status: day.status,
            matchedActivityId: day.matchedActivityId,
            matchedActivityName: day.matchedActivityName,
            matchedActivityDate: day.matchedActivityDate,
            matchedDistanceMeters: day.matchedDistanceMeters,
            matchedMovingTimeSeconds: day.matchedMovingTimeSeconds
          }))
        : [this.createEmptyTrainingDay()]
    };
  }

  private stringifyPlan(plan: TrainingPlan): string {
    return JSON.stringify(plan, null, 2);
  }

  private resetEditor(): void {
    const defaultPlan = this.normalizePlan({
      name: '',
      description: '',
      startDate: '',
      stravaEvaluationStartDate: '',
      planType: 'RUN',
      trainingDays: [this.createEmptyTrainingDay()]
    });

    this.syncFormFromPlan(defaultPlan);
    this.syncJsonFromForm();
  }

  private createTrainingDayGroup(day?: Partial<TrainingDay>): FormGroup {
    return this.fb.group({
      scheduledDate: [day?.scheduledDate ?? '', Validators.required],
      title: [day?.title ?? '', Validators.required],
      activityType: [day?.activityType ?? 'RUN', Validators.required],
      plannedDistanceMeters: [day?.plannedDistanceMeters ?? null],
      plannedDurationSeconds: [day?.plannedDurationSeconds ?? null],
      notes: [day?.notes ?? '']
    });
  }

  private createEmptyTrainingDay(): TrainingDay {
    return {
      scheduledDate: '',
      title: '',
      activityType: 'RUN',
      plannedDistanceMeters: null,
      plannedDurationSeconds: null,
      notes: ''
    };
  }
}
