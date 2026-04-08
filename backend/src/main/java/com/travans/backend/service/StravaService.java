package com.travans.backend.service;

import com.travans.backend.api.dto.StravaActivityResponse;
import com.travans.backend.api.dto.StravaConnectionStatusResponse;
import com.travans.backend.api.dto.StravaSyncResponse;
import com.travans.backend.api.dto.StravaWebhookValidationResponse;
import com.travans.backend.config.StravaProperties;
import com.travans.backend.domain.ActivityType;
import com.travans.backend.domain.AppUser;
import com.travans.backend.domain.StravaActivity;
import com.travans.backend.domain.StravaConnection;
import com.travans.backend.domain.TrainingDay;
import com.travans.backend.domain.TrainingDayStatus;
import com.travans.backend.repository.StravaActivityRepository;
import com.travans.backend.repository.StravaConnectionRepository;
import com.travans.backend.repository.TrainingDayRepository;
import com.travans.backend.security.CurrentUserService;
import jakarta.persistence.EntityNotFoundException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.Clock;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.time.temporal.ChronoUnit;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.reactive.function.client.WebClient;

@Service
public class StravaService {

    private final StravaProperties properties;
    private final WebClient stravaWebClient;
    private final StravaConnectionRepository stravaConnectionRepository;
    private final StravaActivityRepository stravaActivityRepository;
    private final TrainingDayRepository trainingDayRepository;
    private final CurrentUserService currentUserService;
    private final Clock clock;

    public StravaService(
            StravaProperties properties,
            WebClient stravaWebClient,
            StravaConnectionRepository stravaConnectionRepository,
            StravaActivityRepository stravaActivityRepository,
            TrainingDayRepository trainingDayRepository,
            CurrentUserService currentUserService,
            Clock clock) {
        this.properties = properties;
        this.stravaWebClient = stravaWebClient;
        this.stravaConnectionRepository = stravaConnectionRepository;
        this.stravaActivityRepository = stravaActivityRepository;
        this.trainingDayRepository = trainingDayRepository;
        this.currentUserService = currentUserService;
        this.clock = clock;
    }

    @Transactional(readOnly = true)
    public StravaConnectionStatusResponse getConnectionStatus() {
        AppUser user = currentUserService.requireCurrentUserEntity();
        Optional<StravaConnection> connection = stravaConnectionRepository.findByUser(user);
        return new StravaConnectionStatusResponse(
                connection.isPresent(),
                connection.map(StravaConnection::getAthleteId).orElse(null),
                connection.map(StravaConnection::getLastSyncAt).orElse(null),
                buildAuthorizationUrl()
        );
    }

    @Transactional
    @SuppressWarnings("unchecked")
    public void exchangeAuthorizationCode(String code) {
        AppUser user = currentUserService.requireCurrentUserEntity();
        if (properties.getClientId() == null || properties.getClientId().isBlank()) {
            throw new IllegalStateException("Strava client id is not configured");
        }

        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
        body.add("client_id", properties.getClientId());
        body.add("client_secret", properties.getClientSecret());
        body.add("code", code);
        body.add("grant_type", "authorization_code");

        Map<String, Object> response = stravaWebClient.post()
                .uri(properties.getTokenUrl())
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                .bodyValue(body)
                .retrieve()
                .bodyToMono(Map.class)
                .block();

        if (response == null || response.get("athlete") == null) {
            throw new IllegalStateException("Invalid Strava token response");
        }

        Map<String, Object> athlete = (Map<String, Object>) response.get("athlete");
        Long athleteId = Long.valueOf(String.valueOf(athlete.get("id")));

        StravaConnection connection = stravaConnectionRepository.findByUserIdAndAthleteId(user.getId(), athleteId)
                .orElseGet(StravaConnection::new);
        connection.setUser(user);
        connection.setAthleteId(athleteId);
        connection.setAccessToken(String.valueOf(response.get("access_token")));
        connection.setRefreshToken(String.valueOf(response.get("refresh_token")));
        connection.setTokenExpiresAt(Instant.ofEpochSecond(Long.parseLong(String.valueOf(response.get("expires_at")))));
        stravaConnectionRepository.save(connection);
    }

