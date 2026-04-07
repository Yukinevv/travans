import { Routes } from '@angular/router';

import { DashboardPageComponent } from './pages/dashboard-page.component';
import { PlansPageComponent } from './pages/plans-page.component';
import { IntegrationsPageComponent } from './pages/integrations-page.component';

export const appRoutes: Routes = [
  { path: '', pathMatch: 'full', component: DashboardPageComponent },
  { path: 'plans', component: PlansPageComponent },
  { path: 'integrations', component: IntegrationsPageComponent },
  { path: '**', redirectTo: '' }
];
