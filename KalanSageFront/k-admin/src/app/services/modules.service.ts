import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { AuthService } from './auth-service.service';

@Injectable({
  providedIn: 'root',
})
export class ModuleService {
  private apiUrl = 'http://localhost:8080/api/modules';
  private categoriesUrl = 'http://localhost:8080/api/categories';

  constructor(private http: HttpClient, private authService: AuthService) {}

  // Utility method to get the authorization header using the access token from AuthService
  private getAuthHeaders(): HttpHeaders {
    const token = this.authService.getAccessToken();
    return new HttpHeaders({
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json',
    });
  }

  // Create a new module
  creerModule(moduleData: any): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/creer-module`, moduleData, {
      headers: this.getAuthHeaders(),
    });
  }

  // Delete a module by ID
  supprimerModule(moduleId: number): Observable<any> {
    return this.http.delete<any>(
      `${this.apiUrl}/supprimer-module/${moduleId}`,
      {
        headers: this.getAuthHeaders(),
      }
    );
  }

  // Update an existing module
  modifierModule(moduleId: number, moduleData: any): Observable<any> {
    return this.http.put<any>(
      `${this.apiUrl}/modifier-module/${moduleId}`,
      moduleData,
      {
        headers: this.getAuthHeaders(),
      }
    );
  }

  // Fetch the list of all modules
  listerModules(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/list-modules`, {
      headers: this.getAuthHeaders(),
    });
  }

  // Fetch the top 5 modules
  getTop5Modules(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/top5`, {
      headers: this.getAuthHeaders(),
    });
  }

  

  // Fetch a single module by ID
  getModuleById(id: number): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/module-par/${id}`, {
      headers: this.getAuthHeaders(),
    });
  }

  getUsersByModule(moduleId: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/${moduleId}/user-count`, {
      headers: this.getAuthHeaders(),
    });
  }
  
  // Fetch all categories with proper authorization headers
  getCategories(): Observable<any[]> {
    const headers = this.getAuthHeaders();
    return this.http.get<any[]>(`${this.categoriesUrl}/list-categories`, {
      headers,
    });
  }

  // Create a new category
  createCategory(category: { nomCategorie: string }): Observable<any> {
    return this.http.post<any>(
      `${this.categoriesUrl}/creer-categorie`,
      category,
      {
        headers: this.getAuthHeaders(),
      }
    );
  }
}
