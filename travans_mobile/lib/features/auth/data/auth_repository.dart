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
          'Logowanie Google zostalo anulowane.',
          code: 'GOOGLE_SIGN_IN_CANCELED',
        );
      }

      final authentication = await account.authentication;
      final idToken = authentication.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw ApiException(
          'Google nie zwrocil tokena ID.',
          code: 'GOOGLE_ID_TOKEN_MISSING',
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
      throw ApiException('Logowanie Google nie powiodlo sie.');
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

    return ApiException('Nie udalo sie wykonac zadania.');
  }

  ApiException _mapGooglePlatformError(PlatformException error) {
    switch (error.code) {
      case GoogleSignIn.kSignInCanceledError:
        return ApiException(
          'Logowanie Google zostalo anulowane.',
          code: error.code,
        );
      case GoogleSignIn.kNetworkError:
        return ApiException(
          'Blad sieci podczas logowania Google. Sprobuj ponownie.',
          code: error.code,
        );
      case GoogleSignIn.kSignInFailedError:
        return ApiException(
          'Logowanie Google nie jest poprawnie skonfigurowane dla Androida. Sprawdz package name, SHA-1 i OAuth client w Google Cloud.',
          code: error.code,
        );
      case GoogleSignIn.kSignInRequiredError:
        return ApiException(
          'Wymagane jest ponowne uruchomienie logowania Google.',
          code: error.code,
        );
      default:
        if ((error.message ?? '').trim().isNotEmpty) {
          return ApiException(error.message!, code: error.code);
        }

        return ApiException(
          'Logowanie Google zakonczylo sie bledem platformy.',
          code: error.code,
        );
    }
  }
}
