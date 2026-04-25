import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, tap } from 'rxjs';

import { API_BASE_URL } from '../../../core/services/api-base';
import { AuthResponse, ChangePasswordPayload, GoogleLoginPayload, LoginPayload, RegisterPayload, UpdateProfilePayload, UserProfile } from '../types/auth.model';

@Injectable({ providedIn: 'root' })
export class AuthService {
  private readonly accessTokenKey = 'travans_access_token';
  private readonly refreshTokenKey = 'travans_refresh_token';
  private readonly profileKey = 'travans_user_profile';
  private readonly rememberMeKey = 'travans_remember_me';
  private readonly rememberedEmailKey = 'travans_remembered_email';

  constructor(private readonly http: HttpClient) {}

  login(payload: LoginPayload, rememberMe: boolean): Observable<AuthResponse> {
    return this.http.post<AuthResponse>(`${API_BASE_URL}/auth/login`, payload).pipe(
      tap((response) => this.persistSession(response, payload.email, rememberMe))
    );
  }

  loginWithGoogle(payload: GoogleLoginPayload, rememberMe: boolean): Observable<AuthResponse> {
    return this.http.post<AuthResponse>(`${API_BASE_URL}/auth/google`, payload).pipe(
      tap((response) => this.persistSession(response, response.user.email, rememberMe))
    );
  }

  register(payload: RegisterPayload, rememberMe: boolean): Observable<AuthResponse> {
    return this.http.post<AuthResponse>(`${API_BASE_URL}/auth/register`, payload).pipe(
      tap((response) => this.persistSession(response, payload.email, rememberMe))
    );
  }

  me(): Observable<UserProfile> {
    return this.http.get<UserProfile>(`${API_BASE_URL}/auth/me`);
  }

  updateProfile(payload: UpdateProfilePayload): Observable<AuthResponse> {
    return this.http.put<AuthResponse>(`${API_BASE_URL}/auth/me`, payload).pipe(
      tap((response) => this.persistSession(response, response.user.email, this.shouldRememberMe()))
    );
  }

  changePassword(payload: ChangePasswordPayload): Observable<AuthResponse> {
    return this.http.post<AuthResponse>(`${API_BASE_URL}/auth/change-password`, payload).pipe(
      tap((response) => this.persistSession(response, response.user.email, this.shouldRememberMe()))
    );
  }

  refresh(): Observable<AuthResponse> {
    const refreshToken = this.getRefreshToken();
    return this.http.post<AuthResponse>(`${API_BASE_URL}/auth/refresh`, { refreshToken }).pipe(
      tap((response) => this.persistSession(response, this.getRememberedEmail(), this.shouldRememberMe()))
    );
  }

  logout(): void {
    localStorage.removeItem(this.accessTokenKey);
    localStorage.removeItem(this.refreshTokenKey);
    localStorage.removeItem(this.profileKey);
    sessionStorage.removeItem(this.accessTokenKey);
    sessionStorage.removeItem(this.refreshTokenKey);
    sessionStorage.removeItem(this.profileKey);
  }

  isAuthenticated(): boolean {
    return !!this.getAccessToken();
  }

  getAccessToken(): string | null {
    return localStorage.getItem(this.accessTokenKey) ?? sessionStorage.getItem(this.accessTokenKey);
  }

  getRefreshToken(): string | null {
    return localStorage.getItem(this.refreshTokenKey) ?? sessionStorage.getItem(this.refreshTokenKey);
  }

  getStoredProfile(): UserProfile | null {
    const raw = localStorage.getItem(this.profileKey) ?? sessionStorage.getItem(this.profileKey);
    return raw ? JSON.parse(raw) as UserProfile : null;
  }

  shouldRememberMe(): boolean {
    return localStorage.getItem(this.rememberMeKey) === 'true';
  }

  getRememberedEmail(): string {
    return localStorage.getItem(this.rememberedEmailKey) ?? '';
  }

  private persistSession(response: AuthResponse, email: string | null, rememberMe: boolean): void {
    this.logout();

    const storage = rememberMe ? localStorage : sessionStorage;
    storage.setItem(this.accessTokenKey, response.accessToken);
    storage.setItem(this.refreshTokenKey, response.refreshToken);
    storage.setItem(this.profileKey, JSON.stringify(response.user));

    if (rememberMe) {
      localStorage.setItem(this.rememberMeKey, 'true');
      if (email) {
        localStorage.setItem(this.rememberedEmailKey, email);
      }
      return;
    }

    localStorage.removeItem(this.rememberMeKey);
    localStorage.removeItem(this.rememberedEmailKey);
  }
}
