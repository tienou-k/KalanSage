import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { AuthService } from './auth-service.service';
@Injectable({
  providedIn: 'root',
})
export class CategoryService {
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

  // Fetch all categories
  getCategories(): Observable<any[]> {
    return this.http.get<any[]>(`${this.categoriesUrl}/list-categories`, {
      headers: this.getAuthHeaders(),
    });
  }

  // Create a new category
  createCategory(category: {
    nomCategorie: string;
    description: string;
  }): Observable<any> {
    return this.http.post<any>(
      `${this.categoriesUrl}/creer-categorie`,
      category,
      {
        headers: this.getAuthHeaders(),
      }
    );
  }

  // Optional: If you need to fetch a category by its ID
  getCategoryById(categoryId: number): Observable<any> {
    return this.http.get<any>(
      `${this.categoriesUrl}/categorie-par/${categoryId}`,
      {
        headers: this.getAuthHeaders(),
      }
    );
  }

  // Optional: Delete a category
  deleteCategory(categoryId: number): Observable<any> {
    return this.http.delete<any>(
      `${this.categoriesUrl}/supprimer-categorie/${categoryId}`,
      {
        headers: this.getAuthHeaders(),
      }
    );
  }
}
