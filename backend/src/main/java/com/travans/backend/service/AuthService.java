package com.travans.backend.service;

import com.travans.backend.api.dto.AuthTokenResponse;
import com.travans.backend.api.dto.ChangePasswordRequest;
import com.travans.backend.api.dto.GoogleAuthRequest;
import com.travans.backend.api.dto.LoginRequest;
import com.travans.backend.api.dto.RefreshTokenRequest;
import com.travans.backend.api.dto.RegisterRequest;
import com.travans.backend.api.dto.UpdateProfileRequest;
import com.travans.backend.api.dto.UserProfileResponse;
import com.travans.backend.config.AuthProperties;
import com.travans.backend.domain.AuthProvider;
import com.travans.backend.domain.AppUser;
import com.travans.backend.domain.RefreshToken;
import com.travans.backend.domain.UserRole;
import com.travans.backend.exception.AuthException;
import com.travans.backend.repository.AppUserRepository;
import com.travans.backend.repository.RefreshTokenRepository;
import com.travans.backend.security.AuthenticatedUser;
import com.travans.backend.security.CurrentUserService;
import com.travans.backend.security.JwtService;
import java.time.Clock;
import java.time.temporal.ChronoUnit;
import java.util.UUID;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthService {

    private final AppUserRepository appUserRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;
    private final CurrentUserService currentUserService;
    private final AuthProperties authProperties;
    private final Clock clock;
    private final GoogleTokenVerifierService googleTokenVerifierService;

    public AuthService(
            AppUserRepository appUserRepository,
            RefreshTokenRepository refreshTokenRepository,
            PasswordEncoder passwordEncoder,
            AuthenticationManager authenticationManager,
            JwtService jwtService,
            CurrentUserService currentUserService,
            AuthProperties authProperties,
            Clock clock,
            GoogleTokenVerifierService googleTokenVerifierService) {
        this.appUserRepository = appUserRepository;
        this.refreshTokenRepository = refreshTokenRepository;
        this.passwordEncoder = passwordEncoder;
        this.authenticationManager = authenticationManager;
        this.jwtService = jwtService;
        this.currentUserService = currentUserService;
        this.authProperties = authProperties;
        this.clock = clock;
        this.googleTokenVerifierService = googleTokenVerifierService;
    }

    @Transactional
    public AuthTokenResponse register(RegisterRequest request) {
        appUserRepository.findByEmail(request.email().toLowerCase())
                .ifPresent(user -> {
                    throw new IllegalStateException("Uzytkownik z takim adresem email juz istnieje");
                });

        AppUser user = new AppUser();
        user.setEmail(request.email().toLowerCase());
        user.setDisplayName(request.displayName());
        user.setPasswordHash(passwordEncoder.encode(request.password()));
        user.setAuthProvider(AuthProvider.LOCAL);
        user.setRole(UserRole.USER);
        user.setCreatedAt(clock.instant());
        user = appUserRepository.save(user);

        return issueTokens(new AuthenticatedUser(user));
    }

    @Transactional
    public AuthTokenResponse login(LoginRequest request) {
        appUserRepository.findByEmail(request.email().toLowerCase())
                .filter(user -> resolveAuthProvider(user) == AuthProvider.GOOGLE)
                .ifPresent(user -> {
                    throw new AuthException("GOOGLE_ACCOUNT", "To konto korzysta z logowania Google");
                });

        AuthenticatedUser user;
        try {
            user = (AuthenticatedUser) authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(request.email().toLowerCase(), request.password())
            ).getPrincipal();
        } catch (AuthenticationException exception) {
            throw new AuthException("INVALID_CREDENTIALS", "Nieprawidlowy email lub haslo");
        }

        return issueTokens(user);
    }

    @Transactional
    public AuthTokenResponse loginWithGoogle(GoogleAuthRequest request) {
        GoogleTokenVerifierService.GoogleUserProfile googleProfile = googleTokenVerifierService.verify(request.idToken());

        AppUser user = appUserRepository.findByGoogleSubject(googleProfile.subject())
                .orElseGet(() -> createGoogleUser(googleProfile));

        return issueTokens(new AuthenticatedUser(user));
    }

    @Transactional
    public AuthTokenResponse refresh(RefreshTokenRequest request) {
        RefreshToken refreshToken = refreshTokenRepository.findByToken(request.refreshToken())
                .orElseThrow(() -> new AuthException("REFRESH_TOKEN_NOT_FOUND", "Sesja wygasla. Zaloguj sie ponownie"));

        if (refreshToken.isRevoked() || refreshToken.getExpiresAt().isBefore(clock.instant())) {
            throw new AuthException("REFRESH_TOKEN_EXPIRED", "Sesja wygasla. Zaloguj sie ponownie");
        }

        revokeTokens(refreshToken.getUser());
        return issueTokens(new AuthenticatedUser(refreshToken.getUser()));
    }

    @Transactional(readOnly = true)
    public UserProfileResponse me() {
        AppUser user = currentUserService.requireCurrentUserEntity();
        return toProfile(user);
    }

    @Transactional
    public AuthTokenResponse updateProfile(UpdateProfileRequest request) {
        AppUser user = currentUserService.requireCurrentUserEntity();
        String normalizedEmail = request.email().toLowerCase();

        appUserRepository.findByEmail(normalizedEmail)
                .filter(existingUser -> !existingUser.getId().equals(user.getId()))
                .ifPresent(existingUser -> {
                    throw new IllegalStateException("Uzytkownik z takim adresem email juz istnieje");
                });

        user.setEmail(normalizedEmail);
        user.setDisplayName(request.displayName());
        AppUser updatedUser = appUserRepository.save(user);

        return issueTokens(new AuthenticatedUser(updatedUser));
    }

    @Transactional
    public AuthTokenResponse changePassword(ChangePasswordRequest request) {
        AppUser user = currentUserService.requireCurrentUserEntity();

        if (resolveAuthProvider(user) == AuthProvider.GOOGLE) {
            throw new IllegalArgumentException("Konto Google nie korzysta z lokalnego hasla");
        }

        if (!passwordEncoder.matches(request.currentPassword(), user.getPasswordHash())) {
            throw new AuthException("INVALID_CURRENT_PASSWORD", "Aktualne haslo jest nieprawidlowe");
        }

        if (request.currentPassword().equals(request.newPassword())) {
            throw new IllegalArgumentException("Nowe haslo musi byc inne niz aktualne");
        }

        user.setPasswordHash(passwordEncoder.encode(request.newPassword()));
        AppUser updatedUser = appUserRepository.save(user);

        return issueTokens(new AuthenticatedUser(updatedUser));
    }

    private AuthTokenResponse issueTokens(AuthenticatedUser user) {
        revokeTokens(user.getUser());

        RefreshToken refreshToken = new RefreshToken();
        refreshToken.setUser(user.getUser());
        refreshToken.setToken(jwtService.generateRefreshToken());
        refreshToken.setCreatedAt(clock.instant());
        refreshToken.setExpiresAt(clock.instant().plus(authProperties.getRefreshTokenTtlDays(), ChronoUnit.DAYS));
        refreshToken.setRevoked(false);
        refreshTokenRepository.save(refreshToken);

        return new AuthTokenResponse(
                jwtService.generateAccessToken(user),
                refreshToken.getToken(),
                toProfile(user.getUser())
        );
    }

    private void revokeTokens(AppUser user) {
        refreshTokenRepository.findByUserAndRevokedFalse(user).forEach(token -> token.setRevoked(true));
    }

    private UserProfileResponse toProfile(AppUser user) {
        return new UserProfileResponse(user.getId(), user.getEmail(), user.getDisplayName(), user.getRole(), resolveAuthProvider(user));
    }

    private AppUser createGoogleUser(GoogleTokenVerifierService.GoogleUserProfile googleProfile) {
        appUserRepository.findByEmail(googleProfile.email())
                .ifPresent(existingUser -> {
                    throw new IllegalStateException("Konto z tym adresem email juz istnieje. Zaloguj sie dotychczasowa metoda.");
                });

        AppUser user = new AppUser();
        user.setEmail(googleProfile.email());
        user.setDisplayName(googleProfile.displayName());
        user.setPasswordHash(passwordEncoder.encode(UUID.randomUUID().toString()));
        user.setAuthProvider(AuthProvider.GOOGLE);
        user.setGoogleSubject(googleProfile.subject());
        user.setRole(UserRole.USER);
        user.setCreatedAt(clock.instant());
        return appUserRepository.save(user);
    }

    private AuthProvider resolveAuthProvider(AppUser user) {
        return user.getAuthProvider() != null ? user.getAuthProvider() : AuthProvider.LOCAL;
    }
}
