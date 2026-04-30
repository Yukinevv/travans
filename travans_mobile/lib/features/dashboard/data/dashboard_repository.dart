import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/networking/api_client.dart';
import '../../../core/networking/api_endpoints.dart';
import '../../../core/networking/api_exception.dart';
import 'dashboard_models.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.watch(dioProvider));
});

class DashboardRepository {
  DashboardRepository(this._dio);

  final Dio _dio;

  Future<DashboardSummary> getSummary({int? planId}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.dashboard.summary,
        queryParameters: planId == null ? null : {'planId': planId},
      );

      return DashboardSummary.fromJson(response.data ?? const {});
    } on DioException catch (error) {
      throw _mapError(error, 'errorDashboardSummaryLoad');
    }
  }

  ApiException _mapError(DioException error, String fallback) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'] as String?;
      final code = data['code'] as String?;
      if (message != null && message.trim().isNotEmpty) {
        return ApiException(message, code: code);
      }
    }

    return ApiException('', code: fallback);
  }
}
