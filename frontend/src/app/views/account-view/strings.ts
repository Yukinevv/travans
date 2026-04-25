import { createLocalizedStrings } from '../../core/i18n/localized-strings';

const localizedStrings = {
  pl: {
    actions: {
      saveProfile: 'Zapisz dane',
      changePassword: 'Zmień hasło'
    },
    form: {
      currentPassword: 'Aktualne hasło',
      displayName: 'Nazwa użytkownika',
      email: 'Email',
      newPassword: 'Nowe hasło',
      repeatPassword: 'Powtórz nowe hasło'
    },
    header: {
      kicker: 'Konto',
      title: 'Ustawienia użytkownika',
      intro: 'Zmieniaj dane swojego konta i aktualizuj hasło bez opuszczania aplikacji.'
    },
    profile: {
      description: 'Te dane są używane w Twojej sesji i w panelu aplikacji.',
      success: 'Dane konta zostały zapisane.',
      title: 'Dane konta'
    },
    password: {
      description: 'Po zmianie hasła Twoja sesja zostanie odświeżona automatycznie.',
      mismatch: 'Nowe hasła muszą być takie same.',
      success: 'Hasło zostało zmienione.',
      title: 'Bezpieczeństwo'
    },
    status: {
      loading: 'Ładowanie danych konta...'
    }
  },
  en: {
    actions: {
      saveProfile: 'Save profile',
      changePassword: 'Change password'
    },
    form: {
      currentPassword: 'Current password',
      displayName: 'Display name',
      email: 'Email',
      newPassword: 'New password',
      repeatPassword: 'Repeat new password'
    },
    header: {
      kicker: 'Account',
      title: 'User settings',
      intro: 'Update your account details and password without leaving the app.'
    },
    profile: {
      description: 'These details are used in your session and across the application.',
      success: 'Your account details have been saved.',
      title: 'Profile details'
    },
    password: {
      description: 'After changing the password, your session will be refreshed automatically.',
      mismatch: 'The new passwords must match.',
      success: 'Your password has been changed.',
      title: 'Security'
    },
    status: {
      loading: 'Loading account data...'
    }
  }
};

export const strings = createLocalizedStrings(localizedStrings);

export type ModuleStrings = typeof localizedStrings.pl;
