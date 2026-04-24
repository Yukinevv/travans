import { Component, OnInit } from '@angular/core';
import { HttpErrorResponse } from '@angular/common/http';
import { ChangeDetectorRef } from '@angular/core';
import { AbstractControl } from '@angular/forms';
import { FormBuilder, Validators } from '@angular/forms';
import { Router } from '@angular/router';

import { CommonStrings, CommonStringsLoader } from '../../../core/misc';
import { AuthService } from '../services/auth.service';
import { AuthErrorResponse } from '../types/auth.model';
import { ModuleStrings, strings } from './strings';

@Component({
  selector: 'app-auth-view',
  standalone: false,
  templateUrl: './auth-view.component.html',
  styleUrls: ['./auth-view.component.scss']
})
export class AuthViewComponent implements OnInit {
  mode: 'login' | 'register' = 'login';
  errorMessage = '';
  fieldErrors: Record<string, string> = {};
  readonly commonStrings: CommonStrings = CommonStringsLoader.strings;
  readonly moduleStrings: ModuleStrings = strings;

  readonly loginForm = this.fb.group({
    email: ['', [Validators.required, Validators.email]],
    password: ['', [Validators.required, Validators.minLength(8)]],
    rememberMe: [this.authService.shouldRememberMe()]
  });

  readonly registerForm = this.fb.group({
    displayName: ['', [Validators.required]],
    email: ['', [Validators.required, Validators.email]],
    password: ['', [Validators.required, Validators.minLength(8)]],
    rememberMe: [this.authService.shouldRememberMe()]
  });

  constructor(
    private readonly fb: FormBuilder,
    private readonly authService: AuthService,
    private readonly router: Router,
    private readonly changeDetectorRef: ChangeDetectorRef
  ) {}

  ngOnInit(): void {
    const rememberedEmail = this.authService.getRememberedEmail();
    if (rememberedEmail) {
      this.loginForm.patchValue({ email: rememberedEmail, rememberMe: true });
    }
  }

  setMode(mode: 'login' | 'register'): void {
    this.mode = mode;
    this.clearErrors();
  }

  submitLogin(): void {
    this.clearErrors();
    if (this.loginForm.invalid) {
      this.loginForm.markAllAsTouched();
      return;
    }

    const raw = this.loginForm.getRawValue();
    this.authService.login(
      { email: raw.email ?? '', password: raw.password ?? '' },
      !!raw.rememberMe
    ).subscribe({
      next: () => this.router.navigate(['/']),
      error: (error: unknown) => this.applyApiError(error)
    });
  }

  submitRegister(): void {
    this.clearErrors();
    if (this.registerForm.invalid) {
      this.registerForm.markAllAsTouched();
      return;
    }

    const raw = this.registerForm.getRawValue();
    this.authService.register(
      {
        displayName: raw.displayName ?? '',
        email: raw.email ?? '',
        password: raw.password ?? ''
      },
      !!raw.rememberMe
    ).subscribe({
      next: () => this.router.navigate(['/']),
      error: (error: unknown) => this.applyApiError(error)
    });
  }

  getFieldError(formName: 'login' | 'register', fieldName: string): string | null {
    const control = this.resolveControl(formName, fieldName);

    if (this.fieldErrors[fieldName]) {
      return this.fieldErrors[fieldName];
    }

    if (!control || (!control.touched && !control.dirty)) {
      return null;
    }

    if (control.hasError('required')) {
      return this.commonStrings.auth.validation.required;
    }
    if (control.hasError('email')) {
      return this.commonStrings.auth.validation.email;
    }
    if (control.hasError('minlength')) {
      return this.commonStrings.auth.validation.minlength;
    }

    return null;
  }

  private resolveControl(formName: 'login' | 'register', fieldName: string): AbstractControl | null {
    if (formName === 'login') {
      return this.loginForm.controls[fieldName as keyof typeof this.loginForm.controls] ?? null;
    }

    return this.registerForm.controls[fieldName as keyof typeof this.registerForm.controls] ?? null;
  }

  private clearErrors(): void {
    this.errorMessage = '';
    this.fieldErrors = {};
  }

  private applyApiError(error: unknown): void {
    const httpError = error as HttpErrorResponse;
    const payload = this.normalizeApiErrorPayload(httpError);
    this.errorMessage = this.resolveApiMessage(payload, httpError?.status ?? 0, httpError);
    this.fieldErrors = payload.errors ?? {};
    if (Object.keys(this.fieldErrors).length > 0) {
      this.markServerErroredControls();
    }
    this.changeDetectorRef.detectChanges();
  }

  private resolveApiMessage(payload: AuthErrorResponse, status: number, error?: HttpErrorResponse): string {
    if (payload.message) {
      return payload.message;
    }
    if (typeof error?.error === 'string' && error.error.trim().length > 0) {
      return error.error;
    }
    if (status === 401) {
      return this.commonStrings.auth.errors.badCredentials;
    }
    if (status === 409) {
      return this.commonStrings.auth.errors.conflict;
    }
    if (status === 400) {
      return this.commonStrings.auth.errors.invalidForm;
    }
    return this.commonStrings.auth.errors.default;
  }

  private normalizeApiErrorPayload(error: HttpErrorResponse | undefined): AuthErrorResponse {
    if (!error) {
      return {};
    }

    if (typeof error.error === 'string') {
      try {
        return JSON.parse(error.error) as AuthErrorResponse;
      } catch {
        return { message: error.error };
      }
    }

    if (error.error && typeof error.error === 'object') {
      return error.error as AuthErrorResponse;
    }

    return {};
  }

  private markServerErroredControls(): void {
    Object.keys(this.fieldErrors).forEach((field) => {
      const loginControl = this.resolveControl('login', field);
      const registerControl = this.resolveControl('register', field);
      loginControl?.markAsTouched();
      registerControl?.markAsTouched();
    });
  }
}
