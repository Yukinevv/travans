export const strings = {
  actions: {
    back: 'Wróć',
    cancel: 'Anuluj',
    delete: 'Usuń',
    edit: 'Edytuj',
    login: 'Zaloguj',
    logout: 'Wyloguj',
    register: 'Utwórz konto',
    retry: 'Spróbuj ponownie',
    save: 'Zapisz',
    sync: 'Synchronizuj'
  },
  auth: {
    validation: {
      email: 'Podaj poprawny adres email',
      minlength: 'Minimalna długość to 8 znaków',
      required: 'Pole jest wymagane'
    },
    errors: {
      badCredentials: 'Nieprawidłowy email lub hasło',
      conflict: 'Nie można wykonać operacji z powodu konfliktu danych',
      default: 'Wystąpił błąd podczas autoryzacji',
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
    password: 'Hasło',
    startDate: 'Data startu',
    strava: 'Strava',
    title: 'Tytuł',
    type: 'Typ'
  },
  metrics: {
    noCriteria: 'Brak kryterium',
    noDistance: 'Brak dystansu',
    noDuration: 'Brak czasu',
    none: '-'
  },
  states: {
    achieved: 'Osiągnięte',
    connected: 'Połączono',
    disconnected: 'Nie połączono',
    matched: 'Dopasowano',
    notAchieved: 'Nieosiągnięte',
    unmatched: 'Bez dopasowania'
  },
  training: {
    activityTypes: {
      OTHER: 'Inna aktywność',
      RIDE: 'Rower',
      RUN: 'Bieg',
      STRENGTH: 'Siłownia',
      SWIM: 'Pływanie',
      WALK: 'Marsz',
      WORKOUT: 'Trening'
    },
    dayStatuses: {
      COMPLETED: 'Wykonany',
      MISSED: 'Pominięty',
      PARTIALLY_COMPLETED: 'Częściowo wykonany',
      PLANNED: 'Zaplanowany'
    }
  }
};

export type CommonStrings = typeof strings;
