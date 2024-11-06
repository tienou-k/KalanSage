import {
  Component,
  OnInit,
  ViewChild,
  Inject,
  EventEmitter,
  Output,
} from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import {
  MatDialog,
  MatDialogRef,
  MAT_DIALOG_DATA,
} from '@angular/material/dialog';
import { ModuleService } from '../../services/modules.service';
import { CommonModule } from '@angular/common';
import { MaterialModule } from '../../material.module';
import { MatSnackBar } from '@angular/material/snack-bar';
import { CategoryService } from '../../services/categorie.service';

@Component({
  selector: 'app-module-create-dialog',
  standalone: true,
  imports: [CommonModule, MaterialModule],
  templateUrl: './module-create-dialog.component.html',
  styleUrls: ['./module-create-dialog.component.scss'],
})
export class ModuleCreateDialogComponent implements OnInit {
  @Output() moduleUpdated = new EventEmitter<any>();
  moduleForm!: FormGroup;
  categories: any[] = [];
  selectedFile: File | null = null;
  imageUrl: string | ArrayBuffer | null = null;
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
    private categoryService: CategoryService,
    private snackBar: MatSnackBar,
    @Inject(MAT_DIALOG_DATA) public data: any
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
      this.moduleId = this.data.module.id;
      this.moduleForm.patchValue({
        title: this.data.module.titre,
        category: this.data.module.nomCategorie,
        description: this.data.module.description,
        price: this.data.module.prix,
      });
      this.imageUrl = this.data.module.imageUrl;
    }

    this.loadCategories();
  }
  showSnackbar(message: string): void {
    this.snackBar.open(message, 'Fermer', {
      duration: 3000,
      panelClass: ['custom-snackbar'],
    });
  }
  loadCategories(): void {
    this.categoryService.getCategories().subscribe(
      (data) => {
        this.categories = data;
      },
      (error) => {
        console.error('Error fetching categories:', error);
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
        imageUrl: this.selectedFile,
      };

      if (this.editMode && this.moduleId) {
        this.moduleService.modifierModule(this.moduleId, formData).subscribe(
          (response) => {
            this.showSnackbar('Module modifié avec succès');
            this.dialogRef.close(response);
            this.moduleUpdated.emit(response);
          },
          (error) => {
            if (
              error.status === 500 &&
              error.message.includes('Infinite recursion')
            ) {
              this.showSnackbar(
                'Module modifié avec succès malgré une erreur de réponse'
              );
              this.dialogRef.close();
              this.moduleUpdated.emit(formData);
            } else {
              this.showSnackbar(
                'Erreur lors de la modification du module: ' + error.message
              );
              console.error('Erreur lors de la modification:', error);
            }
          }
        );
      } else {
        this.moduleService.creerModule(formData).subscribe(
          (response) => {
            this.showSnackbar('Module créé avec succès');
            this.dialogRef.close(response);
            this.moduleUpdated.emit(response);
          },
          (error) => {
            this.showSnackbar(
              'Erreur lors de la création du module: ' + error.message
            );
            console.error('Error creating module:', error);
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
      if (this.selectedFile) {
        const reader = new FileReader();
        reader.onload = () => {
          this.imageUrl = reader.result;
        };
        reader.readAsDataURL(this.selectedFile);
      }
    }
  }

  onReset(): void {
    this.moduleForm.reset();
    this.selectedFile = null;
    this.imageUrl = null;
  }

  onClose(): void {
    this.dialogRef.close();
  }
}
