import 'package:http/http.dart' as http;
import 'package:k_application/models/lecon_model.dart';
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

  // Fetch the current user's access token and refresh token from SharedPreferences
  String? get _accessToken => _prefs?.getString('accessToken');
  String? get _refreshToken => _prefs?.getString('refreshToken');

  // Fetch a lesson by ID
  Future<Map<String, dynamic>> getLeconById(int leconId) async {
    await _ensureAccessToken();

    if (_accessToken == null) {
      throw Exception('Access token is missing.');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/lecons/lecon-par/$leconId'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await _refreshAccessToken();
      return getLeconById(leconId); 
    } else {
      throw Exception('Failed to fetch lesson: ${response.body}');
    }
  }

  // Fetch all lessons
  Future<List<Map<String, dynamic>>> listerLecons() async {
    await _ensureAccessToken();

    if (_accessToken == null) {
      throw Exception('Access token is missing.');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/lecons/list-lecons'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      await _refreshAccessToken();
      return listerLecons();
    } else {
      throw Exception('Failed to list lessons: ${response.body}');
    }
  }

  // Fetch lessons by module ID
  Future<List<LeconModel>> getLeconsByModule(int moduleId) async {
    await _ensureAccessToken();

    if (_accessToken == null) {
      throw Exception('Access token is missing.');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/modules/module/$moduleId/lecons'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => LeconModel.fromJson(item)).toList();
    } else if (response.statusCode == 401) {
      await _refreshAccessToken();
      return getLeconsByModule(moduleId); 
    } else {
      throw Exception('Failed to fetch lessons by module: ${response.body}');
    }
  }

  // Count all lessons
  Future<int> countLecons() async {
    await _ensureAccessToken();

    if (_accessToken == null) {
      throw Exception('Access token is missing.');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/lecons/count'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await _refreshAccessToken();
      return countLecons(); 
    } else {
      throw Exception('Failed to count lessons: ${response.body}');
    }
  }

  // Ensure that we have a valid access token before making requests
  Future<void> _ensureAccessToken() async {
    if (_accessToken == null || _isTokenExpired(_accessToken!)) {
      await _refreshAccessToken();
    } else {
    }
  }

  // Check if the token is expired 
  bool _isTokenExpired(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return true;
    final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
    final exp = payload['exp'];
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now >= exp;
  }

  // Refresh the access token using the refresh token
  Future<void> _refreshAccessToken() async {
    if (_refreshToken == null) {
      throw Exception('No refresh token available');
    }

    final response = await http.post(
      Uri.parse('$apiUrl/auth/refresh-token'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'refreshToken': _refreshToken,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _prefs?.setString('accessToken', data['accessToken']);
    } else {
      throw Exception('Failed to refresh token: ${response.body}');
    }
  }
}
