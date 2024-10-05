import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class DashboardService {
  private apiUrl = 'http://localhost:8080/api';

  constructor(private http: HttpClient) {}

  getUserCount(): Observable<number> {
    return this.http.get<number>(`${this.apiUrl}/admins/utilisateurs/count`);
  }

  getAbonnementCount(): Observable<number> {
    return this.http.get<number>(`${this.apiUrl}/admins/abonnements/count`);
  }

  getPartnerCount(): Observable<number> {
    return this.http.get<number>(`${this.apiUrl}/admins/partenaires/count`);
  }

  getTopCourses(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/modules/top`);
  }
}
