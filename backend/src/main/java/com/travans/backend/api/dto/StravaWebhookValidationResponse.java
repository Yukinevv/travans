package com.travans.backend.api.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public record StravaWebhookValidationResponse(
        @JsonProperty("hub.challenge") String challenge
) {
}
