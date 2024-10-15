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

  // Initialiser SharedPreferences
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Récupérer toutes les catégories
  Future<List<CategorieModel>> fetchCategories() async {
    await _initPrefs();
    String? token = _prefs?.getString('currentUser.token');
    if (token == null) {
      print(
          'Aucun jeton trouvé. Veuillez vous reconnecter.'); 
      throw Exception(
          'L\'utilisateur n\'est pas authentifié. Le jeton est nul.');
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
      // Créer une liste de catégories et récupérer le nombre de modules
      List<CategorieModel> categories = [];
      for (var json in jsonData) {
        var category = CategorieModel.fromJson(json);
        category.moduleCount =
            await fetchModulesCountInCategorie(category.id.toString());
        categories.add(category);
      }
      return categories;
    } else {
      String errorMessage =
          'Échec du chargement des catégories : ${response.body}';
      print(errorMessage); 
      throw Exception(errorMessage);
    }
  }

  // Récupérer le nombre de modules dans une catégorie spécifique
  Future<int> fetchModulesCountInCategorie(String categoryId) async {
    await _initPrefs();
    String? token = _prefs?.getString('currentUser.token');

    // Vérifier jeton
    if (token == null) {
      throw Exception(
          'L\'utilisateur n\'est pas authentifié. Le jeton est nul.');
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
      String errorMessage =
          'Échec du chargement du nombre de modules : ${response.body}';
      throw Exception(errorMessage);
    }
  }


  /*



  */
}
