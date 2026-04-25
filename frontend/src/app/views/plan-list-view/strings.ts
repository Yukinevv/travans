import { createLocalizedStrings } from '../../core/i18n/localized-strings';

const localizedStrings = {
  pl: {
    confirmation: {
      deleteDescription: 'Ta operacja usunie plan wraz ze wszystkimi jego dniami treningowymi.',
      deleteTitle: 'Usunąć plan?',
      description: 'Czy na pewno chcesz ustawić ten plan jako widoczny na dashboardzie?',
      kicker: 'Potwierdzenie',
      title: 'Pokazać plan na dashboardzie?'
    },
    emptyState: {
      description: 'Dodaj pierwszy plan w widoku "Nowy plan".',
      title: 'Nie masz jeszcze zapisanych planów.'
    },
    errors: {
      deletePlan: 'Nie udało się usunąć planu',
      loadPlans: 'Nie udało się pobrać planów'
    },
    header: {
      kicker: 'Lista',
      title: 'Zapisane plany'
    },
    loading: 'Ładowanie planów...',
    plan: {
      createdAt: 'Utworzono:',
      dayPrefix: 'Dzień',
      deleteConfirmation: 'Czy na pewno chcesz usunąć plan "%s"?',
      edit: 'Edytuj',
      matched: 'Dopasowano:',
      showOnDashboard: 'Pokaż na dashboardzie',
      startDate: 'Start planu:',
      stravaFrom: 'Strava od:',
      typePrefix: 'Typ planu:',
      visibleOnDashboard: 'Widoczny na dashboardzie'
    },
    toggle: {
      hideDetails: 'Ukryj szczegóły',
      showDetails: 'Pokaż szczegóły'
    },
    units: {
      days: 'dni'
    }
  },
  en: {
    confirmation: {
      deleteDescription: 'This action will remove the plan together with all of its training days.',
      deleteTitle: 'Delete this plan?',
      description: 'Are you sure you want to set this plan as visible on the dashboard?',
      kicker: 'Confirmation',
      title: 'Show this plan on the dashboard?'
    },
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
