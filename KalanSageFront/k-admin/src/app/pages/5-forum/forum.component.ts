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
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
})
export class ForumComponent {
  questions = [
  ];
}
