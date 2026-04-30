import '../../../shared/models/activity_type.dart';
import '../../../shared/models/training_day_status.dart';

class TrainingPlan {
  const TrainingPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.stravaEvaluationStartDate,
    required this.planType,
    required this.createdAt,
    required this.trainingDays,
  });

  final int id;
  final String name;
  final String? description;
  final DateTime? startDate;
  final DateTime? stravaEvaluationStartDate;
  final ActivityType planType;
  final DateTime? createdAt;
  final List<TrainingDay> trainingDays;

  factory TrainingPlan.fromJson(Map<String, dynamic> json) {
    return TrainingPlan(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      startDate: _parseDate(json['startDate'] as String?),
      stravaEvaluationStartDate: _parseDate(
        json['stravaEvaluationStartDate'] as String?,
      ),
      planType: ActivityType.fromApi(json['planType'] as String?),
      createdAt: _parseDateTime(json['createdAt'] as String?),
      trainingDays:
          (json['trainingDays'] as List<dynamic>? ?? const [])
              .whereType<Map>()
              .map((item) => TrainingDay.fromJson(Map<String, dynamic>.from(item)))
              .toList(),
    );
  }
}

class TrainingPlanUpsertPayload {
  const TrainingPlanUpsertPayload({
    required this.name,
    required this.description,
    required this.startDate,
    required this.stravaEvaluationStartDate,
    required this.planType,
    required this.trainingDays,
  });

  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime? stravaEvaluationStartDate;
  final ActivityType planType;
  final List<TrainingDayUpsertPayload> trainingDays;

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description?.trim().isEmpty ?? true ? null : description,
    'startDate': _formatDateOnly(startDate),
    'stravaEvaluationStartDate': stravaEvaluationStartDate == null
        ? null
        : _formatDateOnly(stravaEvaluationStartDate!),
    'planType': planType.apiValue,
    'trainingDays': trainingDays.map((day) => day.toJson()).toList(),
  };
}

class TrainingDayUpsertPayload {
  const TrainingDayUpsertPayload({
    required this.scheduledDate,
    required this.title,
    required this.activityType,
    required this.plannedDistanceMeters,
    required this.plannedDurationSeconds,
    required this.notes,
  });

  final DateTime scheduledDate;
  final String title;
  final ActivityType activityType;
  final int? plannedDistanceMeters;
  final int? plannedDurationSeconds;
  final String? notes;

  Map<String, dynamic> toJson() => {
    'scheduledDate': _formatDateOnly(scheduledDate),
    'title': title,
    'activityType': activityType.apiValue,
    'plannedDistanceMeters': plannedDistanceMeters,
    'plannedDurationSeconds': plannedDurationSeconds,
    'notes': notes?.trim().isEmpty ?? true ? null : notes,
  };
}

class TrainingDay {
  const TrainingDay({
    required this.id,
    required this.scheduledDate,
    required this.title,
    required this.activityType,
    required this.plannedDistanceMeters,
    required this.plannedDurationSeconds,
    required this.notes,
    required this.status,
    required this.matchedActivityId,
    required this.matchedActivityName,
    required this.matchedActivityDate,
    required this.matchedDistanceMeters,
    required this.matchedMovingTimeSeconds,
    required this.matchedAverageSpeedMetersPerSecond,
    required this.matchedMaxSpeedMetersPerSecond,
    required this.matchedElevationGainMeters,
    required this.matchedAverageHeartrateBpm,
    required this.matchedMaxHeartrateBpm,
    required this.matchedAverageCadenceRpm,
    required this.distanceGoalMet,
    required this.durationGoalMet,
    required this.paceGoalMet,
    required this.distanceOverMeters,
    required this.durationOverSeconds,
    required this.timeSavedSeconds,
  });

  final int? id;
  final DateTime? scheduledDate;
  final String title;
  final ActivityType activityType;
  final int? plannedDistanceMeters;
  final int? plannedDurationSeconds;
  final String? notes;
  final TrainingDayStatus status;
  final int? matchedActivityId;
  final String? matchedActivityName;
  final DateTime? matchedActivityDate;
  final int? matchedDistanceMeters;
  final int? matchedMovingTimeSeconds;
  final double? matchedAverageSpeedMetersPerSecond;
  final double? matchedMaxSpeedMetersPerSecond;
  final int? matchedElevationGainMeters;
  final double? matchedAverageHeartrateBpm;
  final int? matchedMaxHeartrateBpm;
  final double? matchedAverageCadenceRpm;
  final bool? distanceGoalMet;
  final bool? durationGoalMet;
  final bool? paceGoalMet;
  final int? distanceOverMeters;
  final int? durationOverSeconds;
  final int? timeSavedSeconds;

  factory TrainingDay.fromJson(Map<String, dynamic> json) {
    return TrainingDay(
      id: (json['id'] as num?)?.toInt(),
      scheduledDate: _parseDate(json['scheduledDate'] as String?),
      title: json['title'] as String? ?? '',
      activityType: ActivityType.fromApi(json['activityType'] as String?),
      plannedDistanceMeters: (json['plannedDistanceMeters'] as num?)?.toInt(),
      plannedDurationSeconds:
          (json['plannedDurationSeconds'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      status: TrainingDayStatus.fromApi(json['status'] as String?),
      matchedActivityId: (json['matchedActivityId'] as num?)?.toInt(),
      matchedActivityName: json['matchedActivityName'] as String?,
      matchedActivityDate: _parseDate(json['matchedActivityDate'] as String?),
      matchedDistanceMeters: (json['matchedDistanceMeters'] as num?)?.toInt(),
      matchedMovingTimeSeconds:
          (json['matchedMovingTimeSeconds'] as num?)?.toInt(),
      matchedAverageSpeedMetersPerSecond:
          (json['matchedAverageSpeedMetersPerSecond'] as num?)?.toDouble(),
      matchedMaxSpeedMetersPerSecond:
          (json['matchedMaxSpeedMetersPerSecond'] as num?)?.toDouble(),
      matchedElevationGainMeters:
          (json['matchedElevationGainMeters'] as num?)?.toInt(),
      matchedAverageHeartrateBpm:
          (json['matchedAverageHeartrateBpm'] as num?)?.toDouble(),
      matchedMaxHeartrateBpm:
          (json['matchedMaxHeartrateBpm'] as num?)?.toInt(),
      matchedAverageCadenceRpm:
          (json['matchedAverageCadenceRpm'] as num?)?.toDouble(),
      distanceGoalMet: json['distanceGoalMet'] as bool?,
      durationGoalMet: json['durationGoalMet'] as bool?,
      paceGoalMet: json['paceGoalMet'] as bool?,
      distanceOverMeters: (json['distanceOverMeters'] as num?)?.toInt(),
      durationOverSeconds: (json['durationOverSeconds'] as num?)?.toInt(),
      timeSavedSeconds: (json['timeSavedSeconds'] as num?)?.toInt(),
    );
  }
}

DateTime? _parseDate(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }

  return DateTime.tryParse(value);
}

DateTime? _parseDateTime(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }

  return DateTime.tryParse(value);
}

String _formatDateOnly(DateTime value) {
  final normalized = DateTime(value.year, value.month, value.day);
  final year = normalized.year.toString().padLeft(4, '0');
  final month = normalized.month.toString().padLeft(2, '0');
  final day = normalized.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
