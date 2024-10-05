import { Component, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatChipsModule } from '@angular/material/chips';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatCardModule } from '@angular/material/card';
import { MatTabsModule } from '@angular/material/tabs';
import { MaterialModule } from 'src/app/material.module';

@Component({
  selector: 'app-forum',
  standalone: true,
  imports: [
    CommonModule,
    MatChipsModule,
    MatIconModule,
    MatButtonModule,
    MatToolbarModule,
    MatCardModule,
    MatTabsModule,
    MaterialModule,
  ],
  templateUrl: './forum.component.html',
  styleUrls: ['./forum.component.scss'],
  schemas: [CUSTOM_ELEMENTS_SCHEMA], // Add this line
})
export class ForumComponent {
  questions = [
    {
      userAvatar: 'assets/avatar1.png',
      userName: 'Mariam',
      postTime: '5 min ago',
      title: 'Comment patcher KDE sur FreeBSD ?',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      tags: ['golang', 'linux', 'overflow'],
      views: 125,
      comments: 15,
      upvotes: 155,
    },
    // More questions here...
  ];
}
