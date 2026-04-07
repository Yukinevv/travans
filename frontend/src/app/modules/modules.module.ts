import { NgModule } from '@angular/core';
import { AuthModule } from './auth/auth.module';

@NgModule({
  imports: [AuthModule],
  exports: [AuthModule]
})
export class ModulesModule {}
