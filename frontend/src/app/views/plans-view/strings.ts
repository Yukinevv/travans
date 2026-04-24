export const strings = {
  actions: {
    addDay: 'Dodaj dzień',
    cancel: 'Anuluj',
    removeDay: 'Usuń dzień',
    saveChanges: 'Zapisz zmiany',
    savePlan: 'Zapisz plan'
  },
  day: {
    dayLabel: 'Dzień',
    downAriaLabel: 'Przenieś niżej',
    notes: 'Notatki',
    plannedDistance: 'Dystans planowany (m)',
    plannedDuration: 'Czas planowany (s)',
    removeConfirmation: 'Czy na pewno chcesz usunąć dzień treningowy %d?',
    title: 'Dzień treningowy %d',
    upAriaLabel: 'Przenieś wyżej'
  },
  defaults: {
    jsonInput: `{
  "name": "Przykładowy plan 10 km",
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
    invalidJson: 'JSON jest niepoprawny. Sprawdź składnię i przecinki.',
    invalidJsonFile: 'Wybierz plik JSON z rozszerzeniem .json.',
    loadPlan: 'Nie udało się pobrać planu do edycji',
    readJsonFile: 'Nie udało się odczytać pliku JSON.',
    requiredField: '%s jest wymagane.',
    savePlan: 'Nie udało się zapisać planu',
    submitRequired: 'Uzupełnij wymagane pola planu przed zapisem.'
  },
  form: {
    description: 'Opis',
    name: 'Nazwa',
    planType: 'Typ planu',
    startDate: 'Data startu',
    stravaEvaluationStartDate: 'Uwzględniaj Stravę od',
    title: 'Tytuł'
  },
  header: {
    editTitle: 'Edytuj plan',
    kicker: 'Nowy plan',
    loadingEdit: 'Ładowanie planu do edycji...',
    newTitle: 'Dodaj plan ręcznie'
  },
  import: {
    description: 'Wybranie pliku lub wklejenie poprawnego JSON-a automatycznie uzupełni formularz planu.',
    fileButton: 'Wczytaj plik',
    fileNotSelected: 'Nie wybrano pliku',
    kicker: 'Import JSON',
    title: 'Wklej plan lub wczytaj plik JSON'
  }
};

export type ModuleStrings = typeof strings;
