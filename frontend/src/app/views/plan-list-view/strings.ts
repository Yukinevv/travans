export const strings = {
  emptyState: {
    description: 'Dodaj pierwszy plan w widoku "Nowy plan".',
    title: 'Nie masz jeszcze zapisanych planow.'
  },
  errors: {
    deletePlan: 'Nie udalo sie usunac planu',
    loadPlans: 'Nie udalo sie pobrac planow'
  },
  header: {
    kicker: 'Lista',
    title: 'Zapisane plany'
  },
  loading: 'Ladowanie planow...',
  plan: {
    createdAt: 'Utworzono:',
    dayPrefix: 'Dzien',
    deleteConfirmation: 'Czy na pewno chcesz usunac plan "%s"?',
    edit: 'Edytuj',
    matched: 'Dopasowano:',
    showOnDashboard: 'Pokaz na dashboardzie',
    startDate: 'Start planu:',
    stravaFrom: 'Strava od:',
    typePrefix: 'Typ planu:',
    visibleOnDashboard: 'Widoczny na dashboardzie'
  },
  toggle: {
    hideDetails: 'Ukryj szczegoly',
    showDetails: 'Pokaz szczegoly'
  },
  units: {
    days: 'dni'
  }
};

export type ModuleStrings = typeof strings;
