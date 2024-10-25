import 'package:flutter/material.dart';
import 'package:k_application/services/user_service.dart';
import 'package:k_application/utils/constants.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();
  final _formKeyPassword = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;
  String? _email;
  String? _newPassword;
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Function to send reset email
  Future<void> _sendResetEmail() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() => _isLoading = true);

      try {
        if (_email != null) {
          await _userService.requestPasswordReset(_email!, context);
          setState(() => _emailSent = true);
          _showSnackBar(
              'L\'e-mail a été envoyé avec succès ! Veuillez vérifier votre boîte de réception.',
              Colors.green);
        }
      } catch (e) {
        _showSnackBar(
            'Une erreur s\'est produite: ${e.toString()}', Colors.red);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  // Function to reset password
  Future<void> _resetPassword() async {
    if (_formKeyPassword.currentState?.validate() == true) {
      setState(() => _isLoading = true);
      _newPassword = _passwordController.text;

      try {
        await _userService.resetPassword(_email!, _newPassword!);
        _showSuccessDialog();
      } catch (e) {
        _showSnackBar('Error: ${e.toString()}', Colors.red);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

// Helper function to display success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Réinitialisation'),
          content:
              const Text('Votre mot de passe a été réinitialisé avec succès.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

// Helper function to display snack bar messages
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter an email address';
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return 'Veuillez saisir une adresse e-mail valide';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un mot de passe';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit comporter au moins 6 caractères';
    }
    if (_passwordController.text != _confirmPasswordController.text)
      // ignore: curly_braces_in_flow_control_structures
      return "Les mots de passe ne correspondent pas";
    return null;
  }

  Widget _buildEmailForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 90,
          ),
          Text('Réinitialiser le mot de passe',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor)),
          Text(
              'Renseignez votre email pour recevoir le lien de reinitialisation',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey)),
          SizedBox(
            height: 20,
          ),
          _buildTextField(
            label: 'Email', 
            hint: 'Entrez votre adresse e-mail',
            onSaved: (value) => _email = value?.trim(),
            validator: _validateEmail,
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _sendResetEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 90, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Send',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
        ],
      ),
    );
  }

  Widget _buildPasswordResetForm() {
    return Form(
      key: _formKeyPassword,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Créer un nouveau mot de passe',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor)),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _passwordController,
            label: 'Mot de passe',
            
            hint: 'Entrez le nouveau mot de passe',
            obscureText: _isPasswordHidden,
            suffixIcon: IconButton(
              icon: Icon(
                  _isPasswordHidden ? Icons.visibility_off : Icons.visibility),
              onPressed: () =>
                  setState(() => _isPasswordHidden = !_isPasswordHidden),
            ),
            validator: _validatePassword,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _confirmPasswordController,
            label: 'Confirmer mot de passe',
            hint: 'Saisir à nouveau le mot de passe',
            obscureText: _isConfirmPasswordHidden,
            suffixIcon: IconButton(
              icon: Icon(_isConfirmPasswordHidden
                  ? Icons.visibility_off
                  : Icons.visibility),
              onPressed: () => setState(
                  () => _isConfirmPasswordHidden = !_isConfirmPasswordHidden),
            ),
            validator: (value) => value != _passwordController.text
                ? 'Les mots de passe ne correspondent pas'
                : null,
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 90, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Réinitialiser',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 70, horizontal: 10),
        child: SingleChildScrollView(
          child: _emailSent ? _buildPasswordResetForm() : _buildEmailForm(),
        ),
      ),
    );
  }
}

// Generalized text field builder with customizable properties
Widget _buildTextField({
  TextEditingController? controller,
  required String label,
  required String hint,
  void Function(String?)? onSaved,
  String? Function(String?)? validator,
  bool obscureText = false,
  Widget? suffixIcon,
}) {
  return TextFormField(
    controller: controller,
    cursorColor: primaryColor,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffixIcon,
      labelStyle: TextStyle(
        color: secondaryColor,
      ),
      // focusedLabelStyle: TextStyle(
      //   color: focusedLabelColor, // Color when focused
      // ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey),
      ),
    ),
    onSaved: onSaved,
    validator: validator,
    obscureText: obscureText,
  );
}
