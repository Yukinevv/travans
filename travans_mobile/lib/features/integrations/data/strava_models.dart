import '../../../shared/models/activity_type.dart';

class StravaConnectionStatus {
  const StravaConnectionStatus({
    required this.connected,
    required this.athleteId,
    required this.lastSyncAt,
    required this.authorizationUrl,
  });

  final bool connected;
  final int? athleteId;
  final DateTime? lastSyncAt;
  final String authorizationUrl;

  factory StravaConnectionStatus.fromJson(Map<String, dynamic> json) {
    return StravaConnectionStatus(
      connected: json['connected'] as bool? ?? false,
      athleteId: (json['athleteId'] as num?)?.toInt(),
      lastSyncAt: json['lastSyncAt'] != null
          ? DateTime.tryParse(json['lastSyncAt'] as String)
          : null,
      authorizationUrl: json['authorizationUrl'] as String? ?? '',
    );
  }
}

class StravaSyncResult {
  const StravaSyncResult({
    required this.athleteId,
    required this.importedActivities,
    required this.matchedTrainingDays,
  });

  final int athleteId;
  final int importedActivities;
  final int matchedTrainingDays;

  factory StravaSyncResult.fromJson(Map<String, dynamic> json) {
    return StravaSyncResult(
      athleteId: (json['athleteId'] as num?)?.toInt() ?? 0,
      importedActivities: (json['importedActivities'] as num?)?.toInt() ?? 0,
      matchedTrainingDays: (json['matchedTrainingDays'] as num?)?.toInt() ?? 0,
    );
  }
}

class StravaActivity {
  const StravaActivity({
    required this.id,
    required this.externalActivityId,
    required this.name,
    required this.activityType,
    required this.activityDate,
    required this.startedAt,
    required this.distanceMeters,
    required this.movingTimeSeconds,
    required this.averageSpeedMetersPerSecond,
    required this.maxSpeedMetersPerSecond,
    required this.elevationGainMeters,
    required this.averageHeartrateBpm,
    required this.maxHeartrateBpm,
    required this.averageCadenceRpm,
    required this.matchedToPlan,
    required this.matchedTrainingDayId,
    required this.matchedTrainingDayTitle,
    required this.matchedPlanId,
    required this.matchedPlanName,
  });

  final int id;
  final int externalActivityId;
  final String name;
  final ActivityType activityType;
  final DateTime? activityDate;
  final DateTime? startedAt;
  final int? distanceMeters;
  final int? movingTimeSeconds;
  final double? averageSpeedMetersPerSecond;
  final double? maxSpeedMetersPerSecond;
  final int? elevationGainMeters;
  final double? averageHeartrateBpm;
  final int? maxHeartrateBpm;
  final double? averageCadenceRpm;
  final bool matchedToPlan;
  final int? matchedTrainingDayId;
  final String? matchedTrainingDayTitle;
  final int? matchedPlanId;
  final String? matchedPlanName;

  factory StravaActivity.fromJson(Map<String, dynamic> json) {
    return StravaActivity(
      id: (json['id'] as num?)?.toInt() ?? 0,
      externalActivityId: (json['externalActivityId'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      activityType: ActivityType.fromApi(json['activityType'] as String?),
      activityDate: json['activityDate'] != null
          ? DateTime.tryParse(json['activityDate'] as String)
          : null,
      startedAt: json['startedAt'] != null
          ? DateTime.tryParse(json['startedAt'] as String)
          : null,
      distanceMeters: (json['distanceMeters'] as num?)?.toInt(),
      movingTimeSeconds: (json['movingTimeSeconds'] as num?)?.toInt(),
      averageSpeedMetersPerSecond: (json['averageSpeedMetersPerSecond'] as num?)
          ?.toDouble(),
      maxSpeedMetersPerSecond: (json['maxSpeedMetersPerSecond'] as num?)
          ?.toDouble(),
      elevationGainMeters: (json['elevationGainMeters'] as num?)?.toInt(),
      averageHeartrateBpm: (json['averageHeartrateBpm'] as num?)?.toDouble(),
      maxHeartrateBpm: (json['maxHeartrateBpm'] as num?)?.toInt(),
      averageCadenceRpm: (json['averageCadenceRpm'] as num?)?.toDouble(),
      matchedToPlan: json['matchedToPlan'] as bool? ?? false,
      matchedTrainingDayId: (json['matchedTrainingDayId'] as num?)?.toInt(),
      matchedTrainingDayTitle: json['matchedTrainingDayTitle'] as String?,
      matchedPlanId: (json['matchedPlanId'] as num?)?.toInt(),
      matchedPlanName: json['matchedPlanName'] as String?,
    );
  }
}
