import 'package:flutter/material.dart';
import 'package:k_application/services/auth_service.dart';
import 'package:k_application/utils/constants.dart';
import 'package:k_application/view/custom_nav_bar.dart';
import 'package:k_application/view/pages/profile_parametre.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreen createState() => _DashboardScreen();
}

class _DashboardScreen extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 4;
  final AuthService _authService = AuthService();
  String? _userPrenom;
  String? _userEmail;
  late TabController _tabController; 

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this); 
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final userProfile = await _authService.fetchUserProfile();
      setState(() {
        _userPrenom = userProfile['prenom'];
        _userEmail = userProfile['email'];
      });
    // ignore: empty_catches
    } catch (error) {}
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
      body: Column(
        children: [
          _buildProfileSection(),
          TabBar(
            controller: _tabController,
            indicatorColor: secondaryColor,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'STATS'),
              Tab(text: 'RANG'),
              Tab(text: 'NOTIFICATIONS'),
            ],
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildStatsTab(), 
                _buildBadgesTab(),
                _buildNotificationsTab(), 
              ],
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
          Container(
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: const [
                Text(
                  'Abonnement',
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  '9,9/m',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build Stats Tab
  Widget _buildStatsTab() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            children: [
              InfoCard(icon: Icons.bar_chart, label: '#2 Leaderboard' ),
              const SizedBox(width: 16),
              InfoCard(icon: Icons.quiz, label: '55 Quizzes'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              InfoCard(icon: Icons.emoji_events, label: '55 Badges'),
              const SizedBox(width: 16),
              InfoCard(icon: Icons.balance, label: '12 Challenges'),
            ],
          ),
          const SizedBox(height: 16),
          // Strongest Topics Section
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'STRONGEST TOPICS',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          TopicProgress(title: 'Module 1', progress: 0.28, correct: 28),
          TopicProgress(title: 'Module 2', progress: 0.35, correct: 35),
          TopicProgress(title: 'Module 3', progress: 0.40, correct: 40),
        ],
      ),
    );
  }

  // Build Badges Tab
  Widget _buildBadgesTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      children: const [
        AchievementTile(
          iconColor: Colors.yellow,
          title: 'Earned Gold',
          date: 'May 1, 2022',
          score: '5/5 Correct',
        ),
        AchievementTile(
          iconColor: Colors.grey,
          title: 'Completed Drive-Thru',
          date: 'May 1, 2022',
          score: '5/10 Correct',
        ),
        AchievementTile(
          iconColor: Colors.brown,
          title: 'Earned Bronze in Drive-Thru',
          date: 'May 1, 2022',
          score: '8/10 Correct',
        ),
        AchievementTile(
          iconColor: Colors.grey,
          title: 'Earned Silver in Drive-Thru',
          date: 'May 1, 2022',
          score: '9/10 Correct',
        ),
      ],
    );
  }

  // Build Notifications Tab
  Widget _buildNotificationsTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      children: [
        ListTile(
          leading: Icon(Icons.notifications, color: primaryColor, size: 40),
          title: Text('New Module Available'),
          subtitle: Text('Oct 1, 2023 • 2:00 PM'),
        ),
        ListTile(
          leading: Icon(Icons.notifications, color: primaryColor, size: 40),
          title: Text('Live Session in Progress'),
          subtitle: Text('Oct 10, 2023 • 10:00 AM'),
        ),
        ListTile(
          leading: Icon(Icons.notifications, color: primaryColor, size: 40),
          title: Text('New Badge Earned!'),
          subtitle: Text('Sept 25, 2023 • 5:30 PM'),
        ),
      ],
    );
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

  const TopicProgress({super.key, 
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

class AchievementTile extends StatelessWidget {
  final Color iconColor;
  final String title;
  final String date;
  final String score;

  const AchievementTile({super.key, 
    required this.iconColor,
    required this.title,
    required this.date,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.stars, color: iconColor, size: 40),
      title: Text(title),
      subtitle: Text('$date • $score'),
    );
  }
}
