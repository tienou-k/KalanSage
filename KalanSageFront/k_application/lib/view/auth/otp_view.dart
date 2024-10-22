import 'dart:async';

import 'package:flutter/material.dart';
import 'package:k_application/services/auth_service.dart';
import 'package:k_application/utils/constants.dart';
import 'package:k_application/view/auth/sign_up.dart';
import 'package:pinput/pinput.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;

  const OTPVerificationScreen({super.key, required this.email});

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _authService = AuthService();
  bool _isLoading = false;
  String _otp = '';
  int _countdown = 30; 
  late Timer _timer;
  bool _isTimerFinished = false;

  @override
  void initState() {
    super.initState();
    _startCountdown(); 
  }

  @override
  void dispose() {
    _timer.cancel(); 
    super.dispose();
  }

  void _startCountdown() {
    _isTimerFinished = false;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        setState(() {
          _isTimerFinished = true; 
        });
        _timer.cancel();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

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
            Text(
              'Vous avez reçu le code OTP sur votre email\n${widget.email}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Code expirera dans: $_countdown s',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.redAccent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // OTP Input field
            Pinput(
              length: 5,
              showCursor: true,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _otp = value;
              },
              onCompleted: (value) {
                _otp = value;
              },
              defaultPinTheme: PinTheme(
                width: 60,
                height: 60,
                textStyle: const TextStyle(
                  fontSize: 20,
                  color: secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Confirm or Refresh button
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : _isTimerFinished
                      ? _refreshOTP // When timer finishes, refresh OTP
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
                backgroundColor: primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      _isTimerFinished
                          ? 'Rafraîchir'
                          : 'Confirmer', 
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
            ),
            const SizedBox(height: 20), 
            // Back arrow button to go back to the login page
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              tooltip: 'Retour à la page de connexion',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyOTP(String otp) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.verifyOTP({
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
        _isLoading = false;
      });
    }
  }

  // Function to refresh OTP and restart the countdown
  Future<void> _refreshOTP() async {
    // Logic to request new OTP goes here
    CustomSnackBar.show(
      context,
      'Un nouveau code OTP a été envoyé à votre email.',
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
    );

    // Restart countdown
    setState(() {
      _countdown = 30;
      _isTimerFinished = false;
    });
    _startCountdown();
  }
}
