import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/data/auth_models.dart';
import '../../shared/models/user_profile.dart';

final secureStorageServiceProvider = Provider(
  (ref) => const SecureStorageService(FlutterSecureStorage()),
);

class SecureStorageService {
  const SecureStorageService(this._storage);

  static const _accessTokenKey = 'travans_access_token';
  static const _refreshTokenKey = 'travans_refresh_token';
  static const _profileKey = 'travans_user_profile';
  static const _rememberMeKey = 'travans_remember_me';
  static const _rememberedEmailKey = 'travans_remembered_email';

  final FlutterSecureStorage _storage;

  Future<void> saveSession(AuthSession session) async {
    await _storage.write(key: _accessTokenKey, value: session.accessToken);
    await _storage.write(key: _refreshTokenKey, value: session.refreshToken);
    await _storage.write(
      key: _profileKey,
      value: jsonEncode(session.user.toJson()),
    );
  }

  Future<AuthSession?> readSession() async {
    final accessToken = await _storage.read(key: _accessTokenKey);
    final refreshToken = await _storage.read(key: _refreshTokenKey);
    final profileRaw = await _storage.read(key: _profileKey);

    if (accessToken == null || refreshToken == null || profileRaw == null) {
      return null;
    }

    return AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: UserProfile.fromJson(
        jsonDecode(profileRaw) as Map<String, dynamic>,
      ),
    );
  }

  Future<void> clearSession() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _profileKey);
  }

  Future<void> saveRememberMe(bool rememberMe) async {
    await _storage.write(
      key: _rememberMeKey,
      value: rememberMe ? 'true' : 'false',
    );
  }

  Future<void> saveRememberedEmail(String? email) async {
    if (email == null || email.isEmpty) {
      await _storage.delete(key: _rememberedEmailKey);
      return;
    }

    await _storage.write(key: _rememberedEmailKey, value: email);
  }

  Future<bool> readRememberMe() async {
    final value = await _storage.read(key: _rememberMeKey);
    return value == 'true';
  }

  Future<String?> readRememberedEmail() {
    return _storage.read(key: _rememberedEmailKey);
  }

  Future<String?> readAccessToken() {
    return _storage.read(key: _accessTokenKey);
  }

  Future<String?> readRefreshToken() {
    return _storage.read(key: _refreshTokenKey);
  }
}
