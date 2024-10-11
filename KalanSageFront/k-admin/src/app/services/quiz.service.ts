import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class QuizService {
  private apiUrl = 'http://10.175.48.31:8080/api/quizzes';

  constructor(private http: HttpClient) {}

  getQuizzesByModule(moduleId: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/module/${moduleId}`);
  }
}
