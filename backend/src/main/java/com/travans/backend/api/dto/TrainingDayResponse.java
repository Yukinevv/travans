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
        Long matchedActivityId
) {
}
