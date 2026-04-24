export const strings = {
  currentPlan: {
    emptyDescription: 'Dodaj plan treningowy, a dashboard zacznie pokazywać postęp i dopasowane treningi ze Stravy.',
    emptyTitle: 'Brak aktywnego planu',
    label: 'Bieżący plan',
    pinnedMessage: 'Plan został przypięty do dashboardu.',
    typePrefix: 'Typ planu:'
  },
  details: {
    activity: 'Aktywność',
    averageCadence: 'Średnia kadencja',
    averageHeartrate: 'Średnie tętno',
    averageRideSpeed: 'Średnia prędkość jazdy',
    averageRunPace: 'Średnie tempo biegu',
    completedSection: 'Wykonanie',
    daysMeetingDistanceGoal: 'Dni z celem dystansu',
    daysMeetingDurationGoal: 'Dni z celem czasu',
    daysMeetingPaceGoal: 'Dni z celem tempa',
    distanceGoal: 'Cel dystansu',
    durationGoal: 'Cel czasu',
    elevationGain: 'Przewyższenie',
    fastestRunPace: 'Najszybsze tempo biegu',
    label: 'Statystyki szczegółowe',
    maxHeartrate: 'Maks. tętno',
    maxRideSpeed: 'Maksymalna prędkość jazdy',
    maxSpeed: 'Maks. prędkość',
    matchedActivity: 'Powiązana aktywność:',
    more: 'Więcej danych',
    notes: 'Notatki',
    overDistance: 'Nadwyżka dystansu',
    overDuration: 'Nadwyżka czasu',
    paceGoal: 'Cel tempa',
    planned: 'Plan:',
    plannedSection: 'Plan',
    savedTime: 'Zysk czasu',
    scheduledFor: 'Termin',
    topSpeed: 'Średnia prędkość:',
    averageSpeed: 'Średnia prędkość:',
    done: 'Wykonano:',
    hideDetails: 'Ukryj szczegóły',
    showDetails: 'Pokaż szczegóły'
  },
  errors: {
    loadPlans: 'Nie udało się pobrać listy planów',
    loadSummary: 'Nie udało się pobrać danych dashboardu'
  },
  header: {
    autoSelect: 'Automatycznie wybrany',
    displayedPlan: 'Wyświetlany plan',
    kicker: 'Pulpit',
    title: 'Postęp realizacji planu'
  },
  loading: {
    dashboard: 'Ładowanie danych dashboardu...'
  },
  stats: {
    completed: 'Wykonane',
    effectiveness: 'Skuteczność',
    missed: 'Pominięte',
    partial: 'Częściowo',
    planned: 'Zaplanowane'
  }
};

export type ModuleStrings = typeof strings;
