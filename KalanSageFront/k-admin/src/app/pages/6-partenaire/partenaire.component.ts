import { Component, ViewEncapsulation, OnInit, ViewChild } from '@angular/core';
import { MatTableDataSource } from '@angular/material/table';
import { MatPaginator } from '@angular/material/paginator';
import { MaterialModule } from 'src/app/material.module';
import { CommonModule } from '@angular/common';
import { MatDialog } from '@angular/material/dialog';
import { ModuleCreateDialogComponent } from 'src/app/module-create-dialog/module-create-dialog.component';

interface UserData {
  name: string;
  surname: string;
  email: string;
  phone: string;
  status: string;
}

@Component({
  selector: 'app-partenaire',
  standalone: true,
  imports: [
    CommonModule,
    MaterialModule],
  templateUrl: './partenaire.component.html',
  styleUrls: ['./partenaire.component.scss'],
  encapsulation: ViewEncapsulation.None,
})
export class PartenaireComponnet implements OnInit {
  constructor(private dialog: MatDialog) {}
  displayedColumns: string[] = [
    'name',
    'surname',
    'email',
    'phone',
    'status',
    'actions',
  ];
  users: UserData[] = [
    {
      name: 'Alexander',
      surname: 'Foley',
      email: 'alexander.foley@gmail.com',
      phone: '+223 6 99 88 77 66',
      status: 'Actif',
    },
    {
      name: 'John',
      surname: 'Doe',
      email: 'john.doe@gmail.com',
      phone: '+223 6 99 88 77 67',
      status: 'Inactif',
    },
    {
      name: 'Jane',
      surname: 'Smith',
      email: 'jane.smith@gmail.com',
      phone: '+223 6 99 88 77 68',
      status: 'Désactivé',
    },
    // Add more user data here...
  ];
  filteredUsers = new MatTableDataSource<UserData>(this.users);
  statusList: string[] = ['Actif', 'Inactif', 'Désactivé'];

  @ViewChild(MatPaginator) paginator!: MatPaginator;

  ngOnInit(): void {
    this.filteredUsers.paginator = this.paginator;
  }
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
  applyFilter(event: any): void {
    const filterValue = event.value;
    if (filterValue) {
      this.filteredUsers.data = this.users.filter(
        (user) => user.status === filterValue
      );
    } else {
      this.filteredUsers.data = this.users;
    }
  }

  getStatusClass(status: string): string {
    switch (status) {
      case 'Actif':
        return 'status-active';
      case 'Inactif':
        return 'status-inactive';
      case 'Désactivé':
        return 'status-disabled';
      default:
        return '';
    }
  }

  // Action methods
  editUser(user: UserData): void {
    console.log('Edit User:', user);
    // Implement edit logic here (e.g., open a dialog for editing)
  }

  deleteUser(user: UserData): void {
    console.log('Delete User:', user);
    this.users = this.users.filter((u) => u !== user);
    this.filteredUsers.data = this.users;
  }

  toggleUserStatus(user: UserData): void {
    user.status = user.status === 'Actif' ? 'Inactif' : 'Actif';
    this.filteredUsers.data = [...this.users];
    console.log('User status toggled:', user);
  }
}
