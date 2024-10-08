import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class AbonnementService {
  private apiUrl = 'http://localhost:8080/api/admins/abonnements';

  constructor(private http: HttpClient) {}

  getAbonnementCount(): Observable<number> {
    return this.http.get<number>(`${this.apiUrl}/count`);
  }
  getMostSubscribedAbonnement(): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/most-subscribed`);
  }

  getAbonnementUsers(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/users`);
  }

  getSubscribedUsers(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/users`);
  }


  
}
