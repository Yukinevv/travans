import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/networking/api_client.dart';
import '../../../core/networking/api_endpoints.dart';
import '../../../core/networking/api_exception.dart';
import 'plan_models.dart';

final plansRepositoryProvider = Provider<PlansRepository>((ref) {
  return PlansRepository(ref.watch(dioProvider));
});

class PlansRepository {
  PlansRepository(this._dio);

  final Dio _dio;

  Future<List<TrainingPlan>> getPlans() async {
    try {
      final response = await _dio.get<List<dynamic>>(ApiEndpoints.plans.collection);

      return (response.data ?? const [])
          .whereType<Map>()
          .map((item) => TrainingPlan.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on DioException catch (error) {
      throw _mapError(error, 'errorPlansListLoad');
    }
  }

  Future<TrainingPlan> getPlan(int planId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.plans.detail(planId),
      );
      return TrainingPlan.fromJson(response.data ?? const {});
    } on DioException catch (error) {
      throw _mapError(error, 'errorPlanLoad');
    }
  }

  Future<TrainingPlan> createPlan(TrainingPlanUpsertPayload payload) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.plans.collection,
        data: payload.toJson(),
      );
      return TrainingPlan.fromJson(response.data ?? const {});
    } on DioException catch (error) {
      throw _mapError(error, 'errorPlanCreate');
    }
  }

  Future<TrainingPlan> updatePlan(
    int planId,
    TrainingPlanUpsertPayload payload,
  ) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        ApiEndpoints.plans.detail(planId),
        data: payload.toJson(),
      );
      return TrainingPlan.fromJson(response.data ?? const {});
    } on DioException catch (error) {
      throw _mapError(error, 'errorPlanUpdate');
    }
  }

  Future<void> deletePlan(int planId) async {
    try {
      await _dio.delete<void>(ApiEndpoints.plans.detail(planId));
    } on DioException catch (error) {
      throw _mapError(error, 'errorPlanDelete');
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
