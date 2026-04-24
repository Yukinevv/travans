export const strings = {
  details: {
    averageCadence: 'Średnia kadencja',
    averageHeartrate: 'Średnie tętno',
    averagePace: 'Średnie tempo',
    averageSpeed: 'Średnia prędkość',
    distance: 'Dystans',
    duration: 'Czas',
    elevationGain: 'Przewyższenie',
    maxHeartrate: 'Maksymalne tętno',
    maxSpeed: 'Maksymalna prędkość',
    startDate: 'Data startu'
  },
  errors: {
    invalidId: 'Nie znaleziono identyfikatora aktywności',
    loadActivity: 'Nie udało się pobrać szczegółów aktywności'
  },
  header: {
    back: 'Wróć do listy',
    kicker: 'Integracje',
    loading: 'Ładowanie szczegółów aktywności...',
    title: 'Szczegóły aktywności'
  },
  match: {
    kicker: 'Powiązanie z planem',
    matched: 'Dopasowano do planu',
    unmatchedDescription: 'Ta aktywność nie została jeszcze przypisana do żadnego dnia planu treningowego.',
    unmatchedTitle: 'Brak dopasowania'
  },
  section: {
    kicker: 'Strava'
  }
};

export type ModuleStrings = typeof strings;
