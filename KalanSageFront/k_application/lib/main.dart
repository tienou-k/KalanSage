<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:k_application/utils/constants.dart';
import 'utils/routes.dart'; 

void main() {
=======
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:k_application/utils/constants.dart';
import 'package:k_application/utils/routes.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();
  if (Platform.isIOS) {
    await FirebaseMessaging.instance.requestPermission();
  }

>>>>>>> 6044997 (repusher)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      title: 'KalanSage App', 
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        primaryColor: primaryColor, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppRoutes.splash, 
      onGenerateRoute:
          AppRoutes.generateRoute, 
=======
      title: 'KalanSage App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
>>>>>>> 6044997 (repusher)
    );
  }
}