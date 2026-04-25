import { createLocalizedStrings } from '../../core/i18n/localized-strings';

const localizedStrings = {
  pl: {
    activities: {
      empty: 'Brak pobranych aktywno\u015bci. Kliknij Synchronizuj, aby pobra\u0107 treningi z konta Strava.',
      kicker: 'Aktywno\u015bci',
      loading: '\u0141adowanie aktywno\u015bci...',
      matched: 'Dopasowano',
      title: 'Treningi pobrane ze Stravy',
      unmatched: {
        description: 'Ta aktywno\u015b\u0107 nie zosta\u0142a jeszcze powi\u0105zana z \u017cadnym dniem planu.',
        label: 'Bez dopasowania'
      }
    },
    confirmation: {
      description: 'Czy na pewno chcesz uruchomi\u0107 synchronizacj\u0119 danych ze Stravy?',
      kicker: 'Potwierdzenie',
      title: 'Synchronizowa\u0107 konto Strava?'
    },
    connection: {
      authorizationRequired: 'Po\u0142\u0105czenie ze Strava wymaga ponownej autoryzacji. Kliknij przycisk powy\u017cej, aby odnowi\u0107 dost\u0119p.',
      connect: 'Po\u0142\u0105cz ze Strava',
      connectedAccount: 'Po\u0142\u0105czenie konta',
      connectIntro: 'Po\u0142\u0105cz konto Strava, aby pobra\u0107 swoje aktywno\u015bci i dopasowa\u0107 je do planu treningowego.',
      kicker: 'Strava',
      loading: '\u0141adowanie statusu integracji...',
      reconnect: 'Po\u0142\u0105cz ponownie ze Strava',
      retry: 'Spr\u00f3buj ponownie',
      syncInProgress: 'Synchronizacja...',
      title: 'Po\u0142\u0105czenie ze Strava'
    },
    errors: {
      loadActivities: 'Nie uda\u0142o si\u0119 pobra\u0107 aktywno\u015bci ze Stravy',
      loadStatus: 'Nie uda\u0142o si\u0119 pobra\u0107 statusu integracji',
      sync: 'Nie uda\u0142o si\u0119 zsynchronizowa\u0107 danych ze Strava'
    },
    filters: {
      all: 'Wszystkie',
      strength: 'Si\u0142ownia'
    },
    header: {
      kicker: 'Integracje',
      title: 'Po\u0142\u0105czenie ze Strava'
    },
    labels: {
      athleteId: 'ID atleta:',
      category: 'Kategoria',
      importedActivities: 'Zaimportowane aktywno\u015bci:',
      matchedTrainingDays: 'Dopasowane dni planu:',
      resultKicker: 'Wynik',
      resultTitle: 'Ostatnia synchronizacja'
    }
  },
  en: {
    activities: {
      empty: 'No activities have been downloaded yet. Click Sync to fetch workouts from your Strava account.',
      kicker: 'Activities',
      loading: 'Loading activities...',
      matched: 'Matched',
      title: 'Workouts downloaded from Strava',
      unmatched: {
        description: 'This activity has not been linked to any plan day yet.',
        label: 'Unmatched'
      }
    },
    confirmation: {
      description: 'Are you sure you want to start syncing data from Strava?',
      kicker: 'Confirmation',
      title: 'Sync the Strava account?'
    },
    connection: {
      authorizationRequired: 'The Strava connection requires reauthorization. Click the button above to restore access.',
      connect: 'Connect Strava',
      connectedAccount: 'Connected account',
      connectIntro: 'Connect your Strava account to download activities and match them to your training plan.',
      kicker: 'Strava',
      loading: 'Loading integration status...',
      reconnect: 'Reconnect Strava',
      retry: 'Try again',
      syncInProgress: 'Syncing...',
      title: 'Strava connection'
    },
    errors: {
      loadActivities: 'Could not load activities from Strava',
      loadStatus: 'Could not load integration status',
      sync: 'Could not sync data from Strava'
    },
    filters: {
      all: 'All',
      strength: 'Strength'
    },
    header: {
      kicker: 'Integrations',
      title: 'Strava connection'
    },
    labels: {
      athleteId: 'Athlete ID:',
      category: 'Category',
      importedActivities: 'Imported activities:',
      matchedTrainingDays: 'Matched plan days:',
      resultKicker: 'Result',
      resultTitle: 'Last sync'
    }
  }
};

export const strings = createLocalizedStrings(localizedStrings);

export type ModuleStrings = typeof localizedStrings.pl;
