export type AppLanguage = 'pl' | 'en';

export const defaultAppLanguage: AppLanguage = 'pl';

export const availableAppLanguages: ReadonlyArray<{ code: AppLanguage; label: string }> = [
  { code: 'pl', label: 'Polski' },
  { code: 'en', label: 'English' }
];

export function isAppLanguage(value: string | null | undefined): value is AppLanguage {
  return value === 'pl' || value === 'en';
}
