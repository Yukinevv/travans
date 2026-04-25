import { AfterViewInit, Component, OnDestroy, OnInit } from '@angular/core';
import { HttpErrorResponse } from '@angular/common/http';
import { ChangeDetectorRef } from '@angular/core';
import { AbstractControl } from '@angular/forms';
import { FormBuilder, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { Subscription } from 'rxjs';

import { AppLanguage } from '../../../core/i18n/app-language';
import { LanguageService } from '../../../core/i18n/language.service';
import { CommonStrings, CommonStringsLoader } from '../../../core/misc';
import { environment } from '../../../../environments/environment';
import { AuthService } from '../services/auth.service';
import { GoogleCredentialResponse } from '../services/google-identity.types';
import { AuthErrorResponse } from '../types/auth.model';
import { ModuleStrings, strings } from './strings';

@Component({
  selector: 'app-auth-view',
  standalone: false,
  templateUrl: './auth-view.component.html',
  styleUrls: ['./auth-view.component.scss']
})
export class AuthViewComponent implements OnInit, AfterViewInit, OnDestroy {
  mode: 'login' | 'register' = 'login';
  errorMessage = '';
  fieldErrors: Record<string, string> = {};
  googleReady = false;
  readonly commonStrings: CommonStrings = CommonStringsLoader.strings;
  readonly moduleStrings: ModuleStrings = strings;
  readonly googleClientId = environment.googleClientId;
  private readonly subscriptions = new Subscription();

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
    private readonly changeDetectorRef: ChangeDetectorRef,
    private readonly languageService: LanguageService
  ) {}

  ngOnInit(): void {
    const rememberedEmail = this.authService.getRememberedEmail();
    if (rememberedEmail) {
      this.loginForm.patchValue({ email: rememberedEmail, rememberMe: true });
    }

    this.subscriptions.add(this.languageService.languageChanges$.subscribe(() => {
      if (this.googleClientId) {
        queueMicrotask(() => this.loadGoogleIdentityScript(this.languageService.currentLanguage));
      }
      this.changeDetectorRef.detectChanges();
    }));

    this.initializeGoogleSignIn();
  }

  ngAfterViewInit(): void {
    if (this.googleClientId) {
      queueMicrotask(() => this.renderGoogleButton());
    }
  }

  ngOnDestroy(): void {
    this.subscriptions.unsubscribe();
  }

  setMode(mode: 'login' | 'register'): void {
    this.mode = mode;
    this.clearErrors();
    if (this.googleClientId) {
      queueMicrotask(() => this.renderGoogleButton());
    }
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

  private initializeGoogleSignIn(): void {
    if (!this.googleClientId) {
      return;
    }

    this.loadGoogleIdentityScript(this.languageService.currentLanguage);
  }

  private loadGoogleIdentityScript(language: AppLanguage): void {
    const scriptSrc = this.getGoogleIdentityScriptUrl(language);
    const existingScript = document.getElementById('google-identity-script') as HTMLScriptElement | null;

    if (existingScript?.src === scriptSrc && window.google?.accounts?.id) {
      this.renderGoogleButton();
      return;
    }

    if (existingScript) {
      existingScript.remove();
    }

    delete window.google;

    const script = document.createElement('script');
    script.id = 'google-identity-script';
    script.src = scriptSrc;
    script.async = true;
    script.defer = true;
    script.addEventListener('load', () => this.renderGoogleButton(), { once: true });
    script.addEventListener('error', () => {
      this.errorMessage = this.moduleStrings.google.unavailable;
      this.changeDetectorRef.detectChanges();
    }, { once: true });
    document.head.appendChild(script);
  }

  private getGoogleIdentityScriptUrl(language: AppLanguage): string {
    return `https://accounts.google.com/gsi/client?hl=${language}`;
  }

  private renderGoogleButton(): void {
    const container = document.getElementById('google-signin-button');
    const googleApi = window.google?.accounts?.id;
    if (!container || !googleApi) {
      return;
    }

    container.innerHTML = '';
    googleApi.initialize({
      client_id: this.googleClientId,
      callback: (response) => this.handleGoogleCredential(response)
    });
    googleApi.renderButton(container, {
      theme: 'outline',
      size: 'large',
      shape: 'pill',
      text: this.mode === 'register' ? 'signup_with' : 'signin_with',
      locale: this.languageService.currentLanguage,
      width: '320'
    });

    this.googleReady = true;
    this.changeDetectorRef.detectChanges();
  }

  private handleGoogleCredential(response: GoogleCredentialResponse): void {
    if (!response.credential) {
      this.errorMessage = this.commonStrings.auth.errors.default;
      this.changeDetectorRef.detectChanges();
      return;
    }

    const rememberMe = !!(this.mode === 'register'
      ? this.registerForm.getRawValue().rememberMe
      : this.loginForm.getRawValue().rememberMe);

    this.clearErrors();
    this.authService.loginWithGoogle({ idToken: response.credential }, rememberMe).subscribe({
      next: () => this.router.navigate(['/']),
      error: (error: unknown) => this.applyApiError(error)
    });
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
