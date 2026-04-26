package com.travans.backend.service;

import com.travans.backend.config.AuthProperties;
import com.travans.backend.exception.AuthException;
import org.springframework.security.oauth2.jwt.BadJwtException;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtException;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.stereotype.Service;

@Service
public class GoogleTokenVerifierService {

    private static final String GOOGLE_JWKS_URI = "https://www.googleapis.com/oauth2/v3/certs";
    private static final String GOOGLE_ISSUER = "https://accounts.google.com";
    private static final String GOOGLE_ISSUER_LEGACY = "accounts.google.com";

    private final AuthProperties authProperties;
    private final JwtDecoder jwtDecoder;

    public GoogleTokenVerifierService(AuthProperties authProperties) {
        this.authProperties = authProperties;
        this.jwtDecoder = NimbusJwtDecoder.withJwkSetUri(GOOGLE_JWKS_URI).build();
    }

    public GoogleUserProfile verify(String idToken) {
        if (authProperties.getGoogleClientId() == null || authProperties.getGoogleClientId().isBlank()) {
            throw new AuthException("GOOGLE_AUTH_NOT_CONFIGURED", "Logowanie Google nie jest skonfigurowane");
        }

        Jwt jwt;
        try {
            jwt = jwtDecoder.decode(idToken);
        } catch (JwtException exception) {
            throw new AuthException("INVALID_GOOGLE_TOKEN", "Token Google jest nieprawidlowy");
        }

        String issuer = jwt.getIssuer() != null ? jwt.getIssuer().toString() : "";
        if (!GOOGLE_ISSUER.equals(issuer) && !GOOGLE_ISSUER_LEGACY.equals(issuer)) {
            throw new AuthException("INVALID_GOOGLE_TOKEN", "Token Google ma nieprawidlowego wystawce");
        }

        if (!jwt.getAudience().contains(authProperties.getGoogleClientId())) {
            throw new AuthException("INVALID_GOOGLE_TOKEN", "Token Google nie jest przeznaczony dla tej aplikacji");
        }

        String subject = jwt.getSubject();
        String email = jwt.getClaimAsString("email");
        String displayName = jwt.getClaimAsString("name");
        String pictureUrl = jwt.getClaimAsString("picture");
        Boolean emailVerified = jwt.getClaimAsBoolean("email_verified");

        if (subject == null || subject.isBlank() || email == null || email.isBlank()) {
            throw new AuthException("INVALID_GOOGLE_TOKEN", "Token Google nie zawiera wymaganych danych");
        }

        if (!Boolean.TRUE.equals(emailVerified)) {
            throw new AuthException("GOOGLE_EMAIL_NOT_VERIFIED", "Konto Google nie ma potwierdzonego adresu email");
        }

        String resolvedDisplayName = (displayName == null || displayName.isBlank()) ? email : displayName;
        return new GoogleUserProfile(subject, email.toLowerCase(), resolvedDisplayName, pictureUrl);
    }

    public record GoogleUserProfile(
            String subject,
            String email,
            String displayName,
            String pictureUrl
    ) {
    }
}
