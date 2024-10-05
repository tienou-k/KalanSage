import { Component } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatChipsModule } from '@angular/material/chips';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { TablerIconsModule } from 'angular-tabler-icons';

interface CardImage {
  mat_card_title: string;
  progressValue: number;
  progressColor: string; 
  iconName: string;
}

@Component({
  selector: 'app-blog-card',
  standalone: true,
  imports: [
    MatCardModule,
    MatChipsModule,
    MatButtonModule,
    MatIconModule,
    MatProgressSpinnerModule, // Ensure you import the progress spinner module
    TablerIconsModule,
  ],
  templateUrl: './blog-card.component.html',
})
export class AppBlogCardsComponent {
  cardimgs: CardImage[] = [
    {
      mat_card_title: 'Utilisateurs',
      progressValue: 200,
      progressColor: 'accent',
      iconName: 'group',
    },
    {
      mat_card_title: 'Abonnements',
      progressValue: 150,
      progressColor: 'accent',
      iconName: 'currency_exchange',
    },
    {
      mat_card_title: 'Partenaires',
      progressValue: 100,
      progressColor: 'accent',
      iconName: 'handshake',
    },
  ];

  constructor() {}
}
