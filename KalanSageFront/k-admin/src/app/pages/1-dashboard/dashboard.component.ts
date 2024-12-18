import { Component, OnInit } from '@angular/core';
import { MaterialModule } from 'src/app/material.module';
import { UserService } from 'src/app/services/users.service';
import {ModuleService} from 'src/app/services/modules.service'
import { AbonnementService } from '../../services/abonnement.service';
import { PartenaireService } from 'src/app/services/partenaire.service';


@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [MaterialModule],
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss'],
})
export class DashboardComponent implements OnInit {
  moduleId: any[];
  topModules: any[] = [];
  displayedColumns: string[] = ['titre', 'inscris', 'review'];
  courses: any[] = [];
  users: any[] = [];
  userCount: number = 0;
  usersCount: number = 0;
  abonnementCount: number = 0;
  partnerCount: number = 0;

  constructor(
    private userService: UserService,
    private abonnementService: AbonnementService,
    private moduleService: ModuleService,
    private partenaireService: PartenaireService
  ) {}

  ngOnInit(): void {
    this.fetchTopModules();
    this.fetchUserCount();
    this.fetchAbonnementCount();
    this.fetchPartnerCount();
  }

  fetchUserCount(): void {
    this.userService.getUserCount().subscribe(
      (count) => {
        this.userCount = count;
      },
      (error) => {
        console.error('Failed to fetch user count:', error);
      }
    );
  }

  fetchAbonnementCount(): void {
    this.abonnementService.getAbonnementCount().subscribe(
      (count) => {
        this.abonnementCount = count;
      },
      (error) => {
        console.error('Failed to fetch abonnement count:', error);
      }
    );
  }

  fetchPartnerCount(): void {
    this.partenaireService.countPartenaires().subscribe(
      (count) => {
        this.partnerCount = count;
      },
      (error) => {
        console.error('Failed to fetch partner count:', error);
      }
    );
  }

  fetchTopModules(): void {
    this.moduleService.getTop().subscribe(
      (modules) => {
        this.topModules = modules;
      },
      (error) => {
        console.error('Failed to fetch top modules:', error);
      }
    );
  }

  fetchModuleUsers(moduleId: number): void {
    this.moduleService.getUsersByModule(moduleId).subscribe(
      (userCount) => {
        const module = this.topModules.find((mod) => mod.id === moduleId);
        if (module) {
          module.abonne = userCount.length; 
        }
      },
      (error) => {
        console.error('Error fetching users for module:', moduleId, error);
      }
    );
  }
}
