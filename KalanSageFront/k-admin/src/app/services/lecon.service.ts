import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import {catchError, Observable, throwError} from 'rxjs';
import { AuthService } from './auth-service.service';

@Injectable({
  providedIn: 'root',
})
export class LeconService {
  private apiUrl = 'http://localhost:8080/api/lecons';

  constructor(private http: HttpClient, private authService: AuthService) {}

  private getAuthHeaders(): HttpHeaders {
    const token = this.authService.getAccessToken();
    return new HttpHeaders({
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json',
    });
  }

  createLecon(leconData: any): Observable<any> {
    const formData = new FormData();

    console.log('Received data:', JSON.stringify(leconData));

    formData.append('titre', String(leconData.titre || ''));
    formData.append('description', String(leconData.description || ''));
    formData.append('moduleId', String(leconData.moduleId || ''));
    //formData.append('file', leconData.videoPath || '', leconData.videoPath ? leconData.videoPath.name : '');
    // Append video file if it exists
    if (leconData.videoPath) {
      formData.append('file', leconData.videoPath, leconData.videoPath.name);
    }
    console.log('FormData:', formData);

    return this.http.post<any>(`${this.apiUrl}/creer-lecon`, formData, {
      headers: new HttpHeaders({
        Authorization: `Bearer ${this.authService.getAccessToken()}`,
      }),
    }).pipe(
      catchError(this.handleError)
    );
  }


  // Update a lesson
  updateLecon(id: number, leconData: FormData): Observable<any> {
    const headers = this.getAuthHeaders();
    return this.http.put(`${this.apiUrl}/modifier-lecon/${id}`, leconData, { headers });
  }

  // Delete a lesson
  deleteLecon(id: number): Observable<void> {
    const headers = this.getAuthHeaders();
    return this.http.delete<void>(`${this.apiUrl}/supprimer-lecon/${id}`, { headers });
  }

  // Error handling
  private handleError(error: any) {
    console.error('Une erreur s\est produite:', error);
    return throwError(error);
  }
}
