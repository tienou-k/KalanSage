import { bootstrapApplication } from '@angular/platform-browser';
import { provideHttpClient, withInterceptors } from '@angular/common/http';
import { AppComponent } from './app/app.component';
import { jwtInterceptor } from './app/services/jwt.interceptor.service';
import { provideRouter } from '@angular/router';
import { routes } from './app/app.routes';
import { importProvidersFrom } from '@angular/core';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { TablerIconsModule } from 'angular-tabler-icons';
import {
  IconHome,
  IconUser,
  IconBell,
  IconMessage,
  IconSend,
} from 'angular-tabler-icons/icons';

bootstrapApplication(AppComponent, {
  providers: [
    provideHttpClient(withInterceptors([jwtInterceptor])),
    provideRouter(routes),
    importProvidersFrom(
      BrowserAnimationsModule,
      TablerIconsModule.pick({
        IconHome,
        IconUser,
        IconBell,
        IconMessage,
        IconSend,
      })
    ),
  ],
}).catch((err) => console.error(err));
