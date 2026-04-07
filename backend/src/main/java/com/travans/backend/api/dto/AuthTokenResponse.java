package com.travans.backend.api.dto;

public record AuthTokenResponse(
        String accessToken,
        String refreshToken,
        UserProfileResponse user
) {
}
