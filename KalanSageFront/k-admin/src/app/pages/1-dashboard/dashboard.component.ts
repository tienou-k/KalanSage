import { Component, OnInit } from '@angular/core';
import { MaterialModule } from 'src/app/material.module';
import { DashboardService } from 'src/app/services/dashboard.service';

interface Modules {
  name: string;
  inscris: number;
  review: number;
}

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [MaterialModule],
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss'],
})
export class DashboardComponent implements OnInit {
  displayedColumns: string[] = ['titre', 'inscris', 'review'];
  courses: Modules[] = [];
  userCount: number = 0;
  abonnementCount: number = 0;
  partnerCount: number = 0;

  constructor(private dashboardService: DashboardService) {}

  ngOnInit(): void {
    this.fetchUserCount();
    this.fetchAbonnementCount();
    this.fetchPartnerCount();
    this.fetchTopCourses();
  }

  fetchUserCount(): void {
    this.dashboardService.getUserCount().subscribe(
      (count) => {
        this.userCount = count;
      },
      (error) => {
        console.error('Failed to fetch user count:', error);
      }
    );
  }

  fetchAbonnementCount(): void {
    this.dashboardService.getAbonnementCount().subscribe(
      (count) => {
        this.abonnementCount = count;
      },
      (error) => {
        console.error('Failed to fetch abonnement count:', error);
      }
    );
  }

  fetchPartnerCount(): void {
    this.dashboardService.getPartnerCount().subscribe(
      (count) => {
        this.partnerCount = count;
      },
      (error) => {
        console.error('Failed to fetch partner count:', error);
      }
    );
  }

  fetchTopCourses(): void {
    this.dashboardService.getTopCourses().subscribe(
      (courses) => {
        this.courses = courses;
      },
      (error) => {
        console.error('Failed to fetch top courses:', error);
      }
    );
  }
}
