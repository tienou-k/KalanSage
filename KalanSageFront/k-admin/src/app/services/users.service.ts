import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class UserService {
  private apiUrl = 'http://localhost:8080/api/admins/utilisateurs';
  private apiUserUrl = 'http://localhost:8080/api/users';
  private abonnementapiUrl = 'http://localhost:8080/api/admins/abonnements';

  constructor(private http: HttpClient) {}

  // Fetch all users
  getUsers(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/list-utilisateurs`);
  }

  // Create a new user
  createUser(userData: FormData): Observable<any> {
    return this.http.post<any>(`${this.apiUserUrl}/creer-user`, userData);
  }

  // Update a user
  updateUser(userId: number, userData: FormData): Observable<any> {
    return this.http.put<any>(
      `${this.apiUserUrl}/modifier-user/${userId}`,
      userData
    );
  }

  // Delete a user
  deleteUser(utilisateurId: number): Observable<any> {
    return this.http.delete<any>(
      `${this.apiUrl}/supprimer-utilisateur/${utilisateurId}`
    );
  }

  // Fetch users by role
  getUsersByRole(role: string): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/role/${role}`);
  }

  // Toggle user status
  toggleUserStatus(user: any): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/status/${user.id}`, {});
  }
  getUserCount(): Observable<number> {
    return this.http.get<number>(`${this.apiUrl}/count`);
  }

  getUsersByModule(moduleId: number): Observable<any[]> {
    return this.http.get<any[]>(
      `${this.abonnementapiUrl}/users`
    );
  }
}
