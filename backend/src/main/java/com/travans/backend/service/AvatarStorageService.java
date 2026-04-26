package com.travans.backend.service;

import com.travans.backend.config.AvatarProperties;
import com.travans.backend.exception.AuthException;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Set;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

@Service
public class AvatarStorageService {

    private static final Set<String> ALLOWED_CONTENT_TYPES = Set.of(
            "image/jpeg",
            "image/png",
            "image/webp",
            "image/gif"
    );

    private final AvatarProperties avatarProperties;

    public AvatarStorageService(AvatarProperties avatarProperties) {
        this.avatarProperties = avatarProperties;
    }

    public String store(MultipartFile file) {
        validate(file);

        try {
            Path storageDirectory = resolveStorageDirectory();
            Files.createDirectories(storageDirectory);

            String extension = resolveExtension(file.getOriginalFilename(), file.getContentType());
            String filename = UUID.randomUUID() + extension;
            Path target = storageDirectory.resolve(filename).normalize();

            try (InputStream inputStream = file.getInputStream()) {
                Files.copy(inputStream, target, StandardCopyOption.REPLACE_EXISTING);
            }

            return "/uploads/avatars/" + filename;
        } catch (IOException exception) {
            throw new IllegalStateException("Nie udalo sie zapisac avatara");
        }
    }

    public void deleteIfUploaded(String avatarUrl) {
        if (avatarUrl == null || !avatarUrl.startsWith("/uploads/avatars/")) {
            return;
        }

        String filename = avatarUrl.substring("/uploads/avatars/".length()).trim();
        if (filename.isEmpty() || filename.contains("/") || filename.contains("\\") || filename.contains("..")) {
            return;
        }

        try {
            Files.deleteIfExists(resolveStorageDirectory().resolve(filename).normalize());
        } catch (IOException ignored) {
        }
    }

    public Path resolveStorageDirectory() {
        return Path.of(avatarProperties.getStoragePath()).toAbsolutePath().normalize();
    }

    private void validate(MultipartFile file) {
        if (file.isEmpty()) {
            throw new AuthException("AVATAR_EMPTY", "Wybierz plik avatara");
        }

        if (file.getSize() > avatarProperties.getMaxFileSizeBytes()) {
            throw new AuthException("AVATAR_TOO_LARGE", "Avatar jest za duzy");
        }

        String contentType = file.getContentType();
        if (contentType == null || !ALLOWED_CONTENT_TYPES.contains(contentType)) {
            throw new AuthException("AVATAR_INVALID_TYPE", "Avatar musi byc plikiem JPG, PNG, WEBP albo GIF");
        }
    }

    private String resolveExtension(String originalFilename, String contentType) {
        String filenameExtension = StringUtils.getFilenameExtension(originalFilename);
        if (filenameExtension != null && !filenameExtension.isBlank()) {
            return "." + filenameExtension.toLowerCase();
        }

        return switch (contentType) {
            case "image/jpeg" -> ".jpg";
            case "image/png" -> ".png";
            case "image/webp" -> ".webp";
            case "image/gif" -> ".gif";
            default -> ".img";
        };
    }
}
