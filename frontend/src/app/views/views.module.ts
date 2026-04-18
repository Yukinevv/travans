import { NgModule } from '@angular/core';

import { SharedModule } from '../shared/shared.module';
import { DashboardViewComponent } from './dashboard-view/dashboard-view.component';
import { IntegrationActivityDetailViewComponent } from './integration-activity-detail-view/integration-activity-detail-view.component';
import { IntegrationsViewComponent } from './integrations-view/integrations-view.component';
import { PlanListViewComponent } from './plan-list-view/plan-list-view.component';
import { PlansViewComponent } from './plans-view/plans-view.component';

@NgModule({
  declarations: [DashboardViewComponent, PlansViewComponent, PlanListViewComponent, IntegrationsViewComponent, IntegrationActivityDetailViewComponent],
  imports: [SharedModule],
  exports: [DashboardViewComponent, PlansViewComponent, PlanListViewComponent, IntegrationsViewComponent, IntegrationActivityDetailViewComponent]
})
export class ViewsModule {}
