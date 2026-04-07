package com.travans.backend.repository;

import com.travans.backend.domain.TrainingPlan;
import java.util.List;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TrainingPlanRepository extends JpaRepository<TrainingPlan, Long> {

    @EntityGraph(attributePaths = "trainingDays")
    List<TrainingPlan> findByOwnerId(Long ownerId);

    @EntityGraph(attributePaths = "trainingDays")
    java.util.Optional<TrainingPlan> findByIdAndOwnerId(Long id, Long ownerId);
}
