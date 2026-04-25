package com.travans.backend.api.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record UpdateProfileRequest(
        @Email @NotBlank String email,
        @NotBlank @Size(max = 120) String displayName
) {
}
