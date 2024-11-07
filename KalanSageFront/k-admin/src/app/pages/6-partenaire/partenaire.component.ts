import { Component, ViewEncapsulation, OnInit, ViewChild } from '@angular/core';
import { MatTableDataSource } from '@angular/material/table';
import { MatPaginator } from '@angular/material/paginator';
import { MatDialog } from '@angular/material/dialog';
import { PartenaireService } from '../../services/partenaire.service';
import { PartenaireCreateDialogComponent } from 'src/app/components/partenaire-dialog/partenaire-create-dialog.component';
import { MatSnackBar } from '@angular/material/snack-bar';
import { MaterialModule } from 'src/app/material.module';
import { CommonModule } from '@angular/common';


@Component({
  selector: 'app-partenaire',
  standalone: true,
  imports: [CommonModule, MaterialModule],
  templateUrl: './partenaire.component.html',
  styleUrls: ['./partenaire.component.scss'],
  encapsulation: ViewEncapsulation.None,
})
export class PartenaireComponent implements OnInit {
  partenaire: any[] = [];
  filteredParteanires: any[] = [];
  displayedColumns: string[] = [
    'nomPartenaire',
    // 'dateAjoute',
    'typePartenaire',
    'adresse',
    'emailContact',
    'numeroContact',
    'descriptionPartenariat',
    'status',
    'actions',
  ];
  statusList: string[] = ['Validé', 'En-attente', 'Désactivé'];
  dataSource = new MatTableDataSource<any>();

  @ViewChild(MatPaginator) paginator!: MatPaginator;

  constructor(
    private dialog: MatDialog,
    private partenaireService: PartenaireService,
    private snackBar: MatSnackBar
  ) {}

  ngOnInit(): void {
    this.fetchPartenaires();
  }

  // Fetch partners from the backend
  fetchPartenaires(): void {
    this.partenaireService.listerPartenaires().subscribe(
      (partenaire) => {
        this.partenaire = partenaire;
        this.filteredParteanires = partenaire;
        this.dataSource.data = this.filteredParteanires;
        this.dataSource.paginator = this.paginator;
      },
      (error) => {
        this.snackBar.open(
          'Erreur lors de la récupération des utilisateurs.',
          'Fermer',
          {
            duration: 3000,
            verticalPosition: 'top',
            horizontalPosition: 'center',
          }
        );
        console.error('Error fetching partners:', error);
      }
    );
  }

  openCreateDialog(): void {
    const dialogRef = this.dialog.open(PartenaireCreateDialogComponent, {
      height: '500px',
      width: '900px',
      disableClose: true,
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result) {
        console.log('Partner created:', result);
        this.fetchPartenaires();
      }
    });
  }

  applyFilter(event: any): void {
    const filterValue = event.value;
    if (filterValue) {
      this.dataSource.data = this.partenaire.filter(
        (partenaire) => partenaire.status === filterValue
      );
    } else {
      this.dataSource.data = this.filteredParteanires;
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
  editPartenaire(partenaire: any): void {
    this.snackBar.open("Cette methode n'est pas implementé", 'Fermer!', {
      duration: 2000,
    });
  }

  deleteUser(partenaire: any): void {
    this.partenaireService.supprimerPartenariat(partenaire.id).subscribe(
      () => {
        this.snackBar.open('Partenaire supprimé avec succès !', 'Fermer!', {
          duration: 3000,
        });
        this.fetchPartenaires();
      },
      (error) => {
        console.error('Error deleting partner:', error);
      }
    );
  }

  toggleUserStatus(user: any): void {
    this.partenaireService.togglePartenaireStatus(user).subscribe(
      () => {
        this.fetchPartenaires();
        this.snackBar.open("Statut du partenaire mis à jour avec succès!");
      }
      // (error) => {
      //   this.showSnackbar(
      //     "Erreur lors de la mise à jour du statut de l'utilisateur."
      //   );
      //   console.error('Error toggling user status:', error);
      // }
    );
  }
}
