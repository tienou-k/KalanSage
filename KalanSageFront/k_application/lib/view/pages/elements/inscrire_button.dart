import 'package:flutter/material.dart';
import 'package:k_application/models/module_model.dart';
import 'package:k_application/services/user_service.dart';
import 'package:k_application/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InscrireButton extends StatefulWidget {
  final ModuleModel module;

  const InscrireButton({super.key, required this.module});

  @override
  _InscrireButtonState createState() => _InscrireButtonState();
}

class _InscrireButtonState extends State<InscrireButton> {
  bool _isEnrolling = false;
  bool _isAlreadyEnrolled = false;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _checkEnrollmentStatus();
  }

  // Check if the user is already enrolled
  void _checkEnrollmentStatus() async {
    final userId = await _getCurrentUserId();
    if (userId != null) {
      try {
        bool isEnrolled = await UserService()
            .isUserEnrolledInModule(userId, widget.module.id);
        setState(() {
          _isAlreadyEnrolled = isEnrolled;
        });
      } catch (e) {
        // Handle error if needed
      }
    }
  }

  // Enroll user in the module
  void _enrollUser() async {
    setState(() {
      _isEnrolling = true;
    });

    try {
      final moduleId = widget.module.id;
      final result = await UserService().enrollInModule(moduleId);

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Inscription réussie !'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1)),
        );
        _checkEnrollmentStatus();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Échec de l\'inscription.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 1)),
        );
      }
    } catch (e) {
      String errorMessage = 'Erreur lors de l\'inscription.';
      if (e.toString().contains('User is already enrolled in this module')) {
        errorMessage = 'Vous êtes déjà inscrit à ce module.';
      } else {
        errorMessage = 'Erreur: ${e.toString()}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(errorMessage),
            backgroundColor: secondaryColor,
            duration: Duration(seconds: 1)),
      );
    } finally {
      setState(() {
        _isEnrolling = false;
      });
    }
  }

  // Get the current user's ID from shared preferences
  Future<int?> _getCurrentUserId() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs?.getInt('userId');
  }

  // Build the enrollment button
  Widget _buildEnrollButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: _isEnrolling || _isAlreadyEnrolled ? null : _enrollUser,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: _isEnrolling
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                _isAlreadyEnrolled ? 'Déjà inscrit' : 'S\'inscrire',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildEnrollButton();
  }
}
