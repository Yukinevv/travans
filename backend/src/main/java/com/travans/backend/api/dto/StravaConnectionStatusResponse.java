package com.travans.backend.api.dto;

import java.time.Instant;

public record StravaConnectionStatusResponse(
        boolean connected,
        Long athleteId,
        Instant lastSyncAt,
        String authorizationUrl
) {
}
