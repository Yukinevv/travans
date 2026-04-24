export const strings = {
  activities: {
    empty: 'Brak pobranych aktywnosci. Kliknij Synchronizuj, aby pobrac treningi z konta Strava.',
    kicker: 'Aktywnosci',
    loading: 'Ladowanie aktywnosci...',
    matched: 'Dopasowano',
    title: 'Treningi pobrane ze Stravy',
    unmatched: {
      description: 'Ta aktywnosc nie zostala jeszcze powiazana z zadnym dniem planu.',
      label: 'Bez dopasowania'
    }
  },
  connection: {
    authorizationRequired: 'Polaczenie ze Strava wymaga ponownej autoryzacji. Kliknij przycisk powyzej, aby odnowic dostep.',
    connect: 'Polacz ze Strava',
    connectedAccount: 'Polaczenie konta',
    connectIntro: 'Polacz konto Strava, aby pobrac swoje aktywnosci i dopasowac je do planu treningowego.',
    kicker: 'Strava',
    loading: 'Ladowanie statusu integracji...',
    reconnect: 'Polacz ponownie ze Strava',
    retry: 'Sprobuj ponownie',
    syncInProgress: 'Synchronizacja...',
    title: 'Polaczenie ze Strava'
  },
  errors: {
    loadActivities: 'Nie udalo sie pobrac aktywnosci ze Stravy',
    loadStatus: 'Nie udalo sie pobrac statusu integracji',
    sync: 'Nie udalo sie zsynchronizowac danych ze Strava'
  },
  filters: {
    all: 'Wszystkie',
    strength: 'Silownia'
  },
  header: {
    kicker: 'Integracje',
    title: 'Polaczenie ze Strava'
  },
  labels: {
    athleteId: 'ID atleta:',
    category: 'Kategoria',
    importedActivities: 'Zaimportowane aktywnosci:',
    matchedTrainingDays: 'Dopasowane dni planu:',
    resultKicker: 'Wynik',
    resultTitle: 'Ostatnia synchronizacja'
  }
};

export type ModuleStrings = typeof strings;
