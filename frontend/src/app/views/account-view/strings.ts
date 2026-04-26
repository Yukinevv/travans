import { createLocalizedStrings } from '../../core/i18n/localized-strings';

const localizedStrings = {
  pl: {
    actions: {
      saveProfile: 'Zapisz dane',
      changePassword: 'Zmien haslo'
    },
    form: {
      currentPassword: 'Aktualne haslo',
      displayName: 'Nazwa uzytkownika',
      email: 'Email',
      newPassword: 'Nowe haslo',
      repeatPassword: 'Powtorz nowe haslo'
    },
    header: {
      kicker: 'Konto',
      title: 'Ustawienia uzytkownika',
      intro: 'Zmieniaj dane swojego konta i aktualizuj haslo bez opuszczania aplikacji.'
    },
    profile: {
      avatarError: 'To blad avatara.',
      avatarHint: 'JPG, PNG, WEBP lub GIF do 5 MB.',
      description: 'Te dane sa uzywane w Twojej sesji i w panelu aplikacji.',
      success: 'Dane konta zostaly zapisane.',
      title: 'Dane konta'
    },
    password: {
      description: 'Po zmianie hasla Twoja sesja zostanie odswiezona automatycznie.',
      googleManaged: 'To konto korzysta z logowania Google, wiec haslo jest zarzadzane po stronie Google.',
      mismatch: 'Nowe hasla musza byc takie same.',
      success: 'Haslo zostalo zmienione.',
      title: 'Bezpieczenstwo'
    },
    status: {
      avatarUploading: 'Przesylanie avatara...',
      loading: 'Ladowanie danych konta...'
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
      avatarError: 'This avatar is invalid.',
      avatarHint: 'JPG, PNG, WEBP, or GIF up to 5 MB.',
      description: 'These details are used in your session and across the application.',
      success: 'Your account details have been saved.',
      title: 'Profile details'
    },
    password: {
      description: 'After changing the password, your session will be refreshed automatically.',
      googleManaged: 'This account uses Google sign-in, so the password is managed by Google.',
      mismatch: 'The new passwords must match.',
      success: 'Your password has been changed.',
      title: 'Security'
    },
    status: {
      avatarUploading: 'Uploading avatar...',
      loading: 'Loading account data...'
    }
  }
};

export const strings = createLocalizedStrings(localizedStrings);

export type ModuleStrings = typeof localizedStrings.pl;
