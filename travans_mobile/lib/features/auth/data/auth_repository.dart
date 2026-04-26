import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/networking/api_exception.dart';
import '../../../core/networking/api_client.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../shared/models/user_profile.dart';
import 'auth_models.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    dio: ref.watch(dioProvider),
    secureStorageService: ref.watch(secureStorageServiceProvider),
  );
});

class AuthRepository {
  AuthRepository({
    required Dio dio,
    required SecureStorageService secureStorageService,
  }) : _dio = dio,
       _secureStorageService = secureStorageService;

  final Dio _dio;
  final SecureStorageService _secureStorageService;

  Future<AuthSession?> restoreSession() {
    return _secureStorageService.readSession();
  }

  Future<AuthSession> login(
    LoginPayload payload, {
    required bool rememberMe,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: payload.toJson(),
      );

      final session = AuthSession.fromJson(
        response.data ?? <String, dynamic>{},
      );
      await _secureStorageService.saveSession(session);
      await _secureStorageService.saveRememberMe(rememberMe);
      await _secureStorageService.saveRememberedEmail(
        rememberMe ? payload.email : null,
      );
      return session;
    } on DioException catch (error) {
      throw _mapError(error);
    }
  }

  Future<AuthSession> register(
    RegisterPayload payload, {
    required bool rememberMe,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: payload.toJson(),
      );

      final session = AuthSession.fromJson(
        response.data ?? <String, dynamic>{},
      );
      await _secureStorageService.saveSession(session);
      await _secureStorageService.saveRememberMe(rememberMe);
      await _secureStorageService.saveRememberedEmail(
        rememberMe ? payload.email : null,
      );
      return session;
    } on DioException catch (error) {
      throw _mapError(error);
    }
  }

  Future<UserProfile> me() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/auth/me');
      return UserProfile.fromJson(response.data ?? <String, dynamic>{});
    } on DioException catch (error) {
      throw _mapError(error);
    }
  }

  Future<void> logout() async {
    await _secureStorageService.clearSession();
  }

  Future<bool> readRememberMe() {
    return _secureStorageService.readRememberMe();
  }

  Future<String?> readRememberedEmail() {
    return _secureStorageService.readRememberedEmail();
  }

  ApiException _mapError(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'] as String?;
      final code = data['code'] as String?;
      if (message != null && message.isNotEmpty) {
        return ApiException(message, code: code);
      }
    }

    return ApiException('Request failed');
  }
}
