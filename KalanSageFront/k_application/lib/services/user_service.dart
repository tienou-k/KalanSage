import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../utils/constants.dart';

class UserService {
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

  // Get current user token
  Future<String?> _getCurrentUserToken() async {
    await _ensurePrefsInitialized();
    final currentUser = _prefs?.getString('currentUser');
    if (currentUser != null) {
      final userMap = jsonDecode(currentUser);
      return userMap['token'];
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

    final token = await _getCurrentUserToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = await response.stream.bytesToString();
      return jsonDecode(responseData);
    } else {
      throw Exception(
          'Failed to create user: ${await response.stream.bytesToString()}');
    }
  }

  // Login service
  Future<UserModel?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/auth/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  // Update user details
  Future<Map<String, dynamic>> updateUser(
      int userId, Map<String, dynamic> userData) async {
    final token = await _getCurrentUserToken();
    final response = await http.put(
      Uri.parse('$apiUrl/users/modifier-user/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update user: ${response.body}');
    }
  }

  // Fetch user by ID
  Future<Map<String, dynamic>> getUserById(int userId) async {
    final token = await _getCurrentUserToken();
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
    final token = await _getCurrentUserToken();
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
    final token = await _getCurrentUserToken();
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
    final token = await _getCurrentUserToken();
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
    final token = await _getCurrentUserToken();
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
    final token = await _getCurrentUserToken();
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

// Extract current user ID from the token
  Future<int?> _getCurrentUserId() async {
    await _ensurePrefsInitialized();
    final currentUser = _prefs?.getString('currentUser');
    if (currentUser != null) {
      final userMap = jsonDecode(currentUser);
      return userMap['id']; // Assuming the token contains a user ID.
    }
    return null;
  }

// Enroll in a module using current user's ID
Future<Map<String, dynamic>> enrollInModule(int moduleId) async {
    final userId = await _getCurrentUserId();
    if (userId == null) {
      throw Exception('User is not authenticated.');
    }

    final token = await _getCurrentUserToken();
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


  // Subscribe to an abonnement
  Future<void> subscribeToAbonnement(int userId, int abonnementId) async {
    final token = await _getCurrentUserToken();
    final response = await http.post(
      Uri.parse('$apiUrl/user/abonnement/$userId/$abonnementId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to subscribe to abonnement: ${response.body}');
    }
  }

  // Submit course evaluation
  Future<Map<String, dynamic>> submitEvaluation(
      int userId, int courseId, String commentaire, int etoiles) async {
    final token = await _getCurrentUserToken();
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
    final token = await _getCurrentUserToken();
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

  verifyOTP(Map<String, String> map) {}

   // Assuming you have a method to get current user ID or user-related info
  Future<bool> isUserEnrolledInModule(int userId, int moduleId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$apiUrl/check?userId=$userId&moduleId=$moduleId'),
      );

      if (response.statusCode == 200) {
        // Parse the response
        var data = jsonDecode(response.body);
        return data[
            'isEnrolled']; 
      } else {
        throw Exception('Failed to load enrollment status');
      }
    } catch (e) {
      print('Error checking enrollment: $e');
      return false;
    }
  }
}
