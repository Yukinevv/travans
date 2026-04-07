package com.travans.backend.service;

import com.travans.backend.api.dto.TrainingDayRequest;
import com.travans.backend.api.dto.TrainingDayResponse;
import com.travans.backend.api.dto.TrainingPlanRequest;
import com.travans.backend.api.dto.TrainingPlanResponse;
import com.travans.backend.domain.TrainingDay;
import com.travans.backend.domain.TrainingDayStatus;
import com.travans.backend.domain.TrainingPlan;
import com.travans.backend.repository.TrainingPlanRepository;
import jakarta.persistence.EntityNotFoundException;
import java.time.Clock;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class TrainingPlanService {

    private final TrainingPlanRepository trainingPlanRepository;
    private final Clock clock;

    public TrainingPlanService(TrainingPlanRepository trainingPlanRepository, Clock clock) {
        this.trainingPlanRepository = trainingPlanRepository;
        this.clock = clock;
    }

    @Transactional(readOnly = true)
    public List<TrainingPlanResponse> getPlans() {
        return trainingPlanRepository.findAll().stream().map(this::toResponse).toList();
    }

    @Transactional(readOnly = true)
    public TrainingPlanResponse getPlan(Long planId) {
        TrainingPlan plan = trainingPlanRepository.findById(planId)
                .orElseThrow(() -> new EntityNotFoundException("Training plan not found: " + planId));
        plan.getTrainingDays().size();
        return toResponse(plan);
    }

    @Transactional
    public TrainingPlanResponse createPlan(TrainingPlanRequest request) {
        TrainingPlan plan = new TrainingPlan();
        plan.setName(request.name());
        plan.setDescription(request.description());
        plan.setStartDate(request.startDate());
        plan.setCreatedAt(clock.instant());

        for (TrainingDayRequest dayRequest : request.trainingDays()) {
            TrainingDay day = new TrainingDay();
            day.setPlan(plan);
            day.setScheduledDate(dayRequest.scheduledDate());
            day.setTitle(dayRequest.title());
            day.setActivityType(dayRequest.activityType());
            day.setPlannedDistanceMeters(dayRequest.plannedDistanceMeters());
            day.setPlannedDurationSeconds(dayRequest.plannedDurationSeconds());
            day.setNotes(dayRequest.notes());
            day.setStatus(TrainingDayStatus.PLANNED);
            plan.getTrainingDays().add(day);
        }

        return toResponse(trainingPlanRepository.save(plan));
    }

    TrainingPlanResponse toResponse(TrainingPlan plan) {
        return new TrainingPlanResponse(
                plan.getId(),
                plan.getName(),
                plan.getDescription(),
                plan.getStartDate(),
                plan.getCreatedAt(),
                plan.getTrainingDays().stream().map(this::toResponse).toList()
        );
    }

    private TrainingDayResponse toResponse(TrainingDay day) {
        return new TrainingDayResponse(
                day.getId(),
                day.getScheduledDate(),
                day.getTitle(),
                day.getActivityType(),
                day.getPlannedDistanceMeters(),
                day.getPlannedDurationSeconds(),
                day.getNotes(),
                day.getStatus(),
                day.getMatchedActivityId()
        );
    }
}