    @Transactional(readOnly = true)
    public List<StravaActivityResponse> getActivities(ActivityType activityType) {
        Long userId = currentUserService.requireAuthenticatedUser().getId();
        List<StravaActivity> activities = activityType == null
                ? stravaActivityRepository.findByUserIdOrderByStartedAtDescImportedAtDesc(userId)
                : stravaActivityRepository.findByUserIdAndActivityTypeOrderByStartedAtDescImportedAtDesc(userId, activityType);

        Map<Long, TrainingDay> matchedDaysByActivityId = new HashMap<>();
        for (TrainingDay day : trainingDayRepository.findByPlanOwnerIdOrderByScheduledDateAsc(userId)) {
            if (day.getMatchedActivityId() != null) {
                matchedDaysByActivityId.put(day.getMatchedActivityId(), day);
            }
        }

        return activities.stream()
                .map(activity -> toActivityResponse(matchedDaysByActivityId.get(activity.getExternalActivityId()), activity))
                .toList();
    }

    @Transactional(readOnly = true)
    public StravaActivityResponse getActivity(Long activityId) {
        Long userId = currentUserService.requireAuthenticatedUser().getId();
        StravaActivity activity = stravaActivityRepository.findByUserIdAndId(userId, activityId)
                .orElseThrow(() -> new EntityNotFoundException("Strava activity not found: " + activityId));

        TrainingDay matchedDay = trainingDayRepository.findByPlanOwnerIdOrderByScheduledDateAsc(userId).stream()
                .filter(day -> activity.getExternalActivityId().equals(day.getMatchedActivityId()))
                .findFirst()
                .orElse(null);

        return toActivityResponse(matchedDay, activity);
    }

    @Transactional
    public StravaSyncResponse syncActivities(Long athleteId) {
        AppUser user = currentUserService.requireCurrentUserEntity();
        StravaConnection connection = stravaConnectionRepository.findByUserIdAndAthleteId(user.getId(), athleteId)
                .orElseThrow(() -> new EntityNotFoundException("Strava connection not found for athlete " + athleteId));
        return syncConnection(user, connection);
    }

    @Transactional
    public void syncActivitiesForWebhook(Long athleteId) {
        StravaConnection connection = stravaConnectionRepository.findByAthleteId(athleteId)
                .orElseThrow(() -> new EntityNotFoundException("Strava connection not found for athlete " + athleteId));
        syncConnection(connection.getUser(), connection);
    }

    public StravaWebhookValidationResponse validateWebhook(String mode, String verifyToken, String challenge) {
        if (!"subscribe".equals(mode) || !properties.getWebhookVerifyToken().equals(verifyToken)) {
            throw new IllegalArgumentException("Invalid webhook verification request");
        }
        return new StravaWebhookValidationResponse(challenge);
    }

    @Transactional
    public void handleWebhookEvent(Map<String, Object> payload) {
        Object ownerId = payload.get("owner_id");
        if (ownerId != null) {
            syncActivitiesForWebhook(Long.valueOf(String.valueOf(ownerId)));
        }
    }

