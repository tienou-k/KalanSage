import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, BehaviorSubject } from 'rxjs';
import { map, catchError, tap } from 'rxjs/operators';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Router } from '@angular/router';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private apiUrl = 'http://localhost:8080/api/auth';
  private currentUserSubject: BehaviorSubject<any>;
  public currentUser: Observable<any>;

  constructor(
    private http: HttpClient,
    private snackBar: MatSnackBar,
    private router: Router
  ) {
    this.currentUserSubject = new BehaviorSubject<any>(
      JSON.parse(localStorage.getItem('currentUser') || '{}')
    );
    this.currentUser = this.currentUserSubject.asObservable();

    window.addEventListener('storage', (event) => {
      if (event.key === 'currentUser' && !event.newValue) {
        this.currentUserSubject.next(null);
        this.router.navigate(['/login']);
      }
    });
  }

  // Modified login method to store both access and refresh tokens
  login(email: string, password: string): Observable<any> {
    const headers = { 'Content-Type': 'application/json' };

    return this.http
      .post<any>(
        `${this.apiUrl}/login`,
        { email, motDePasse: password },
        { headers }
      )
      .pipe(
        map((response) => {
          const user = {
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
            role: response.role,
          };
          localStorage.setItem('currentUser', JSON.stringify(user));
          this.currentUserSubject.next(user);
          return user;
        }),
        catchError((error) => {
          console.error('Login failed:', error);
          this.showSnackbar('Erreur de connexion. Vérifiez vos identifiants.');
          localStorage.removeItem('currentUser');
          this.currentUserSubject.next(null);
          throw error;
        })
      );
  }

  // AuthService.ts
  getAccessToken(): string | null {
    const currentUser = this.currentUserSubject.value;
    const token = currentUser ? currentUser.accessToken : null;
    console.log('Access Token:', token);
    return token;
  }

  getRefreshToken(): string | null {
    const currentUser = this.currentUserSubject.value;
    const refreshToken = currentUser ? currentUser.refreshToken : null;
    console.log('Refresh Token:', refreshToken); 
    return refreshToken;
  }

  // Method to refresh the access token using the refresh token
  refreshToken(): Observable<any> {
    const refreshToken = this.currentUserValue?.refreshToken;
    if (!refreshToken) {
      return this.logout();
    }

    const headers = new HttpHeaders().set(
      'Authorization',
      `Bearer ${refreshToken}`
    );
    return this.http
      .post<any>(`${this.apiUrl}/refresh-token`, {}, { headers })
      .pipe(
        map((response) => {
          const updatedUser = {
            ...this.currentUserValue,
            accessToken: response.accessToken,
          };
          localStorage.setItem('currentUser', JSON.stringify(updatedUser));
          this.currentUserSubject.next(updatedUser);
          return updatedUser;
        }),
        catchError((error) => {
          console.error('Failed to refresh token:', error);
          this.logout();
          throw error;
        })
      );
  }

  private showSnackbar(message: string) {
    this.snackBar.open(message, 'Fermer', {
      duration: 3000,
      verticalPosition: 'top',
      horizontalPosition: 'center',
    });
  }

  // Method to fetch the user profile using the access token
  fetchUserProfile(): Observable<any> {
    const headers = new HttpHeaders().set(
      'Authorization',
      `Bearer ${this.currentUserValue.accessToken}`
    );
    return this.http.get<any>(`${this.apiUrl}/profil`, { headers }).pipe(
      tap((profile) => {
        const updatedUser = { ...this.currentUserValue, ...profile };
        localStorage.setItem('currentUser', JSON.stringify(updatedUser));
        this.currentUserSubject.next(updatedUser);
      }),
      catchError((error) => {
        console.error('Failed to fetch user profile:', error);
        throw error;
      })
    );
  }

  // Logout method clears both access and refresh tokens
  logout(): Observable<any> {
    const headers = new HttpHeaders().set(
      'Authorization',
      `Bearer ${this.currentUserValue?.accessToken}`
    );

    return this.http
      .post(`${this.apiUrl}/se-deconnecter`, {}, { headers })
      .pipe(
        tap(() => {
          // Clear local storage and user state
          localStorage.removeItem('currentUser');
          sessionStorage.clear();
          this.currentUserSubject.next(null);
          // Redirect to login page
          this.router.navigateByUrl('/login', { replaceUrl: true });
        }),
        catchError((error) => {
          console.error('Logout failed:', error);
          throw error;
        })
      );
  }

  public get currentUserValue(): any {
    return this.currentUserSubject.value;
  }

  isLoggedIn(): boolean {
    return !!this.currentUserValue && !!this.currentUserValue.accessToken;
  }

  // This method checks if the user is an admin
  isUserAdmin(): boolean {
    const userRoles = this.getUserRoles();
    return userRoles.includes('ROLE_ADMIN');
  }

  // Mock method to fetch user roles, replace this with your actual implementation
  getUserRoles(): string[] {
    const token = localStorage.getItem('userToken');
    if (token) {
      const payload = JSON.parse(atob(token.split('.')[1]));
      return payload.roles;
    }
    return [];
  }
}
