import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { AuthService } from './auth-service.service'; // Assuming you have AuthService to manage tokens

@Injectable({
  providedIn: 'root',
})
export class QuizService {
  private apiUrl = 'http://localhost:8080/api/quizzes';

  constructor(private http: HttpClient, private authService: AuthService) {}

  // Utility method to get the authorization header using the access token from AuthService
  private getAuthHeaders(): HttpHeaders {
    const token = this.authService.getAccessToken();
    return new HttpHeaders({
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json',
    });
  }

  // Fetch quizzes by module ID
  getQuizzesByModule(moduleId: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/module/${moduleId}`, {
      headers: this.getAuthHeaders(),
    });
  }

  // Create a new quiz
  creerQuiz(quizData: any): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/creer-quiz`, quizData, {
      headers: this.getAuthHeaders(),
    });
  }

  // Update an existing quiz
  modifierQuiz(quizId: number, quizData: any): Observable<any> {
    return this.http.put<any>(
      `${this.apiUrl}/modifier-quiz/${quizId}`,
      quizData,
      {
        headers: this.getAuthHeaders(),
      }
    );
  }

  // Delete a quiz by ID
  supprimerQuiz(quizId: number): Observable<any> {
    return this.http.delete<any>(`${this.apiUrl}/supprimer-quiz/${quizId}`, {
      headers: this.getAuthHeaders(),
    });
  }

  // Fetch a quiz by ID
  getQuizById(quizId: number): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/quiz-par/${quizId}`, {
      headers: this.getAuthHeaders(),
    });
  }

  // Fetch all quizzes
  listerQuizzes(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/list-quizzes`, {
      headers: this.getAuthHeaders(),
    });
  }
}
