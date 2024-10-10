import '../services/user_service.dart';
import '../models/user_model.dart';

class UserController {
  final UserService _userService = UserService();

  // Login function
  Future<UserModel?> login(String email, String password) async {
    try {
      return await _userService.login(email, password);
    } catch (e) {
      throw Exception('Login failed');
    }
  }

  // Sign-up function
  Future<UserModel?> createUser(
      String name, String email, String password) async {
    try {
      return await _userService.createUser(name, email, password);
    } catch (e) {
      throw Exception('Sign-up failed');
    }
  }
}
