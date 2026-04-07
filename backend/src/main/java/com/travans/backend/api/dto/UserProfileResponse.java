package com.travans.backend.api.dto;

import com.travans.backend.domain.UserRole;

public record UserProfileResponse(
        Long id,
        String email,
        String displayName,
        UserRole role
) {
}
