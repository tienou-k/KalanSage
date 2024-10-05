import { Component } from '@angular/core';
import { MaterialModule } from '../../material.module';
import { MatMenuModule } from '@angular/material/menu';
import { MatButtonModule } from '@angular/material/button';
import { CommonModule } from '@angular/common';
import { TablerIconsModule } from 'angular-tabler-icons';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { NgScrollbarModule } from 'ngx-scrollbar';
import { AppTotalFollowersComponent } from '../total-utilistaion/total-followers.component';

export interface productsData {
  id: number;
  imagePath: string;
  uname: string;
  price: string;
  status: string;
}

const ELEMENT_DATA: productsData[] = [
  {
    id: 1,
    imagePath: 'assets/images/products/s1.jpg',
    uname: 'iPhone 13 pro max-Pacific Blue-128GB storage',
    price: '$180',
    status: 'Confirmed',
  },
  {
    id: 2,
    imagePath: 'assets/images/products/s2.jpg',
    uname: 'Apple MacBook Pro 13 inch-M1-8/256GB-space',
    price: '$120',
    status: 'Confirmed',
  },
  {
    id: 3,
    imagePath: 'assets/images/products/s3.jpg',
    uname: 'PlayStation 5 DualSense Wireless Controller',
    price: '$120',
    status: 'Confirmed',
  },
  {
    id: 4,
    imagePath: 'assets/images/products/s4.jpg',
    uname: 'Amazon Basics Mesh, Mid-Back, Swivel Office De...',
    price: '$120',
    status: 'Confirmed',
  },
];
@Component({
  selector: 'app-total-gangne',
  standalone: true,
  imports: [
    MaterialModule,
    MatMenuModule,
    MatButtonModule,
    CommonModule,
    TablerIconsModule,
    MatProgressBarModule,
    NgScrollbarModule,
    AppTotalFollowersComponent,
  ],
  templateUrl: './earning-reports.component.html',
})
export class AppTotalGagne {
  displayedColumns: string[] = ['module', 'inscris', 'status', 'menu'];
  dataSource = ELEMENT_DATA;

  constructor() {}
}
