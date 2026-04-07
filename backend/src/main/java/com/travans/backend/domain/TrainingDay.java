package com.travans.backend.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.time.LocalDate;

@Entity
@Table(name = "training_days")
public class TrainingDay {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "plan_id")
    private TrainingPlan plan;

    @Column(nullable = false)
    private LocalDate scheduledDate;

    @Column(nullable = false, length = 120)
    private String title;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 32)
    private ActivityType activityType;

    @Column
    private Integer plannedDistanceMeters;

    @Column
    private Integer plannedDurationSeconds;

    @Column(length = 600)
    private String notes;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 32)
    private TrainingDayStatus status;

    @Column
    private Long matchedActivityId;

    public Long getId() {
        return id;
    }

    public TrainingPlan getPlan() {
        return plan;
    }

    public void setPlan(TrainingPlan plan) {
        this.plan = plan;
    }

    public LocalDate getScheduledDate() {
        return scheduledDate;
    }

    public void setScheduledDate(LocalDate scheduledDate) {
        this.scheduledDate = scheduledDate;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public ActivityType getActivityType() {
        return activityType;
    }

    public void setActivityType(ActivityType activityType) {
        this.activityType = activityType;
    }

    public Integer getPlannedDistanceMeters() {
        return plannedDistanceMeters;
    }

    public void setPlannedDistanceMeters(Integer plannedDistanceMeters) {
        this.plannedDistanceMeters = plannedDistanceMeters;
    }

    public Integer getPlannedDurationSeconds() {
        return plannedDurationSeconds;
    }

    public void setPlannedDurationSeconds(Integer plannedDurationSeconds) {
        this.plannedDurationSeconds = plannedDurationSeconds;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public TrainingDayStatus getStatus() {
        return status;
    }

    public void setStatus(TrainingDayStatus status) {
        this.status = status;
    }

    public Long getMatchedActivityId() {
        return matchedActivityId;
    }

    public void setMatchedActivityId(Long matchedActivityId) {
        this.matchedActivityId = matchedActivityId;
    }
}
