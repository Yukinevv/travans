package com.travans.backend.repository;

import com.travans.backend.domain.StravaConnection;
import com.travans.backend.domain.AppUser;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StravaConnectionRepository extends JpaRepository<StravaConnection, Long> {

    Optional<StravaConnection> findByAthleteId(Long athleteId);

    Optional<StravaConnection> findByUser(AppUser user);

    Optional<StravaConnection> findByUserIdAndAthleteId(Long userId, Long athleteId);
}
