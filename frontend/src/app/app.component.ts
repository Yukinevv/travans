import { Component, HostListener, OnInit } from '@angular/core';
import { NavigationEnd, Router } from '@angular/router';
import { filter } from 'rxjs/operators';

import { CommonStrings, CommonStringsLoader } from './core/misc';
import { AuthService } from './modules/auth/services/auth.service';
import { ModuleStrings, strings } from './strings';

@Component({
  selector: 'app-root',
  standalone: false,
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit {
  sidebarOpen = true;
  isMobileViewport = false;
  suppressHoverOpen = false;
  readonly commonStrings: CommonStrings = CommonStringsLoader.strings;
  readonly moduleStrings: ModuleStrings = strings;

  constructor(
    public readonly authService: AuthService,
    private readonly router: Router
  ) {}

  ngOnInit(): void {
    this.updateSidebarForViewport();
    this.router.events
      .pipe(filter((event) => event instanceof NavigationEnd))
      .subscribe(() => {
        this.sidebarOpen = false;
      });
  }

  @HostListener('window:resize')
  onWindowResize(): void {
    this.updateSidebarForViewport();
  }

  toggleSidebar(): void {
    this.sidebarOpen = !this.sidebarOpen;
  }

  openSidebar(): void {
    this.sidebarOpen = true;
  }

  closeSidebar(): void {
    this.sidebarOpen = false;
  }

  closeSidebarFromToggle(): void {
    this.suppressHoverOpen = true;
    this.sidebarOpen = false;
  }

  openSidebarOnHover(): void {
    if (this.isMobileViewport || this.sidebarOpen || this.suppressHoverOpen) {
      return;
    }

    this.openSidebar();
  }

  resetHoverOpen(): void {
    this.suppressHoverOpen = false;
  }

  closeSidebarAfterNavigation(): void {
    if (this.isMobileViewport) {
      this.sidebarOpen = false;
    }
  }

  logout(): void {
    this.authService.logout();
    this.sidebarOpen = !this.isMobileViewport;
    this.router.navigate(['/auth']);
  }

  private updateSidebarForViewport(): void {
    const mobileViewport = window.innerWidth <= 960;
    if (mobileViewport !== this.isMobileViewport) {
      this.isMobileViewport = mobileViewport;
      this.sidebarOpen = !mobileViewport;
    }
  }
}
