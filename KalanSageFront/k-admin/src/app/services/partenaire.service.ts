import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class PartenaireService {
  private apiUrl = 'http://localhost:8080/api/admins/partenaires';

  constructor(private http: HttpClient) {}

  // Create a new partner
  creerPartenariat(partenaireData: FormData): Observable<any> {
    return this.http.post<any>(
      `${this.apiUrl}/creer-partenariat`,
      partenaireData
    );
  }

  // Update an existing partner
  modifierPartenariat(id: number, partenaireData: any): Observable<any> {
    return this.http.put<any>(
      `${this.apiUrl}/modifier-partenariat/${id}`,
      partenaireData
    );
  }

  // Delete a partner by ID
  supprimerPartenariat(id: number): Observable<any> {
    return this.http.delete<any>(`${this.apiUrl}/supprimer-partenariat/${id}`);
  }

  // Activate/Deactivate a partner
  activerDesactiverPartenariat(id: number, statut: boolean): Observable<any> {
    return this.http.put<any>(
      `${this.apiUrl}/activer-desactiver-partenariat/${id}?statut=${statut}`,
      {}
    );
  }

  // Fetch the list of all partners
  listerPartenaires(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/list-partenaires`);
  }

  // Get a partner by ID
  getPartenaireById(id: number): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/${id}`);
  }

  // Count all partners
  countPartenaires(): Observable<number> {
    return this.http.get<number>(`${this.apiUrl}/count`);
  }
  togglePartenaireStatus(user: any): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/status/${user.id}`, {});
  }
}
