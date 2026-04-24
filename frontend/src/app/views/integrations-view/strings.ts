export const strings = {
  activities: {
    empty: 'Brak pobranych aktywności. Kliknij Synchronizuj, aby pobrać treningi z konta Strava.',
    kicker: 'Aktywności',
    loading: 'Ładowanie aktywności...',
    matched: 'Dopasowano',
    title: 'Treningi pobrane ze Stravy',
    unmatched: {
      description: 'Ta aktywność nie została jeszcze powiązana z żadnym dniem planu.',
      label: 'Bez dopasowania'
    }
  },
  connection: {
    authorizationRequired: 'Połączenie ze Strava wymaga ponownej autoryzacji. Kliknij przycisk powyżej, aby odnowić dostęp.',
    connect: 'Połącz ze Strava',
    connectedAccount: 'Połączenie konta',
    connectIntro: 'Połącz konto Strava, aby pobrać swoje aktywności i dopasować je do planu treningowego.',
    kicker: 'Strava',
    loading: 'Ładowanie statusu integracji...',
    reconnect: 'Połącz ponownie ze Strava',
    retry: 'Spróbuj ponownie',
    syncInProgress: 'Synchronizacja...',
    title: 'Połączenie ze Strava'
  },
  errors: {
    loadActivities: 'Nie udało się pobrać aktywności ze Stravy',
    loadStatus: 'Nie udało się pobrać statusu integracji',
    sync: 'Nie udało się zsynchronizować danych ze Strava'
  },
  filters: {
    all: 'Wszystkie',
    strength: 'Siłownia'
  },
  header: {
    kicker: 'Integracje',
    title: 'Połączenie ze Strava'
  },
  labels: {
    athleteId: 'ID atleta:',
    category: 'Kategoria',
    importedActivities: 'Zaimportowane aktywności:',
    matchedTrainingDays: 'Dopasowane dni planu:',
    resultKicker: 'Wynik',
    resultTitle: 'Ostatnia synchronizacja'
  }
};

export type ModuleStrings = typeof strings;
