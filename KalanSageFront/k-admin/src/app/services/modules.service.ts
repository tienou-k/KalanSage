import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import {catchError, Observable, throwError} from 'rxjs';
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
    console.log('Access Token:', token); // for debugging
    return new HttpHeaders({
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json',
    });
  }


  // Method to create a new module
  creerModule(moduleData: any): Observable<any> {
    const formData = new FormData();
    formData.append('titre', moduleData.titre);
    formData.append('description', moduleData.description);
    formData.append('prix', moduleData.prix.toString());
    formData.append('nomCategorie', moduleData.nomCategorie);
    formData.append('dateCreation', moduleData.dateCreation.toISOString());

    // Append image file if it exists
    if (moduleData.imageUrl) {
      formData.append('file', moduleData.imageUrl, moduleData.imageUrl.name);
    }

    return this.http.post<any>(`${this.apiUrl}/creer-module`, formData,{
      headers: new HttpHeaders({
        Authorization: `Bearer ${this.authService.getAccessToken()}`,
      }),
    })
      .pipe(
        catchError(this.handleError)
      );
  }

  /*
  // Update an existing module
  modifierModule(
    moduleId: number,
    moduleData: any,
    file?: File
  ): Observable<any> {
    const formData = new FormData();
    formData.append('titre', moduleData.titre);
    formData.append('description', moduleData.description);
    formData.append('prix', moduleData.prix);
    if (file) {
      formData.append('file', file, file.name);
    }
    return this.http.put<any>(
      `${this.apiUrl}/modifier-module/${moduleId}`,
      formData,
      {
        headers: new HttpHeaders({
          Authorization: `Bearer ${this.authService.getAccessToken()}`,
        }),
      }
    );
  }*/



  // Method to modify an existing module
  modifierModule(moduleId: number, moduleData: any): Observable<any> {
    const formData = new FormData();
    formData.append('titre', moduleData.titre);
    formData.append('description', moduleData.description);
    formData.append('prix', moduleData.prix.toString());
    formData.append('nomCategorie', moduleData.nomCategorie);
    formData.append('dateCreation', moduleData.dateCreation.toISOString());

    // Append image file if it exists
    if (moduleData.imageUrl) {
      formData.append('image', moduleData.imageUrl, moduleData.imageUrl.name);
    }

    return this.http.put<any>(`${this.apiUrl}/update/${moduleId}`, formData)
      .pipe(
        catchError(this.handleError)
      );
  }

  // Error handling
  private handleError(error: any) {
    console.error('An error occurred:', error);
    return throwError(error);
  }






  // Delete a module by ID
  supprimerModule(moduleId: number): Observable<any> {
    return this.http.delete<any>(`${this.apiUrl}/suprimer-module/${moduleId}`, {
      headers: this.getAuthHeaders(),
    });
  }

  // Fetch the list of all modules
  listerModules(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/list-modules`, {
      headers: this.getAuthHeaders(),
    });
  }

  // Fetch the top 5 modules
  getTop5Modules(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/popular`, {
      headers: this.getAuthHeaders(),
    });
  }

  // Fetch a single module by ID
  getModuleById(id: number): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/module-par/${id}`, {
      headers: this.getAuthHeaders(),
    });
  }

  // Method to get users by module
  getUsersByModule(moduleId: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/${moduleId}/user-count`, {
      headers: this.getAuthHeaders(),
    });
  }

  // Method to get lessons (Lecons) by module
  getLeconsByModule(moduleId: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/${moduleId}/lecons`, {
      headers: this.getAuthHeaders(),
    });
  }
  // Method to get the count of lessons (Lecons) by module
  getLeconsCountByModule(moduleId: number): Observable<number> {
    return this.http.get<number>(`${this.apiUrl}/${moduleId}/lecons/count`, {
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

  getTop(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/popular`, {
      headers: this.getAuthHeaders(),
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
