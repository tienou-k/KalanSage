import 'dart:convert';
import 'package:flutter/material.dart';
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
  Future<Map<String, dynamic>?> login(
      String email, String password, BuildContext context) async {
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

    if (response.statusCode == 200) {
      debugPrint('Login successful, processing response...');
      final responseData = jsonDecode(response.body);

      if (responseData['accessToken'] != null) {
        final user = {
          'token': responseData['accessToken'],
          'role': responseData['role'],
          'status': responseData['status'],
        };

        await _prefs?.setString('currentUser', jsonEncode(user));

        if (user['status'] == false) {
          // Navigate to OTP verification screen if user is not active
          Navigator.pushNamed(context, '/otp_verification', arguments: email);
        } else {
          return user;
        }
      } else {
        throw Exception('No access token found in login response.');
      }
    } else {
      // Detailed error handling based on response data
      final errorData = jsonDecode(response.body);
      if (errorData['message'] != null) {
        throw Exception(errorData['message']);
      }
      throw Exception('Login failed. Please try again.');
    }
    return null;
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

  // Verify OTP
  Future<Map<String, dynamic>> verifyOTP(Map<String, String> otpData) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/auth/verify-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(otpData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 'error', 'message': 'Failed to verify OTP'};
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Error: $e'};
    }
  }

  verifyPassword(currentUser, String text) {}
}
