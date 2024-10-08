import { Component, OnInit } from '@angular/core';
import { AbonnementService } from 'src/app/services/abonnement.service';
import { MatTableDataSource } from '@angular/material/table';
import { MaterialModule } from 'src/app/material.module';

@Component({
  selector: 'app-abonnement-dashboard',
  standalone: true,
  imports: [MaterialModule],
  templateUrl: './abonnement.component.html',
  styleUrls: ['./abonnement.component.scss'],
})
export class AbonnementComponent implements OnInit {
  abonnementCount: number = 0;
  mostSubscribedAbonnement: any;
  dataSource1 = new MatTableDataSource<any>();
  displayedColumns1: string[] = [
    'id',
    'date',
    'client',
    'abonnement',
    'budget',
    'priority',
    'actions',
  ];

  constructor(private abonnementService: AbonnementService) {}

  ngOnInit(): void {
    this.fetchAbonnementCount();
    this.fetchMostSubscribedAbonnement();
    this.fetchAbonnementUsers();
  }

  fetchAbonnementCount(): void {
    this.abonnementService.getAbonnementCount().subscribe(
      (count) => {
        this.abonnementCount = count;
      },
      (error) => {
        console.error('Error fetching abonnement count:', error);
      }
    );
  }

  fetchMostSubscribedAbonnement(): void {
    this.abonnementService.getMostSubscribedAbonnement().subscribe(
      (abonnement) => {
        this.mostSubscribedAbonnement = abonnement;
      },
      (error) => {
        console.error('Error fetching most subscribed abonnement:', error);
        this.mostSubscribedAbonnement = {
          prix: 0,
          typeAbonnement: 'N/A',
        };
      }
    );
  }

  fetchAbonnementUsers(): void {
    this.abonnementService.getAbonnementUsers().subscribe(
      (users) => {
        // Extract the first abonnement from the abonnementUser list for each user
        this.dataSource1.data = users.map((user) => {
          const abonnement = user.abonnementUser[0]; // Assuming each user has at least one abonnement
          return {
            id: user.id,
            date: abonnement?.dateExpiration || 'N/A',
            client: `${user.nom} ${user.prenom}`,
            typeAbonnement: abonnement?.typeAbonnement || 'N/A',
            montant: abonnement?.prix || 0,
            priority: abonnement?.statut ? 'confirmer' : 'annuler', // Set status based on statut
          };
        });
      },
      (error) => {
        console.error('Error fetching abonnement users:', error);
      }
    );
  }
}
