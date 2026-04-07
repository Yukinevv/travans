import { Component } from '@angular/core';
import { RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, RouterLink, RouterLinkActive],
  template: `
    <div class="shell">
      <aside class="sidebar">
        <div>
          <p class="eyebrow">Travans</p>
          <h1>Plan treningowy zsynchronizowany ze Strava</h1>
          <p class="lead">
            Szkielet aplikacji do zarzadzania planem, importu JSON i sprawdzania wykonanych aktywnosci.
          </p>
        </div>

        <nav class="nav">
          <a routerLink="/" [routerLinkActiveOptions]="{ exact: true }" routerLinkActive="active">Dashboard</a>
          <a routerLink="/plans" routerLinkActive="active">Plany</a>
          <a routerLink="/integrations" routerLinkActive="active">Integracje</a>
        </nav>
      </aside>

      <main class="content">
        <router-outlet></router-outlet>
      </main>
    </div>
  `,
  styles: [`
    .shell {
      display: grid;
      grid-template-columns: 320px 1fr;
      min-height: 100vh;
    }

    .sidebar {
      padding: 32px;
      border-right: 1px solid var(--border);
      background: rgba(255, 248, 239, 0.7);
      backdrop-filter: blur(12px);
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      gap: 24px;
    }

    .eyebrow {
      margin: 0 0 8px;
      text-transform: uppercase;
      letter-spacing: 0.18em;
      color: var(--accent-dark);
      font-size: 0.75rem;
      font-weight: 700;
    }

    h1 {
      margin: 0;
      font-size: 2rem;
      line-height: 1.05;
    }

    .lead {
      color: var(--muted);
      line-height: 1.6;
    }

    .nav {
      display: grid;
      gap: 10px;
    }

    .nav a {
      color: var(--text);
      text-decoration: none;
      padding: 14px 16px;
      border-radius: 16px;
      border: 1px solid transparent;
      transition: 180ms ease;
    }

    .nav a.active,
    .nav a:hover {
      background: var(--surface-strong);
      border-color: var(--border);
      box-shadow: var(--shadow);
    }

    .content {
      padding: 32px;
    }

    @media (max-width: 960px) {
      .shell {
        grid-template-columns: 1fr;
      }

      .sidebar {
        border-right: 0;
        border-bottom: 1px solid var(--border);
      }
    }
  `]
})
export class AppComponent {}
