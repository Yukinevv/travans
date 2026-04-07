package com.travans.backend.api.dto;

import com.travans.backend.domain.ActivityType;
import java.time.Instant;
import java.time.LocalDate;

public record StravaActivityResponse(
        Long id,
        Long externalActivityId,
        String name,
        ActivityType activityType,
        LocalDate activityDate,
        Instant startedAt,
        Integer distanceMeters,
        Integer movingTimeSeconds,
        boolean matchedToPlan,
        Long matchedTrainingDayId,
        String matchedTrainingDayTitle,
        Long matchedPlanId,
        String matchedPlanName
) {
}
