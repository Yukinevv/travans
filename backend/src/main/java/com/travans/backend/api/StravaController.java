package com.travans.backend.api;

import com.travans.backend.api.dto.StravaActivityResponse;
import com.travans.backend.api.dto.StravaConnectionStatusResponse;
import com.travans.backend.api.dto.StravaSyncResponse;
import com.travans.backend.domain.ActivityType;
import com.travans.backend.service.StravaService;
import java.util.Map;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/integrations/strava")
public class StravaController {

    private final StravaService stravaService;

    public StravaController(StravaService stravaService) {
        this.stravaService = stravaService;
    }

    @GetMapping("/status")
    public StravaConnectionStatusResponse getStatus() {
        return stravaService.getConnectionStatus();
    }

    @GetMapping("/activities")
    public List<StravaActivityResponse> getActivities(@RequestParam(required = false) ActivityType activityType) {
        return stravaService.getActivities(activityType);
    }

    @PostMapping("/exchange-token")
    @ResponseStatus(HttpStatus.CREATED)
    public void exchangeToken(@RequestParam String code) {
        stravaService.exchangeAuthorizationCode(code);
    }

    @PatchMapping("/sync")
    public StravaSyncResponse sync(@RequestParam Long athleteId) {
        return stravaService.syncActivities(athleteId);
    }

    @PostMapping("/webhook")
    @ResponseStatus(HttpStatus.ACCEPTED)
    public void handleWebhook(@RequestBody Map<String, Object> payload) {
        stravaService.handleWebhookEvent(payload);
    }
}
