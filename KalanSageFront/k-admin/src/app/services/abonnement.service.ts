import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { AuthService } from './auth-service.service';
import { catchError, map } from 'rxjs/operators';

@Injectable({
  providedIn: 'root',
})
export class AbonnementService {
  private apiUrl = 'http://localhost:8080/api/admins/abonnements';

  constructor(private http: HttpClient, private authService: AuthService) {}

  // Utility method to get the authorization header using the access token from AuthService
  private getAuthHeaders(): HttpHeaders {
    const token = this.authService.getAccessToken();
    return new HttpHeaders({
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json',
    });
  }

  // Fetch abonnement count
  getAbonnementCount(): Observable<number> {
    return this.http
      .get<number>(`${this.apiUrl}/count`, {
        headers: this.getAuthHeaders(),
      })
      .pipe(
        catchError((error) => {
          console.error('Error fetching abonnement count:', error);
          throw error;
        })
      );
  }

  // Fetch the most subscribed abonnement
  getMostSubscribedAbonnement(): Observable<any> {
    return this.http
      .get<any>(`${this.apiUrl}/most-subscribed`, {
        headers: this.getAuthHeaders(),
      })
      .pipe(
        catchError((error) => {
          console.error('Error fetching most subscribed abonnement:', error);
          throw error;
        })
      );
  }

  // Fetch all abonnement users
  getAbonnementUsers(): Observable<any[]> {
    return this.http
      .get<any[]>(`${this.apiUrl}/users`, {
        headers: this.getAuthHeaders(),
      })
      .pipe(
        catchError((error) => {
          console.error('Error fetching abonnement users:', error);
          throw error;
        })
      );
  }

  // Fetch all subscribed users
  getSubscribedUsers(): Observable<any[]> {
    return this.http
      .get<any[]>(`${this.apiUrl}/users`, {
        headers: this.getAuthHeaders(),
      })
      .pipe(
        catchError((error) => {
          console.error('Error fetching subscribed users:', error);
          throw error;
        })
      );
  }
}
