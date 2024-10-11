import 'package:http/http.dart' as http;
import 'package:k_application/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LeconService {
  SharedPreferences? _prefs;

  LeconService() {
    _initPrefs();
  }

  // Initialize SharedPreferences
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }


  // Fetch a lesson by ID
  Future<Map<String, dynamic>> getLeconById(int leconId) async {
    final response = await http.get(
      Uri.parse('$apiUrl/lecons/lecon-par/$leconId'),
      headers: {
        'Authorization': 'Bearer ${_prefs?.getString('currentUser.token')}'
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch lesson: ${response.body}');
    }
  }

  // Fetch all lessons
  Future<List<Map<String, dynamic>>> listerLecons() async {
    final response = await http.get(
      Uri.parse('$apiUrl/lecons/list-lecons'),
      headers: {
        'Authorization': 'Bearer ${_prefs?.getString('currentUser.token')}'
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to list lessons: ${response.body}');
    }
  }

  // Fetch lessons by module ID
  Future<List<Map<String, dynamic>>> getLeconsByModule(int moduleId) async {
    final response = await http.get(
      Uri.parse(
          'http://10.175.48.31:8080/api/modules/module/$moduleId/lecons'),
      headers: {
        'Authorization': 'Bearer ${_prefs?.getString('currentUser.token')}'
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch lessons by module: ${response.body}');
    }
  }

  // Count all lessons
  Future<int> countLecons() async {
    final response = await http.get(
      Uri.parse('$apiUrl/lecons/count'),
      headers: {
        'Authorization': 'Bearer ${_prefs?.getString('currentUser.token')}'
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to count lessons: ${response.body}');
    }
  }
}
