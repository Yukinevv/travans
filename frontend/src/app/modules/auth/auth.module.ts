import { NgModule } from '@angular/core';

import { SharedModule } from '../../shared/shared.module';
import { AuthViewComponent } from './auth-view/auth-view.component';

@NgModule({
  declarations: [AuthViewComponent],
  imports: [SharedModule],
  exports: [AuthViewComponent]
})
export class AuthModule {}
