import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { DashboardViewComponent } from './views/dashboard-view/dashboard-view.component';
import { PlansViewComponent } from './views/plans-view/plans-view.component';
import { IntegrationsViewComponent } from './views/integrations-view/integrations-view.component';

const routes: Routes = [
  { path: '', component: DashboardViewComponent },
  { path: 'plans', component: PlansViewComponent },
  { path: 'integrations', component: IntegrationsViewComponent },
  { path: '**', redirectTo: '' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {}
