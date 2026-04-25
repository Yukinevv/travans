import { createLocalizedStrings } from './core/i18n/localized-strings';

const localizedStrings = {
  pl: {
    brand: 'Travans',
    navigation: {
      auth: 'Logowanie',
      dashboard: 'Pulpit',
      integrations: 'Integracje',
      newPlan: 'Nowy plan',
      planList: 'Lista plan\u00f3w'
    },
    sidebar: {
      closeAriaLabel: 'Zamknij menu boczne',
      collapseAriaLabel: 'Zwi\u0144 menu boczne',
      expandAriaLabel: 'Rozwi\u0144 menu boczne',
      headline: 'Plan treningowy zsynchronizowany ze Strava',
      languageLabel: 'J\u0119zyk aplikacji',
      lead: 'Tw\u00f3rz plany treningowe, synchronizuj aktywno\u015bci ze Stravy i analizuj realizacj\u0119 swoich cel\u00f3w.'
    },
    session: {
      logout: 'Wyloguj'
    }
  },
  en: {
    brand: 'Travans',
    navigation: {
      auth: 'Sign in',
      dashboard: 'Dashboard',
      integrations: 'Integrations',
      newPlan: 'New plan',
      planList: 'Plan list'
    },
    sidebar: {
      closeAriaLabel: 'Close sidebar',
      collapseAriaLabel: 'Collapse sidebar',
      expandAriaLabel: 'Expand sidebar',
      headline: 'Training plan synced with Strava',
      languageLabel: 'App language',
      lead: 'Create training plans, sync your Strava activities, and track how well you are meeting your goals.'
    },
    session: {
      logout: 'Log out'
    }
  }
};

export const strings = createLocalizedStrings(localizedStrings);

export type ModuleStrings = typeof localizedStrings.pl;
