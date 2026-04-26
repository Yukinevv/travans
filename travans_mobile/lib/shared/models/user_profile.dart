class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    required this.displayName,
    required this.avatarUrl,
    required this.role,
    required this.authProvider,
  });

  final int id;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final String role;
  final String authProvider;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      role: json['role'] as String? ?? 'USER',
      authProvider: json['authProvider'] as String? ?? 'LOCAL',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'displayName': displayName,
    'avatarUrl': avatarUrl,
    'role': role,
    'authProvider': authProvider,
  };
}
