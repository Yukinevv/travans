package com.travans.backend.service;

import com.travans.backend.domain.StravaActivity;
import com.travans.backend.domain.TrainingDay;
import com.travans.backend.domain.TrainingDayStatus;
import org.springframework.stereotype.Service;

@Service
public class TrainingDayEvaluationService {

    public TrainingDayEvaluation evaluate(TrainingDay day, StravaActivity activity) {
        if (activity == null) {
            return new TrainingDayEvaluation(TrainingDayStatus.PLANNED, null, null, null, null, null, null);
        }

        Integer plannedDistance = day.getPlannedDistanceMeters();
        Integer plannedDuration = day.getPlannedDurationSeconds();
        Integer actualDistance = activity.getDistanceMeters();
        Integer actualDuration = activity.getMovingTimeSeconds();

        Boolean distanceGoalMet = plannedDistance == null || actualDistance == null
                ? null
                : actualDistance >= plannedDistance;

        Boolean durationGoalMet = plannedDuration == null || actualDuration == null || plannedDistance != null
                ? null
                : actualDuration >= plannedDuration;

        Boolean paceGoalMet = hasPaceInputs(plannedDistance, plannedDuration, actualDistance, actualDuration)
                ? actualDuration.longValue() * plannedDistance <= plannedDuration.longValue() * actualDistance
                : null;

        boolean completed = meetsDistanceGoal(plannedDistance, actualDistance)
                && meetsDurationGoal(plannedDistance, plannedDuration, actualDuration)
                && meetsPaceGoal(plannedDistance, plannedDuration, actualDistance, actualDuration);

        return new TrainingDayEvaluation(
                completed ? TrainingDayStatus.COMPLETED : TrainingDayStatus.PARTIALLY_COMPLETED,
                distanceGoalMet,
                durationGoalMet,
                paceGoalMet,
                calculateDistanceOver(plannedDistance, actualDistance),
                calculateDurationOver(plannedDistance, plannedDuration, actualDuration),
                calculateTimeSaved(plannedDistance, plannedDuration, actualDistance, actualDuration)
        );
    }

    private boolean meetsDistanceGoal(Integer plannedDistance, Integer actualDistance) {
        return plannedDistance == null || actualDistance == null || actualDistance >= plannedDistance;
    }

    private boolean meetsDurationGoal(Integer plannedDistance, Integer plannedDuration, Integer actualDuration) {
        if (plannedDistance != null) {
            return true;
        }

        return plannedDuration == null || actualDuration == null || actualDuration >= plannedDuration;
    }

    private boolean meetsPaceGoal(Integer plannedDistance, Integer plannedDuration, Integer actualDistance, Integer actualDuration) {
        if (!hasPaceInputs(plannedDistance, plannedDuration, actualDistance, actualDuration)) {
            return true;
        }

        return actualDuration.longValue() * plannedDistance <= plannedDuration.longValue() * actualDistance;
    }

    private boolean hasPaceInputs(Integer plannedDistance, Integer plannedDuration, Integer actualDistance, Integer actualDuration) {
        return plannedDistance != null
                && plannedDuration != null
                && actualDistance != null
                && actualDuration != null
                && plannedDistance > 0
                && plannedDuration > 0
                && actualDistance > 0
                && actualDuration > 0;
    }

    private Integer calculateDistanceOver(Integer plannedDistance, Integer actualDistance) {
        if (plannedDistance == null || actualDistance == null) {
            return null;
        }

        return Math.max(actualDistance - plannedDistance, 0);
    }

    private Integer calculateDurationOver(Integer plannedDistance, Integer plannedDuration, Integer actualDuration) {
        if (plannedDistance != null || plannedDuration == null || actualDuration == null) {
            return null;
        }

        return Math.max(actualDuration - plannedDuration, 0);
    }

    private Integer calculateTimeSaved(Integer plannedDistance, Integer plannedDuration, Integer actualDistance, Integer actualDuration) {
        if (!hasPaceInputs(plannedDistance, plannedDuration, actualDistance, actualDuration)) {
            return null;
        }

        long expectedDurationAtPlannedPace = (long) plannedDuration * actualDistance / plannedDistance;
        return (int) Math.max(expectedDurationAtPlannedPace - actualDuration, 0);
    }
}
