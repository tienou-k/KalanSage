import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class ModuleService {
  private apiUrl = 'http://10.175.48.31:8080/api/modules';
  private categoriesUrl = 'http://:8080/api/admins/categories';

  constructor(private http: HttpClient) {}

  // Create a new module
  creerModule(moduleData: any): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/creer-module`, moduleData);
  }

  // Delete a module by ID
  supprimerModule(moduleId: number): Observable<any> {
    return this.http.delete<any>(`${this.apiUrl}/supprimer-module/${moduleId}`);
  }

  // Update an existing module
  modifierModule(moduleId: number, moduleData: any): Observable<any> {
    return this.http.put<any>(
      `${this.apiUrl}/modifier-module/${moduleId}`,
      moduleData
    );
  }

  // Fetch the list of all modules
  listerModules(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/list-modules`);
  }

  // Fetch the top 5 modules
  getTop5Modules(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/top5`);
  }
  getTopCourses(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/modules/top`);
  }

  // Fetch a single module by ID
  getModuleById(id: number): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/module-par/${id}`);
  }

  createCategory(category: { nomCategorie: string }): Observable<any> {
    return this.http.post<any>(
      `${this.categoriesUrl}/creer-categorie`,
      category
    );
  }

  getCategories(): Observable<any[]> {
    return this.http.get<any[]>(`${this.categoriesUrl}/list-categories`);
  }
}
