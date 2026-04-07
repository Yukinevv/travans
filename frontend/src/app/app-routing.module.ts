import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { AuthGuard } from './modules/auth/services/auth.guard';
import { AuthViewComponent } from './modules/auth/auth-view/auth-view.component';
import { DashboardViewComponent } from './views/dashboard-view/dashboard-view.component';
import { PlansViewComponent } from './views/plans-view/plans-view.component';
import { IntegrationActivityDetailViewComponent } from './views/integration-activity-detail-view/integration-activity-detail-view.component';
import { IntegrationsViewComponent } from './views/integrations-view/integrations-view.component';

const routes: Routes = [
  { path: 'auth', component: AuthViewComponent },
  { path: '', component: DashboardViewComponent, canActivate: [AuthGuard] },
  { path: 'plans', component: PlansViewComponent, canActivate: [AuthGuard] },
  { path: 'integrations', component: IntegrationsViewComponent, canActivate: [AuthGuard] },
  { path: 'integrations/activities/:activityId', component: IntegrationActivityDetailViewComponent, canActivate: [AuthGuard] },
  { path: '**', redirectTo: '' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {}
