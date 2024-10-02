import { Component, ElementRef } from '@angular/core';
import { MatFormField } from '@angular/material/form-field';
import { MatIcon } from '@angular/material/icon';
import {
  MatSidenav,
  MatSidenavContainer,
  MatSidenavContent,
} from '@angular/material/sidenav';
import { MatListModule } from '@angular/material/list';
import { NavigationEnd, Router, RouterLink } from '@angular/router';
import { HeaderComponent } from "../header/header.component";


@Component({
  selector: 'app-sidebar',
  standalone: true,
  imports: [
    RouterLink,
    MatFormField,
    MatIcon,
    MatSidenavContainer,
    MatSidenav,
    MatSidenavContent,
    MatListModule,
    HeaderComponent,
  ],
  templateUrl: './sidebar.component.html',
  styleUrl: './sidebar.component.css',
})
export class SidebarComponent {
  constructor(private router: Router, private el: ElementRef) {
    this.router.events.subscribe((event) => {
      if (event instanceof NavigationEnd) {
        const url = this.router.url;
        const items = [
          'dashboard',
          'abonnement',
          'cours',
          'users',
          'forum',
          'partenaire',
          'settings',
          'live',
          'notifications',
          'inbox',
        ]; // Add all your routes here

        items.forEach((item) => {
          const element = this.el.nativeElement.querySelector(`#${item}Item`);
          if (element) {
            element.classList.remove('active');
            if (url.includes(item)) {
              element.classList.add('active');
            }
          }
        });
      }
    });
  }
}
