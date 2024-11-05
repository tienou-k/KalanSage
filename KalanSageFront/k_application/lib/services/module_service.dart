import 'package:http/http.dart' as http;
import 'package:k_application/models/lecon_model.dart';
import 'package:k_application/models/module_model.dart';
import 'package:k_application/models/userBookmark.dart';
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

  // Ensure prefs is initialized before calling any methods
  Future<void> _ensurePrefsInitialized() async {
    if (_prefs == null) {
      await _initPrefs();
    }
  }

// Fetch the user details from SharedPreferences
  Future<Map<String, dynamic>?> _getUser() async {
    await _initPrefs();
    String? currentUserJson = _prefs?.getString('currentUser');
    return jsonDecode(currentUserJson!); 
      return null;
  }

  // Fetch the token from SharedPreferences
  Future<String?> _getToken() async {
    await _initPrefs();
    String? currentUserJson = _prefs?.getString('currentUser');
    final currentUser = jsonDecode(currentUserJson!);
    return currentUser['token']; // Extract the token
      return null;
  }

// Extract current user ID from the token
  Future<int?> _getCurrentUserId() async {
    await _ensurePrefsInitialized();
    final currentUser = _prefs?.getString('currentUser');
    if (currentUser != null) {
      final userMap = jsonDecode(currentUser);
      return userMap['id'];
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

  // Fetch the top  modules
  Future<List<ModuleModel>> fetchPopularModules() async {
    String? token = await _getToken();

    if (token == null) {
      throw Exception('User is not authenticated. Token is null.');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/modules/popular'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ModuleModel.fromJson(data)).toList();
    } else {
      throw Exception('Echec recuperation: ${response.body}');
    }
  }

// Fetch a single module by ID and return as ModuleModel
  Future<ModuleModel> getModuleById(int id) async {
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
      return ModuleModel.fromJson(jsonDecode(response.body));
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

  // get lecons conatin in module
  Future<List<LeconModel>> getLeconsByModule(int moduleId) async {
    String? token = await _getToken();
    if (token == null) {
      throw Exception('User is not authenticated. Token is null.');
    }
    final url = '$apiUrl/modules/$moduleId/lecons';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => LeconModel.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load lessons');
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
      return int.parse(response.body);
    } else {
      throw Exception('Failed to fetch user count: ${response.body}');
    }
  }

  // Add a bookmark
  Future<UserBookmark> addToBookmarks(int moduleId) async {
    final userId = await _getCurrentUserId();
    if (userId == null) {
      throw Exception('User ID is null. Cannot add bookmark.');
    }

    final token = await _getToken();
    final url = Uri.parse('$apiUrl/bookmarks/add/$userId/$moduleId');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userId': userId
      }),
    );

    if (response.statusCode == 200) {
      return UserBookmark.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to add bookmark: ${response.statusCode} - ${response.body}');
    }
  }

// Remove a bookmark
  Future<void> removeFromBookmarks(int moduleId) async {
    final userId = await _getCurrentUserId(); 
    if (userId == null) {
      throw Exception('User ID is null. Cannot remove bookmark.');
    }

    final token = await _getToken();
    final url = Uri.parse(
        '$apiUrl/bookmarks/remove/$userId/$moduleId');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove bookmark: ${response.body}');
    }
  }

// Check if a module is bookmarked
  Future<bool> isBookmarked(int moduleId) async {
    final userId = await _getCurrentUserId(); 
    if (userId == null) {
      throw Exception('User ID is null. Cannot check bookmark status.');
    }

    final token = await _getToken();
    final url = Uri.parse(
        '$apiUrl/bookmarks/isBookmarked/$userId/$moduleId'); 
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['isBookmarked'] ??
          false;
    } else {
      throw Exception('Failed to check bookmark status: ${response.body}');
    }
  }

// Retrieve the current user's bookmarked modules
  Future<List<UserBookmark>> getBookmarkedModules() async {
    final userId = await _getCurrentUserId(); 
    if (userId == null) {
      throw Exception('User ID is null. Cannot fetch bookmarked modules.');
    }

    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse(
          '$apiUrl/bookmarks/bookmarked-modules/$userId'), 
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((bookmark) => UserBookmark.fromJson(bookmark))
          .toList();
    } else {
      throw Exception('Failed to load bookmarked modules: ${response.body}');
    }
  }

// getmodule module details from the backend
  Future<ModuleModel> getModuleDetails(String moduleId) async {
    String? token = await _getToken();
    if (token == null) {
      throw Exception('User is not authenticated. Token is null.');
    }
    final response = await http.get(
      Uri.parse('$apiUrl/modules/module-par/$moduleId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return ModuleModel.fromJson(json);
    } else {
      throw Exception('Failed to fetch module details: ${response.body}');
    }
  }
}