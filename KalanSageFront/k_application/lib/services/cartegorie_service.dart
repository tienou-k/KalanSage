// services/categorie_service.dart

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

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Fetch all categories
  Future<List<CategorieModel>> fetchCategories() async {
    final response =
        await http.get(Uri.parse('$apiUrl/admins/categories/list-categories'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      // Map the response to CategorieModel
      return jsonData.map((json) => CategorieModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories: ${response.body}');
    }
  }
}
