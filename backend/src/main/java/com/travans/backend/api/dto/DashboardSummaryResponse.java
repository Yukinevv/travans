package com.travans.backend.api.dto;

import com.travans.backend.domain.ActivityType;
import java.util.List;

public record DashboardSummaryResponse(
        long totalPlanned,
        long completed,
        long partiallyCompleted,
        long missed,
        double completionRate,
        Long currentPlanId,
        String currentPlanName,
        ActivityType currentPlanType,
        List<TrainingDayResponse> trainingDays,
        DashboardDetailedStatsResponse detailedStats
) {
}
