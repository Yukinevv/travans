import { createLocalizedStrings } from '../../core/i18n/localized-strings';

const localizedStrings = {
  pl: {
    emptyState: {
      description: 'Dodaj pierwszy plan w widoku "Nowy plan".',
      title: 'Nie masz jeszcze zapisanych plan\u00f3w.'
    },
    errors: {
      deletePlan: 'Nie uda\u0142o si\u0119 usun\u0105\u0107 planu',
      loadPlans: 'Nie uda\u0142o si\u0119 pobra\u0107 plan\u00f3w'
    },
    header: {
      kicker: 'Lista',
      title: 'Zapisane plany'
    },
    loading: '\u0141adowanie plan\u00f3w...',
    plan: {
      createdAt: 'Utworzono:',
      dayPrefix: 'Dzie\u0144',
      deleteConfirmation: 'Czy na pewno chcesz usun\u0105\u0107 plan "%s"?',
      edit: 'Edytuj',
      matched: 'Dopasowano:',
      showOnDashboard: 'Poka\u017c na dashboardzie',
      startDate: 'Start planu:',
      stravaFrom: 'Strava od:',
      typePrefix: 'Typ planu:',
      visibleOnDashboard: 'Widoczny na dashboardzie'
    },
    toggle: {
      hideDetails: 'Ukryj szczeg\u00f3\u0142y',
      showDetails: 'Poka\u017c szczeg\u00f3\u0142y'
    },
    units: {
      days: 'dni'
    }
  },
  en: {
    emptyState: {
      description: 'Add your first plan in the "New plan" view.',
      title: 'You do not have any saved plans yet.'
    },
    errors: {
      deletePlan: 'Could not delete the plan',
      loadPlans: 'Could not load plans'
    },
    header: {
      kicker: 'List',
      title: 'Saved plans'
    },
    loading: 'Loading plans...',
    plan: {
      createdAt: 'Created:',
      dayPrefix: 'Day',
      deleteConfirmation: 'Are you sure you want to delete the plan "%s"?',
      edit: 'Edit',
      matched: 'Matched:',
      showOnDashboard: 'Show on dashboard',
      startDate: 'Plan starts:',
      stravaFrom: 'Strava from:',
      typePrefix: 'Plan type:',
      visibleOnDashboard: 'Visible on dashboard'
    },
    toggle: {
      hideDetails: 'Hide details',
      showDetails: 'Show details'
    },
    units: {
      days: 'days'
    }
  }
};

export const strings = createLocalizedStrings(localizedStrings);

export type ModuleStrings = typeof localizedStrings.pl;
