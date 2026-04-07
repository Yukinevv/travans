package com.travans.backend.api.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;
import java.util.List;

public record TrainingPlanRequest(
        @NotBlank String name,
        String description,
        @NotNull LocalDate startDate,
        @Valid @NotEmpty List<TrainingDayRequest> trainingDays
) {
}
