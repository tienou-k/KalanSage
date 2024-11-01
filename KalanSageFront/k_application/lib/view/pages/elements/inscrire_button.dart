import 'package:flutter/material.dart';
import 'package:k_application/models/module_model.dart';
import 'package:k_application/services/user_service.dart';
import 'package:k_application/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InscrireButton extends StatefulWidget {
  final ModuleModel module;
  final bool isAlreadyEnrolled;
  final ValueChanged<bool> onEnrollmentStatusChanged;
  final VoidCallback onStartFirstLesson;

  const InscrireButton({
    super.key,
    required this.module,
    required this.isAlreadyEnrolled,
    required this.onEnrollmentStatusChanged,
    required this.onStartFirstLesson,
  });

  @override
  _InscrireButtonState createState() => _InscrireButtonState();
}

class _InscrireButtonState extends State<InscrireButton> {
  bool _isEnrolling = false;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _isEnrolling = false;
  }

  // Enroll the user in the selected module
  void _enrollUser() async {
    setState(() {
      _isEnrolling = true;
    });

    try {
      final moduleId = widget.module.id;
      final result = await UserService().enrollInModule(moduleId);

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Inscription réussie !'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        widget.onEnrollmentStatusChanged(true);
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Échec de l\'inscription.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      String errorMessage = 'Erreur lors de l\'inscription.';
      if (e.toString().contains('User is already enrolled in this module')) {
        errorMessage = 'Vous êtes déjà inscrit à ce module.';
      } else if (e.toString().contains('Network error')) {
        errorMessage = 'Erreur de connexion. Veuillez réessayer.';
      } else {
        errorMessage = 'Erreur: ${e.toString()}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: secondaryColor,
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isEnrolling = false;
      });
    }
  }

  // Retrieve the current user's ID from SharedPreferences
  Future<int?> getCurrentUserId() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs?.getInt('userId');
  }

  // Build the enrollment button
  Widget _buildEnrollButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: _isEnrolling
            ? null
            : () {
                if (widget.isAlreadyEnrolled) {
                  // Trigger the callback to display the first lesson
                  widget.onStartFirstLesson();
                } else {
                  _enrollUser();
                }
              },
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
                widget.isAlreadyEnrolled ? 'Commencer' : 'S\'inscrire',
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
