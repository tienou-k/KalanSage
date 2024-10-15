import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:pinput/pinput.dart'; // For OTP input field

class OTPVerificationScreen extends StatelessWidget {
  const OTPVerificationScreen({super.key});
=======
import 'package:k_application/view/auth/sign_up.dart';
import 'package:pinput/pinput.dart';
import 'package:k_application/services/user_service.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;

  const OTPVerificationScreen({super.key, required this.email});

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final userService = UserService();
  bool isLoading = false;
  String otp = '';
>>>>>>> 6044997 (repusher)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            const Text(
              'OTP vérification',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            // Subtitle
            const Text(
              'Entrer le code reçu sur votre numéro',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // OTP Input field (numbers only)
            Pinput(
              length: 5,
              showCursor: true,
              keyboardType: TextInputType.number,
              onChanged: (value) {
<<<<<<< HEAD
                // Handle OTP value change
              },
              onCompleted: (value) {
                // Handle completed OTP entry
                print("OTP Code Entered: $value");
=======
                otp = value;
              },
              onCompleted: (value) {
                otp = value;
>>>>>>> 6044997 (repusher)
              },
              defaultPinTheme: PinTheme(
                width: 60,
                height: 60,
                textStyle: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Confirm button
            ElevatedButton(
<<<<<<< HEAD
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C3E50), 
=======
              onPressed: _isLoading
                  ? null
                  : () {
                      if (_otp.isNotEmpty && _otp.length == 5) {
                        _verifyOTP(_otp);
                      } else {
                        CustomSnackBar.show(
                          context,
                          'Veuillez entrer un code OTP valide.',
                          backgroundColor: Colors.red,
                          icon: Icons.error,
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C3E50),
>>>>>>> 6044997 (repusher)
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
<<<<<<< HEAD
              child: const Text(
                'Confirmer',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
=======
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Confirmer',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
>>>>>>> 6044997 (repusher)
            ),
          ],
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

  Future<void> _verifyOTP(String otp) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await userService.verifyOTP({
        'email': widget.email,
        'otp': otp,
      });

      if (response['status'] == 'success') {
        CustomSnackBar.show(
          context,
          'Compte activé avec succès!',
          backgroundColor: Colors.green,
          icon: Icons.check_circle,
        );
        Navigator.pushNamed(context, '/home');
      } else {
        CustomSnackBar.show(
          context,
          'Code OTP invalide ou expiré.',
          backgroundColor: Colors.red,
          icon: Icons.error,
        );
      }
    } catch (e) {
      CustomSnackBar.show(
        context,
        'Erreur lors de la vérification: $e',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
>>>>>>> 6044997 (repusher)
}
