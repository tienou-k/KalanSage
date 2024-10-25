import 'package:flutter/material.dart';
import 'package:k_application/view/auth/password_reset.dart';

class ResetPasswordActivity extends StatelessWidget {
  const ResetPasswordActivity({super.key});

  @override
  Widget build(BuildContext context) {
    // Handle the intent data if necessary
    // Example: final Uri? uri = ModalRoute.of(context)?.settings.arguments as Uri?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Réinitialiser le mot de passe'),
      ),
      
      body: PasswordReset(), 
    );
  }
}

