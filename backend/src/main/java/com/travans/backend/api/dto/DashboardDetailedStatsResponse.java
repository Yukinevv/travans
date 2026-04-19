package com.travans.backend.api.dto;

public record DashboardDetailedStatsResponse(
        long daysMeetingDistanceGoal,
        long daysMeetingDurationGoal,
        long daysMeetingPaceGoal,
        long daysWithExtraDistance,
        long daysWithTimeSaved,
        int totalDistanceOverMeters,
        int totalDurationOverSeconds,
        int totalTimeSavedSeconds
) {
}
