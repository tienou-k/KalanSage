import { Component, Inject } from '@angular/core';
import { MaterialModule } from "../../material.module";
import { FormBuilder, FormGroup } from "@angular/forms";
import { LeconService } from "../../services/lecon.service";
import { MAT_DIALOG_DATA, MatDialogRef } from "@angular/material/dialog";

@Component({
  selector: 'app-lecon-add',
  standalone: true,
  imports: [
    MaterialModule
  ],
  templateUrl: './lecon-add.component.html',
  styleUrls: ['./lecon-add.component.scss']
})
export class LeconAddComponent {
  leconForm: FormGroup;
  selectedFile: File | null = null;
  editMode: boolean = false;
  moduleId: number;

  constructor(
    private fb: FormBuilder,
    private leconService: LeconService,
    private dialogRef: MatDialogRef<LeconAddComponent>,
    @Inject(MAT_DIALOG_DATA) public data: { moduleId: number }
  ) {
    this.leconForm = this.fb.group({
      titre: [''],
      description: [''],
    });
  this.moduleId = data.moduleId;
  }

  onFileSelected(event: any): void {
    const file = event.target.files[0];
    if (file) {
      this.selectedFile = file;
    }
  }

  submit(): void {
    const leconData = {
      titre: this.leconForm.get('titre')?.value,
      description: this.leconForm.get('description')?.value,
      moduleId: this.data.moduleId.toString(),
      videoPath: this.selectedFile,
    };
    console.log('Sending data:', JSON.stringify(leconData));

    this.leconService.createLecon(leconData).subscribe(
      (response) => {
        console.log('Lesson created successfully:', response);
        this.dialogRef.close(response);
      },
      (error) => {
        console.error('Failed to create lesson:', error);
      }
    );
  }

  onClose(): void {
    this.dialogRef.close();
  }

  onReset(): void {
    this.leconForm.reset();
    this.selectedFile = null;
  }
}
