export interface UserProfile {
  id: number;
  email: string;
  displayName: string;
  role: 'USER' | 'ADMIN';
}

export interface AuthResponse {
  accessToken: string;
  refreshToken: string;
  user: UserProfile;
}

export interface LoginPayload {
  email: string;
  password: string;
}

export interface RegisterPayload {
  email: string;
  password: string;
  displayName: string;
}

export interface AuthErrorResponse {
  code?: string;
  message?: string;
  errors?: Record<string, string>;
}
