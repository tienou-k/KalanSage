import 'package:http/http.dart' as http;
import 'package:k_application/models/module_model.dart';
import 'package:k_application/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ModuleService {
  SharedPreferences? _prefs;

  ModuleService() {
    _initPrefs();
  }

  // Initialize SharedPreferences
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }


  // Fetch the list of all modules
  Future<List<Map<String, dynamic>>> listerModules() async {
    final response = await http.get(
      Uri.parse('$apiUrl/modules/list-modules'),
      headers: {
        'Authorization': 'Bearer ${_prefs?.getString('currentUser.token')}'
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to list modules: ${response.body}');
    }
  }
Future<List<ModuleModel>> fetchModulesByCategory(String categoryId) async {
    await _initPrefs(); // Make sure preferences are initialized
    String? token = _prefs?.getString('currentUser.token');

    // Check if the token is null
    if (token == null) {
      throw Exception('User is not authenticated. Token is null.');
    }

    // Set up headers for the request
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // Update the URL with your local IP
    final response = await http.get(
      Uri.parse('$apiUrl/categories/$categoryId/modules'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => ModuleModel.fromJson(json)).toList();
    } else {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load modules in categorie');
    }
  }

  
  // Fetch the top 5 modules
  Future<List<Map<String, dynamic>>> getTop5Modules() async {
    final response = await http.get(
      Uri.parse('$apiUrl/modules/top5'),
      headers: {
        'Authorization': 'Bearer ${_prefs?.getString('currentUser.token')}'
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch top 5 modules: ${response.body}');
    }
  }

  // Fetch a single module by ID
  Future<Map<String, dynamic>> getModuleById(int id) async {
    final response = await http.get(
      Uri.parse('$apiUrl/modules/module-par/$id'),
      headers: {
        'Authorization': 'Bearer ${_prefs?.getString('currentUser.token')}'
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch module by ID: ${response.body}');
    }
  }

  // Fetch top courses
  Future<List<Map<String, dynamic>>> getTopCourses() async {
    final response = await http.get(
      Uri.parse('$apiUrl/modules/top'),
      headers: {
        'Authorization': 'Bearer ${_prefs?.getString('currentUser.token')}'
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch top courses: ${response.body}');
    }
  }

  // Fetch categories
  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await http.get(
      Uri.parse(
          '$apiUrl/admins/categories/list-categories'),
      headers: {
        'Authorization': 'Bearer ${_prefs?.getString('currentUser.token')}'
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch categories: ${response.body}');
    }
  }
}
