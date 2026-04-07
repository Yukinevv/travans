package com.travans.backend.service;

import com.travans.backend.api.dto.StravaConnectionStatusResponse;
import com.travans.backend.api.dto.StravaSyncResponse;
import com.travans.backend.api.dto.StravaWebhookValidationResponse;
import com.travans.backend.config.StravaProperties;
import com.travans.backend.domain.ActivityType;
import com.travans.backend.domain.StravaActivity;
import com.travans.backend.domain.StravaConnection;
import com.travans.backend.domain.TrainingDay;
import com.travans.backend.domain.TrainingDayStatus;
import com.travans.backend.repository.StravaActivityRepository;
import com.travans.backend.repository.StravaConnectionRepository;
import com.travans.backend.repository.TrainingDayRepository;
import jakarta.persistence.EntityNotFoundException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.Clock;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.core.ParameterizedTypeReference;
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
    private final Clock clock;

    public StravaService(
            StravaProperties properties,
            WebClient stravaWebClient,
            StravaConnectionRepository stravaConnectionRepository,
            StravaActivityRepository stravaActivityRepository,
            TrainingDayRepository trainingDayRepository,
            Clock clock) {
        this.properties = properties;
        this.stravaWebClient = stravaWebClient;
        this.stravaConnectionRepository = stravaConnectionRepository;
        this.stravaActivityRepository = stravaActivityRepository;
        this.trainingDayRepository = trainingDayRepository;
        this.clock = clock;
    }

    @Transactional(readOnly = true)
    public StravaConnectionStatusResponse getConnectionStatus() {
        Optional<StravaConnection> connection = stravaConnectionRepository.findAll().stream().findFirst();
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

        StravaConnection connection = stravaConnectionRepository.findByAthleteId(athleteId)
                .orElseGet(StravaConnection::new);
        connection.setAthleteId(athleteId);
        connection.setAccessToken(String.valueOf(response.get("access_token")));
        connection.setRefreshToken(String.valueOf(response.get("refresh_token")));
        connection.setTokenExpiresAt(Instant.ofEpochSecond(Long.parseLong(String.valueOf(response.get("expires_at")))));
        stravaConnectionRepository.save(connection);
    }

    @Transactional
    public StravaSyncResponse syncActivities(Long athleteId) {
        StravaConnection connection = stravaConnectionRepository.findByAthleteId(athleteId)
                .orElseThrow(() -> new EntityNotFoundException("Strava connection not found for athlete " + athleteId));

        List<Map<String, Object>> remoteActivities = fetchActivities(connection.getAccessToken());
        int imported = 0;

        for (Map<String, Object> payload : remoteActivities) {
            Long externalId = Long.valueOf(String.valueOf(payload.get("id")));
            StravaActivity activity = stravaActivityRepository.findByExternalActivityId(externalId)
                    .orElseGet(StravaActivity::new);
            activity.setExternalActivityId(externalId);
            activity.setAthleteId(athleteId);
            activity.setActivityType(mapActivityType(String.valueOf(payload.getOrDefault("sport_type", payload.getOrDefault("type", "Other")))));
            activity.setActivityDate(Instant.parse(String.valueOf(payload.get("start_date"))).atZone(ZoneOffset.UTC).toLocalDate());
            activity.setDistanceMeters((int) Math.round(Double.parseDouble(String.valueOf(payload.getOrDefault("distance", 0)))));
            activity.setMovingTimeSeconds(Integer.parseInt(String.valueOf(payload.getOrDefault("moving_time", 0))));
            activity.setImportedAt(clock.instant());
            stravaActivityRepository.save(activity);
            imported++;
        }

        long matched = matchTrainingDays(athleteId);
        connection.setLastSyncAt(clock.instant());
        stravaConnectionRepository.save(connection);
        return new StravaSyncResponse(athleteId, imported, matched);
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
            syncActivities(Long.valueOf(String.valueOf(ownerId)));
        }
    }

    private List<Map<String, Object>> fetchActivities(String accessToken) {
        List<Map<String, Object>> response = stravaWebClient.get()
                .uri(properties.getBaseUrl() + "/athlete/activities?page=1&per_page=50")
                .headers(headers -> headers.setBearerAuth(accessToken))
                .retrieve()
                .bodyToFlux(new ParameterizedTypeReference<Map<String, Object>>() {})
                .collectList()
                .block();
        return response == null ? List.of() : response;
    }

    private long matchTrainingDays(Long athleteId) {
        List<StravaActivity> activities = stravaActivityRepository.findByAthleteIdAndActivityDateBetween(
                athleteId,
                LocalDate.now(clock).minusMonths(6),
                LocalDate.now(clock).plusMonths(1)
        );

        List<TrainingDay> days = trainingDayRepository.findAll().stream()
                .sorted(Comparator.comparing(TrainingDay::getScheduledDate))
                .toList();

        long matched = 0;
        for (TrainingDay day : days) {
            Optional<StravaActivity> match = activities.stream()
                    .filter(activity -> activity.getActivityType() == day.getActivityType())
                    .filter(activity -> activity.getActivityDate().equals(day.getScheduledDate()))
                    .findFirst();

            if (match.isPresent()) {
                StravaActivity activity = match.get();
                day.setMatchedActivityId(activity.getExternalActivityId());
                day.setStatus(resolveStatus(day, activity));
                trainingDayRepository.save(day);
                matched++;
            } else if (day.getScheduledDate().isBefore(LocalDate.now(clock)) && day.getStatus() == TrainingDayStatus.PLANNED) {
                day.setStatus(TrainingDayStatus.MISSED);
                trainingDayRepository.save(day);
            }
        }
        return matched;
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
            case "WeightTraining", "Workout" -> ActivityType.STRENGTH;
            default -> ActivityType.OTHER;
        };
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
