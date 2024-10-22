import 'package:flutter/material.dart';
import 'package:k_application/services/auth_service.dart';
import 'package:k_application/services/user_service.dart';
import 'package:k_application/utils/constants.dart';
import 'package:k_application/view/pages/profile_home.dart';

class ProfileModifier extends StatefulWidget {
  const ProfileModifier({super.key});

  @override
  _ProfileModifierState createState() => _ProfileModifierState();
}

class _ProfileModifierState extends State<ProfileModifier> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _isLoading = true;
  late Map<String, dynamic> _currentUser;

  // State variables for password visibility
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final userProfile = await _authService.fetchUserProfile();

      // Convert the map to Map<String, dynamic>
      final convertedProfile = userProfile.map<String, dynamic>((key, value) {
        return MapEntry(key.toString(), value);
      });

      setState(() {
        _currentUser = convertedProfile;
        _nomController.text = convertedProfile['nom'] ?? '';
        _prenomController.text = convertedProfile['prenom'] ?? '';
        _emailController.text = convertedProfile['email'] ?? '';
        _phoneController.text = convertedProfile['telephone'] ?? '';
        _isLoading = false;
      });
    // ignore: empty_catches
    } catch (e) {
    }
  }

  Future<void> _updateUserProfile() async {
  if (_formKey.currentState?.validate() ?? false) {
    try {
      final updatedUser = {
        'nom': _nomController.text,
        'prenom': _prenomController.text,
        'email': _emailController.text,
        'telephone': _phoneController.text,
        'newPassword': _newPasswordController.text,
      };
      await _userService.updateUser(_currentUser['id'], updatedUser);

      // Show success alert dialog with customized style
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.green[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 30),
                SizedBox(width: 10),
                Text(
                  'Success',
                  style: TextStyle(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(
              'Vos informations ont été mis à jour avec succès!',
              style: TextStyle(
                color: Colors.green[800],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: <Widget>[
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardScreen( ),
                        ),
                      );
                  },
                ),
              ),
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Mes informations',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First Name
                    buildLabel('Nom '),
                    buildTextField(
                      controller: _nomController,
                      context: context,
                      hintText: 'TEST',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 16),

                    // Last Name
                    buildLabel('Prenom'),
                    buildTextField(
                      controller: _prenomController,
                      context: context,
                      hintText: 'Test ',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    buildLabel('Email'),
                    buildTextField(
                      controller: _emailController,
                      context: context,
                      hintText: 'test@gmail.com',
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 16),

                    // Phone Number
                    buildLabel('Numero'),
                    buildTextField(
                      controller: _phoneController,
                      context: context,
                      hintText: '+223 00-00-00-00',
                      icon: Icons.phone,
                    ),
                    const SizedBox(height: 16),

                    // Current Password
                    buildLabel('Mot de passe actuelle'),
                    buildPasswordField(
                      _currentPasswordController,
                      context,
                      isVisible: _isCurrentPasswordVisible,
                      toggleVisibility: () {
                        setState(() {
                          _isCurrentPasswordVisible =
                              !_isCurrentPasswordVisible;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // New Password
                    buildLabel('Nouveau Mot de passe'),
                    buildPasswordField(
                      _newPasswordController,
                      context,
                      isVisible: _isNewPasswordVisible,
                      toggleVisibility: () {
                        setState(() {
                          _isNewPasswordVisible = !_isNewPasswordVisible;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: _updateUserProfile,
                          child: Text(
                            'Enregistrement',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildLabel(String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        labelText,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required BuildContext context,
    required String hintText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        fillColor: Colors.grey[200],
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildPasswordField(
      TextEditingController controller, BuildContext context,
      {required bool isVisible, required VoidCallback toggleVisibility}) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: toggleVisibility,
        ),
        hintText: '************',
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        fillColor: Colors.grey[200],
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
