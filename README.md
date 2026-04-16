# Travans

Szkielet aplikacji do zarzadzania planem treningowym zsynchronizowanym ze Strava.

## Struktura

- `frontend` - Angular SPA
- `backend` - Spring Boot API
- `docker-compose.yml` - PostgreSQL

## Backend

Wymagania:

- Java 22
- Maven 3.6+
- PostgreSQL uruchomiony przez Dockera

Uruchomienie:

```powershell
docker compose up -d
cd backend
mvn spring-boot:run
```

API startuje na `http://localhost:8080`.
Domyslnie backend uruchamia profile `dev,local`, wiec lokalna konfiguracja z `application-local.yml` laduje sie automatycznie.

Hot reload backendu:

```powershell
cd backend
mvn spring-boot:run
```

Przy zmianach w kodzie Spring Boot DevTools wykona automatyczny restart aplikacji.

Lokalna konfiguracja bez zmiennych srodowiskowych:

1. Uzupelnij plik `backend/src/main/resources/application-local.yml`
2. Uruchom backend zwyklym poleceniem

```powershell
cd backend
mvn spring-boot:run
```

Plik `application-local.yml` jest ignorowany przez Git, wiec mozesz tam trzymac lokalne sekrety developerskie, np. dane Stravy.

## Frontend

Wymagania:

- Node.js zgodny z aktualnym Angular 21, czyli co najmniej `20.19.0`
- npm

Uruchomienie:

```powershell
cd frontend
npm install
npm start
```

Aplikacja startuje na `http://localhost:4200`.

## Najwazniejsze elementy szkieltu

- model planu treningowego i dni treningowych
- import planu przez JSON
- dashboard postepu
- szkic integracji Strava OAuth + sync aktywnosci
- webhook endpoint pod Strava
- PostgreSQL w Dockerze

## Konfiguracja Stravy

Ustaw w backendzie przez zmienne srodowiskowe albo `application-local.yml`:

- `TRAVANS_STRAVA_CLIENT_ID`
- `TRAVANS_STRAVA_CLIENT_SECRET`
- `TRAVANS_STRAVA_REDIRECT_URI`
- `TRAVANS_STRAVA_WEBHOOK_VERIFY_TOKEN`

## Uwaga

To jest szkielet aplikacji. Integracja Stravy ma juz kontrakty, serwis HTTP i endpointy, ale wymaga dopracowania:

- autoryzacji uzytkownikow aplikacji
- bezpiecznego przechowywania tokenow
- odswiezania tokenow
- rejestracji webhooka w Strava
- lepszej logiki dopasowania aktywnosci do planu
