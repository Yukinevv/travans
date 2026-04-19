package com.travans.backend.api.dto;

import java.util.List;

public record DashboardSummaryResponse(
        long totalPlanned,
        long completed,
        long partiallyCompleted,
        long missed,
        double completionRate,
        Long currentPlanId,
        String currentPlanName,
        List<TrainingDayResponse> trainingDays,
        DashboardDetailedStatsResponse detailedStats
) {
}
