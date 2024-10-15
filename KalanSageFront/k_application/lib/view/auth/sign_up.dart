import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:k_application/utils/constants.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
=======
import 'package:k_application/services/user_service.dart';
import 'package:k_application/utils/constants.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final userService = UserService();
  final formKey = GlobalKey<FormState>();
  String? name;
  String? firstName;
  String? email;
  String? phone;
  String? password;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
>>>>>>> 6044997 (repusher)
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
<<<<<<< HEAD
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              // Title
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Bienvenue ✌️',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Créer votre compte ici',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Name input field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nom........',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Surname input field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Prénom........',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Email input field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Votre email........',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Phone number input field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Numéro........',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Password input field
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe........',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Create account button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/otp-verification');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Créer',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Navigate to login page
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, '/login'); // Navigate back to login
                  },
                  child: const Text(
                    'Vous n\'avez pas de compte ? Connexion',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
=======
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Bienvenue ✌️',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Créer votre compte ici',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                _buildTextField(
                  label: 'Nom',
                  hint: 'Entrez votre nom',
                  onSaved: (value) => _name = value,
                  validator: (value) => _validateName(value),
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Prénom',
                  hint: 'Entrez votre prénom',
                  onSaved: (value) => _firstName = value,
                  validator: (value) => _validateName(value),
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Email',
                  hint: 'Entrez votre adresse e-mail',
                  onSaved: (value) => _email = value,
                  validator: (value) => _validateEmail(value),
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Numéro',
                  hint: 'Entrez votre numéro',
                  onSaved: (value) => _phone = value,
                  validator: (value) => _validatePhone(value),
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Mot de passe',
                  hint: 'Entrez votre mot de passe',
                  onSaved: (value) => _password = value,
                  validator: (value) => _validatePassword(value),
                  obscureText: true,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            _signup();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Créer',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Vous avez déjà un compte ? Connexion',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
>>>>>>> 6044997 (repusher)
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

  Widget _buildTextField({
    required String label,
    required String hint,
    required FormFieldSetter<String> onSaved,
    required String? Function(String?) validator,
    bool obscureText = false,
    bool enabled = true,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
      onSaved: onSaved,
      obscureText: obscureText,
      enabled: enabled,
    );
  }

  String? validateName(String? value) {
    final namePattern = RegExp(r'^[A-Za-zÀ-ÿ\s]+$');
    if (value == null || value.isEmpty) {
      return 'Le champ nom est requis';
    } else if (!namePattern.hasMatch(value)) {
      return 'Le nom ne doit contenir que des lettres.';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || !value.contains('@')) {
      return 'Veuillez entrer une adresse e-mail valide';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty || value.length < 8) {
      return 'Le numéro doit contenir au moins 8 chiffres';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  Future<void> signup() async {
    setState(() {
      isLoading = true;
    });

    try {
      final userData = {
        'nom': name ?? '',
        'prenom': firstName ?? '',
        'email': email ?? '',
        'telephone': phone ?? '',
        'username': email ?? '',
        'password': password ?? '',
        'role': 'USER',
        'status': false, 
      };

      // Call the service to create a user
      final response = await userService.createUser(userData);

      if (response['message'] != null) {
        CustomSnackBar.show(
          context,
          response['message'],
          backgroundColor:
              response['status'] == 'error' ? Colors.red : Colors.green,
          icon:
              response['status'] == 'error' ? Icons.error : Icons.check_circle,
        );

        if (response['status'] != 'error') {
          Navigator.pushNamed(context, '/opt_verification');
        }
      } else {
        CustomSnackBar.show(
          context,
          'Une erreur inattendue est survenue.',
          backgroundColor: Colors.red,
          icon: Icons.error,
        );
      }
    } catch (e) {
      print('Error creating user: $e');
      CustomSnackBar.show(
        context,
        'Erreur lors de la création de l\'utilisateur: $e',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

// Custom SnackBar widget
class CustomSnackBar {
  static void show(BuildContext context, String message,
      {Color? backgroundColor, IconData? icon, Color? textColor}) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor ?? Colors.white),
            const SizedBox(width: 8),
          ],
          Expanded(
              child: Text(message,
                  style: TextStyle(color: textColor ?? Colors.white))),
        ],
      ),
      backgroundColor: backgroundColor ?? Colors.black,
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
>>>>>>> 6044997 (repusher)
}
