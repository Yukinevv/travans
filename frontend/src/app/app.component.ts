import { Component, HostListener, OnInit } from '@angular/core';
import { Router } from '@angular/router';

import { AuthService } from './modules/auth/services/auth.service';

@Component({
  selector: 'app-root',
  standalone: false,
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit {
  sidebarOpen = true;
  isMobileViewport = false;

  constructor(
    public readonly authService: AuthService,
    private readonly router: Router
  ) {}

  ngOnInit(): void {
    this.updateSidebarForViewport();
  }

  @HostListener('window:resize')
  onWindowResize(): void {
    this.updateSidebarForViewport();
  }

  toggleSidebar(): void {
    this.sidebarOpen = !this.sidebarOpen;
  }

  closeSidebar(): void {
    this.sidebarOpen = false;
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
