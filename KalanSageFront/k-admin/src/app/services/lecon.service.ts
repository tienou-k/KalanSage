import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { AuthService } from './auth-service.service'; // Assuming you have an AuthService to handle tokens

@Injectable({
  providedIn: 'root',
})
export class LeconService {
  private apiUrl = 'http://localhost:8080/api/lecons';
  private apiModuleUrl = 'http://localhost:8080/api/modules';

  constructor(private http: HttpClient, private authService: AuthService) {}

  // Utility method to get the authorization header using the access token from AuthService
  private getAuthHeaders(): HttpHeaders {
    const token = this.authService.getAccessToken();
    return new HttpHeaders({
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json',
    });
  }

  // Create a new lesson
  creerLecon(leconData: any): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/creer-lecon`, leconData, {
      headers: this.getAuthHeaders(),
    });
  }

  // Update an existing lesson
  modifierLecon(leconId: number, leconData: any): Observable<any> {
    return this.http.put<any>(
      `${this.apiUrl}/modifier-lecon/${leconId}`,
      leconData,
      {
        headers: this.getAuthHeaders(),
      }
    );
  }

  // Delete a lesson
  supprimerLecon(leconId: number): Observable<any> {
    return this.http.delete<any>(`${this.apiUrl}/supprimer-lecon/${leconId}`, {
      headers: this.getAuthHeaders(),
    });
  }

  // Fetch a lesson by ID
  getLeconById(leconId: number): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/lecon-par/${leconId}`, {
      headers: this.getAuthHeaders(),
    });
  }

  // Fetch all lessons
  listerLecons(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/list-lecons`, {
      headers: this.getAuthHeaders(),
    });
  }

  // Fetch lessons by module ID
  getLeconsByModule(moduleId: number): Observable<any[]> {
    return this.http.get<any[]>(
      `${this.apiModuleUrl}/module/${moduleId}/lecons`,
      { headers: this.getAuthHeaders() }
    );
  }

  // Count all lessons
  countLecons(): Observable<number> {
    return this.http.get<number>(`${this.apiUrl}/count`, {
      headers: this.getAuthHeaders(),
    });
  }
}
