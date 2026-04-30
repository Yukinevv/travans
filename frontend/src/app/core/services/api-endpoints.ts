import { API_BASE_URL } from './api-base';

export const API_ENDPOINTS = {
  auth: {
    login: `${API_BASE_URL}/auth/login`,
    google: `${API_BASE_URL}/auth/google`,
    register: `${API_BASE_URL}/auth/register`,
    me: `${API_BASE_URL}/auth/me`,
    changePassword: `${API_BASE_URL}/auth/change-password`,
    avatar: `${API_BASE_URL}/auth/avatar`,
    refresh: `${API_BASE_URL}/auth/refresh`
  },
  plans: {
    collection: `${API_BASE_URL}/plans`,
    import: `${API_BASE_URL}/plans/import`,
    detail: (planId: number) => `${API_BASE_URL}/plans/${planId}`
  },
  dashboard: {
    summary: `${API_BASE_URL}/dashboard/summary`
  },
  strava: {
    status: `${API_BASE_URL}/integrations/strava/status`,
    activities: `${API_BASE_URL}/integrations/strava/activities`,
    exchangeToken: `${API_BASE_URL}/integrations/strava/exchange-token`,
    sync: `${API_BASE_URL}/integrations/strava/sync`,
    activityDetail: (activityId: number) =>
      `${API_BASE_URL}/integrations/strava/activities/${activityId}`
  }
} as const;
