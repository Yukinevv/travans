import { HttpErrorResponse, HttpEvent, HttpHandler, HttpInterceptor, HttpRequest } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { Observable, catchError, switchMap, throwError } from 'rxjs';

import { AuthService } from './auth.service';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {
  private refreshInFlight = false;

  constructor(
    private readonly authService: AuthService,
    private readonly router: Router
  ) {}

  intercept(req: HttpRequest<unknown>, next: HttpHandler): Observable<HttpEvent<unknown>> {
    const accessToken = this.authService.getAccessToken();
    const authReq = accessToken ? req.clone({ setHeaders: { Authorization: `Bearer ${accessToken}` } }) : req;

    return next.handle(authReq).pipe(
      catchError((error: HttpErrorResponse) => {
        if (error.status !== 401 || this.refreshInFlight || !this.authService.getRefreshToken() || req.url.includes('/auth/')) {
          return throwError(() => error);
        }

        this.refreshInFlight = true;
        return this.authService.refresh().pipe(
          switchMap((response) => {
            this.refreshInFlight = false;
            const retried = req.clone({ setHeaders: { Authorization: `Bearer ${response.accessToken}` } });
            return next.handle(retried);
          }),
          catchError((refreshError) => {
            this.refreshInFlight = false;
            this.authService.logout();
            this.router.navigate(['/auth']);
            return throwError(() => refreshError);
          })
        );
      })
    );
  }
}
