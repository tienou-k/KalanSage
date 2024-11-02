import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { AuthService } from './auth-service.service';

@Injectable({
  providedIn: 'root',
})
export class PartenaireService {
  private apiUrl = 'http://localhost:8080/api/admins/partenaires';

  constructor(private http: HttpClient, private authService: AuthService) {}

  // Utility method to get the authorization header using the access token from AuthService
  private getAuthHeaders(): HttpHeaders {
    const token = this.authService.getAccessToken();
    console.log('Access Token:', token);
    return new HttpHeaders({
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json',
    });
  }

  // Create a new partner
  creerPartenariat(partenaireData: FormData): Observable<any> {
    return this.http.post<any>(
      `${this.apiUrl}/creer-partenariat`,
      partenaireData, {
      headers: this.getAuthHeaders(),
    });
  }

  // Update an existing partner
  modifierPartenariat(id: number, partenaireData: any): Observable<any> {
    return this.http.put<any>(
      `${this.apiUrl}/modifier-partenariat/${id}`,
      partenaireData,{
      headers: this.getAuthHeaders(),
    });
  }

  // Delete a partner by ID
  supprimerPartenariat(id: number): Observable<any> {
    return this.http.delete<any>(`${this.apiUrl}/supprimer-partenariat/${id}`,
      {
      headers: this.getAuthHeaders(),
    });
  }

  // Activate/Deactivate a partner
  activerDesactiverPartenariat(id: number, statut: boolean): Observable<any> {
    return this.http.put<any>(
      `${this.apiUrl}/activer-desactiver-partenariat/${id}?statut=${statut}`,
      {
      headers: this.getAuthHeaders(),
    });
  }

  // Fetch the list of all partners
  listerPartenaires(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/list-partenaires`,{
      headers: this.getAuthHeaders(),
    });
  }

  // Get a partner by ID
  getPartenaireById(id: number): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/${id}`, {
      headers: this.getAuthHeaders(),
    });
  }

  // Count all partners
  countPartenaires(): Observable<number> {
    return this.http.get<number>(`${this.apiUrl}/count`, {
      headers: this.getAuthHeaders(),
    });
  }
  /*
   getTop(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/popular`, {
      headers: this.getAuthHeaders(),
    });
  }
  
  */
  togglePartenaireStatus(user: any): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/status/${user.id}`, {
      headers: this.getAuthHeaders(),
    });
  }
}
