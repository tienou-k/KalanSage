import '../services/user_service.dart';
import '../models/user_model.dart';

class UserController {
  final UserService _userService = UserService();

  // Login function
  Future<UserModel?> login(String email, String password) async {
    try {
      final userData = await _userService.login(email, password);
      return UserModel.fromJson(
          userData as Map<String, dynamic>); 
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Sign-up function
  Future<UserModel?> createUser(String nom, String prenom, String email,
      String username, String password) async {
    try {
      // Prepare the user data map
      final userData = {
        "nom": nom,
        "prenom": prenom,
        "email": email,
        "username": username,
        "password": password,
        "role": 'USER',
        "status": true 
      };

      // Call the service to create the user
      final responseData = await _userService.createUser(userData);
      return UserModel.fromJson(responseData); 
    } catch (e) {
      throw Exception('Sign-up failed: $e');
    }
  }
}
