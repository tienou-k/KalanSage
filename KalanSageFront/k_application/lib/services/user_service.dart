import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:k_application/models/abonnement_model.dart';
import 'package:k_application/models/module_model.dart';
import 'package:k_application/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_abonnement.dart';
import '../utils/constants.dart';

class UserService {
  final AuthService _authService = AuthService();
  SharedPreferences? _prefs;

  UserService() {
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

  // Fetch the user details from SharedPreferences
  Future<Map<String, dynamic>?> getUser() async {
    await _ensurePrefsInitialized();
    String? currentUserJson = _prefs?.getString('currentUser');
    return jsonDecode(currentUserJson!);
    return null;
  }

  // Extract current user ID from SharedPreferences
  Future<int?> getCurrentUserId() async {
    await _ensurePrefsInitialized();
    final currentUser = _prefs?.getString('currentUser');
    if (currentUser != null) {
      final userMap = jsonDecode(currentUser);
      return userMap['id'];
    }
    return null;
  }

  // Fetch the token from SharedPreferences
  Future<String?> getToken() async {
    await _ensurePrefsInitialized();
    final currentUserJson = _prefs?.getString('currentUser');
    if (currentUserJson != null) {
      final currentUser = jsonDecode(currentUserJson);
      return currentUser['token'];
    }
    return null;
  }

  // Create a new user
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiUrl/users/creer-user'),
    );
    if (userData['nom'] != null) request.fields['nom'] = userData['nom'];
    if (userData['prenom'] != null) {
      request.fields['prenom'] = userData['prenom'];
    }
    if (userData['email'] != null) request.fields['email'] = userData['email'];
    if (userData['username'] != null) {
      request.fields['username'] = userData['username'];
    }
    if (userData['password'] != null) {
      request.fields['password'] = userData['password'];
    }
    if (userData['status'] != null) {
      request.fields['status'] = userData['status'].toString();
    }
    if (userData['telephone'] != null) {
      request.fields['telephone'] = userData['telephone'];
    } else {
      throw Exception('Telephone is required.');
    }
    if (userData['file'] != null) {
      request.files.add(
        await http.MultipartFile.fromPath('file', userData['file'].path),
      );
    }

    final token = await getToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = await response.stream.bytesToString();
      return jsonDecode(responseData);
    } else {
      throw Exception(
          'Erreur la creation à échouée: ${await response.stream.bytesToString()}');
    }
  }

  // Update user details
  Future<Map<String, dynamic>> updateUser(
      int userId, Map<String, dynamic> userData) async {
    final token = await getToken();
    final request = http.MultipartRequest(
      'PUT',
      Uri.parse('$apiUrl/users/modifier-user/$userId'),
    );
    if (userData['nom'] != null) request.fields['nom'] = userData['nom'];
    if (userData['prenom'] != null) {
      request.fields['prenom'] = userData['prenom'];
    }
    if (userData['email'] != null) request.fields['email'] = userData['email'];
    if (userData['username'] != null) {
      request.fields['username'] = userData['username'];
    }
    if (userData['password'] != null) {
      request.fields['password'] = userData['password'];
    }
    if (userData['status'] != null) {
      request.fields['status'] = userData['status'].toString();
    }
    if (userData['telephone'] != null) {
      request.fields['telephone'] = userData['telephone'];
    }
    if (userData['file'] != null) {
      request.files.add(
        await http.MultipartFile.fromPath('file', userData['file'].path),
      );
    }
    request.headers['Authorization'] = 'Bearer $token';
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      return jsonDecode(responseData);
    } else {
      throw Exception(
          'Failed to update user: ${await response.stream.bytesToString()}');
    }
  }

  // Fetch user by ID
  Future<Map<String, dynamic>> getUserById(int userId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$apiUrl/users/par-id/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch user: ${response.body}');
    }
  }

  // Fetch all users
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$apiUrl/users/list-users'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch users: ${response.body}');
    }
  }

  // Award points to a user
  Future<void> awardPoints(int userId, int points) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$apiUrl/points/gagner/points'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'userId': userId, 'points': points}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to award points: ${response.body}');
    }
  }

  // Complete a lesson
  Future<Map<String, dynamic>> completeLesson(
      int userId, int lessonId, int pointsEarned) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$apiUrl/user/complete-lesson/$userId/$lessonId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'pointsEarned': pointsEarned}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to complete lesson: ${response.body}');
    }
  }

  // Complete a module
  Future<Map<String, dynamic>> completeModule(
      int userId, int moduleId, int pointsEarned) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$apiUrl/user/complete-module/$userId/$moduleId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'pointsEarned': pointsEarned}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to complete module: ${response.body}');
    }
  }

  // Earn a badge
  Future<Map<String, dynamic>> earnBadge(int userId, int badgeId) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$apiUrl/user/earn-badge/$userId/$badgeId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to earn badge: ${response.body}');
    }
  }

