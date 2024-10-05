import { Component, OnInit, ViewEncapsulation, ViewChild } from '@angular/core';
import { MaterialModule } from '../../material.module';
import { PageEvent, MatPaginator } from '@angular/material/paginator';
import { CommonModule } from '@angular/common';
import { MatTableModule } from '@angular/material/table';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { MatMenuModule } from '@angular/material/menu';
import { ReactiveFormsModule } from '@angular/forms';
import { ModuleCreateDialogComponent } from 'src/app/module-create-dialog/module-create-dialog.component';
import { MatDialog } from '@angular/material/dialog';

interface CardItemData {
  image: string;
  date: string;
  titre: string;
  description: string;
}

const itemsData: CardItemData[] = [
  {
    image: 'assets/images/image1.jpg',
    date: 'Jan 24, 2023',
    titre: 'Card Title 1',
    description: 'This is a sample description for card 1.',
  },
  {
    image: 'assets/images/image2.jpg',
    date: 'Jan 24, 2023',
    titre: 'Card Title 2',
    description: 'This is a sample description for card 2.',
  },
  // More items...
];

@Component({
  selector: 'app-module',
  standalone: true,
  imports: [
    ReactiveFormsModule,
    MaterialModule,
    MatTableModule,
    CommonModule,
    MatCardModule,
    MatIconModule,
    MatMenuModule,
    MatButtonModule,
  ],
  templateUrl: './module.component.html',
  styleUrls: ['./module.component.scss'],
  encapsulation: ViewEncapsulation.None,
})
export class ModuleComponent implements OnInit {
  constructor(private dialog: MatDialog) {}
  items: CardItemData[] = itemsData;
  pagedItems: CardItemData[] = [];
  pageSize = 6;
  currentPage = 0;
  pageSizeOptions: number[] = [6, 12, 24];

  openCreateDialog(): void {
    const dialogRef = this.dialog.open(ModuleCreateDialogComponent, {
      height: '500px',
      width: '900px',
      disableClose: true,
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result) {
        console.log('Module created:', result);
        // You can add the created module to the items array here if needed
      }
    });
  }

  @ViewChild(MatPaginator) paginator!: MatPaginator;

  ngOnInit(): void {
    this.onPageChange({
      pageIndex: 0,
      pageSize: this.pageSize,
      length: 0,
    });
  }

  onPageChange(event: PageEvent): void {
    const startIndex = event.pageIndex * event.pageSize;
    const endIndex = startIndex + event.pageSize;
    this.pagedItems = this.items.slice(startIndex, endIndex);
  }
}
