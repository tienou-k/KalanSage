import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { catchError, Observable, tap } from 'rxjs';
import { AuthService } from './auth-service.service';

@Injectable({
  providedIn: 'root',
})
export class UserService {
  private apiUrl = 'http://localhost:8080/api/admins/utilisateurs';
  private apiUserUrl = 'http://localhost:8080/api/users';
  private abonnementapiUrl = 'http://localhost:8080/api/admins/abonnements';

  constructor(private http: HttpClient, private authService: AuthService) {}

  // Utility method to get the authorization header using the access token from AuthService
  private getAuthHeaders(): HttpHeaders {
    const token = this.authService.getAccessToken();
    return new HttpHeaders({
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json',
    });
  }

  // Fetch all users
  getUsers(): Observable<any[]> {
    return this.http
      .get<any[]>(`${this.apiUrl}/list-utilisateurs`, {
        headers: this.getAuthHeaders(),
      })
      .pipe(
        tap((users) => console.log('Users fetched:', users)), 
        catchError((error) => {
          console.error('Error fetching users:', error); 
          if (error.status === 401) {
            console.log('Token might be expired. Attempting refresh...');
            this.authService.refreshToken().subscribe(() => {
              // Retry fetching users after token refresh
              return this.getUsers();
            });
          }
          throw error; 
        })
      );
  }

  // Create a new user
  createUser(userData: FormData): Observable<any> {
    return this.http.post<any>(`${this.apiUserUrl}/creer-user`, userData, {
      headers: this.getAuthHeaders(),
    });
  }

  // Update a user
  updateUser(userId: number, userData: FormData): Observable<any> {
    return this.http.put<any>(
      `${this.apiUserUrl}/modifier-user/${userId}`,
      userData,
      {
        headers: this.getAuthHeaders(),
      }
    );
  }

  // Delete a user
  deleteUser(utilisateurId: number): Observable<any> {
    return this.http.delete<any>(
      `${this.apiUrl}/supprimer-utilisateur/${utilisateurId}`,
      {
        headers: this.getAuthHeaders(),
      }
    );
  }

  // Fetch users by role
  getUsersByRole(role: string): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/role/${role}`, {
      headers: this.getAuthHeaders(),
    });
  }

  // Toggle user status
  toggleUserStatus(user: any): Observable<any> {
    return this.http.post<any>(
      `${this.apiUrl}/status/${user.id}`,
      {},
      {
        headers: this.getAuthHeaders(),
      }
    );
  }

  // Get user count
  getUserCount(): Observable<number> {
    return this.http.get<number>(`${this.apiUrl}/count`, {
      headers: this.getAuthHeaders(),
    });
  }

  // // Fetch users by module
  // getUsersByModule(moduleId: number): Observable<any[]> {
  //   return this.http.get<any[]>(`${this.abonnementapiUrl}/users`, {
  //     headers: this.getAuthHeaders(),
  //   });
  // }
}
