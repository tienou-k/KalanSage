import { Component, ViewChild } from '@angular/core';
import { MaterialModule } from '../../material.module';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';

@Component({
  selector: 'app-total-retention',
  standalone: true,
  imports: [MaterialModule, MatProgressSpinnerModule],
  templateUrl: './total-income.component.html',
  styleUrls: ['./retention-card.component.css'],
})
export class RetentionCardComponent {
  // Value for the circular progress
  retentionValue: number = 0;

  constructor() {}
}

