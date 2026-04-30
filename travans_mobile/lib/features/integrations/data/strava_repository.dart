import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/networking/api_exception.dart';
import '../../../core/networking/api_client.dart';
import '../../../shared/models/activity_type.dart';
import 'strava_models.dart';

final stravaRepositoryProvider = Provider<StravaRepository>((ref) {
  return StravaRepository(dio: ref.watch(dioProvider), appLinks: AppLinks());
});

class StravaRepository {
  StravaRepository({required Dio dio, required AppLinks appLinks})
    : _dio = dio,
      _appLinks = appLinks;

  final Dio _dio;
  final AppLinks _appLinks;

  Stream<Uri> get incomingLinks => _appLinks.uriLinkStream;

  Future<Uri?> getInitialLink() {
    return _appLinks.getInitialLink();
  }

  Future<StravaConnectionStatus> getStatus() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/integrations/strava/status',
        queryParameters: const {'platform': 'mobile'},
      );
      return StravaConnectionStatus.fromJson(response.data ?? {});
    } on DioException catch (error) {
      throw _mapError(error, fallback: 'errorStravaStatusLoad');
    }
  }

  Future<List<StravaActivity>> getActivities({
    ActivityType? activityType,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/integrations/strava/activities',
        queryParameters: activityType == null
            ? null
            : {'activityType': activityType.apiValue},
      );

      return (response.data ?? [])
          .whereType<Map>()
          .map(
            (item) => StravaActivity.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    } on DioException catch (error) {
      throw _mapError(
        error,
        fallback: 'errorStravaActivitiesLoad',
      );
    }
  }

  Future<StravaActivity> getActivity(int activityId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/integrations/strava/activities/$activityId',
      );
      return StravaActivity.fromJson(response.data ?? {});
    } on DioException catch (error) {
      throw _mapError(
        error,
        fallback: 'errorStravaActivityLoad',
      );
    }
  }

  Future<void> exchangeToken(String code) async {
    try {
      await _dio.post<void>(
        '/integrations/strava/exchange-token',
        queryParameters: {'code': code},
      );
    } on DioException catch (error) {
      throw _mapError(
        error,
        fallback: 'errorStravaExchange',
      );
    }
  }

  Future<StravaSyncResult> sync(int athleteId) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        '/integrations/strava/sync',
        queryParameters: {'athleteId': athleteId},
      );
      return StravaSyncResult.fromJson(response.data ?? {});
    } on DioException catch (error) {
      throw _mapError(
        error,
        fallback: 'errorStravaSync',
      );
    }
  }

  Future<void> openAuthorizationUrl(String authorizationUrl) async {
    final uri = Uri.parse(authorizationUrl);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened) {
      throw ApiException('', code: 'errorStravaOpenLogin');
    }
  }

  ApiException _mapError(DioException error, {required String fallback}) {
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
