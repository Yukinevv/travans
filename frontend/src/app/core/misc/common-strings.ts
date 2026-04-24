export const strings = {
  actions: {
    back: 'Wroc',
    cancel: 'Anuluj',
    delete: 'Usun',
    edit: 'Edytuj',
    login: 'Zaloguj',
    logout: 'Wyloguj',
    register: 'Utworz konto',
    retry: 'Sprobuj ponownie',
    save: 'Zapisz',
    sync: 'Synchronizuj'
  },
  auth: {
    validation: {
      email: 'Podaj poprawny adres email',
      minlength: 'Minimalna dlugosc to 8 znakow',
      required: 'Pole jest wymagane'
    },
    errors: {
      badCredentials: 'Nieprawidlowy email lub haslo',
      conflict: 'Nie mozna wykonac operacji z powodu konfliktu danych',
      default: 'Wystapil blad podczas autoryzacji',
      invalidForm: 'Popraw dane formularza'
    }
  },
  labels: {
    category: 'Kategoria',
    createdAt: 'Utworzono',
    dashboard: 'Dashboard',
    date: 'Data',
    description: 'Opis',
    distance: 'Dystans',
    duration: 'Czas',
    email: 'Email',
    integrations: 'Integracje',
    lastSync: 'Ostatnia synchronizacja',
    name: 'Nazwa',
    notes: 'Notatki',
    password: 'Haslo',
    startDate: 'Data startu',
    strava: 'Strava',
    title: 'Tytul',
    type: 'Typ'
  },
  metrics: {
    noCriteria: 'Brak kryterium',
    noDistance: 'Brak dystansu',
    noDuration: 'Brak czasu',
    none: '-'
  },
  states: {
    achieved: 'Osiagniete',
    connected: 'Polaczono',
    disconnected: 'Nie polaczono',
    matched: 'Dopasowano',
    notAchieved: 'Nieosigniete',
    unmatched: 'Bez dopasowania'
  },
  training: {
    activityTypes: {
      OTHER: 'Inna aktywnosc',
      RIDE: 'Rower',
      RUN: 'Bieg',
      STRENGTH: 'Silownia',
      SWIM: 'Plywanie',
      WALK: 'Marsz',
      WORKOUT: 'Trening'
    },
    dayStatuses: {
      COMPLETED: 'Wykonany',
      MISSED: 'Pominiety',
      PARTIALLY_COMPLETED: 'Czesciowo wykonany',
      PLANNED: 'Zaplanowany'
    }
  }
};

export type CommonStrings = typeof strings;
