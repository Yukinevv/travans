export const strings = {
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
};

export type ModuleStrings = typeof strings;
