import { createLocalizedStrings } from '../../core/i18n/localized-strings';

const localizedStrings = {
  pl: {
    details: {
      averageCadence: '\u015arednia kadencja',
      averageHeartrate: '\u015arednie t\u0119tno',
      averagePace: '\u015arednie tempo',
      averageSpeed: '\u015arednia pr\u0119dko\u015b\u0107',
      distance: 'Dystans',
      duration: 'Czas',
      elevationGain: 'Przewy\u017cszenie',
      maxHeartrate: 'Maksymalne t\u0119tno',
      maxSpeed: 'Maksymalna pr\u0119dko\u015b\u0107',
      startDate: 'Data startu'
    },
    errors: {
      invalidId: 'Nie znaleziono identyfikatora aktywno\u015bci',
      loadActivity: 'Nie uda\u0142o si\u0119 pobra\u0107 szczeg\u00f3\u0142\u00f3w aktywno\u015bci'
    },
    header: {
      back: 'Wr\u00f3\u0107 do listy',
      kicker: 'Integracje',
      loading: '\u0141adowanie szczeg\u00f3\u0142\u00f3w aktywno\u015bci...',
      title: 'Szczeg\u00f3\u0142y aktywno\u015bci'
    },
    match: {
      kicker: 'Powi\u0105zanie z planem',
      matched: 'Dopasowano do planu',
      unmatchedDescription: 'Ta aktywno\u015b\u0107 nie zosta\u0142a jeszcze przypisana do \u017cadnego dnia planu treningowego.',
      unmatchedTitle: 'Brak dopasowania'
    },
    section: {
      kicker: 'Strava'
    }
  },
  en: {
    details: {
      averageCadence: 'Average cadence',
      averageHeartrate: 'Average heart rate',
      averagePace: 'Average pace',
      averageSpeed: 'Average speed',
      distance: 'Distance',
      duration: 'Duration',
      elevationGain: 'Elevation gain',
      maxHeartrate: 'Max heart rate',
      maxSpeed: 'Max speed',
      startDate: 'Start date'
    },
    errors: {
      invalidId: 'Activity identifier was not found',
      loadActivity: 'Could not load activity details'
    },
    header: {
      back: 'Back to list',
      kicker: 'Integrations',
      loading: 'Loading activity details...',
      title: 'Activity details'
    },
    match: {
      kicker: 'Plan match',
      matched: 'Matched to a plan',
      unmatchedDescription: 'This activity has not been assigned to any training plan day yet.',
      unmatchedTitle: 'No match'
    },
    section: {
      kicker: 'Strava'
    }
  }
};

export const strings = createLocalizedStrings(localizedStrings);

export type ModuleStrings = typeof localizedStrings.pl;
