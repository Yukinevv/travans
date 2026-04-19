package com.travans.backend.service;

import com.travans.backend.domain.TrainingDayStatus;

record TrainingDayEvaluation(
        TrainingDayStatus status,
        Boolean distanceGoalMet,
        Boolean durationGoalMet,
        Boolean paceGoalMet,
        Integer distanceOverMeters,
        Integer durationOverSeconds,
        Integer timeSavedSeconds
) {
}
