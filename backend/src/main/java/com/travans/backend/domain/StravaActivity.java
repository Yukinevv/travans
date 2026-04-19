package com.travans.backend.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.FetchType;
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

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id")
    private AppUser user;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 32)
    private ActivityType activityType;

    @Column(nullable = false, length = 160)
    private String name;

    @Column(nullable = false)
    private LocalDate activityDate;

    @Column(nullable = false)
    private Instant startedAt;

    @Column
    private Integer distanceMeters;

    @Column
    private Integer movingTimeSeconds;

    @Column
    private Double averageSpeedMetersPerSecond;

    @Column
    private Double maxSpeedMetersPerSecond;

    @Column
    private Integer elevationGainMeters;

    @Column
    private Double averageHeartrateBpm;

    @Column
    private Integer maxHeartrateBpm;

    @Column
    private Double averageCadenceRpm;

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

    public AppUser getUser() {
        return user;
    }

    public void setUser(AppUser user) {
        this.user = user;
    }

    public ActivityType getActivityType() {
        return activityType;
    }

    public void setActivityType(ActivityType activityType) {
        this.activityType = activityType;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public LocalDate getActivityDate() {
        return activityDate;
    }

    public void setActivityDate(LocalDate activityDate) {
        this.activityDate = activityDate;
    }

    public Instant getStartedAt() {
        return startedAt;
    }

    public void setStartedAt(Instant startedAt) {
        this.startedAt = startedAt;
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

    public Double getAverageSpeedMetersPerSecond() {
        return averageSpeedMetersPerSecond;
    }

    public void setAverageSpeedMetersPerSecond(Double averageSpeedMetersPerSecond) {
        this.averageSpeedMetersPerSecond = averageSpeedMetersPerSecond;
    }

    public Double getMaxSpeedMetersPerSecond() {
        return maxSpeedMetersPerSecond;
    }

    public void setMaxSpeedMetersPerSecond(Double maxSpeedMetersPerSecond) {
        this.maxSpeedMetersPerSecond = maxSpeedMetersPerSecond;
    }

    public Integer getElevationGainMeters() {
        return elevationGainMeters;
    }

    public void setElevationGainMeters(Integer elevationGainMeters) {
        this.elevationGainMeters = elevationGainMeters;
    }

    public Double getAverageHeartrateBpm() {
        return averageHeartrateBpm;
    }

    public void setAverageHeartrateBpm(Double averageHeartrateBpm) {
        this.averageHeartrateBpm = averageHeartrateBpm;
    }

    public Integer getMaxHeartrateBpm() {
        return maxHeartrateBpm;
    }

    public void setMaxHeartrateBpm(Integer maxHeartrateBpm) {
        this.maxHeartrateBpm = maxHeartrateBpm;
    }

    public Double getAverageCadenceRpm() {
        return averageCadenceRpm;
    }

    public void setAverageCadenceRpm(Double averageCadenceRpm) {
        this.averageCadenceRpm = averageCadenceRpm;
    }

    public Instant getImportedAt() {
        return importedAt;
    }

    public void setImportedAt(Instant importedAt) {
        this.importedAt = importedAt;
    }
}
