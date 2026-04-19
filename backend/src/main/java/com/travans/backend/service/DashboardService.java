package com.travans.backend.service;

import com.travans.backend.api.dto.DashboardSummaryResponse;
import com.travans.backend.api.dto.DashboardDetailedStatsResponse;
import com.travans.backend.api.dto.TrainingDayResponse;
import com.travans.backend.domain.ActivityType;
import com.travans.backend.domain.TrainingDay;
import com.travans.backend.domain.TrainingDayStatus;
import com.travans.backend.repository.TrainingDayRepository;
import com.travans.backend.repository.TrainingPlanRepository;
import com.travans.backend.security.CurrentUserService;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class DashboardService {

    private final TrainingPlanRepository trainingPlanRepository;
    private final TrainingDayRepository trainingDayRepository;
    private final CurrentUserService currentUserService;
    private final TrainingPlanService trainingPlanService;

    public DashboardService(
            TrainingPlanRepository trainingPlanRepository,
            TrainingDayRepository trainingDayRepository,
            CurrentUserService currentUserService,
            TrainingPlanService trainingPlanService) {
        this.trainingPlanRepository = trainingPlanRepository;
        this.trainingDayRepository = trainingDayRepository;
        this.currentUserService = currentUserService;
        this.trainingPlanService = trainingPlanService;
    }

    @Transactional(readOnly = true)
    public DashboardSummaryResponse getSummary(Long planId) {
        Long userId = currentUserService.requireAuthenticatedUser().getId();
        Optional<com.travans.backend.domain.TrainingPlan> selectedPlan = resolveCurrentPlan(userId, planId);
        List<TrainingDay> days = selectedPlan
                .map(plan -> trainingDayRepository.findByPlanOwnerIdAndPlanIdOrderByScheduledDateAsc(userId, plan.getId()))
                .orElse(List.of());

        long total = days.size();
        long completed = days.stream().filter(day -> day.getStatus() == TrainingDayStatus.COMPLETED).count();
        long partial = days.stream().filter(day -> day.getStatus() == TrainingDayStatus.PARTIALLY_COMPLETED).count();
        long missed = days.stream().filter(day -> day.getStatus() == TrainingDayStatus.MISSED).count();
        double completionRate = total == 0 ? 0 : ((double) completed / (double) total) * 100.0;
        List<TrainingDayResponse> trainingDays = selectedPlan
                .map(trainingPlanService::toResponse)
                .map(com.travans.backend.api.dto.TrainingPlanResponse::trainingDays)
                .orElse(List.of());

        return new DashboardSummaryResponse(
                total,
                completed,
                partial,
                missed,
                completionRate,
                selectedPlan.map(com.travans.backend.domain.TrainingPlan::getId).orElse(null),
                selectedPlan.map(com.travans.backend.domain.TrainingPlan::getName).orElse(null),
                selectedPlan.map(trainingPlanService::resolvePlanType).orElse(null),
                trainingDays,
                buildDetailedStats(trainingDays)
        );
    }

    private DashboardDetailedStatsResponse buildDetailedStats(List<TrainingDayResponse> trainingDays) {
        long daysMeetingDistanceGoal = trainingDays.stream().filter(day -> Boolean.TRUE.equals(day.distanceGoalMet())).count();
        long daysMeetingDurationGoal = trainingDays.stream().filter(day -> Boolean.TRUE.equals(day.durationGoalMet())).count();
        long daysMeetingPaceGoal = trainingDays.stream().filter(day -> Boolean.TRUE.equals(day.paceGoalMet())).count();
        long daysWithExtraDistance = trainingDays.stream().filter(day -> getSafeValue(day.distanceOverMeters()) > 0).count();
        long daysWithTimeSaved = trainingDays.stream().filter(day -> getSafeValue(day.timeSavedSeconds()) > 0).count();
        int totalDistanceOverMeters = trainingDays.stream().mapToInt(day -> getSafeValue(day.distanceOverMeters())).sum();
        int totalDurationOverSeconds = trainingDays.stream().mapToInt(day -> getSafeValue(day.durationOverSeconds())).sum();
        int totalTimeSavedSeconds = trainingDays.stream().mapToInt(day -> getSafeValue(day.timeSavedSeconds())).sum();
        int totalElevationGainMeters = trainingDays.stream().mapToInt(day -> getSafeValue(day.matchedElevationGainMeters())).sum();
        Integer averageRunPaceSecondsPerKm = calculateAverageRunPace(trainingDays);
        Integer fastestRunPaceSecondsPerKm = calculateFastestRunPace(trainingDays);
        Double averageRideSpeedKph = calculateAverageRideSpeed(trainingDays);
        Double topRideSpeedKph = calculateTopRideSpeed(trainingDays);

        return new DashboardDetailedStatsResponse(
                daysMeetingDistanceGoal,
                daysMeetingDurationGoal,
                daysMeetingPaceGoal,
                daysWithExtraDistance,
                daysWithTimeSaved,
                totalDistanceOverMeters,
                totalDurationOverSeconds,
                totalTimeSavedSeconds,
                averageRunPaceSecondsPerKm,
                fastestRunPaceSecondsPerKm,
                averageRideSpeedKph,
                topRideSpeedKph,
                totalElevationGainMeters
        );
    }

    private int getSafeValue(Integer value) {
        return value == null ? 0 : value;
    }

    private Integer calculateAverageRunPace(List<TrainingDayResponse> trainingDays) {
        long totalDistance = trainingDays.stream()
                .filter(day -> day.activityType() == ActivityType.RUN)
                .mapToLong(day -> getSafeValue(day.matchedDistanceMeters()))
                .sum();
        long totalTime = trainingDays.stream()
                .filter(day -> day.activityType() == ActivityType.RUN)
                .mapToLong(day -> getSafeValue(day.matchedMovingTimeSeconds()))
                .sum();

        if (totalDistance <= 0 || totalTime <= 0) {
            return null;
        }

        return (int) Math.round((double) totalTime * 1000.0 / totalDistance);
    }

    private Integer calculateFastestRunPace(List<TrainingDayResponse> trainingDays) {
        return trainingDays.stream()
                .filter(day -> day.activityType() == ActivityType.RUN)
                .filter(day -> getSafeValue(day.matchedDistanceMeters()) > 0 && getSafeValue(day.matchedMovingTimeSeconds()) > 0)
                .map(day -> (int) Math.round((double) day.matchedMovingTimeSeconds() * 1000.0 / day.matchedDistanceMeters()))
                .min(Integer::compareTo)
                .orElse(null);
    }

    private Double calculateAverageRideSpeed(List<TrainingDayResponse> trainingDays) {
        long totalDistance = trainingDays.stream()
                .filter(day -> day.activityType() == ActivityType.RIDE)
                .mapToLong(day -> getSafeValue(day.matchedDistanceMeters()))
                .sum();
        long totalTime = trainingDays.stream()
                .filter(day -> day.activityType() == ActivityType.RIDE)
                .mapToLong(day -> getSafeValue(day.matchedMovingTimeSeconds()))
                .sum();

        if (totalDistance <= 0 || totalTime <= 0) {
            return null;
        }

        return ((double) totalDistance / (double) totalTime) * 3.6;
    }

    private Double calculateTopRideSpeed(List<TrainingDayResponse> trainingDays) {
        return trainingDays.stream()
                .filter(day -> day.activityType() == ActivityType.RIDE)
                .map(TrainingDayResponse::matchedMaxSpeedMetersPerSecond)
                .filter(value -> value != null && value > 0)
                .map(value -> value * 3.6)
                .max(Double::compareTo)
                .orElse(null);
    }

    private Optional<com.travans.backend.domain.TrainingPlan> resolveCurrentPlan(Long userId, Long planId) {
        if (planId != null) {
            return trainingPlanRepository.findByIdAndOwnerId(planId, userId);
        }

        return trainingPlanRepository.findByOwnerId(userId).stream()
                .max(Comparator.comparing(com.travans.backend.domain.TrainingPlan::getStartDate)
                        .thenComparing(com.travans.backend.domain.TrainingPlan::getCreatedAt));
    }
}
