import { Component, OnInit, ViewChild, Inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import {
  MatDialog,
  MatDialogRef,
  MAT_DIALOG_DATA,
} from '@angular/material/dialog';
import { ModuleService } from '../../app/services/modules.service';
import { CommonModule } from '@angular/common';
import { MaterialModule } from '../material.module';

@Component({
  selector: 'app-module-create-dialog',
  standalone: true,
  imports: [CommonModule, MaterialModule],
  templateUrl: './module-create-dialog.component.html',
  styleUrls: ['./module-create-dialog.component.scss'],
})
export class ModuleCreateDialogComponent implements OnInit {
  moduleForm!: FormGroup;
  categories: any[] = [];
  selectedFile: File | null = null;
  newCategoryName: string = '';
  newCategoryDescription: string = '';
  editMode: boolean = false;
  moduleId: number | null = null;

  @ViewChild('addCategoryDialog') addCategoryDialog: any;

  constructor(
    private fb: FormBuilder,
    private dialog: MatDialog,
    private dialogRef: MatDialogRef<ModuleCreateDialogComponent>,
    private moduleService: ModuleService,
    @Inject(MAT_DIALOG_DATA) public data: any // Inject the module data if it's an edit
  ) {}

  ngOnInit(): void {
    // Initialize the form with form controls
    this.moduleForm = this.fb.group({
      title: ['', Validators.required],
      category: ['', Validators.required],
      description: ['', Validators.required],
      price: ['', [Validators.required, Validators.pattern('^[0-9]*$')]],
    });

    // Check if the dialog was opened for editing or creating
    if (this.data?.module) {
      this.editMode = true;
      this.moduleId = this.data.module.id; // Save the module ID for updating
      this.moduleForm.patchValue({
        title: this.data.module.titre,
        category: this.data.module.nomCategorie,
        description: this.data.module.description,
        price: this.data.module.prix,
      });
    }

    this.fetchCategories();
  }

  fetchCategories(): void {
    this.moduleService.getCategories().subscribe(
      (data) => {
        this.categories = data;
      },
      (error) => {
        console.error('Erreur lors de la récupération des catégories:', error);
      }
    );
  }

  openAddCategoryDialog(): void {
    const dialogRef = this.dialog.open(this.addCategoryDialog, {
      height: '80%',
      width: '70%',
      disableClose: true,
    });
  }

  closeCategoryDialog(): void {
    this.dialog.closeAll();
  }

  addNewCategory(): void {
    if (this.newCategoryName.trim() && this.newCategoryDescription.trim()) {
      const newCategory = {
        nomCategorie: this.newCategoryName,
        description: this.newCategoryDescription,
      };
      this.moduleService.createCategory(newCategory).subscribe(
        (newCategoryResponse) => {
          this.categories.push(newCategoryResponse);
          this.moduleForm.patchValue({
            category: newCategoryResponse.nomCategorie,
          });
          this.dialog.closeAll();
          this.newCategoryName = '';
          this.newCategoryDescription = '';
        },
        (error) => {
          console.error(
            'Erreur lors de la création de la nouvelle catégorie:',
            error
          );
        }
      );
    } else {
      console.log('Les champs nom et description de la catégorie sont requis.');
    }
  }

  onCreate(): void {
    if (this.moduleForm.valid) {
      const formData = {
        titre: this.moduleForm.value.title,
        description: this.moduleForm.value.description,
        prix: this.moduleForm.value.price,
        nomCategorie: this.moduleForm.value.category,
        dateCreation: new Date(),
        image: this.selectedFile,
      };

      if (this.editMode && this.moduleId) {
        // Call the update service if in edit mode
        this.moduleService.modifierModule(this.moduleId, formData).subscribe(
          (response) => {
            console.log('Module modifié avec succès:', response);
            this.dialogRef.close(response);
          },
          (error) => {
            console.error('Erreur lors de la modification du module:', error);
          }
        );
      } else {
        // Call the create service if in creation mode
        this.moduleService.creerModule(formData).subscribe(
          (response) => {
            console.log('Module créé avec succès:', response);
            this.dialogRef.close(response);
          },
          (error) => {
            console.error('Erreur lors de la création du module:', error);
          }
        );
      }
    } else {
      console.log(
        'Formulaire invalide. Veuillez remplir tous les champs requis.'
      );
    }
  }

  onFileSelected(event: any): void {
    if (event.target.files && event.target.files.length > 0) {
      this.selectedFile = event.target.files[0];
    }
  }

  onReset(): void {
    this.moduleForm.reset();
    this.selectedFile = null;
  }

  onClose(): void {
    this.dialogRef.close();
  }
}
