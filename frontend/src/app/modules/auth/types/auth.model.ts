export interface UserProfile {
  id: number;
  email: string;
  displayName: string;
  avatarUrl: string | null;
  role: 'USER' | 'ADMIN';
  authProvider: 'LOCAL' | 'GOOGLE';
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

export interface GoogleLoginPayload {
  idToken: string;
}

export interface RegisterPayload {
  email: string;
  password: string;
  displayName: string;
}

export interface UpdateProfilePayload {
  email: string;
  displayName: string;
}

export interface ChangePasswordPayload {
  currentPassword: string;
  newPassword: string;
}

export interface AuthErrorResponse {
  code?: string;
  message?: string;
  errors?: Record<string, string>;
}
