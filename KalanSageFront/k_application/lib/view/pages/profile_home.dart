import 'package:flutter/material.dart';
import 'package:k_application/services/auth_service.dart';
import 'package:k_application/services/user_service.dart';
import 'package:k_application/utils/constants.dart';
import 'package:k_application/view/custom_nav_bar.dart';
import 'package:k_application/view/pages/profile_parametre.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_abonnement.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreen createState() => _DashboardScreen();
}

class _DashboardScreen extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 4;
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  UserAbonnement? _userAbonnement;
  String? _userPrenom;
  String? _userEmail;
  late TabController _tabController;
  SharedPreferences? _prefs;
  bool isLoading = false;
  bool hasError = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _tabController = TabController(length: 2, vsync: this);
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final userProfile = await _authService.fetchUserProfile();

      setState(() {
        _userPrenom = userProfile['prenom'];
        _userEmail = userProfile['email'];
      });

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
      final abonnements = await _userService.getUserAbonnementsByUserId(userId);

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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileSettings(),
                ),
              );
            },
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileSection(),
            TabBar(
              controller: _tabController,
              indicatorColor: secondaryColor,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'STATS'),
                Tab(text: 'ACTIVITES'),
              ],
            ),
            // Tab Content
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildStatsTab(),
                  _buildBadgesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
      ),
    );
  }

  // Build profile section widget
  Widget _buildProfileSection() {
    return Container(
      color: primaryColor,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _userPrenom ?? 'Utilisateur',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _userEmail ?? 'null',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          Spacer(),
          _userAbonnement != null
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        _userAbonnement!.abonnement.typeAbonnement,
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        "${_userAbonnement!.abonnement.prix} f CFA",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  // Build Stats Tab
  Widget _buildStatsTab() {
    return SingleChildScrollView(
      // Wrap with SingleChildScrollView
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            children: [
              InfoCard(icon: Icons.bar_chart, label: '#- Classement'),
              const SizedBox(width: 16),
              InfoCard(icon: Icons.emoji_events, label: '- Badges'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              InfoCard(icon: Icons.school, label: '- Certificats'),
              const SizedBox(width: 16),
              InfoCard(icon: Icons.balance, label: '- Challenges'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              InfoCard(icon: Icons.quiz, label: '- Quiz'),
            ],
          ),
          const SizedBox(height: 16),
          // Strongest Topics Section
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Modules en Progressions',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          TopicProgress(title: '- -', progress: 0, correct: 0),
          TopicProgress(title: '- -', progress: 0, correct: 0),
          TopicProgress(title: '- -', progress: 0, correct: 0),
        ],
      ),
    );
  }

  // Build Badges Tab
  Widget _buildBadgesTab() {
    return ListView();
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const InfoCard({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: secondaryColor),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class TopicProgress extends StatelessWidget {
  final String title;
  final double progress;
  final int correct;

  const TopicProgress({
    super.key,
    required this.title,
    required this.progress,
    required this.correct,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(title),
          ),
          Text('$correct%'),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: progress,
              color: primaryColor,
              backgroundColor: primaryColor.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
