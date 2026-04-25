import { AppLanguage, defaultAppLanguage } from './app-language';

let activeLanguage: AppLanguage = defaultAppLanguage;

export type LocalizedStrings<T extends object> = Record<AppLanguage, T>;

export function setActiveLanguage(language: AppLanguage): void {
  activeLanguage = language;
}

export function getActiveLanguage(): AppLanguage {
  return activeLanguage;
}

export function createLocalizedStrings<T extends object>(translations: LocalizedStrings<T>): T {
  return new Proxy({} as T, {
    get: (_, property) => Reflect.get(translations[activeLanguage] as object, property),
    has: (_, property) => Reflect.has(translations[activeLanguage] as object, property),
    ownKeys: () => Reflect.ownKeys(translations[activeLanguage] as object),
    getOwnPropertyDescriptor: (_, property) => {
      const descriptor = Object.getOwnPropertyDescriptor(translations[activeLanguage] as object, property);
      if (!descriptor) {
        return undefined;
      }

      return {
        ...descriptor,
        configurable: true
      };
    }
  });
}
