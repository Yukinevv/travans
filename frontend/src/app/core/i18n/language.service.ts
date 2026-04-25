import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';

import { AppLanguage, availableAppLanguages, defaultAppLanguage, isAppLanguage } from './app-language';
import { setActiveLanguage } from './localized-strings';

@Injectable({ providedIn: 'root' })
export class LanguageService {
  private readonly storageKey = 'travans.language';
  private readonly languageSubject = new BehaviorSubject<AppLanguage>(this.resolveInitialLanguage());

  readonly availableLanguages = availableAppLanguages;
  readonly languageChanges$: Observable<AppLanguage> = this.languageSubject.asObservable();

  constructor() {
    setActiveLanguage(this.languageSubject.value);
  }

  get currentLanguage(): AppLanguage {
    return this.languageSubject.value;
  }

  setLanguage(language: AppLanguage): void {
    if (language === this.languageSubject.value) {
      return;
    }

    setActiveLanguage(language);
    localStorage.setItem(this.storageKey, language);
    this.languageSubject.next(language);
  }

  private resolveInitialLanguage(): AppLanguage {
    const storedLanguage = localStorage.getItem(this.storageKey);
    return isAppLanguage(storedLanguage) ? storedLanguage : defaultAppLanguage;
  }
}
