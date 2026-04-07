package com.travans.backend.api.dto;

public record StravaSyncResponse(
        Long athleteId,
        int importedActivities,
        long matchedTrainingDays
) {
}
