import 'package:http/http.dart' as http;
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
