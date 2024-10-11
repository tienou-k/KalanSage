import 'package:flutter/material.dart';
import 'package:k_application/services/authService.dart';
import 'package:k_application/utils/constants.dart';

class HeaderPage extends StatefulWidget {
  const HeaderPage({super.key});

  @override
  _HeaderPage createState() => _HeaderPage();
}

class _HeaderPage extends State<HeaderPage> {
  final AuthService _authService = AuthService();
  String? _userName;
  String? _userPrenom;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final userProfile = await _authService.fetchUserProfile();
      setState(() {
        _userName = userProfile['nom'];
        _userPrenom = userProfile['prenom'];
        _userEmail = userProfile['email'];
      });
    } catch (error) {
      // Handle errors appropriately, for now, just print it.
      print('Error fetching user profile: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      width: double.infinity,
      height: 80,
      decoration: const BoxDecoration(
        color: primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_userPrenom ?? 'Utilisateur'} ${_userName ?? ''}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_userEmail ??'email-null'} ${_userEmail ?? ''}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
