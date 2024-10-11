import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class LeconService {
  private apiUrl = 'http://10.175.48.31:8080/api/lecons';
  private apiModuleUrl = 'http://10.175.48.31:8080/api/modules';

  constructor(private http: HttpClient) {}

  // Create a new lesson
  creerLecon(leconData: any): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/creer-lecon`, leconData);
  }

  // Update an existing lesson
  modifierLecon(leconId: number, leconData: any): Observable<any> {
    return this.http.put<any>(
      `${this.apiUrl}/modifier-lecon/${leconId}`,
      leconData
    );
  }

  // Delete a lesson
  supprimerLecon(leconId: number): Observable<any> {
    return this.http.delete<any>(`${this.apiUrl}/supprimer-lecon/${leconId}`);
  }

  // Fetch a lesson by ID
  getLeconById(leconId: number): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/lecon-par/${leconId}`);
  }

  // Fetch all lessons
  listerLecons(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/list-lecons`);
  }

  // Fetch lessons by module ID
  getLeconsByModule(moduleId: number): Observable<any[]> {
    return this.http.get<any[]>(
      `${this.apiModuleUrl}/module/${moduleId}/lecons`
    );
  }
  // Count all lessons
  countLecons(): Observable<number> {
    return this.http.get<number>(`${this.apiUrl}/count`);
  }
}
