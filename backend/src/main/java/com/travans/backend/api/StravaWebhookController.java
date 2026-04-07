package com.travans.backend.api;

import com.travans.backend.api.dto.StravaWebhookValidationResponse;
import com.travans.backend.service.StravaService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/integrations/strava/webhook")
public class StravaWebhookController {

    private final StravaService stravaService;

    public StravaWebhookController(StravaService stravaService) {
        this.stravaService = stravaService;
    }

    @GetMapping
    @ResponseStatus(HttpStatus.OK)
    public StravaWebhookValidationResponse validate(
            @RequestParam("hub.mode") String mode,
            @RequestParam("hub.verify_token") String verifyToken,
            @RequestParam("hub.challenge") String challenge) {
        return stravaService.validateWebhook(mode, verifyToken, challenge);
    }
}
