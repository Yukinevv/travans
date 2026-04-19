package com.travans.backend.api.dto;

import com.travans.backend.domain.ActivityType;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

public record TrainingPlanResponse(
        Long id,
        String name,
        String description,
        LocalDate startDate,
        LocalDate stravaEvaluationStartDate,
        ActivityType planType,
        Instant createdAt,
        List<TrainingDayResponse> trainingDays
) {
}
