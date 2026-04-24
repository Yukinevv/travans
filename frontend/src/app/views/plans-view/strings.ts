export const strings = {
  actions: {
    addDay: 'Dodaj dzien',
    cancel: 'Anuluj',
    removeDay: 'Usun dzien',
    saveChanges: 'Zapisz zmiany',
    savePlan: 'Zapisz plan'
  },
  day: {
    dayLabel: 'Dzien',
    downAriaLabel: 'Przenies nizej',
    notes: 'Notatki',
    plannedDistance: 'Dystans planowany (m)',
    plannedDuration: 'Czas planowany (s)',
    removeConfirmation: 'Czy na pewno chcesz usunac dzien treningowy %d?',
    title: 'Dzien treningowy %d',
    upAriaLabel: 'Przenies wyzej'
  },
  defaults: {
    jsonInput: `{
  "name": "Przykladowy plan 10 km",
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
    invalidJson: 'JSON jest niepoprawny. Sprawdz skladnie i przecinki.',
    invalidJsonFile: 'Wybierz plik JSON z rozszerzeniem .json.',
    loadPlan: 'Nie udalo sie pobrac planu do edycji',
    readJsonFile: 'Nie udalo sie odczytac pliku JSON.',
    requiredField: '%s jest wymagane.',
    savePlan: 'Nie udalo sie zapisac planu',
    submitRequired: 'Uzupelnij wymagane pola planu przed zapisem.'
  },
  form: {
    description: 'Opis',
    name: 'Nazwa',
    planType: 'Typ planu',
    startDate: 'Data startu',
    stravaEvaluationStartDate: 'Uwzgledniaj Strave od',
    title: 'Tytul'
  },
  header: {
    editTitle: 'Edytuj plan',
    kicker: 'Nowy plan',
    loadingEdit: 'Ladowanie planu do edycji...',
    newTitle: 'Dodaj plan recznie'
  },
  import: {
    description: 'Wybranie pliku lub wklejenie poprawnego JSON-a automatycznie uzupelni formularz planu.',
    fileButton: 'Wczytaj plik',
    fileNotSelected: 'Nie wybrano pliku',
    kicker: 'Import JSON',
    title: 'Wklej plan lub wczytaj plik JSON'
  }
};

export type ModuleStrings = typeof strings;
