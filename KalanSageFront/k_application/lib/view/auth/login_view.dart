import 'package:flutter/material.dart';
import 'package:k_application/services/authService.dart';
import 'package:k_application/utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _passwordVisible = false; // Toggle password visibility

  // Handle login logic
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        String email = _emailController.text;
        String password = _passwordController.text;

        // Debug: Print the entered email and password
        print(
            'Attempting to log in with email: $email and password: $password');

        final user = await _authService.login(email, password);

        // Debug: Check if user is null
        if (user != null) {
          print('Login successful. Navigating to home page.');
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          print('Login failed. No user returned.');
          _showSnackbar('La connexion a échoué. Veuillez réessayer.');
        }
      } catch (error) {
        // Debug: Log the error
        print('Error during login: $error');
        _showSnackbar('La connexion a échoué.');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Debug: Log validation failure
      print('Form validation failed');
    }
  }

  // Show Snackbar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  // Email validation
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre email';
    }
    // regex pattern for email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  // Password validation
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre mot de passe';
    }
    if (value.length < 3) {
      return 'Le mot de passe doit comporter au moins 3 caractères';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Top image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(50),
                ),
                child: Image.asset(
                  'assets/images/login.png',
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              // Title and subtitle
              const Text(
                'Bienvenue 👋',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const Text(
                'connectez-vous à votre compte',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),
              // Email input field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  validator: _validateEmail,
                  enabled: !_isLoading,
                ),
              ),
              const SizedBox(height: 20),
              // Password input field with visibility toggle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible, // Password visibility
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  validator: _validatePassword,
                  enabled: !_isLoading,
                ),
              ),
              const SizedBox(height: 30),

              // Login button
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'S\'identifier',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
              const SizedBox(height: 20),

              // Forgot password and create account
              TextButton(
                onPressed: () {
                  // Debug: Forgot password button pressed
                  print('Forgot password button pressed');
                },
                child: const Text(
                  'Mot de passe oublié ?',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                  // Debug: Create account button pressed
                  print('Navigating to sign up page');
                },
                child: const Text(
                  'Vous n\'avez pas de compte ? Créer',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
