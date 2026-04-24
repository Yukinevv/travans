export const strings = {
  currentPlan: {
    emptyDescription: 'Dodaj plan treningowy, a dashboard zacznie pokazywać postęp i dopasowane treningi ze Stravy.',
    emptyTitle: 'Brak aktywnego planu',
    label: 'Bieżący plan',
    pinnedMessage: 'Plan został przypięty do dashboardu.',
    typePrefix: 'Typ planu:'
  },
  details: {
    averageCadence: 'Średnia kadencja',
    averageHeartrate: 'Średnie tętno',
    averageRideSpeed: 'Średnia prędkość jazdy',
    averageRunPace: 'Średnie tempo biegu',
    daysMeetingDistanceGoal: 'Dni z celem dystansu',
    daysMeetingDurationGoal: 'Dni z celem czasu',
    daysMeetingPaceGoal: 'Dni z celem tempa',
    distanceGoal: 'Cel dystansu',
    durationGoal: 'Cel czasu',
    elevationGain: 'Przewyższenie',
    fastestRunPace: 'Najszybsze tempo biegu',
    label: 'Statystyki szczegółowe',
    maxRideSpeed: 'Maksymalna prędkość jazdy',
    maxSpeed: 'Maks. prędkość',
    matchedActivity: 'Powiązana aktywność:',
    overDistance: 'Nadwyżka dystansu',
    overDuration: 'Nadwyżka czasu',
    paceGoal: 'Cel tempa',
    planned: 'Plan:',
    savedTime: 'Zysk czasu',
    topSpeed: 'Średnia prędkość:',
    averageSpeed: 'Średnia prędkość:',
    done: 'Wykonano:'
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
