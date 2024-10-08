import { Component, OnInit, ViewEncapsulation, ViewChild } from '@angular/core';
import { PageEvent, MatPaginator } from '@angular/material/paginator';
import { MatDialog } from '@angular/material/dialog';
import { ModuleService } from '../../services/modules.service';
import { Router } from '@angular/router';
import { MaterialModule } from 'src/app/material.module';
import { ModuleCreateDialogComponent } from '../../module-create-dialog/module-create-dialog.component';

interface CardItemData {
  id: number;
  image: string;
  date: string;
  titre: string;
  description: string;
}

@Component({
  selector: 'app-module',
  standalone: true,
  imports: [MaterialModule],
  templateUrl: './module.component.html',
  styleUrls: ['./module.component.scss'],
  encapsulation: ViewEncapsulation.None,
})
export class ModuleComponent implements OnInit {
  items: CardItemData[] = [];
  pagedItems: CardItemData[] = [];
  pageSize = 6;
  pageSizeOptions: number[] = [6, 12, 24];

  @ViewChild(MatPaginator) paginator!: MatPaginator;

  constructor(
    private dialog: MatDialog,
    private moduleService: ModuleService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.fetchModules();
  }

  fetchModules(): void {
    this.moduleService.listerModules().subscribe({
      next: (modules) => {
        this.items = modules.map((module) => ({
          id: module.id,
          date: new Date(module.dateCreation).toLocaleDateString(),
          titre: module.titre,
          description: module.description,
          image: module.image,
          prix: module.prix,
          nomCategorie: module.nomCategorie,
        }));
        this.setPagedItems(0, this.pageSize); 
      },
      error: (error) => console.error('Error fetching modules:', error),
    });
  }

  setPagedItems(pageIndex: number, pageSize: number): void {
    const startIndex = pageIndex * pageSize;
    this.pagedItems = this.items.slice(startIndex, startIndex + pageSize);
  }

  onPageChange(event: PageEvent): void {
    this.setPagedItems(event.pageIndex, event.pageSize);
  }

  openModuleDetails(id: number): void {
    this.router.navigate(['/modules', id]);
  }

  openCreateDialog(module?: any): void {
    const dialogRef = this.dialog.open(ModuleCreateDialogComponent, {
      height: '80%',
      width: '70%',
      disableClose: true,
      data: { module },
    });

    dialogRef.afterClosed().subscribe((formData) => {
      if (formData) {
        module
          ? this.updateModule(module.id, formData)
          : this.createModule(formData);
      }
    });
  }

  createModule(moduleData: any): void {
    this.moduleService.creerModule(moduleData).subscribe({
      next: () => this.refreshModuleList(),
      error: (error) => console.error('Error creating module:', error),
    });
  }

  updateModule(id: number, moduleData: any): void {
    this.moduleService.modifierModule(id, moduleData).subscribe({
      next: () => this.refreshModuleList(),
      error: (error) => console.error('Error updating module:', error),
    });
  }

  onEditModule(item: any): void {
    this.openCreateDialog(item); 
  }

  deleteModule(id: number): void {
    this.moduleService.supprimerModule(id).subscribe({
      next: () => this.refreshModuleList(),
      error: (error) => console.error('Error deleting module:', error),
    });
  }

  onDeleteModule(id: number): void {
    if (confirm('Are you sure you want to delete this module?')) {
      this.deleteModule(id);
    }
  }

  refreshModuleList(): void {
    this.fetchModules(); 
  }
}
