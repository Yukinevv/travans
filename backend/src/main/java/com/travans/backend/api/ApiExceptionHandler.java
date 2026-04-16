package com.travans.backend.api;

import com.travans.backend.api.dto.ApiErrorResponse;
import com.travans.backend.exception.AuthException;
import com.travans.backend.exception.StravaIntegrationException;
import jakarta.persistence.EntityNotFoundException;
import java.util.LinkedHashMap;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class ApiExceptionHandler {

    @ExceptionHandler(EntityNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ApiErrorResponse handleNotFound(EntityNotFoundException exception) {
        return new ApiErrorResponse("NOT_FOUND", exception.getMessage(), Map.of());
    }

    @ExceptionHandler({IllegalArgumentException.class, MethodArgumentNotValidException.class})
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ApiErrorResponse handleBadRequest(Exception exception) {
        if (exception instanceof MethodArgumentNotValidException validationException) {
            Map<String, String> fieldErrors = new LinkedHashMap<>();
            validationException.getBindingResult().getFieldErrors()
                    .forEach(error -> fieldErrors.put(error.getField(), resolveValidationMessage(error.getDefaultMessage())));

            return new ApiErrorResponse("VALIDATION_ERROR", "Popraw zaznaczone pola", fieldErrors);
        }
        return new ApiErrorResponse("BAD_REQUEST", exception.getMessage(), Map.of());
    }

    @ExceptionHandler(IllegalStateException.class)
    @ResponseStatus(HttpStatus.CONFLICT)
    public ApiErrorResponse handleConflict(IllegalStateException exception) {
        return new ApiErrorResponse("CONFLICT", exception.getMessage(), Map.of());
    }

    @ExceptionHandler({BadCredentialsException.class, AuthenticationException.class})
    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    public ApiErrorResponse handleUnauthorized(Exception exception) {
        return new ApiErrorResponse("INVALID_CREDENTIALS", "Nieprawidlowy email lub haslo", Map.of());
    }

    @ExceptionHandler(AuthException.class)
    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    public ApiErrorResponse handleAuthException(AuthException exception) {
        return new ApiErrorResponse(exception.getCode(), exception.getMessage(), Map.of());
    }

    @ExceptionHandler(StravaIntegrationException.class)
    public org.springframework.http.ResponseEntity<ApiErrorResponse> handleStravaIntegrationException(StravaIntegrationException exception) {
        return org.springframework.http.ResponseEntity.status(exception.getStatus())
                .body(new ApiErrorResponse(exception.getCode(), exception.getMessage(), Map.of()));
    }

    private String resolveValidationMessage(String defaultMessage) {
        if (defaultMessage == null) {
            return "Niepoprawna wartosc";
        }

        return switch (defaultMessage) {
            case "must not be blank" -> "Pole jest wymagane";
            case "must not be null" -> "Pole jest wymagane";
            case "must be a well-formed email address" -> "Podaj poprawny adres email";
            default -> {
                if (defaultMessage.startsWith("size must be between")) {
                    yield "Nieprawidlowa dlugosc pola";
                }
                if (defaultMessage.startsWith("must be greater than or equal to")) {
                    yield "Wartosc jest za mala";
                }
                yield defaultMessage;
            }
        };
    }
}
