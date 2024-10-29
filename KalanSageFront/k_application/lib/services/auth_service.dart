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
    debugPrint('SharedPreferences initialized');
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

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/auth/login'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        if (responseData['accessToken'] != null && responseData['id'] != null) {
          final user = {
            'token': responseData['accessToken'],
            'role': responseData['role'],
            'status': responseData['status'],
            'id': responseData['id'],
          };

          await _prefs?.setString('currentUser', jsonEncode(user));
          if (user['status'] == false) {
            Navigator.pushNamed(context, '/otp_verification', arguments: email);
          } else {
            return user;
          }
        } else {
          throw Exception('Access token or user ID is missing.');
        }
      } else {
        final errorData = json.decode(utf8.decode(response.bodyBytes));
        String errorMessage = errorData['message'] ??
            'Une erreur s\'est produite. Veuillez réessayer.';
        throw Exception(errorMessage);
      }
    } catch (error) {
      if (error is Exception) {
        rethrow;
      }
    }

    return null;
  }

  // Fetch User Profile
  Future<Map> fetchUserProfile() async {
    await _ensurePrefsInitialized();

    final currentUser = await getCurrentUser();
    if (currentUser == null || currentUser['token'] == null) {
      throw Exception('No user logged in. Please log in again.');
    }

    final token = currentUser['token'];
    final headers = {'Authorization': 'Bearer $token'};

    try {
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
        throw Exception(
            'Failed to fetch user profile: ${errorData['message']}');
      }
    } catch (e) {
      throw Exception('An error occurred while fetching the profile: $e');
    }
  }

  // Get current user data
  Future<Map<String, dynamic>?> getCurrentUser() async {
    await _ensurePrefsInitialized();
    final currentUser = _prefs?.getString('currentUser');
    if (currentUser != null) {
      final userMap = jsonDecode(currentUser);
      return userMap;
    }
    return null;
  }

  // Logout method
  Future<void> logout() async {
    await _ensurePrefsInitialized();
    await _prefs?.remove('currentUser');
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    await _ensurePrefsInitialized(); 
    final currentUser = await getCurrentUser(); 
    return currentUser !=
        null; 
  }


  // Get current user ID
  Future<int?> getCurrentUserId() async {
    final currentUser = await getCurrentUser();
    return currentUser?['id'];
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

}
