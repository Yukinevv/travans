package com.travans.backend.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;
import java.time.LocalDate;

@Entity
@Table(name = "strava_activities")
public class StravaActivity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private Long externalActivityId;

    @Column(nullable = false)
    private Long athleteId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 32)
    private ActivityType activityType;

    @Column(nullable = false)
    private LocalDate activityDate;

    @Column
    private Integer distanceMeters;

    @Column
    private Integer movingTimeSeconds;

    @Column(nullable = false)
    private Instant importedAt;

    public Long getId() {
        return id;
    }

    public Long getExternalActivityId() {
        return externalActivityId;
    }

    public void setExternalActivityId(Long externalActivityId) {
        this.externalActivityId = externalActivityId;
    }

    public Long getAthleteId() {
        return athleteId;
    }

    public void setAthleteId(Long athleteId) {
        this.athleteId = athleteId;
    }

    public ActivityType getActivityType() {
        return activityType;
    }

    public void setActivityType(ActivityType activityType) {
        this.activityType = activityType;
    }

    public LocalDate getActivityDate() {
        return activityDate;
    }

    public void setActivityDate(LocalDate activityDate) {
        this.activityDate = activityDate;
    }

    public Integer getDistanceMeters() {
        return distanceMeters;
    }

    public void setDistanceMeters(Integer distanceMeters) {
        this.distanceMeters = distanceMeters;
    }

    public Integer getMovingTimeSeconds() {
        return movingTimeSeconds;
    }

    public void setMovingTimeSeconds(Integer movingTimeSeconds) {
        this.movingTimeSeconds = movingTimeSeconds;
    }

    public Instant getImportedAt() {
        return importedAt;
    }

    public void setImportedAt(Instant importedAt) {
        this.importedAt = importedAt;
    }
}
