import { createLocalizedStrings } from '../../core/i18n/localized-strings';

const localizedStrings = {
  pl: {
    actions: {
      addDay: 'Dodaj dzie\u0144',
      cancel: 'Anuluj',
      removeDay: 'Usu\u0144 dzie\u0144',
      saveChanges: 'Zapisz zmiany',
      savePlan: 'Zapisz plan'
    },
    day: {
      dayLabel: 'Dzie\u0144',
      downAriaLabel: 'Przenie\u015b ni\u017cej',
      notes: 'Notatki',
      plannedDistance: 'Dystans planowany (m)',
      plannedDuration: 'Czas planowany (s)',
      removeConfirmation: 'Czy na pewno chcesz usun\u0105\u0107 dzie\u0144 treningowy %d?',
      title: 'Dzie\u0144 treningowy %d',
      upAriaLabel: 'Przenie\u015b wy\u017cej'
    },
    defaults: {
      jsonInput: `{
  "name": "Przyk\u0142adowy plan 10 km",
  "description": "4 tygodnie pracy nad tempem",
  "startDate": "2026-04-13",
  "stravaEvaluationStartDate": "2026-04-13",
  "planType": "RUN",
  "trainingDays": [
    {
      "scheduledDate": "2026-04-13",
      "title": "Easy run",
      "activityType": "RUN",
      "plannedDistanceMeters": 6000,
      "plannedDurationSeconds": 2100,
      "notes": "Lekko"
    }
  ]
}`
    },
    errors: {
      invalidField: '%s jest niepoprawne.',
      invalidJson: 'JSON jest niepoprawny. Sprawd\u017a sk\u0142adni\u0119 i przecinki.',
      invalidJsonFile: 'Wybierz plik JSON z rozszerzeniem .json.',
      loadPlan: 'Nie uda\u0142o si\u0119 pobra\u0107 planu do edycji',
      readJsonFile: 'Nie uda\u0142o si\u0119 odczyta\u0107 pliku JSON.',
      requiredField: '%s jest wymagane.',
      savePlan: 'Nie uda\u0142o si\u0119 zapisa\u0107 planu',
      submitRequired: 'Uzupe\u0142nij wymagane pola planu przed zapisem.'
    },
    form: {
      description: 'Opis',
      name: 'Nazwa',
      planType: 'Typ planu',
      startDate: 'Data startu',
      stravaEvaluationStartDate: 'Uwzgl\u0119dniaj Strav\u0119 od',
      title: 'Tytu\u0142'
    },
    header: {
      editTitle: 'Edytuj plan',
      kicker: 'Nowy plan',
      loadingEdit: '\u0141adowanie planu do edycji...',
      newTitle: 'Dodaj plan r\u0119cznie'
    },
    import: {
      description: 'Wybranie pliku lub wklejenie poprawnego JSON-a automatycznie uzupe\u0142ni formularz planu.',
      fileButton: 'Wczytaj plik',
      fileNotSelected: 'Nie wybrano pliku',
      hidePreview: 'Ukryj podgl\u0105d JSON',
      kicker: 'Import JSON',
      showPreview: 'Poka\u017c podgl\u0105d JSON',
      title: 'Wklej plan lub wczytaj plik JSON'
    }
  },
  en: {
    actions: {
      addDay: 'Add day',
      cancel: 'Cancel',
      removeDay: 'Remove day',
      saveChanges: 'Save changes',
      savePlan: 'Save plan'
    },
    day: {
      dayLabel: 'Day',
      downAriaLabel: 'Move down',
      notes: 'Notes',
      plannedDistance: 'Planned distance (m)',
      plannedDuration: 'Planned duration (s)',
      removeConfirmation: 'Are you sure you want to remove training day %d?',
      title: 'Training day %d',
      upAriaLabel: 'Move up'
    },
    defaults: {
      jsonInput: `{
  "name": "Sample 10 km plan",
  "description": "4 weeks of pace-focused work",
  "startDate": "2026-04-13",
  "stravaEvaluationStartDate": "2026-04-13",
  "planType": "RUN",
  "trainingDays": [
    {
      "scheduledDate": "2026-04-13",
      "title": "Easy run",
      "activityType": "RUN",
      "plannedDistanceMeters": 6000,
      "plannedDurationSeconds": 2100,
      "notes": "Easy effort"
    }
  ]
}`
    },
    errors: {
      invalidField: '%s is invalid.',
      invalidJson: 'The JSON is invalid. Check the syntax and commas.',
      invalidJsonFile: 'Choose a JSON file with the .json extension.',
      loadPlan: 'Could not load the plan for editing',
      readJsonFile: 'Could not read the JSON file.',
      requiredField: '%s is required.',
      savePlan: 'Could not save the plan',
      submitRequired: 'Fill in the required plan fields before saving.'
    },
    form: {
      description: 'Description',
      name: 'Name',
      planType: 'Plan type',
      startDate: 'Start date',
      stravaEvaluationStartDate: 'Include Strava from',
      title: 'Title'
    },
    header: {
      editTitle: 'Edit plan',
      kicker: 'New plan',
      loadingEdit: 'Loading plan for editing...',
      newTitle: 'Add a plan manually'
    },
    import: {
      description: 'Selecting a file or pasting valid JSON will automatically fill the plan form.',
      fileButton: 'Load file',
      fileNotSelected: 'No file selected',
      hidePreview: 'Hide JSON preview',
      kicker: 'JSON import',
      showPreview: 'Show JSON preview',
      title: 'Paste a plan or load a JSON file'
    }
  }
};

export const strings = createLocalizedStrings(localizedStrings);

export type ModuleStrings = typeof localizedStrings.pl;
