package com.travans.backend.service;

import com.travans.backend.api.dto.DashboardSummaryResponse;
import com.travans.backend.domain.TrainingDay;
import com.travans.backend.domain.TrainingDayStatus;
import com.travans.backend.repository.TrainingDayRepository;
import com.travans.backend.repository.TrainingPlanRepository;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class DashboardService {

    private final TrainingPlanRepository trainingPlanRepository;
    private final TrainingDayRepository trainingDayRepository;

    public DashboardService(TrainingPlanRepository trainingPlanRepository, TrainingDayRepository trainingDayRepository) {
        this.trainingPlanRepository = trainingPlanRepository;
        this.trainingDayRepository = trainingDayRepository;
    }

    @Transactional(readOnly = true)
    public DashboardSummaryResponse getSummary(Long planId) {
        List<TrainingDay> days = planId == null
                ? trainingPlanRepository.findAll().stream().flatMap(plan -> plan.getTrainingDays().stream()).toList()
                : trainingDayRepository.findByPlanIdOrderByScheduledDateAsc(planId);

        long total = days.size();
        long completed = days.stream().filter(day -> day.getStatus() == TrainingDayStatus.COMPLETED).count();
        long partial = days.stream().filter(day -> day.getStatus() == TrainingDayStatus.PARTIALLY_COMPLETED).count();
        long missed = days.stream().filter(day -> day.getStatus() == TrainingDayStatus.MISSED).count();
        double completionRate = total == 0 ? 0 : ((double) completed / (double) total) * 100.0;

        return new DashboardSummaryResponse(total, completed, partial, missed, completionRate);
    }
}
