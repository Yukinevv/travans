export const strings = {
  currentPlan: {
    emptyDescription: 'Dodaj plan treningowy, a dashboard zacznie pokazywac postep i dopasowane treningi ze Stravy.',
    emptyTitle: 'Brak aktywnego planu',
    label: 'Biezacy plan',
    pinnedMessage: 'Plan zostal przypiety do dashboardu.',
    typePrefix: 'Typ planu:'
  },
  details: {
    averageCadence: 'Srednia kadencja',
    averageHeartrate: 'Srednie tetno',
    averageRideSpeed: 'Srednia predkosc jazdy',
    averageRunPace: 'Srednie tempo biegu',
    daysMeetingDistanceGoal: 'Dni z celem dystansu',
    daysMeetingDurationGoal: 'Dni z celem czasu',
    daysMeetingPaceGoal: 'Dni z celem tempa',
    distanceGoal: 'Cel dystansu',
    durationGoal: 'Cel czasu',
    elevationGain: 'Przewyzszenie',
    fastestRunPace: 'Najszybsze tempo biegu',
    label: 'Statystyki szczegolowe',
    maxRideSpeed: 'Maksymalna predkosc jazdy',
    maxSpeed: 'Maks. predkosc',
    matchedActivity: 'Powiazana aktywnosc:',
    overDistance: 'Nadwyzka dystansu',
    overDuration: 'Nadwyzka czasu',
    paceGoal: 'Cel tempa',
    planned: 'Plan:',
    savedTime: 'Zysk czasu',
    topSpeed: 'Srednia predkosc:',
    averageSpeed: 'Srednia predkosc:',
    done: 'Wykonano:'
  },
  errors: {
    loadPlans: 'Nie udalo sie pobrac listy planow',
    loadSummary: 'Nie udalo sie pobrac danych dashboardu'
  },
  header: {
    autoSelect: 'Automatycznie wybrany',
    displayedPlan: 'Wyswietlany plan',
    kicker: 'Pulpit',
    title: 'Postep realizacji planu'
  },
  loading: {
    dashboard: 'Ladowanie danych dashboardu...'
  },
  stats: {
    completed: 'Wykonane',
    effectiveness: 'Skutecznosc',
    missed: 'Pominiete',
    partial: 'Czesciowo',
    planned: 'Zaplanowane'
  }
};

export type ModuleStrings = typeof strings;
