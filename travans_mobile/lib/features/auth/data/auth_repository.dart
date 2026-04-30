import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/config/app_env.dart';
import '../../../core/networking/api_exception.dart';
import '../../../core/networking/api_client.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../shared/models/user_profile.dart';
import 'auth_models.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    dio: ref.watch(dioProvider),
    secureStorageService: ref.watch(secureStorageServiceProvider),
    googleSignIn: GoogleSignIn(
      scopes: const ['email'],
      serverClientId: AppEnv.googleClientId,
    ),
  );
});

class AuthRepository {
  AuthRepository({
    required Dio dio,
    required SecureStorageService secureStorageService,
    required GoogleSignIn googleSignIn,
  }) : _dio = dio,
       _secureStorageService = secureStorageService,
       _googleSignIn = googleSignIn;

  final Dio _dio;
  final SecureStorageService _secureStorageService;
  final GoogleSignIn _googleSignIn;

  Stream<SessionEvent> get sessionEvents => _secureStorageService.sessionEvents;

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

      final session = AuthSession.fromJson(response.data ?? <String, dynamic>{});
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

      final session = AuthSession.fromJson(response.data ?? <String, dynamic>{});
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

  Future<AuthSession> loginWithGoogle({required bool rememberMe}) async {
    try {
      await _googleSignIn.signOut();
      final account = await _googleSignIn.signIn();
      if (account == null) {
        throw ApiException(
          '',
          code: 'errorGoogleSignInCanceled',
        );
      }

      final authentication = await account.authentication;
      final idToken = authentication.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw ApiException(
          '',
          code: 'errorGoogleIdTokenMissing',
        );
      }

      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/google',
        data: GoogleLoginPayload(idToken: idToken).toJson(),
      );

      final session = AuthSession.fromJson(response.data ?? <String, dynamic>{});
      await _secureStorageService.saveSession(session);
      await _secureStorageService.saveRememberMe(rememberMe);
      await _secureStorageService.saveRememberedEmail(
        rememberMe ? session.user.email : null,
      );
      return session;
    } on ApiException {
      rethrow;
    } on PlatformException catch (error) {
      throw _mapGooglePlatformError(error);
    } on DioException catch (error) {
      throw _mapError(error);
    } catch (_) {
      throw ApiException('', code: 'errorAuthGoogleFailed');
    }
  }

  Future<UserProfile> me() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/auth/me');
      final profile = UserProfile.fromJson(
        response.data ?? <String, dynamic>{},
      );
      await _secureStorageService.saveUserProfile(profile);
      return profile;
    } on DioException catch (error) {
      throw _mapError(error);
    }
  }

  Future<void> logout() async {
    await _secureStorageService.clearSession();
    await _googleSignIn.signOut();
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

    return ApiException('', code: 'errorGenericTaskFailed');
  }

  ApiException _mapGooglePlatformError(PlatformException error) {
    switch (error.code) {
      case GoogleSignIn.kSignInCanceledError:
        return ApiException(
          '',
          code: 'errorGoogleSignInCanceled',
        );
      case GoogleSignIn.kNetworkError:
        return ApiException(
          '',
          code: 'errorGoogleNetwork',
        );
      case GoogleSignIn.kSignInFailedError:
        return ApiException(
          '',
          code: 'errorGoogleAndroidConfig',
        );
      case GoogleSignIn.kSignInRequiredError:
        return ApiException(
          '',
          code: 'errorGoogleRestartRequired',
        );
      default:
        if ((error.message ?? '').trim().isNotEmpty) {
          return ApiException(error.message!, code: error.code);
        }

        return ApiException(
          '',
          code: 'errorGooglePlatform',
        );
    }
  }
}
