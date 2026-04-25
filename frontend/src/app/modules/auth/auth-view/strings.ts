import { createLocalizedStrings } from '../../../core/i18n/localized-strings';

const localizedStrings = {
  pl: {
    form: {
      displayName: 'Nazwa',
      email: 'Email',
      password: 'Has\u0142o',
      rememberMe: 'Zapami\u0119taj mnie'
    },
    google: {
      action: 'Kontynuuj z Google',
      unavailable: 'Logowanie Google nie jest jeszcze skonfigurowane.'
    },
    intro: 'Zaloguj si\u0119, aby zarz\u0105dza\u0107 planem treningowym i synchronizacj\u0105 Stravy.',
    kicker: 'Witaj w Travans',
    separator: 'lub',
    modes: {
      login: {
        button: 'Logowanie',
        submit: 'Zaloguj',
        title: 'Logowanie'
      },
      register: {
        button: 'Rejestracja',
        submit: 'Utw\u00f3rz konto',
        title: 'Rejestracja'
      }
    }
  },
  en: {
    form: {
      displayName: 'Display name',
      email: 'Email',
      password: 'Password',
      rememberMe: 'Remember me'
    },
    google: {
      action: 'Continue with Google',
      unavailable: 'Google sign-in is not configured yet.'
    },
    intro: 'Sign in to manage your training plan and Strava synchronization.',
    kicker: 'Welcome to Travans',
    separator: 'or',
    modes: {
      login: {
        button: 'Login',
        submit: 'Sign in',
        title: 'Sign in'
      },
      register: {
        button: 'Register',
        submit: 'Create account',
        title: 'Register'
      }
    }
  }
};

export const strings = createLocalizedStrings(localizedStrings);

export type ModuleStrings = typeof localizedStrings.pl;
