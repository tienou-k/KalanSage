import { Routes, RouterModule } from '@angular/router';
import { NgModule } from '@angular/core';
import { LoginComponent } from './pages/login/login.component';
import { DashbordComponent } from './pages/dashbord/dashbord.component';
import { LiveComponent } from './pages/live/live.component';
import { AbonnementComponent } from './pages/abonnement/abonnement.component';
import { CoursComponent } from './pages/cours/cours.component';
import { UsersComponent } from './pages/users/users.component';
import { ForumComponent } from './pages/forum/forum.component';
import { InboxComponent } from './pages/inbox/inbox.component';
import { NotificationComponent } from './pages/notification/notification.component';
import { PartenaireComponent } from './pages/partenaire/partenaire.component';
import { SettingsComponent } from './pages/settings/settings.component';

export const routes: Routes = [
    { path: 'dashboard', component: DashbordComponent },
    { path: 'abonnement', component: AbonnementComponent },
    { path: 'cours', component: CoursComponent },
    { path: 'users', component: UsersComponent },
    { path: 'forum', component: ForumComponent },
    { path: 'inbox', component: InboxComponent },
    { path: 'notification', component: NotificationComponent },
    { path: 'partenaire', component: PartenaireComponent },
    { path: 'settings', component: SettingsComponent },
    { path: 'live', component: LiveComponent },
    {path:'login', component: LoginComponent},
    { path: 'login', component: LoginComponent },
    { path:'', redirectTo: 'login', pathMatch:'full'}

];
