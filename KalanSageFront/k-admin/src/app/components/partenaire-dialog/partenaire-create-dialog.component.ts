import { Component, OnInit, ViewEncapsulation } from '@angular/core';
import {
  FormBuilder,
  FormGroup,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { MaterialModule } from '../../material.module';
import { MatDialogRef } from '@angular/material/dialog';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-module-create-dialog',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, MaterialModule],
  templateUrl: './partenaire-create-dialog.component.html',
  styleUrls: ['./partenaire-create-dialog.component.scss'],
  encapsulation: ViewEncapsulation.None,
})
export class PartenaireCreateDialogComponent implements OnInit {
  moduleForm!: FormGroup;
  selectedFile: File | null = null;

  constructor(
    private fb: FormBuilder,
    private dialogRef: MatDialogRef<PartenaireCreateDialogComponent> //
  ) {}

  ngOnInit(): void {
    // Initialize the form with form controls
    this.moduleForm = this.fb.group({
      title: ['', Validators.required],
      category: ['', Validators.required],
      description: ['', Validators.required],
      price: ['', [Validators.required, Validators.pattern('^[0-9]*$')]],
    });
  }

  onFileSelected(event: any): void {
    if (event.target.files && event.target.files.length > 0) {
      this.selectedFile = event.target.files[0];
    }
  }

  onCreate(): void {
    if (this.moduleForm.valid) {
      const formData = this.moduleForm.value;
      formData.image = this.selectedFile;
      this.dialogRef.close(formData);
    } else {
      console.log('Form is invalid. Please fill out all required fields.');
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
