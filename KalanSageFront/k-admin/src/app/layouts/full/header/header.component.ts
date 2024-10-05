import {
  Component,
  Output,
  EventEmitter,
  Input,
  ViewEncapsulation,
} from '@angular/core';
import { Router, RouterModule } from '@angular/router';
import { MaterialModule } from 'src/app/material.module';
import { CommonModule } from '@angular/common';
import { NgScrollbarModule } from 'ngx-scrollbar';
import { MatButtonModule } from '@angular/material/button';
import { AuthService } from 'src/app/services/auth-service.service';
import { MatSnackBar } from '@angular/material/snack-bar';

// Define an interface to represent the current user structure
interface UserProfile {
  nom?: string;
  prenom?: string;
  fileInfos?: {
    url?: string;
  };
}

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [
    RouterModule,
    CommonModule,
    NgScrollbarModule,
    MaterialModule,
    MatButtonModule,
  ],
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss'],
  encapsulation: ViewEncapsulation.None,
})
export class HeaderComponent {
  @Input() showToggle = true;
  @Input() toggleChecked = false;
  @Output() toggleMobileNav = new EventEmitter<void>();
  @Output() toggleCollapsed = new EventEmitter<void>();

  userName: string = 'User';
  profileImageUrl: string = '/assets/images/profile/default-user.jpg';

  constructor(
    private authService: AuthService,
    private router: Router,
    private snackBar: MatSnackBar
  ) {
    // Listen for changes in the current user
    this.authService.currentUser.subscribe((user) => {
      if (user) {
        this.userName = `${user.nom || ''}`.trim();
        this.profileImageUrl =
          user.fileInfos?.url || '/assets/images/profile/default-user.jpg';
      }
    });
  }

  ngOnInit(): void {
    this.fetchUserProfile();
  }

  fetchUserProfile(): void {
    this.authService.fetchUserProfile().subscribe(
      (profile) => {
        this.userName = `${profile.nom || ''}`.trim(); 
        this.profileImageUrl =
          profile.fileInfos?.url || '/assets/images/profile/default-user.jpg';
      },
      (error) => {
        console.error('Failed to fetch user profile:', error);
      }
    );
  }

  navigateToProfile(): void {
    this.router.navigate(['/parametre']);
  }

  // Logout method
  logout(): void {
    this.authService.logout().subscribe(
      () => {
        this.snackBar.open('Déconnexion réussie', 'Fermer', {
          duration: 3000,
          verticalPosition: 'top',
          horizontalPosition: 'center',
        });
        this.router.navigate(['/login']);
      },
      (error) => {
        console.error('Error during logout:', error);
      }
    );
  }
}
