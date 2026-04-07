package com.travans.backend.security;

import com.travans.backend.domain.AppUser;
import com.travans.backend.domain.UserRole;
import java.util.Collection;
import java.util.List;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

public class AuthenticatedUser implements UserDetails {

    private final AppUser user;

    public AuthenticatedUser(AppUser user) {
        this.user = user;
    }

    public Long getId() {
        return user.getId();
    }

    public String getDisplayName() {
        return user.getDisplayName();
    }

    public UserRole getRole() {
        return user.getRole();
    }

    public AppUser getUser() {
        return user;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority("ROLE_" + user.getRole().name()));
    }

    @Override
    public String getPassword() {
        return user.getPasswordHash();
    }

    @Override
    public String getUsername() {
        return user.getEmail();
    }
}
