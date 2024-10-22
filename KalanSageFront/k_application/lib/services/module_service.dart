import 'package:http/http.dart' as http;
import 'package:k_application/models/lecon_model.dart';
import 'package:k_application/models/module_model.dart';
import 'package:k_application/services/auth_service.dart';
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

  // Fetch the token from SharedPreferences
  Future<String?> _getToken() async {
    await _initPrefs();
    String? currentUserJson = _prefs?.getString('currentUser');
    if (currentUserJson != null) {
      final currentUser = jsonDecode(currentUserJson);
      return currentUser['token']; // Extract the token
    }
    return null;
  }

  // Fetch the list of all modules
  Future<List<Map<String, dynamic>>> listerModules() async {
    String? token = await _getToken();

    if (token == null) {
      throw Exception('User is not authenticated. Token is null.');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/modules/list-modules'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to list modules: ${response.body}');
    }
  }

// Fetch modules by category
  Future<List<ModuleModel>> fetchModulesByCategory(String categoryId) async {
    String? token = await _getToken();
    if (token == null) {
      throw Exception('User is not authenticated. Token is null.');
    }
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final url = '$apiUrl/categories/$categoryId/modules';
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => ModuleModel.fromJson(json)).toList();
      } else if (response.statusCode == 204) {
        return []; 
      } else {
        throw Exception('Failed to load modules in category: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred while fetching modules: $e');
    }
  }



  // Fetch the top 5 modules
  Future<List<Map<String, dynamic>>> getTop5Modules() async {
    String? token = await _getToken();

    if (token == null) {
      throw Exception('User is not authenticated. Token is null.');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/modules/top5'),
      headers: {
        'Authorization': 'Bearer $token',
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
    String? token = await _getToken();

    if (token == null) {
      throw Exception('User is not authenticated. Token is null.');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/modules/module-par/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch module by ID: ${response.body}');
    }
  }

  // Fetch top modules
  Future<List<Map<String, dynamic>>> getTopModules() async {
    String? token = await _getToken();

    if (token == null) {
      throw Exception('User is not authenticated. Token is null.');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/modules/top'),
      headers: {
        'Authorization': 'Bearer $token',
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
    String? token = await _getToken();

    if (token == null) {
      throw Exception('User is not authenticated. Token is null.');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/admins/categories/list-categories'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch categories: ${response.body}');
    }
  }

 Future<List<LeconModel>> getLeconsByModule(int moduleId) async {
    String? token = await _getToken();

    if (token == null) {
      throw Exception('User is not authenticated. Token is null.');
    }

    final url = '$apiUrl/modules/module/$moduleId/lecons';
    print('Fetching lessons from: $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => LeconModel.fromJson(json)).toList();
    } else {
      print('Failed to fetch lessons: ${response.body}');
      throw Exception('Failed to fetch lessons: ${response.body}');
    }
  }
  // User count by Modules
  Future<int> getUserCountByModule(int moduleId) async {
    String? token = await _getToken();

    if (token == null) {
      throw Exception('User is not authenticated. Token is null.');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/modules/$moduleId/user-count'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return int.parse(
          response.body); // Ensure the response body is parsed as an integer
    } else {
      throw Exception('Failed to fetch user count: ${response.body}');
    }
  }

//addToBookmarks
  Future<void> addToBookmarks(String moduleId, String userId) async {
    // Implementation to add module to bookmarks
    final token = await _getToken(); // Assuming this method exists
    if (token == null) {
      throw Exception('User is not authenticated. Token is null.');
    }

    final url = '$apiUrl/modules/${moduleId}/';
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({'userId': userId, 'isBookmarked': true});

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Failed to add to bookmarks: ${response.body}');
    }
  }

  Future<void> removeFromBookmarks(String moduleId) async {
    // Implementation to remove module from bookmarks
    final token = await _getToken(); // Assuming this method exists
    if (token == null) {
      throw Exception('User is not authenticated. Token is null.');
    }
    final url = '$apiUrl/modules/$moduleId/bookmark';
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({'userId': '', 'isBookmarked': false});

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Failed to remove from bookmarks: ${response.body}');
    }
  }

}
