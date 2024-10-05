import { Component, OnInit } from '@angular/core';
import {
  FormBuilder,
  FormGroup,
  Validators,
  FormsModule,
} from '@angular/forms';
import { CommonModule, JsonPipe, NgIf } from '@angular/common';
import { AuthService } from '../../../services/auth-service.service';
import { Router } from '@angular/router';
import { MaterialModule } from 'src/app/material.module';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
  standalone: true,
  imports: [MaterialModule, CommonModule, FormsModule, JsonPipe, NgIf],
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss'],
})
export class LoginComponent implements OnInit {
  loginForm: FormGroup;
  showPassword: boolean = false;

  constructor(
    private fb: FormBuilder,
    private authService: AuthService,
    private router: Router,
    private snackBar: MatSnackBar
  ) {
    this.loginForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required]],
    });
  }

  ngOnInit(): void {}

  togglePasswordVisibility(): void {
    this.showPassword = !this.showPassword;
  }
  onLogin(): void {
    if (this.loginForm.invalid) {
      return;
    }

    const { email, password } = this.loginForm.value;

    this.authService.login(email, password).subscribe(
      (user) => {
        // Check if the user's role is ROLE_ADMIN
        if (user.role !== 'ROLE_ADMIN') {
          this.snackBar.open(
            'Accès refusé. Seul ROLE_ADMIN peut se connecter ici',
            'Fermer',
            {
              duration: 3000,
              verticalPosition: 'top',
              horizontalPosition: 'center',
            }
          );
          console.log(user);
          return;
        }
        // Navigate to the admin dashboard if the user is an admin
        this.router.navigate(['dashboard']);
        console.log('Connexion réussi', this.loginForm.value);
      },
      (error) => {
        console.error('Login failed', error);
        this.snackBar.open(
          "Échec de la connexion. Veuillez vérifier vos informations d'identification",
          'Fermer',
          {
            duration: 3000,
            verticalPosition: 'top',
            horizontalPosition: 'center',
          }
        );
      }
    );
  }
}
