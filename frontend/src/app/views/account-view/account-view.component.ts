import { HttpErrorResponse } from '@angular/common/http';
import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';

import { CommonStrings, CommonStringsLoader } from '../../core/misc';
import { AuthService } from '../../modules/auth/services/auth.service';
import { AuthErrorResponse } from '../../modules/auth/types/auth.model';
import { ModuleStrings, strings } from './strings';

@Component({
  selector: 'app-account-view',
  standalone: false,
  templateUrl: './account-view.component.html',
  styleUrls: ['./account-view.component.scss']
})
export class AccountViewComponent implements OnInit {
  loading = true;
  profileSubmitting = false;
  passwordSubmitting = false;
  profileErrorMessage = '';
  profileSuccessMessage = '';
  passwordErrorMessage = '';
  passwordSuccessMessage = '';
  readonly commonStrings: CommonStrings = CommonStringsLoader.strings;
  readonly moduleStrings: ModuleStrings = strings;

  readonly profileForm = this.fb.group({
    displayName: ['', [Validators.required]],
    email: ['', [Validators.required, Validators.email]]
  });

  readonly passwordForm = this.fb.group({
    currentPassword: ['', [Validators.required, Validators.minLength(8)]],
    newPassword: ['', [Validators.required, Validators.minLength(8)]],
    repeatPassword: ['', [Validators.required, Validators.minLength(8)]]
  });

  constructor(
    private readonly fb: FormBuilder,
    private readonly authService: AuthService,
    private readonly changeDetectorRef: ChangeDetectorRef
  ) {}

  ngOnInit(): void {
    this.authService.me().subscribe({
      next: (profile) => {
        this.profileForm.patchValue({
          displayName: profile.displayName,
          email: profile.email
        });
        this.loading = false;
        this.changeDetectorRef.detectChanges();
      },
      error: (error: unknown) => {
        this.profileErrorMessage = this.resolveErrorMessage(error, this.commonStrings.auth.errors.default);
        this.loading = false;
        this.changeDetectorRef.detectChanges();
      }
    });
  }

  submitProfile(): void {
    this.profileSuccessMessage = '';
    this.profileErrorMessage = '';

    if (this.profileForm.invalid) {
      this.profileForm.markAllAsTouched();
      this.profileErrorMessage = this.commonStrings.auth.errors.invalidForm;
      return;
    }

    const raw = this.profileForm.getRawValue();
    this.profileSubmitting = true;

    this.authService.updateProfile({
      displayName: raw.displayName ?? '',
      email: raw.email ?? ''
    }).subscribe({
      next: () => {
        this.profileSubmitting = false;
        this.profileSuccessMessage = this.moduleStrings.profile.success;
        this.changeDetectorRef.detectChanges();
      },
      error: (error: unknown) => {
        this.profileSubmitting = false;
        this.profileErrorMessage = this.resolveErrorMessage(error, this.commonStrings.auth.errors.default);
        this.changeDetectorRef.detectChanges();
      }
    });
  }

  submitPassword(): void {
    this.passwordSuccessMessage = '';
    this.passwordErrorMessage = '';

    if (this.passwordForm.invalid) {
      this.passwordForm.markAllAsTouched();
      this.passwordErrorMessage = this.commonStrings.auth.errors.invalidForm;
      return;
    }

    const raw = this.passwordForm.getRawValue();
    if ((raw.newPassword ?? '') !== (raw.repeatPassword ?? '')) {
      this.passwordErrorMessage = this.moduleStrings.password.mismatch;
      return;
    }

    this.passwordSubmitting = true;
    this.authService.changePassword({
      currentPassword: raw.currentPassword ?? '',
      newPassword: raw.newPassword ?? ''
    }).subscribe({
      next: () => {
        this.passwordSubmitting = false;
        this.passwordSuccessMessage = this.moduleStrings.password.success;
        this.passwordForm.reset();
        this.changeDetectorRef.detectChanges();
      },
      error: (error: unknown) => {
        this.passwordSubmitting = false;
        this.passwordErrorMessage = this.resolveErrorMessage(error, this.commonStrings.auth.errors.default);
        this.changeDetectorRef.detectChanges();
      }
    });
  }

  getProfileFieldError(fieldName: 'displayName' | 'email'): string | null {
    const control = this.profileForm.controls[fieldName];
    if (!control || (!control.touched && !control.dirty)) {
      return null;
    }

    if (control.hasError('required')) {
      return this.commonStrings.auth.validation.required;
    }
    if (control.hasError('email')) {
      return this.commonStrings.auth.validation.email;
    }

    return null;
  }

  getPasswordFieldError(fieldName: 'currentPassword' | 'newPassword' | 'repeatPassword'): string | null {
    const control = this.passwordForm.controls[fieldName];
    if (!control || (!control.touched && !control.dirty)) {
      return null;
    }

    if (control.hasError('required')) {
      return this.commonStrings.auth.validation.required;
    }
    if (control.hasError('minlength')) {
      return this.commonStrings.auth.validation.minlength;
    }

    return null;
  }

  private resolveErrorMessage(error: unknown, fallback: string): string {
    if (!(error instanceof HttpErrorResponse)) {
      return fallback;
    }

    const payload = error.error as AuthErrorResponse | null;
    if (payload?.message) {
      return payload.message;
    }

    if (typeof error.error === 'string' && error.error.trim().length > 0) {
      return error.error;
    }

    if (error.status === 400) {
      return this.commonStrings.auth.errors.invalidForm;
    }
    if (error.status === 409) {
      return this.commonStrings.auth.errors.conflict;
    }

    return fallback;
  }
}
