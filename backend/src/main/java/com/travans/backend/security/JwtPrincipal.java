package com.travans.backend.security;

public record JwtPrincipal(
        Long userId,
        String email,
        String displayName,
        String role
) {
}
