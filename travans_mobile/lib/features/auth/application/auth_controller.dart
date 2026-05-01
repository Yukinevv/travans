import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/networking/api_exception.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../shared/models/user_profile.dart';
import '../data/auth_models.dart';
import '../data/auth_repository.dart';
import 'auth_state.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((
  ref,
) {
  final controller = AuthController(ref.watch(authRepositoryProvider));
  controller.initialize();
  return controller;
});

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository) : super(AuthState.loading) {
    _sessionSubscription = _repository.sessionEvents.listen((event) {
      if (event == SessionEvent.invalidated) {
        state = AuthState(
          status: AuthStatus.unauthenticated,
          errorMessage: 'errorAuthSessionExpired',
        );
      }
    });
  }

  final AuthRepository _repository;
  StreamSubscription<SessionEvent>? _sessionSubscription;

  Future<void> initialize() async {
    try {
      final session = await _repository.restoreSession();
      if (session == null) {
        state = AuthState.unauthenticated;
        return;
      }

      state = AuthState(status: AuthStatus.authenticated, user: session.user);
      await refreshProfile(silent: true);
    } catch (_) {
      state = AuthState.unauthenticated;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, clearError: true);

    try {
      final session = await _repository.login(
        LoginPayload(email: email, password: password),
        rememberMe: rememberMe,
      );

      state = AuthState(status: AuthStatus.authenticated, user: session.user);
      return true;
    } on ApiException catch (error) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: error.message,
      );
      return false;
    } catch (_) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: 'errorAuthLoginFailed',
      );
      return false;
    }
  }

  Future<bool> register({
    required String displayName,
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, clearError: true);

    try {
      final session = await _repository.register(
        RegisterPayload(
          displayName: displayName,
          email: email,
          password: password,
        ),
        rememberMe: rememberMe,
      );

      state = AuthState(status: AuthStatus.authenticated, user: session.user);
      return true;
    } on ApiException catch (error) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: error.message,
      );
      return false;
    } catch (_) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: 'errorAuthRegisterFailed',
      );
      return false;
    }
  }

  Future<bool> loginWithGoogle({required bool rememberMe}) async {
    state = state.copyWith(status: AuthStatus.loading, clearError: true);

    try {
      final session = await _repository.loginWithGoogle(rememberMe: rememberMe);
      state = AuthState(status: AuthStatus.authenticated, user: session.user);
      return true;
    } on ApiException catch (error) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: error.message,
      );
      return false;
    } catch (_) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: 'errorAuthGoogleFailed',
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = AuthState.unauthenticated;
  }

  Future<void> refreshProfile({bool silent = false}) async {
    if (!silent) {
      state = state.copyWith(status: AuthStatus.loading, clearError: true);
    }

    try {
      final profile = await _repository.me();
      state = AuthState(status: AuthStatus.authenticated, user: profile);
    } on ApiException catch (error) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: error.message,
      );
    } catch (_) {
      state = AuthState.unauthenticated;
    }
  }

  void setAuthenticatedUser(UserProfile user) {
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }

  Future<bool> readRememberMe() {
    return _repository.readRememberMe();
  }

  Future<String?> readRememberedEmail() {
    return _repository.readRememberedEmail();
  }

  @override
  void dispose() {
    _sessionSubscription?.cancel();
    super.dispose();
  }
}
