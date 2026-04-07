package com.travans.backend.repository;

import com.travans.backend.domain.TrainingDay;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TrainingDayRepository extends JpaRepository<TrainingDay, Long> {

    List<TrainingDay> findByPlanIdOrderByScheduledDateAsc(Long planId);

    List<TrainingDay> findByPlanOwnerIdAndPlanIdOrderByScheduledDateAsc(Long ownerId, Long planId);

    List<TrainingDay> findByPlanOwnerIdOrderByScheduledDateAsc(Long ownerId);
}
