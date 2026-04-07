package com.travans.backend.repository;

import com.travans.backend.domain.StravaActivity;
import com.travans.backend.domain.ActivityType;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StravaActivityRepository extends JpaRepository<StravaActivity, Long> {

    Optional<StravaActivity> findByExternalActivityId(Long externalActivityId);

    Optional<StravaActivity> findByUserIdAndExternalActivityId(Long userId, Long externalActivityId);

    List<StravaActivity> findByAthleteIdAndActivityDateBetween(Long athleteId, LocalDate startDate, LocalDate endDate);

    List<StravaActivity> findByUserIdAndAthleteIdAndActivityDateBetween(Long userId, Long athleteId, LocalDate startDate, LocalDate endDate);

    List<StravaActivity> findByUserIdOrderByStartedAtDescImportedAtDesc(Long userId);

    List<StravaActivity> findByUserIdAndActivityTypeOrderByStartedAtDescImportedAtDesc(Long userId, ActivityType activityType);
}
