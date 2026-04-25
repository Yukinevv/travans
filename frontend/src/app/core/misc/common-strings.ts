import { createLocalizedStrings } from '../i18n/localized-strings';

const localizedStrings = {
  pl: {
    actions: {
      back: 'Wr\u00f3\u0107',
      cancel: 'Anuluj',
      delete: 'Usu\u0144',
      edit: 'Edytuj',
      login: 'Zaloguj',
      logout: 'Wyloguj',
      register: 'Utw\u00f3rz konto',
      retry: 'Spr\u00f3buj ponownie',
      save: 'Zapisz',
      sync: 'Synchronizuj'
    },
    auth: {
      validation: {
        email: 'Podaj poprawny adres email',
        minlength: 'Minimalna d\u0142ugo\u015b\u0107 to 8 znak\u00f3w',
        required: 'Pole jest wymagane'
      },
      errors: {
        badCredentials: 'Nieprawid\u0142owy email lub has\u0142o',
        conflict: 'Nie mo\u017cna wykona\u0107 operacji z powodu konfliktu danych',
        default: 'Wyst\u0105pi\u0142 b\u0142\u0105d podczas autoryzacji',
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
      password: 'Has\u0142o',
      startDate: 'Data startu',
      strava: 'Strava',
      title: 'Tytu\u0142',
      type: 'Typ'
    },
    metrics: {
      noCriteria: 'Brak kryterium',
      noDistance: 'Brak dystansu',
      noDuration: 'Brak czasu',
      none: '-'
    },
    states: {
      achieved: 'Osi\u0105gni\u0119te',
      connected: 'Po\u0142\u0105czono',
      disconnected: 'Nie po\u0142\u0105czono',
      matched: 'Dopasowano',
      notAchieved: 'Nieosi\u0105gni\u0119te',
      unmatched: 'Bez dopasowania'
    },
    training: {
      activityTypes: {
        OTHER: 'Inna aktywno\u015b\u0107',
        RIDE: 'Rower',
        RUN: 'Bieg',
        STRENGTH: 'Si\u0142ownia',
        SWIM: 'P\u0142ywanie',
        WALK: 'Marsz',
        WORKOUT: 'Trening'
      },
      dayStatuses: {
        COMPLETED: 'Wykonany',
        MISSED: 'Pomini\u0119ty',
        PARTIALLY_COMPLETED: 'Cz\u0119\u015bciowo wykonany',
        PLANNED: 'Zaplanowany'
      }
    }
  },
  en: {
    actions: {
      back: 'Back',
      cancel: 'Cancel',
      delete: 'Delete',
      edit: 'Edit',
      login: 'Log in',
      logout: 'Log out',
      register: 'Create account',
      retry: 'Try again',
      save: 'Save',
      sync: 'Sync'
    },
    auth: {
      validation: {
        email: 'Enter a valid email address',
        minlength: 'Minimum length is 8 characters',
        required: 'This field is required'
      },
      errors: {
        badCredentials: 'Invalid email or password',
        conflict: 'The operation could not be completed because of a data conflict',
        default: 'An authorization error occurred',
        invalidForm: 'Correct the form data'
      }
    },
    labels: {
      category: 'Category',
      createdAt: 'Created',
      dashboard: 'Dashboard',
      date: 'Date',
      description: 'Description',
      distance: 'Distance',
      duration: 'Duration',
      email: 'Email',
      integrations: 'Integrations',
      lastSync: 'Last sync',
      name: 'Name',
      notes: 'Notes',
      password: 'Password',
      startDate: 'Start date',
      strava: 'Strava',
      title: 'Title',
      type: 'Type'
    },
    metrics: {
      noCriteria: 'No criteria',
      noDistance: 'No distance',
      noDuration: 'No duration',
      none: '-'
    },
    states: {
      achieved: 'Achieved',
      connected: 'Connected',
      disconnected: 'Disconnected',
      matched: 'Matched',
      notAchieved: 'Not achieved',
      unmatched: 'Unmatched'
    },
    training: {
      activityTypes: {
        OTHER: 'Other activity',
        RIDE: 'Ride',
        RUN: 'Run',
        STRENGTH: 'Strength',
        SWIM: 'Swim',
        WALK: 'Walk',
        WORKOUT: 'Workout'
      },
      dayStatuses: {
        COMPLETED: 'Completed',
        MISSED: 'Missed',
        PARTIALLY_COMPLETED: 'Partially completed',
        PLANNED: 'Planned'
      }
    }
  }
};

export const strings = createLocalizedStrings(localizedStrings);

export type CommonStrings = typeof localizedStrings.pl;
