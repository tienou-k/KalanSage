import 'package:flutter/material.dart';
import 'package:k_application/utils/constants.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
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
          ),
        ),
      ),
    );
  }
}
