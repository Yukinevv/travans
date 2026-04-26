package com.travans.backend.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "travans.strava")
public class StravaProperties {

    private String baseUrl;
    private String oauthUrl;
    private String mobileOauthUrl;
    private String tokenUrl;
    private String clientId;
    private String clientSecret;
    private String backendCallbackUri;
    private String webRedirectUri;
    private String mobileRedirectUri;
    private String webhookVerifyToken;

    public String getBaseUrl() {
        return baseUrl;
    }

    public void setBaseUrl(String baseUrl) {
        this.baseUrl = baseUrl;
    }

    public String getOauthUrl() {
        return oauthUrl;
    }

    public void setOauthUrl(String oauthUrl) {
        this.oauthUrl = oauthUrl;
    }

    public String getMobileOauthUrl() {
        return mobileOauthUrl;
    }

    public void setMobileOauthUrl(String mobileOauthUrl) {
        this.mobileOauthUrl = mobileOauthUrl;
    }

    public String getTokenUrl() {
        return tokenUrl;
    }

    public void setTokenUrl(String tokenUrl) {
        this.tokenUrl = tokenUrl;
    }

    public String getClientId() {
        return clientId;
    }

    public void setClientId(String clientId) {
        this.clientId = clientId;
    }

    public String getClientSecret() {
        return clientSecret;
    }

    public void setClientSecret(String clientSecret) {
        this.clientSecret = clientSecret;
    }

    public String getBackendCallbackUri() {
        return backendCallbackUri;
    }

    public void setBackendCallbackUri(String backendCallbackUri) {
        this.backendCallbackUri = backendCallbackUri;
    }

    public String getWebRedirectUri() {
        return webRedirectUri;
    }

    public void setWebRedirectUri(String webRedirectUri) {
        this.webRedirectUri = webRedirectUri;
    }

    public String getMobileRedirectUri() {
        return mobileRedirectUri;
    }

    public void setMobileRedirectUri(String mobileRedirectUri) {
        this.mobileRedirectUri = mobileRedirectUri;
    }

    public String getWebhookVerifyToken() {
        return webhookVerifyToken;
    }

    public void setWebhookVerifyToken(String webhookVerifyToken) {
        this.webhookVerifyToken = webhookVerifyToken;
    }
}
