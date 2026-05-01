import '../../../shared/models/user_profile.dart';

class LoginPayload {
  const LoginPayload({required this.email, required this.password});

  final String email;
  final String password;

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class RegisterPayload {
  const RegisterPayload({
    required this.displayName,
    required this.email,
    required this.password,
  });

  final String displayName;
  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
    'displayName': displayName,
    'email': email,
    'password': password,
  };
}

class GoogleLoginPayload {
  const GoogleLoginPayload({required this.idToken});

  final String idToken;

  Map<String, dynamic> toJson() => {'idToken': idToken};
}

class UpdateProfilePayload {
  const UpdateProfilePayload({required this.displayName, required this.email});

  final String displayName;
  final String email;

  Map<String, dynamic> toJson() => {
    'displayName': displayName,
    'email': email,
  };
}

class ChangePasswordPayload {
  const ChangePasswordPayload({
    required this.currentPassword,
    required this.newPassword,
  });

  final String currentPassword;
  final String newPassword;

  Map<String, dynamic> toJson() => {
    'currentPassword': currentPassword,
    'newPassword': newPassword,
  };
}

class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final UserProfile user;

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      user: UserProfile.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }
}
