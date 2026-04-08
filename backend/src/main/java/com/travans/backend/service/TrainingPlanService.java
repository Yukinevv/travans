package com.travans.backend.service;

import com.travans.backend.api.dto.TrainingDayRequest;
import com.travans.backend.api.dto.TrainingDayResponse;
import com.travans.backend.api.dto.TrainingPlanRequest;
import com.travans.backend.api.dto.TrainingPlanResponse;
import com.travans.backend.domain.StravaActivity;
import com.travans.backend.domain.TrainingDay;
import com.travans.backend.domain.TrainingDayStatus;
import com.travans.backend.domain.TrainingPlan;
import com.travans.backend.repository.StravaActivityRepository;
import com.travans.backend.repository.TrainingPlanRepository;
import com.travans.backend.security.CurrentUserService;
import jakarta.persistence.EntityNotFoundException;
import java.time.Clock;
import java.util.List;
import java.util.Optional;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class TrainingPlanService {

    private final TrainingPlanRepository trainingPlanRepository;
    private final StravaActivityRepository stravaActivityRepository;
    private final CurrentUserService currentUserService;
    private final Clock clock;

    public TrainingPlanService(
            TrainingPlanRepository trainingPlanRepository,
            StravaActivityRepository stravaActivityRepository,
            CurrentUserService currentUserService,
            Clock clock) {
        this.trainingPlanRepository = trainingPlanRepository;
        this.stravaActivityRepository = stravaActivityRepository;
        this.currentUserService = currentUserService;
        this.clock = clock;
    }

    @Transactional(readOnly = true)
    public List<TrainingPlanResponse> getPlans() {
        Long userId = currentUserService.requireAuthenticatedUser().getId();
        return trainingPlanRepository.findByOwnerId(userId).stream().map(this::toResponse).toList();
    }

    @Transactional(readOnly = true)
    public TrainingPlanResponse getPlan(Long planId) {
        Long userId = currentUserService.requireAuthenticatedUser().getId();
        TrainingPlan plan = trainingPlanRepository.findByIdAndOwnerId(planId, userId)
                .orElseThrow(() -> new EntityNotFoundException("Training plan not found: " + planId));
        return toResponse(plan);
    }

    @Transactional
    public TrainingPlanResponse createPlan(TrainingPlanRequest request) {
        TrainingPlan plan = new TrainingPlan();
        plan.setOwner(currentUserService.requireCurrentUserEntity());
        plan.setName(request.name());
        plan.setDescription(request.description());
        plan.setStartDate(request.startDate());
        plan.setStravaEvaluationStartDate(
                request.stravaEvaluationStartDate() != null ? request.stravaEvaluationStartDate() : request.startDate()
        );
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
        Long userId = plan.getOwner().getId();
        return new TrainingPlanResponse(
                plan.getId(),
                plan.getName(),
                plan.getDescription(),
                plan.getStartDate(),
                Optional.ofNullable(plan.getStravaEvaluationStartDate()).orElse(plan.getStartDate()),
                plan.getCreatedAt(),
                plan.getTrainingDays().stream().map(day -> toResponse(userId, day)).toList()
        );
    }

    private TrainingDayResponse toResponse(Long userId, TrainingDay day) {
        Optional<StravaActivity> matchedActivity = day.getMatchedActivityId() == null
                ? Optional.empty()
                : stravaActivityRepository.findByUserIdAndExternalActivityId(userId, day.getMatchedActivityId());

        return new TrainingDayResponse(
                day.getId(),
                day.getScheduledDate(),
                day.getTitle(),
                day.getActivityType(),
                day.getPlannedDistanceMeters(),
                day.getPlannedDurationSeconds(),
                day.getNotes(),
                day.getStatus(),
                day.getMatchedActivityId(),
                matchedActivity.map(StravaActivity::getName).orElse(null),
                matchedActivity.map(StravaActivity::getActivityDate).orElse(null),
                matchedActivity.map(StravaActivity::getDistanceMeters).orElse(null),
                matchedActivity.map(StravaActivity::getMovingTimeSeconds).orElse(null)
        );
    }
}
