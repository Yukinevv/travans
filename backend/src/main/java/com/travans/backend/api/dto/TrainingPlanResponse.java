package com.travans.backend.api.dto;

import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

public record TrainingPlanResponse(
        Long id,
        String name,
        String description,
        LocalDate startDate,
        Instant createdAt,
        List<TrainingDayResponse> trainingDays
) {
}
