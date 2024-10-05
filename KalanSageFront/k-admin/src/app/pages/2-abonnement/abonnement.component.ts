import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { MatCardModule } from '@angular/material/card';
import { MatTableModule } from '@angular/material/table';
import { MaterialModule } from 'src/app/material.module';
import { MatIconModule } from '@angular/material/icon';
import { MatMenuModule } from '@angular/material/menu';
import { MatButtonModule } from '@angular/material/button';

// Table data interface
export interface productsData {
  id: number;
  uname: string;
  date: string;
  client: string;
  budget: number;
  priority: string;
}

const PRODUCT_DATA: productsData[] = [
  {
    id: 1,
    uname: 'Basic',
    budget: 180,
    date: '2000-01-01',
    client: 'Harouna@gmail.com',
    priority: 'confirmed',
  },
  {
    id: 2,
    uname: 'Pro',
    budget: 180,
    date: '2000-01-01',
    client: 'Harouna@gmail.com',
    priority: 'confirmed',
  },
  {
    id: 3,
    uname: 'Pro',
    budget: 180,
    date: '2000-01-01',
    client: 'Harouna@gmail.com',
    priority: 'confirmed',
  },
  {
    id: 4,
    uname: 'Premium',
    budget: 180,
    date: '2000-01-01',
    client: 'Harouna@gmail.com',
    priority: 'confirmed',
  },
];

@Component({
  selector: 'app-abonnement',
  standalone: true,
  imports: [
   MaterialModule,
    CommonModule,
  ],
  templateUrl: './abonnement.component.html',
  styleUrls: ['./abonnement.component.scss'],
})
export class AbonnementComponent {
  // Table columns
  displayedColumns1: string[] = [
    'id',
    'date',
    'abonnement',
    'client',
    'budget',
    'priority',
    'actions',
  ];
  dataSource1 = PRODUCT_DATA;
}
