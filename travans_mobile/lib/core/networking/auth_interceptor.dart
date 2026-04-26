import 'package:dio/dio.dart';

import '../../features/auth/data/auth_models.dart';
import '../storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required SecureStorageService secureStorageService,
    required Dio refreshDio,
    required String apiBaseUrl,
  }) : _secureStorageService = secureStorageService,
       _refreshDio = refreshDio,
       _apiBaseUrl = apiBaseUrl;

  final SecureStorageService _secureStorageService;
  final Dio _refreshDio;
  final String _apiBaseUrl;

  bool _refreshInFlight = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _secureStorageService.readAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final isAuthEndpoint = err.requestOptions.path.contains('/auth/');
    final refreshToken = await _secureStorageService.readRefreshToken();

    if (!isUnauthorized ||
        isAuthEndpoint ||
        refreshToken == null ||
        _refreshInFlight) {
      handler.next(err);
      return;
    }

    _refreshInFlight = true;

    try {
      final response = await _refreshDio.post<Map<String, dynamic>>(
        '$_apiBaseUrl/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final session = AuthSession.fromJson(
        response.data ?? <String, dynamic>{},
      );
      await _secureStorageService.saveSession(session);

      final retryOptions = err.requestOptions;
      retryOptions.headers['Authorization'] = 'Bearer ${session.accessToken}';

      final retriedResponse = await _refreshDio.fetch<dynamic>(retryOptions);
      handler.resolve(retriedResponse);
    } catch (_) {
      await _secureStorageService.clearSession();
      handler.next(err);
    } finally {
      _refreshInFlight = false;
    }
  }
}
