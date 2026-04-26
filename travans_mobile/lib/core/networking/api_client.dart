import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_env.dart';
import '../storage/secure_storage_service.dart';
import 'auth_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageServiceProvider);
  final refreshDio = Dio(
    BaseOptions(
      baseUrl: AppEnv.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: Headers.jsonContentType,
    ),
  );

  final dio = Dio(
    BaseOptions(
      baseUrl: AppEnv.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: Headers.jsonContentType,
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(
      secureStorageService: storage,
      refreshDio: refreshDio,
      apiBaseUrl: AppEnv.apiBaseUrl,
    ),
  );

  return dio;
});
