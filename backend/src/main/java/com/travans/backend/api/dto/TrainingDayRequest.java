package com.travans.backend.api.dto;

import com.travans.backend.domain.ActivityType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;

public record TrainingDayRequest(
        @NotNull LocalDate scheduledDate,
        @NotBlank String title,
        @NotNull ActivityType activityType,
        Integer plannedDistanceMeters,
        Integer plannedDurationSeconds,
        String notes
) {
}
