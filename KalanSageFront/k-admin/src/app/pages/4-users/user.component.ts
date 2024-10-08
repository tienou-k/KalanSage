import { Component, ViewEncapsulation, OnInit, ViewChild } from '@angular/core';
import { MatTableDataSource } from '@angular/material/table';
import { MatPaginator } from '@angular/material/paginator';
import { MaterialModule } from 'src/app/material.module';
import { CommonModule } from '@angular/common';
import { UserService } from 'src/app/services/users.service';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
  selector: 'app-starter',
  standalone: true,
  imports: [CommonModule, MaterialModule],
  templateUrl: './user.component.html',
  styleUrls: ['./user.component.scss'],
  encapsulation: ViewEncapsulation.None,
})
export class UserComponent implements OnInit {
  users: any[] = [];
  filteredUsers: any[] = [];
  displayedColumns: string[] = [
    'nom',
    'surname',
    'email',
    'status',
    'actions',
  ];
  statusList: string[] = ['Actif', 'Inactif'];
  dataSource = new MatTableDataSource<any>();

  @ViewChild(MatPaginator) paginator!: MatPaginator;

  constructor(
    private userService: UserService,
    private snackBar: MatSnackBar
  ) {
  
  }
  showSnackbar(message: string): void {
    this.snackBar.open(message, 'Fermer', {
      duration: 3000,
      panelClass: ['custom-snackbar']
    });
  }

  ngOnInit(): void {
    this.fetchUsers();
  }

  // Fetch users from the backend
  fetchUsers(): void {
    this.userService.getUsers().subscribe(
      (users) => {
        this.users = users;
        this.filteredUsers = users;
        this.dataSource.data = this.filteredUsers;
        this.dataSource.paginator = this.paginator;
      },
      (error) => {
        this.showSnackbar(
          'Erreur lors de la récupération des utilisateurs.'
        );
        console.error('Error fetching users:', error);
      }
    );
  }

  // Apply filter based on user status
  applyStatusFilter(event: any): void {
    const filterValue = event.value;
    this.filteredUsers = this.users.filter(
      (user) => user.status === filterValue
    );
    this.dataSource.data = this.filteredUsers;
  }

  // Apply search filter
  applySearchFilter(event: any): void {
    const filterValue = event.target.value.trim().toLowerCase();
    this.filteredUsers = this.users.filter((user) => {
      return (
        user.nom.toLowerCase().includes(filterValue) ||
        user.prenom.toLowerCase().includes(filterValue) ||
        user.email.toLowerCase().includes(filterValue)
      );
    });
    this.dataSource.data = this.filteredUsers;
  }

  // Edit a user
  editUser(user: any): void {
    // Logic for opening a dialog for editing the user
    this.showSnackbar(
      'Fonctionnalité de modification non encore implémentée.'
    );
  }

  // Delete a user
  deleteUser(user: any): void {
    this.userService.deleteUser(user.id).subscribe(
      () => {
        this.fetchUsers();
        this.showSnackbar('Utilisateur supprimé avec succès!');
      },
      (error) => {
        this.showSnackbar(
          "Erreur lors de la suppression de l'utilisateur."
        );
        console.error('Error deleting user:', error);
      }
    );
  }

  // Toggle user status
  toggleUserStatus(user: any): void {
    this.userService.toggleUserStatus(user).subscribe(
      () => {
        this.fetchUsers();
        this.showSnackbar(
          "Statut de l'utilisateur mis à jour avec succès!"
        );
      },
      // (error) => {
      //   this.showSnackbar(
      //     "Erreur lors de la mise à jour du statut de l'utilisateur."
      //   );
      //   console.error('Error toggling user status:', error);
      // }
    );
  }

  // Get status CSS class based on status
  getStatusClass(status: string): string {
    return status === 'Actif' ? 'status-active' : 'status-inactive';
  }
}