    private StravaSyncResponse syncConnection(AppUser user, StravaConnection connection) {
        refreshAccessTokenIfNeeded(connection);
        List<Map<String, Object>> remoteActivities = fetchActivities(connection.getAccessToken());
        int imported = 0;

        for (Map<String, Object> payload : remoteActivities) {
            Long externalId = Long.valueOf(String.valueOf(payload.get("id")));
            StravaActivity activity = stravaActivityRepository.findByExternalActivityId(externalId)
                    .orElseGet(StravaActivity::new);
            Instant startedAt = Instant.parse(String.valueOf(payload.get("start_date")));

            activity.setExternalActivityId(externalId);
            activity.setUser(user);
            activity.setAthleteId(connection.getAthleteId());
            activity.setActivityType(mapActivityType(String.valueOf(payload.getOrDefault("sport_type", payload.getOrDefault("type", "Other")))));
            activity.setName(String.valueOf(payload.getOrDefault("name", "Aktywnosc Strava")));
            activity.setStartedAt(startedAt);
            activity.setActivityDate(startedAt.atZone(ZoneOffset.UTC).toLocalDate());
            activity.setDistanceMeters((int) Math.round(Double.parseDouble(String.valueOf(payload.getOrDefault("distance", 0)))));
            activity.setMovingTimeSeconds(Integer.parseInt(String.valueOf(payload.getOrDefault("moving_time", 0))));
            activity.setImportedAt(clock.instant());
            stravaActivityRepository.save(activity);
            imported++;
        }

        long matched = matchTrainingDays(user.getId(), connection.getAthleteId());
        connection.setLastSyncAt(clock.instant());
        stravaConnectionRepository.save(connection);
        return new StravaSyncResponse(connection.getAthleteId(), imported, matched);
    }

    private List<Map<String, Object>> fetchActivities(String accessToken) {
        List<Map<String, Object>> response = stravaWebClient.get()
                .uri(properties.getBaseUrl() + "/athlete/activities?page=1&per_page=100")
                .headers(headers -> headers.setBearerAuth(accessToken))
                .retrieve()
                .bodyToFlux(new ParameterizedTypeReference<Map<String, Object>>() {})
                .collectList()
                .block();
        return response == null ? List.of() : response;
    }

    private long matchTrainingDays(Long userId, Long athleteId) {
        List<StravaActivity> activities = stravaActivityRepository.findByUserIdAndAthleteIdAndActivityDateBetween(
                userId,
                athleteId,
                LocalDate.now(clock).minusMonths(6),
                LocalDate.now(clock).plusMonths(1)
        );

        List<TrainingDay> days = trainingDayRepository.findByPlanOwnerIdOrderByScheduledDateAsc(userId);
        Set<Long> usedActivities = new HashSet<>();
        long matched = 0;

        for (TrainingDay day : days) {
            LocalDate evaluationStartDate = day.getPlan().getStravaEvaluationStartDate() != null
                    ? day.getPlan().getStravaEvaluationStartDate()
                    : day.getPlan().getStartDate();

            if (day.getScheduledDate().isBefore(evaluationStartDate)) {
                day.setStatus(TrainingDayStatus.PLANNED);
                day.setMatchedActivityId(null);
                trainingDayRepository.save(day);
                continue;
            }

            Optional<StravaActivity> match = findBestMatch(day, activities, usedActivities);

            if (match.isPresent()) {
                StravaActivity activity = match.get();
                day.setMatchedActivityId(activity.getExternalActivityId());
                day.setStatus(resolveStatus(day, activity));
                usedActivities.add(activity.getExternalActivityId());
                trainingDayRepository.save(day);
                matched++;
            } else if (day.getScheduledDate().isBefore(LocalDate.now(clock))) {
                day.setStatus(TrainingDayStatus.MISSED);
                day.setMatchedActivityId(null);
                trainingDayRepository.save(day);
            } else {
                day.setStatus(TrainingDayStatus.PLANNED);
                day.setMatchedActivityId(null);
                trainingDayRepository.save(day);
            }
        }

        return matched;
    }

    private Optional<StravaActivity> findBestMatch(TrainingDay day, List<StravaActivity> activities, Set<Long> usedActivities) {
        return activities.stream()
                .filter(activity -> !usedActivities.contains(activity.getExternalActivityId()))
                .filter(activity -> activity.getActivityType() == day.getActivityType())
                .filter(activity -> Math.abs(ChronoUnit.DAYS.between(day.getScheduledDate(), activity.getActivityDate())) <= 1)
                .min(Comparator
                        .comparingLong((StravaActivity activity) -> Math.abs(ChronoUnit.DAYS.between(day.getScheduledDate(), activity.getActivityDate())))
                        .thenComparingLong(activity -> distanceDelta(day, activity))
                        .thenComparingLong(activity -> durationDelta(day, activity)));
    }

