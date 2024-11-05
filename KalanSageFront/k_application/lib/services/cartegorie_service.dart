import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:k_application/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/categorie_model.dart';

class CategorieService {
  SharedPreferences? _prefs;

  CategorieService() {
    _initPrefs();
  }

  // Initialize SharedPreferences
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Retrieve all categories
  Future<List<CategorieModel>> fetchCategories() async {
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

    final response = await http.get(
      Uri.parse('$apiUrl/categories/list-categories'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<CategorieModel> categories = [];
      for (var json in jsonData) {
        var category = CategorieModel.fromJson(json);
        category.moduleCount =
            await fetchModulesCountInCategorie(category.id.toString());
        categories.add(category);
      }
      return categories;
    } else {
      String errorMessage = 'Failed to load categories: ${response.body}';
      throw Exception(errorMessage);
    }
  }

  // Retrieve the count of modules in a specific category
  Future<int> fetchModulesCountInCategorie(String categoryId) async {
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
    final response = await http.get(
      Uri.parse('$apiUrl/categories/$categoryId/modules/count'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['moduleCount'];
    } else {
      String errorMessage = 'Failed to load module count: ${response.body}';
      throw Exception(errorMessage);
    }
  }
}
