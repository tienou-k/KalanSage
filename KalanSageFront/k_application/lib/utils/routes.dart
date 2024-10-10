import 'package:flutter/material.dart';
import 'package:k_application/view/auth/login_view.dart';
import 'package:k_application/view/auth/otp_view.dart';
import 'package:k_application/view/auth/sign_up.dart';
import 'package:k_application/view/pages/home_page.dart';
import 'package:k_application/view/screens/loading_screen.dart';
import 'package:k_application/view/screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String logout = '/logout';
  static const String welcome = '/welcome';
  static const String otpverification = '/otp-verification';
  //----------------------------------------------------------------//
  static const String home = '/home';

  // Method to handle routing
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case otpverification:
        return MaterialPageRoute(builder: (_) => const OTPVerificationScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
