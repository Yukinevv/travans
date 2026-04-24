export const strings = {
  details: {
    averageCadence: 'Srednia kadencja',
    averageHeartrate: 'Srednie tetno',
    averagePace: 'Srednie tempo',
    averageSpeed: 'Srednia predkosc',
    distance: 'Dystans',
    duration: 'Czas',
    elevationGain: 'Przewyzszenie',
    maxHeartrate: 'Maksymalne tetno',
    maxSpeed: 'Maksymalna predkosc',
    startDate: 'Data startu'
  },
  errors: {
    invalidId: 'Nie znaleziono identyfikatora aktywnosci',
    loadActivity: 'Nie udalo sie pobrac szczegolow aktywnosci'
  },
  header: {
    back: 'Wroc do listy',
    kicker: 'Integracje',
    loading: 'Ladowanie szczegolow aktywnosci...',
    title: 'Szczegoly aktywnosci'
  },
  match: {
    kicker: 'Powiazanie z planem',
    matched: 'Dopasowano do planu',
    unmatchedDescription: 'Ta aktywnosc nie zostala jeszcze przypisana do zadnego dnia planu treningowego.',
    unmatchedTitle: 'Brak dopasowania'
  },
  section: {
    kicker: 'Strava'
  }
};

export type ModuleStrings = typeof strings;
