import { createLocalizedStrings } from '../../core/i18n/localized-strings';

const localizedStrings = {
  pl: {
    currentPlan: {
      emptyDescription: 'Dodaj plan treningowy, a dashboard zacznie pokazywa\u0107 post\u0119p i dopasowane treningi ze Stravy.',
      emptyTitle: 'Brak aktywnego planu',
      label: 'Bie\u017c\u0105cy plan',
      pinnedMessage: 'Plan zosta\u0142 przypi\u0119ty do dashboardu.',
      typePrefix: 'Typ planu:'
    },
    details: {
      activity: 'Aktywno\u015b\u0107',
      averageCadence: '\u015arednia kadencja',
      averageHeartrate: '\u015arednie t\u0119tno',
      averageRideSpeed: '\u015arednia pr\u0119dko\u015b\u0107 jazdy',
      averageRunPace: '\u015arednie tempo biegu',
      averageSpeed: '\u015arednia pr\u0119dko\u015b\u0107:',
      completedSection: 'Wykonanie',
      daysMeetingDistanceGoal: 'Dni z celem dystansu',
      daysMeetingDurationGoal: 'Dni z celem czasu',
      daysMeetingPaceGoal: 'Dni z celem tempa',
      distanceGoal: 'Cel dystansu',
      done: 'Wykonano:',
      durationGoal: 'Cel czasu',
      elevationGain: 'Przewy\u017cszenie',
      fastestRunPace: 'Najszybsze tempo biegu',
      hideDetails: 'Ukryj szczeg\u00f3\u0142y',
      label: 'Statystyki szczeg\u00f3\u0142owe',
      matchedActivity: 'Powi\u0105zana aktywno\u015b\u0107:',
      maxHeartrate: 'Maks. t\u0119tno',
      maxRideSpeed: 'Maksymalna pr\u0119dko\u015b\u0107 jazdy',
      maxSpeed: 'Maks. pr\u0119dko\u015b\u0107',
      more: 'Wi\u0119cej danych',
      notes: 'Notatki',
      overDistance: 'Nadwy\u017cka dystansu',
      overDuration: 'Nadwy\u017cka czasu',
      paceGoal: 'Cel tempa',
      planned: 'Plan:',
      plannedSection: 'Plan',
      savedTime: 'Zysk czasu',
      scheduledFor: 'Termin',
      showDetails: 'Poka\u017c szczeg\u00f3\u0142y',
      topSpeed: '\u015arednia pr\u0119dko\u015b\u0107:'
    },
    errors: {
      loadPlans: 'Nie uda\u0142o si\u0119 pobra\u0107 listy plan\u00f3w',
      loadSummary: 'Nie uda\u0142o si\u0119 pobra\u0107 danych dashboardu'
    },
    header: {
      autoSelect: 'Automatycznie wybrany',
      displayedPlan: 'Wy\u015bwietlany plan',
      kicker: 'Pulpit',
      title: 'Post\u0119p realizacji planu'
    },
    loading: {
      dashboard: '\u0141adowanie danych dashboardu...'
    },
    stats: {
      completed: 'Wykonane',
      effectiveness: 'Skuteczno\u015b\u0107',
      missed: 'Pomini\u0119te',
      partial: 'Cz\u0119\u015bciowo',
      planned: 'Zaplanowane'
    }
  },
  en: {
    currentPlan: {
      emptyDescription: 'Add a training plan and the dashboard will start showing progress and matched Strava workouts.',
      emptyTitle: 'No active plan',
      label: 'Current plan',
      pinnedMessage: 'The plan has been pinned to the dashboard.',
      typePrefix: 'Plan type:'
    },
    details: {
      activity: 'Activity',
      averageCadence: 'Average cadence',
      averageHeartrate: 'Average heart rate',
      averageRideSpeed: 'Average ride speed',
      averageRunPace: 'Average run pace',
      averageSpeed: 'Average speed:',
      completedSection: 'Completed',
      daysMeetingDistanceGoal: 'Days meeting distance goal',
      daysMeetingDurationGoal: 'Days meeting duration goal',
      daysMeetingPaceGoal: 'Days meeting pace goal',
      distanceGoal: 'Distance goal',
      done: 'Done:',
      durationGoal: 'Duration goal',
      elevationGain: 'Elevation gain',
      fastestRunPace: 'Fastest run pace',
      hideDetails: 'Hide details',
      label: 'Detailed stats',
      matchedActivity: 'Matched activity:',
      maxHeartrate: 'Max heart rate',
      maxRideSpeed: 'Max ride speed',
      maxSpeed: 'Max speed',
      more: 'More data',
      notes: 'Notes',
      overDistance: 'Distance surplus',
      overDuration: 'Time surplus',
      paceGoal: 'Pace goal',
      planned: 'Planned:',
      plannedSection: 'Plan',
      savedTime: 'Time saved',
      scheduledFor: 'Scheduled for',
      showDetails: 'Show details',
      topSpeed: 'Average speed:'
    },
    errors: {
      loadPlans: 'Could not load the plan list',
      loadSummary: 'Could not load dashboard data'
    },
    header: {
      autoSelect: 'Automatically selected',
      displayedPlan: 'Displayed plan',
      kicker: 'Dashboard',
      title: 'Plan completion progress'
    },
    loading: {
      dashboard: 'Loading dashboard data...'
    },
    stats: {
      completed: 'Completed',
      effectiveness: 'Effectiveness',
      missed: 'Missed',
      partial: 'Partial',
      planned: 'Planned'
    }
  }
};

export const strings = createLocalizedStrings(localizedStrings);

export type ModuleStrings = typeof localizedStrings.pl;
