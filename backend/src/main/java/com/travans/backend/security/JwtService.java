package com.travans.backend.security;

import com.nimbusds.jose.JOSEException;
import com.nimbusds.jose.JWSAlgorithm;
import com.nimbusds.jose.JWSHeader;
import com.nimbusds.jose.crypto.MACSigner;
import com.nimbusds.jose.crypto.MACVerifier;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import com.travans.backend.config.AuthProperties;
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.time.Clock;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.UUID;
import org.springframework.stereotype.Service;

@Service
public class JwtService {

    private final AuthProperties authProperties;
    private final Clock clock;

    public JwtService(AuthProperties authProperties, Clock clock) {
        this.authProperties = authProperties;
        this.clock = clock;
    }

    public String generateAccessToken(AuthenticatedUser user) {
        Instant now = clock.instant();
        Instant expiresAt = now.plus(authProperties.getAccessTokenTtlMinutes(), ChronoUnit.MINUTES);

        JWTClaimsSet claimsSet = new JWTClaimsSet.Builder()
                .subject(String.valueOf(user.getId()))
                .claim("email", user.getUsername())
                .claim("displayName", user.getDisplayName())
                .claim("role", user.getRole().name())
                .claim("type", "access")
                .issueTime(Date.from(now))
                .expirationTime(Date.from(expiresAt))
                .jwtID(UUID.randomUUID().toString())
                .build();

        return sign(claimsSet);
    }

    public String generateRefreshToken() {
        return UUID.randomUUID() + "." + UUID.randomUUID();
    }

    public JwtPrincipal parseAccessToken(String token) {
        try {
            SignedJWT jwt = SignedJWT.parse(token);
            if (!jwt.verify(new MACVerifier(secretBytes()))) {
                throw new IllegalArgumentException("Invalid JWT signature");
            }

            JWTClaimsSet claims = jwt.getJWTClaimsSet();
            if (claims.getExpirationTime() == null || claims.getExpirationTime().toInstant().isBefore(clock.instant())) {
                throw new IllegalArgumentException("JWT token expired");
            }
            if (!"access".equals(claims.getStringClaim("type"))) {
                throw new IllegalArgumentException("Invalid JWT token type");
            }

            return new JwtPrincipal(
                    Long.parseLong(claims.getSubject()),
                    claims.getStringClaim("email"),
                    claims.getStringClaim("displayName"),
                    claims.getStringClaim("role")
            );
        } catch (ParseException | JOSEException exception) {
            throw new IllegalArgumentException("Invalid JWT token", exception);
        }
    }

    private String sign(JWTClaimsSet claimsSet) {
        try {
            SignedJWT jwt = new SignedJWT(new JWSHeader(JWSAlgorithm.HS256), claimsSet);
            jwt.sign(new MACSigner(secretBytes()));
            return jwt.serialize();
        } catch (JOSEException exception) {
            throw new IllegalStateException("Could not sign JWT token", exception);
        }
    }

    private byte[] secretBytes() {
        byte[] secret = authProperties.getJwtSecret().getBytes(StandardCharsets.UTF_8);
        if (secret.length < 32) {
            throw new IllegalStateException("JWT secret must be at least 32 bytes long");
        }
        return secret;
    }
}
