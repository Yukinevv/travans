import { NgModule } from '@angular/core';

import { SharedModule } from '../shared/shared.module';
import { DashboardViewComponent } from './dashboard-view/dashboard-view.component';
import { IntegrationsViewComponent } from './integrations-view/integrations-view.component';
import { PlansViewComponent } from './plans-view/plans-view.component';

@NgModule({
  declarations: [DashboardViewComponent, PlansViewComponent, IntegrationsViewComponent],
  imports: [SharedModule],
  exports: [DashboardViewComponent, PlansViewComponent, IntegrationsViewComponent]
})
export class ViewsModule {}
