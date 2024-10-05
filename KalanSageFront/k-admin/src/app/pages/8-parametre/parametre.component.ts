import { Component } from '@angular/core';
import {
  FormBuilder,
  FormGroup,
  Validators,
  ReactiveFormsModule,
} from '@angular/forms';
import { MaterialModule } from 'src/app/material.module'; 

@Component({
  selector: 'app-parametre',
  standalone: true,
  imports: [ReactiveFormsModule, MaterialModule],
  templateUrl: './parametre.component.html',
  styleUrls: ['./parametre.component.scss'],
})
export class ParametreComponent {
  userForm: FormGroup;
  showPasswordChange = false;
  profileImageUrl: string | null = null;

  constructor(private fb: FormBuilder) {
    this.userForm = this.fb.group({
      fullName: ['Kontere TIENOU', Validators.required],
      email: ['admin@gmail.com', [Validators.required, Validators.email]],
      phone: ['', Validators.pattern('[- +()0-9]+')],
      address: [''],
      role: ['CEO', Validators.required],
      currentPassword: [''],
      newPassword: [''],
    });
  }

  onUploadClick() {
    const fileInput = document.getElementById('fileInput');
    if (fileInput) {
      fileInput.click();
    }
  }

  onFileSelected(event: any) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = () => {
        this.profileImageUrl = reader.result as string;
      };
      reader.readAsDataURL(file);
    }
  }

  togglePasswordChange() {
    this.showPasswordChange = !this.showPasswordChange;
  }

  onSave() {
    if (this.userForm.valid) {
      console.log('Form data:', this.userForm.value);
    }
  }

  onCancel() {
    this.userForm.reset();
  }

  onLogout() {
    console.log('User logged out.');
  }
}
