import { Routes } from '@angular/router';
import { FullComponent } from './layouts/full/full.component';
import { DashboardComponent } from './pages/1-dashboard/dashboard.component';
import { NotificationComponent } from './pages/9-notification/notification.component';
import { InboxComponent } from './pages/10-inbox/inbox-page.component';
import { ForumComponent } from './pages/5-forum/forum.component';
import { UserComponent } from './pages/4-users/user.component';
import { ModuleComponent } from './pages/3-Module/module.component';
import { AbonnementComponent } from './pages/2-abonnement/abonnement.component';
import { ParametreComponent } from './pages/8-parametre/parametre.component';
import { LiveComponent } from './pages/7-live/live.component';
import { PartenaireComponent } from './pages/6-partenaire/partenaire.component';
import { LoginComponent } from './pages/authentication/side-login/login.component';
import { AuthGuard } from './services/auth-guard.service';
import { ModuleDetailComponent } from './pages/3-Module/module-details/module-details.component';

export const routes: Routes = [
  {
    path: '',
    redirectTo: 'login',
    pathMatch: 'full',
  },
  {
    path: '',
    component: FullComponent,
    children: [
      {
        path: 'dashboard',
        component: DashboardComponent,
        canActivate: [AuthGuard],
      },
      {
        path: 'notification',
        component: NotificationComponent,
        canActivate: [AuthGuard],
      },
      {
        path: 'inbox',
        component: InboxComponent,
        canActivate: [AuthGuard],
      },
      {
        path: 'forum',
        component: ForumComponent,
        canActivate: [AuthGuard],
      },
      {
        path: 'user',
        component: UserComponent,
        canActivate: [AuthGuard],
      },
      {
        path: 'module',
        component: ModuleComponent,
        canActivate: [AuthGuard],
      },
      {
        path: 'modules/:id',
        component: ModuleDetailComponent,
        canActivate: [AuthGuard],
      },
      {
        path: 'abonnement',
        component: AbonnementComponent,
        canActivate: [AuthGuard],
      },
      {
        path: 'partenaire',
        component: PartenaireComponent,
        canActivate: [AuthGuard],
      },
      {
        path: 'live',
        component: LiveComponent,
        canActivate: [AuthGuard],
      },
      {
        path: 'parametre',
        component: ParametreComponent,
        canActivate: [AuthGuard],
      },
    ],
  },
  {
    path: '',
    children: [
      {
        path: 'login',
        component: LoginComponent,
      },
    ],
  },
  {
    path: '**',
    redirectTo: 'login',
  },
];
