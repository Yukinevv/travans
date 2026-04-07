package com.travans.backend.service;

import com.travans.backend.api.dto.DashboardSummaryResponse;
import com.travans.backend.domain.TrainingDay;
import com.travans.backend.domain.TrainingDayStatus;
import com.travans.backend.repository.TrainingDayRepository;
import com.travans.backend.repository.TrainingPlanRepository;
import com.travans.backend.security.CurrentUserService;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class DashboardService {

    private final TrainingPlanRepository trainingPlanRepository;
    private final TrainingDayRepository trainingDayRepository;
    private final CurrentUserService currentUserService;
    private final TrainingPlanService trainingPlanService;

    public DashboardService(
            TrainingPlanRepository trainingPlanRepository,
            TrainingDayRepository trainingDayRepository,
            CurrentUserService currentUserService,
            TrainingPlanService trainingPlanService) {
        this.trainingPlanRepository = trainingPlanRepository;
        this.trainingDayRepository = trainingDayRepository;
        this.currentUserService = currentUserService;
        this.trainingPlanService = trainingPlanService;
    }

    @Transactional(readOnly = true)
    public DashboardSummaryResponse getSummary(Long planId) {
        Long userId = currentUserService.requireAuthenticatedUser().getId();
        Optional<com.travans.backend.domain.TrainingPlan> selectedPlan = resolveCurrentPlan(userId, planId);
        List<TrainingDay> days = selectedPlan
                .map(plan -> trainingDayRepository.findByPlanOwnerIdAndPlanIdOrderByScheduledDateAsc(userId, plan.getId()))
                .orElse(List.of());

        long total = days.size();
        long completed = days.stream().filter(day -> day.getStatus() == TrainingDayStatus.COMPLETED).count();
        long partial = days.stream().filter(day -> day.getStatus() == TrainingDayStatus.PARTIALLY_COMPLETED).count();
        long missed = days.stream().filter(day -> day.getStatus() == TrainingDayStatus.MISSED).count();
        double completionRate = total == 0 ? 0 : ((double) completed / (double) total) * 100.0;

        return new DashboardSummaryResponse(
                total,
                completed,
                partial,
                missed,
                completionRate,
                selectedPlan.map(com.travans.backend.domain.TrainingPlan::getId).orElse(null),
                selectedPlan.map(com.travans.backend.domain.TrainingPlan::getName).orElse(null),
                selectedPlan.map(trainingPlanService::toResponse).map(com.travans.backend.api.dto.TrainingPlanResponse::trainingDays).orElse(List.of())
        );
    }

    private Optional<com.travans.backend.domain.TrainingPlan> resolveCurrentPlan(Long userId, Long planId) {
        if (planId != null) {
            return trainingPlanRepository.findByIdAndOwnerId(planId, userId);
        }

        return trainingPlanRepository.findByOwnerId(userId).stream()
                .max(Comparator.comparing(com.travans.backend.domain.TrainingPlan::getStartDate)
                        .thenComparing(com.travans.backend.domain.TrainingPlan::getCreatedAt));
    }
}
