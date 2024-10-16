import 'package:http/http.dart' as http;
import 'package:k_application/models/leconModel.dart';
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
    print('Initializing SharedPreferences...');
    _prefs = await SharedPreferences.getInstance();
    print('SharedPreferences initialized: $_prefs');
  }

  // Fetch the current user's access token and refresh token from SharedPreferences
  String? get _accessToken => _prefs?.getString('accessToken');
  String? get _refreshToken => _prefs?.getString('refreshToken');

  // Fetch a lesson by ID
  Future<Map<String, dynamic>> getLeconById(int leconId) async {
    print('Fetching lesson with ID: $leconId');
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

    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Lesson fetched successfully');
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      print('Token expired, refreshing token...');
      await _refreshAccessToken();
      return getLeconById(leconId); // Retry the request
    } else {
      print('Failed to fetch lesson: ${response.body}');
      throw Exception('Failed to fetch lesson: ${response.body}');
    }
  }

  // Fetch all lessons
  Future<List<Map<String, dynamic>>> listerLecons() async {
    print('Fetching all lessons...');
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

    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Lessons fetched successfully');
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      print('Token expired, refreshing token...');
      await _refreshAccessToken();
      return listerLecons(); // Retry the request
    } else {
      print('Failed to list lessons: ${response.body}');
      throw Exception('Failed to list lessons: ${response.body}');
    }
  }

  // Fetch lessons by module ID
  Future<List<LeconModel>> getLeconsByModule(int moduleId) async {
    print('Fetching lessons for module ID: $moduleId');
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

    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Lessons for module $moduleId fetched successfully');
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => LeconModel.fromJson(item)).toList();
    } else if (response.statusCode == 401) {
      print('Token expired, refreshing token...');
      await _refreshAccessToken();
      return getLeconsByModule(moduleId); // Retry the request
    } else {
      print('Failed to fetch lessons by module: ${response.body}');
      throw Exception('Failed to fetch lessons by module: ${response.body}');
    }
  }

  // Count all lessons
  Future<int> countLecons() async {
    print('Counting all lessons...');
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

    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Lesson count fetched successfully');
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      print('Token expired, refreshing token...');
      await _refreshAccessToken();
      return countLecons(); // Retry the request
    } else {
      print('Failed to count lessons: ${response.body}');
      throw Exception('Failed to count lessons: ${response.body}');
    }
  }

  // Ensure that we have a valid access token before making requests
  Future<void> _ensureAccessToken() async {
    print('Ensuring access token is valid...');
    if (_accessToken == null || _isTokenExpired(_accessToken!)) {
      print('Access token expired or not available, refreshing...');
      await _refreshAccessToken();
    } else {
      print('Access token is valid');
    }
  }

  // Check if the token is expired (this function may vary depending on how token expiration is handled)
  bool _isTokenExpired(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return true;

    final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
    final exp = payload['exp'];
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    print('Token expiration time: $exp, current time: $now');
    return now >= exp;
  }

  // Refresh the access token using the refresh token
  Future<void> _refreshAccessToken() async {
    print('Refreshing access token...');
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

    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('New access token: ${data['accessToken']}');
      _prefs?.setString('accessToken', data['accessToken']);
    } else {
      print('Failed to refresh token: ${response.body}');
      throw Exception('Failed to refresh token: ${response.body}');
    }
  }
}
