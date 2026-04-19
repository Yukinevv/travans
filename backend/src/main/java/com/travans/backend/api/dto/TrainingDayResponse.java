package com.travans.backend.api.dto;

import com.travans.backend.domain.ActivityType;
import com.travans.backend.domain.TrainingDayStatus;
import java.time.LocalDate;

public record TrainingDayResponse(
        Long id,
        LocalDate scheduledDate,
        String title,
        ActivityType activityType,
        Integer plannedDistanceMeters,
        Integer plannedDurationSeconds,
        String notes,
        TrainingDayStatus status,
        Long matchedActivityId,
        String matchedActivityName,
        LocalDate matchedActivityDate,
        Integer matchedDistanceMeters,
        Integer matchedMovingTimeSeconds,
        Double matchedAverageSpeedMetersPerSecond,
        Double matchedMaxSpeedMetersPerSecond,
        Integer matchedElevationGainMeters,
        Double matchedAverageHeartrateBpm,
        Integer matchedMaxHeartrateBpm,
        Double matchedAverageCadenceRpm,
        Boolean distanceGoalMet,
        Boolean durationGoalMet,
        Boolean paceGoalMet,
        Integer distanceOverMeters,
        Integer durationOverSeconds,
        Integer timeSavedSeconds
) {
}
