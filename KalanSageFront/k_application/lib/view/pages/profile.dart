import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:k_application/services/authService.dart';
import 'package:k_application/utils/constants.dart';
import 'package:k_application/view/custom_nav_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 4;
  bool isDarkMode = false;
  final AuthService authService = AuthService();
  String? _userName;
  String? _userPrenom;
  String? _userEmail;
  String? _userImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final userProfile = await authService.fetchUserProfile();
      setState(() {
        _userName = userProfile['nom'];
        _userPrenom = userProfile['prenom'];
        _userEmail = userProfile['email'];
      });
    } catch (error) {
      print('Error fetching user profile: $error');
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/categorie');
        break;
      case 2:
        Navigator.pushNamed(context, '/mes_modules');
        break;
      case 3:
        Navigator.pushNamed(context, '/chats');
        break;
      case 4:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Profile Header
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: _buildProfileHeader(),
            ),
          ),
          Spacer(),
          // Profile Menu Items Card
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMenuItem('assets/icons/User Heart Rounded.svg',
                        'Profile', const Color(0xFFEEF2FF)),
                    _buildMenuItem('assets/icons/Document Add.svg',
                        'Notification', const Color(0xFFD5F4E6)),
                    _buildMenuItem('assets/icons/langueAdd.svg', 'Langue',
                        const Color.fromARGB(29, 9, 40, 175)),
                    _buildMenuItem('assets/icons/Wallet 2.svg', 'Mes Points',
                        const Color(0xFFFFE5E5)),
                  ],
                ),
              ),
            ),
          ),

          // Light/Dark and Deconnexion Card at the bottom
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/dark_mode.svg',
                            height: 24,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Light/Dark',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Switch(
                            value: isDarkMode,
                            onChanged: (value) {
                              setState(() {
                                isDarkMode = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildMenuItem(
                        'assets/icons/decon.svg',
                        'Deconnexion',
                        const Color(0xFFEEF2FF),
                        onTap: () async {
                          await authService.logout();
                          Navigator.pushNamed(context, '/login');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage:
              NetworkImage(_userImageUrl ?? 'default_user_image.jpg'),
        ),
        const SizedBox(width: 16),
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
              _userEmail ?? 'email-null',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
        
      ],
    );
  }

  Widget _buildMenuItem(String iconPath, String title, Color iconBgColor,
      {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                iconPath,
                height: 24,
                width: 24,
                color: Colors.black54,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
