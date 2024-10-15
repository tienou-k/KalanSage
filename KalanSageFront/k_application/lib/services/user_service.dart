import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
<<<<<<< HEAD
import '../utils/constants.dart'; 
=======
import '../utils/constants.dart';
>>>>>>> 6044997 (repusher)

class UserService {
  SharedPreferences? _prefs;

  UserService() {
    _initPrefs();
  }

  // Initialize SharedPreferences
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }
<<<<<<< HEAD
=======

>>>>>>> 6044997 (repusher,)
// Create a new user
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiUrl/users/creer-user'),
    );

<<<<<<< HEAD
    // Add fields to the request
    request.fields['nom'] = userData['nom'];
    request.fields['prenom'] = userData['prenom'];
    request.fields['email'] = userData['email'];
    request.fields['username'] = userData['username'];
    request.fields['password'] = userData['password'];
    request.fields['role'] = 'USER';
    request.fields['status'] =
        userData['status'].toString(); 

    // Optionally add a file if provided
=======
    // Assigning fields including telephone
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

    // Check for telephone field
    if (userData['telephone'] != null) {
      request.fields['telephone'] =
          userData['telephone']; // Adding telephone field
    } else {
      throw Exception('Telephone is required.');
    }

    // Add file if available
>>>>>>> 6044997 (repusher)
    if (userData['file'] != null) {
      request.files.add(
        await http.MultipartFile.fromPath('file', userData['file'].path),
      );
    }

<<<<<<< HEAD
    // Add authorization header if available
=======
    // Add authorization token if available
>>>>>>> 6044997 (repusher)
    final token = _prefs?.getString('currentUser.token');
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

<<<<<<< HEAD
    // Send the request
    final response = await request.send();

    // Process the response
=======
    // Send request and handle response
    final response = await request.send();
>>>>>>> 6044997 (repusher)
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = await response.stream.bytesToString();
      return jsonDecode(responseData);
    } else {
      throw Exception(
          'Échec de la création du compte: ${await response.stream.bytesToString()}');
    }
  }

  //Login service
  Future<UserModel?> login(String email, String MotDePasse) async {
    final response = await http.post(
      Uri.parse('$apiUrl/auth/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'email': email, 'password': MotDePasse}),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

<<<<<<< HEAD
   /*// Sign-up service
  Future<UserModel?> createUser(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/user/creer-user'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to sign up');
    }
  }*/

=======
>>>>>>> 6044997 (repusher,)
  // Update user details
  Future<Map<String, dynamic>> updateUser(
      int userId, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('$apiUrl/users/modifier-user/$userId'),
      headers: {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer ${_prefs?.getString('currentUser.token')}'
      },
      body: userData,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update user: ${response.body}');
    }
  }
<<<<<<< HEAD
=======

>>>>>>> 6044997 (repusher,)
  // Fetch user by ID
  Future<Map<String, dynamic>> getUserById(int userId) async {
    final response = await http.get(
      Uri.parse('$apiUrl/users/par-id/$userId'),
      headers: {
        'Authorization': 'Bearer ${_prefs?.getString('currentUser.token')}'
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch user: ${response.body}');
    }
  }

<<<<<<< HEAD
   // Fetch all users
=======
  // Fetch all users
>>>>>>> 6044997 (repusher,)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await http.get(
      Uri.parse('$apiUrl/users/list-users'),
      headers: {
        'Authorization': 'Bearer ${_prefs?.getString('currentUser.token')}'
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
    final response = await http.post(
      Uri.parse('$apiUrl/points/gagner/points'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_prefs?.getString('currentUser.token')}'
      },
      body: jsonEncode({'userId': userId, 'points': points}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to award points: ${response.body}');
    }
  }

  // Fetch all abonnements
  Future<List<Map<String, dynamic>>> listerAbonnements() async {
    final response = await http.get(
      Uri.parse('$apiUrl/admins/abonnements/list-abonnements'),
      headers: {
        'Authorization': 'Bearer ${_prefs?.getString('currentUser.token')}'
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to list abonnements: ${response.body}');
    }
  }
<<<<<<< HEAD
=======

  Future<Map<String, dynamic>> verifyOTP(Map<String, String> otpData) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/verify-otp'),
        body: jsonEncode(otpData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 'error', 'message': 'OTP verification failed'};
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Error during OTP verification'};
    }
  }
>>>>>>> 6044997 (repusher)
}
