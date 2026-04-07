package com.travans.backend.security;

import com.travans.backend.domain.AppUser;
import com.travans.backend.repository.AppUserRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
public class CurrentUserService {

    private final AppUserRepository appUserRepository;

    public CurrentUserService(AppUserRepository appUserRepository) {
        this.appUserRepository = appUserRepository;
    }

    public AuthenticatedUser requireAuthenticatedUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !(authentication.getPrincipal() instanceof AuthenticatedUser user)) {
            throw new IllegalStateException("User is not authenticated");
        }
        return user;
    }

    public AppUser requireCurrentUserEntity() {
        Long userId = requireAuthenticatedUser().getId();
        return appUserRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("Authenticated user not found"));
    }
}