// Enroll in a module using current user's ID
  Future<Map<String, dynamic>> enrollInModule(int moduleId) async {
    final userId = await getCurrentUserId();
    if (userId == null) {
      throw Exception('User is not authenticated.');
    }

    final token = await getToken();
    final response = await http.post(
      Uri.parse('$apiUrl/user/inscrisModule/$userId/$moduleId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      throw Exception('User is already enrolled in this module.');
    } else {
      throw Exception('Failed to enroll in module: ${response.body}');
    }
  }

  //Abonnement list
  Future<List<Abonnement>> fetchAbonnements() async {
    final userId = await getCurrentUserId();
    if (userId == null) {
      throw Exception('User is not authenticated.');
    }
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$apiUrl/user/list-abonnements'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> abonnementsJson = json.decode(response.body);
      return abonnementsJson.map((json) => Abonnement.fromJson(json)).toList();
    } else {
      // Handle unauthorized response
      throw Exception(
          'Failed to load abonnements: ${response.statusCode} ${response.body}');
    }
  }

  Future<List<UserAbonnement>> getUserAbonnementsByUserId(int userId) async {
    await _initPrefs();
    String? currentUserJson = _prefs?.getString('currentUser');
    final currentUser = jsonDecode(currentUserJson!);
    String? token = currentUser['token'];

    if (token == null) {
      throw Exception('No token found. User not authenticated.');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('$apiUrl/user/abonnements/$userId');
    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => UserAbonnement.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        print("No abonnement found for user ID: $userId");
        return [];
      } else {
        throw Exception("Failed to load abonnements: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Failed to load abonnements: $e");
    }
  }

  // Subscribe to an abonnement
  // Subscribe to an abonnement
  Future<String?> subscribeToAbonnement(int userId, int abonnementId) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$apiUrl/user/abonnement/$userId/$abonnementId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      return response.body;
    }
    return null;
  }

  // Submit course evaluation
  Future<Map<String, dynamic>> submitEvaluation(
      int userId, int courseId, String commentaire, int etoiles) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$apiUrl/user/submit-evaluation/$userId/$courseId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'commentaire': commentaire, 'etoiles': etoiles}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to submit evaluation: ${response.body}');
    }
  }

  // Fetch all enrollments of a user
  Future<List<Map<String, dynamic>>> getAllEnrollments(int userId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$apiUrl/user/enrollments/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch enrollments: ${response.body}');
    }
  }

  // Assuming you have a method to get current user ID or user-related info
  Future<bool> isUserEnrolledInModule(int moduleId) async {
    final userId = await getCurrentUserId();
    if (userId == null) {
      throw Exception('User is not authenticated.');
    }
    String? token = await getToken();
    if (token == null) {
      throw Exception('User is not authenticated. Token is null.');
    }
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/user/is-enrolled/$userId/$moduleId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return response.body == 'true';
      } else if (response.statusCode == 404) {
        throw Exception('User not found for ID $userId');
      } else {
        throw Exception('Failed to load enrollment status: ${response.body}');
      }
    } catch (e) {
      print('Error s\'est produite: $e');
      return false;
    }
  }

// fetch user modules
  Future<List<ModuleModel>> getModulesForUser(int moduleId) async {
    final userId = await getCurrentUserId();
    if (userId == null) {
      throw Exception('Erreur de recuperation de User actuel');
    }
    String? token = await getToken();
    if (token == null) {
      throw Exception('Erreur de recuperation du token');
    }
    try {
      // Assuming this is a network call
      final response = await http.get(Uri.parse('$apiUrl/modules/$userId'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // Parse and return the data
        return (data as List)
            .map((module) => ModuleModel.fromJson(module))
            .toList();
      } else {
        throw Exception('Failed to load modules');
      }
    } catch (e) {
      throw Exception('Error fetching modules: $e');
    }
  }

// Request  password reset link
  Future<void> requestPasswordReset(String email, BuildContext contect) async {
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email': email,
    });
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/users/reset-password-request'),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // check
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
            errorData['message'] ?? 'Envoyer de mail échec. Please try again.');
      }
    } catch (e) {
      debugPrint('envoi de mail error: $e');
      throw Exception('An error occured during the request: $e');
    }
    return;
  }

  // Reset the password with email and new password
  Future<void> resetPassword(String email, String newPassword) async {
    try {
      final url = Uri.parse('$apiUrl/users/reset-password');

      // Prepare the request body
      final body = jsonEncode({
        'email': email,
        'newPassword': newPassword,
      });

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
      } else {
        throw Exception('Failed to reset password');
      }
    } catch (e) {
      throw Exception('Error resetting password: $e');
    }
  }
}
