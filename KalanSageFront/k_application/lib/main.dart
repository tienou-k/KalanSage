import 'package:flutter/material.dart';
import 'package:k_application/utils/constants.dart';
import 'utils/routes.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KalanSage App', 
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        primaryColor: primaryColor, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppRoutes.splash, 
      onGenerateRoute:
          AppRoutes.generateRoute, 
    );
  }
}
