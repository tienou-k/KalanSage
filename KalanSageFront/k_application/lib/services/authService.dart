import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:k_application/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  SharedPreferences? _prefs;

  AuthService() {
    _initPrefs();
  }

  // Initialize SharedPreferences
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Ensure prefs is initialized before calling any methods
  Future<void> _ensurePrefsInitialized() async {
    if (_prefs == null) {
      await _initPrefs();
    }
  }

  // Login method
  Future<Map<String, dynamic>?> login(String email, String password) async {
    await _ensurePrefsInitialized();

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email': email,
      'motDePasse': password,
    });

    final response = await http.post(
      Uri.parse('$apiUrl/auth/login'),
      headers: headers,
      body: body,
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('Parsed response: $responseData');

      // Check if accessToken exists in the response
      if (responseData['accessToken'] != null) {
        // Save accessToken and role in SharedPreferences
        final user = {
          'token': responseData['accessToken'],
          'role': responseData['role'],
        };
        await _prefs?.setString('currentUser', jsonEncode(user));
        return user;
      } else {
        throw Exception('No access token found in login response.');
      }
    } else {
      // Enhanced error logging
      final errorData = jsonDecode(response.body);
      throw Exception('Login failed: ${errorData['message']}');
    }
  }

  // Fetch User Profile
  Future<Map> fetchUserProfile() async {
    await _ensurePrefsInitialized();

    final currentUser = getCurrentUser();
    if (currentUser == null || currentUser['token'] == null) {
      throw Exception('Aucun jeton trouvé. Veuillez vous reconnecter.');
    }

    final token = currentUser['token'];
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(
      Uri.parse('$apiUrl/auth/profil'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final profileData = jsonDecode(response.body);

      // Update user profile in SharedPreferences
      final updatedUser = {
        ...currentUser,
        ...profileData,
      };
      await _prefs?.setString('currentUser', jsonEncode(updatedUser));
      return updatedUser;
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception('Failed to fetch user profile: ${errorData['message']}');
    }
  }

  // Logout method
  Future<void> logout() async {
    await _ensurePrefsInitialized();
    await _prefs?.remove('currentUser');
    print('User logged out.');
  }

  // Check if user is logged in
  bool isLoggedIn() {
    final currentUser = getCurrentUser();
    return currentUser != null && currentUser['token'] != null;
  }

  // Get current user data
  Map<String, dynamic>? getCurrentUser() {
    final currentUser = _prefs?.getString('currentUser');
    if (currentUser != null) {
      return jsonDecode(currentUser);
    }
    return null;
  }
}
