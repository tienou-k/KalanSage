import 'package:flutter/material.dart';
import 'package:k_application/models/abonnement_model.dart';
import 'package:k_application/services/user_service.dart';
import 'package:k_application/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_abonnement.dart';
import '../../services/auth_service.dart';

class AbonnementPage extends StatefulWidget {
  const AbonnementPage({super.key});

  @override
  _AbonnementPage createState() => _AbonnementPage();
}

class _AbonnementPage extends State<AbonnementPage> {
  late Future<List<Abonnement>> abonnements;
  UserAbonnement? _userAbonnement;
  final UserService userService = UserService();
  final AuthService _authService = AuthService();
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    abonnements = userService.fetchAbonnements();
    _fetchUserAbonnement();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final userProfile = await _authService.fetchUserProfile();

      // Get the userId from AuthService instead of SharedPreferences
      final userId = await _authService.getCurrentUserId();

      if (userId != null) {
        // Once we have the userId, fetch the abonnements
        await _fetchUserAbonnement();
      } else {
        print("No userId found.");
      }
    } catch (error) {
      print("Error fetching user profile: $error");
    }
  }

  Future<void> _fetchUserAbonnement() async {
    try {
      // Get the current user ID from AuthService
      final userId = await _authService.getCurrentUserId();

      if (userId == null) {
        print("User ID is null");
        return;
      }

      // Fetch the abonnements using the current userId
      final abonnements = await userService.getUserAbonnementsByUserId(userId);

      if (abonnements.isNotEmpty) {
        setState(() {
          _userAbonnement = abonnements.first;
        });
      } else {
        print("No abonnements found for userId $userId");
      }
    } catch (error) {
      print("Error fetching abonnements: $error");
    }
  }

  // print sharing
  void _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _subscribeToAbonnement(Abonnement abonnement) async {
    // Add logic to subscribe the user to the selected abonnement
    try {
      final userId = await _authService.getCurrentUserId();
      if (userId != null) {
        await userService.subscribeToAbonnement(
            userId, abonnement.idAbonnement);
        // Optionally refetch the user's abonnements to reflect the change
        _fetchUserAbonnement();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Abonnement ajouté avec succès!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'abonnement : $error'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: primaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              'Abonnement',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            elevation: 0,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20.0),
        child: FutureBuilder<List<Abonnement>>(
          future: abonnements,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display the current user's abonnement
                  if (_userAbonnement != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFb38f00), Color(0xFFd6a632)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'ACTUEL ABONNEMENT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                  Text(
                    _userAbonnement!.abonnement.typeAbonnement,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    //'Profitez de votre abonnement offre exclusive et limitée !',
                    EncodingUtils.decode(
                        _userAbonnement!.abonnement.description),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: primaryColor),
                  ),
                  const SizedBox(height: 110),

                  // Abonnement list
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Abonnement list
                        ...snapshot.data!.asMap().entries.map((entry) {
                          int index = entry.key;
                          Abonnement subscription = entry.value;
                          Color borderColor = (index % 2 == 0) ? Colors.white : Colors.amber;
                          Color textColor = (index % 2 == 0) ? Colors.white : Colors.amber[400]!;

                          return GestureDetector(
                            onTap: () {
                              // Call the subscribe function when container is tapped
                              _subscribeToAbonnement(subscription);
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: borderColor, width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.transparent,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            EncodingUtils.decode(subscription.typeAbonnement.toUpperCase()),
                                            style: TextStyle(
                                              color: textColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF4B13D),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              'Promo 0%',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "${subscription.prix.toStringAsFixed(2)} CFA",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        EncodingUtils.decode(subscription.description),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 30),

                        // Trial Button
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Pas implementé!',
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: secondaryColor,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            backgroundColor: const Color(0xFFF4B13D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'ESSAYEZ 7 JOURS ET S\'ABONNER',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // "Non Merci" Button
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Center(
                            child: Text(
                              'Non Merci',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
