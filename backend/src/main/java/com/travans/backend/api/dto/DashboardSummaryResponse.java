package com.travans.backend.api.dto;

public record DashboardSummaryResponse(
        long totalPlanned,
        long completed,
        long partiallyCompleted,
        long missed,
        double completionRate
) {
}
