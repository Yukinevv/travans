package com.travans.backend.api.dto;

import java.util.Map;

public record ApiErrorResponse(
        String code,
        String message,
        Map<String, String> errors
) {
}
