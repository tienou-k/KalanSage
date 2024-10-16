import 'package:flutter/material.dart';
import 'package:k_application/services/authService.dart';
import 'package:k_application/utils/constants.dart';

class HeaderPage extends StatefulWidget {
  final double? height; 
  final double? width; 

  const HeaderPage({super.key, this.height, this.width,});

  @override
  _HeaderPage createState() => _HeaderPage();
}

class _HeaderPage extends State<HeaderPage> {
  final AuthService _authService = AuthService();
  String? _userPrenom;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final userProfile = await _authService.fetchUserProfile();
      setState(() {
        //_userName = userProfile['nom'];
        _userPrenom = userProfile['prenom'];
        // _userEmail = userProfile['email'];
        // _userImageUrl = userProfile['imageUrl'];
      });
    } catch (error) {
      print('Error fetching user profile: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0, // Controls the level of elevation
      shadowColor:
          Colors.black.withOpacity(0.3), 
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        height: widget.height ?? 80,
        width: widget.width ?? double.infinity,
        decoration: const BoxDecoration(
          color: primaryColor,
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // First row with "Bienvenue 🤞"
                    Row(
                      children: [
                        Text(
                          'Bienvenue 🤞',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // Second row with username
                    Text(
                      // '${_userPrenom ?? 'Utilisateur'} ${_userName ?? ''}',
                      _userPrenom ?? 'Utilisateur',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              color: Colors.white, 
              onPressed: () {
                // Handle notification click
              },
            ),
          ],
        ),
      ),
    );
  }
}
