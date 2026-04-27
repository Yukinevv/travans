import '../../../shared/models/activity_type.dart';
import '../../plans/data/plan_models.dart';

class DashboardDetailedStats {
  const DashboardDetailedStats({
    required this.daysMeetingDistanceGoal,
    required this.daysMeetingDurationGoal,
    required this.daysMeetingPaceGoal,
    required this.daysWithExtraDistance,
    required this.daysWithTimeSaved,
    required this.totalDistanceOverMeters,
    required this.totalDurationOverSeconds,
    required this.totalTimeSavedSeconds,
    required this.averageRunPaceSecondsPerKm,
    required this.fastestRunPaceSecondsPerKm,
    required this.averageRideSpeedKph,
    required this.topRideSpeedKph,
    required this.totalElevationGainMeters,
  });

  final int daysMeetingDistanceGoal;
  final int daysMeetingDurationGoal;
  final int daysMeetingPaceGoal;
  final int daysWithExtraDistance;
  final int daysWithTimeSaved;
  final int totalDistanceOverMeters;
  final int totalDurationOverSeconds;
  final int totalTimeSavedSeconds;
  final int? averageRunPaceSecondsPerKm;
  final int? fastestRunPaceSecondsPerKm;
  final double? averageRideSpeedKph;
  final double? topRideSpeedKph;
  final int totalElevationGainMeters;

  factory DashboardDetailedStats.fromJson(Map<String, dynamic> json) {
    return DashboardDetailedStats(
      daysMeetingDistanceGoal:
          (json['daysMeetingDistanceGoal'] as num?)?.toInt() ?? 0,
      daysMeetingDurationGoal:
          (json['daysMeetingDurationGoal'] as num?)?.toInt() ?? 0,
      daysMeetingPaceGoal:
          (json['daysMeetingPaceGoal'] as num?)?.toInt() ?? 0,
      daysWithExtraDistance:
          (json['daysWithExtraDistance'] as num?)?.toInt() ?? 0,
      daysWithTimeSaved: (json['daysWithTimeSaved'] as num?)?.toInt() ?? 0,
      totalDistanceOverMeters:
          (json['totalDistanceOverMeters'] as num?)?.toInt() ?? 0,
      totalDurationOverSeconds:
          (json['totalDurationOverSeconds'] as num?)?.toInt() ?? 0,
      totalTimeSavedSeconds:
          (json['totalTimeSavedSeconds'] as num?)?.toInt() ?? 0,
      averageRunPaceSecondsPerKm:
          (json['averageRunPaceSecondsPerKm'] as num?)?.toInt(),
      fastestRunPaceSecondsPerKm:
          (json['fastestRunPaceSecondsPerKm'] as num?)?.toInt(),
      averageRideSpeedKph:
          (json['averageRideSpeedKph'] as num?)?.toDouble(),
      topRideSpeedKph: (json['topRideSpeedKph'] as num?)?.toDouble(),
      totalElevationGainMeters:
          (json['totalElevationGainMeters'] as num?)?.toInt() ?? 0,
    );
  }
}

class DashboardSummary {
  const DashboardSummary({
    required this.totalPlanned,
    required this.completed,
    required this.partiallyCompleted,
    required this.missed,
    required this.completionRate,
    required this.currentPlanId,
    required this.currentPlanName,
    required this.currentPlanType,
    required this.trainingDays,
    required this.detailedStats,
  });

  final int totalPlanned;
  final int completed;
  final int partiallyCompleted;
  final int missed;
  final double completionRate;
  final int? currentPlanId;
  final String? currentPlanName;
  final ActivityType? currentPlanType;
  final List<TrainingDay> trainingDays;
  final DashboardDetailedStats detailedStats;

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      totalPlanned: (json['totalPlanned'] as num?)?.toInt() ?? 0,
      completed: (json['completed'] as num?)?.toInt() ?? 0,
      partiallyCompleted:
          (json['partiallyCompleted'] as num?)?.toInt() ?? 0,
      missed: (json['missed'] as num?)?.toInt() ?? 0,
      completionRate: (json['completionRate'] as num?)?.toDouble() ?? 0,
      currentPlanId: (json['currentPlanId'] as num?)?.toInt(),
      currentPlanName: json['currentPlanName'] as String?,
      currentPlanType: json['currentPlanType'] == null
          ? null
          : ActivityType.fromApi(json['currentPlanType'] as String?),
      trainingDays:
          (json['trainingDays'] as List<dynamic>? ?? const [])
              .whereType<Map>()
              .map((item) => TrainingDay.fromJson(Map<String, dynamic>.from(item)))
              .toList(),
      detailedStats: DashboardDetailedStats.fromJson(
        json['detailedStats'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }
}