    private TrainingDayStatus resolveStatus(TrainingDay day, StravaActivity activity) {
        boolean distanceMatches = day.getPlannedDistanceMeters() == null
                || activity.getDistanceMeters() >= (int) (day.getPlannedDistanceMeters() * 0.9);
        boolean durationMatches = day.getPlannedDurationSeconds() == null
                || activity.getMovingTimeSeconds() >= (int) (day.getPlannedDurationSeconds() * 0.9);

        if (distanceMatches && durationMatches) {
            return TrainingDayStatus.COMPLETED;
        }
        return TrainingDayStatus.PARTIALLY_COMPLETED;
    }

    private ActivityType mapActivityType(String rawType) {
        return switch (rawType) {
            case "Run", "TrailRun" -> ActivityType.RUN;
            case "Ride", "VirtualRide", "EBikeRide" -> ActivityType.RIDE;
            case "Swim" -> ActivityType.SWIM;
            case "Walk", "Hike" -> ActivityType.WALK;
            case "WeightTraining" -> ActivityType.STRENGTH;
            case "Workout" -> ActivityType.WORKOUT;
            default -> ActivityType.OTHER;
        };
    }

    @SuppressWarnings("unchecked")
    private void refreshAccessTokenIfNeeded(StravaConnection connection) {
        if (connection.getTokenExpiresAt() != null && connection.getTokenExpiresAt().isAfter(clock.instant().plusSeconds(60))) {
            return;
        }

        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
        body.add("client_id", properties.getClientId());
        body.add("client_secret", properties.getClientSecret());
        body.add("grant_type", "refresh_token");
        body.add("refresh_token", connection.getRefreshToken());

        Map<String, Object> response = stravaWebClient.post()
                .uri(properties.getTokenUrl())
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                .bodyValue(body)
                .retrieve()
                .bodyToMono(Map.class)
                .block();

        if (response == null) {
            throw new IllegalStateException("Invalid Strava refresh token response");
        }

        connection.setAccessToken(String.valueOf(response.get("access_token")));
        connection.setRefreshToken(String.valueOf(response.getOrDefault("refresh_token", connection.getRefreshToken())));
        connection.setTokenExpiresAt(Instant.ofEpochSecond(Long.parseLong(String.valueOf(response.get("expires_at")))));
        stravaConnectionRepository.save(connection);
    }

    private StravaActivityResponse toActivityResponse(TrainingDay matchedDay, StravaActivity activity) {
        return new StravaActivityResponse(
                activity.getId(),
                activity.getExternalActivityId(),
                activity.getName(),
                activity.getActivityType(),
                activity.getActivityDate(),
                activity.getStartedAt(),
                activity.getDistanceMeters(),
                activity.getMovingTimeSeconds(),
                matchedDay != null,
                matchedDay != null ? matchedDay.getId() : null,
                matchedDay != null ? matchedDay.getTitle() : null,
                matchedDay != null ? matchedDay.getPlan().getId() : null,
                matchedDay != null ? matchedDay.getPlan().getName() : null
        );
    }

    private long distanceDelta(TrainingDay day, StravaActivity activity) {
        if (day.getPlannedDistanceMeters() == null || activity.getDistanceMeters() == null) {
            return 0;
        }
        return Math.abs((long) day.getPlannedDistanceMeters() - activity.getDistanceMeters());
    }

    private long durationDelta(TrainingDay day, StravaActivity activity) {
        if (day.getPlannedDurationSeconds() == null || activity.getMovingTimeSeconds() == null) {
            return 0;
        }
        return Math.abs((long) day.getPlannedDurationSeconds() - activity.getMovingTimeSeconds());
    }

    private String buildAuthorizationUrl() {
        return properties.getOauthUrl()
                + "?client_id=" + urlEncode(properties.getClientId())
                + "&response_type=code"
                + "&redirect_uri=" + urlEncode(properties.getRedirectUri())
                + "&approval_prompt=auto"
                + "&scope=read,activity:read_all";
    }

    private String urlEncode(String value) {
        return URLEncoder.encode(value == null ? "" : value, StandardCharsets.UTF_8);
    }
}
