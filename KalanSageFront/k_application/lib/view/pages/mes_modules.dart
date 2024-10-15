import 'package:flutter/material.dart';
import 'package:k_application/utils/constants.dart';

class MesModulesPage extends StatefulWidget {
  const MesModulesPage({super.key});

  @override
  _MesModulesPage createState() => _MesModulesPage();
}

class _MesModulesPage extends State<MesModulesPage> {
  int _currentIndex = 2;

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
        break;
      case 3:
<<<<<<< HEAD
       Navigator.pushNamed(context, '/chats');
=======
        Navigator.pushNamed(context, '/chats');
>>>>>>> 6044997 (repusher)
        break;
      case 4:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
<<<<<<< HEAD
      appBar: AppBar(
        title: const Text(
          'Mes Formations',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
=======
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
            title: Text(
              'Mes Modules',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
        ),
>>>>>>> 6044997 (repusher)
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs Section: Inscris, En cours, Finis
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTab('Inscris', true),
                _buildTab('En cours', false),
                _buildTab('Finis', false),
              ],
            ),
            const SizedBox(height: 20),
            // List of Courses
            Expanded(
              child: ListView(
                children: [
                  _buildCourseCard(
                    title: 'Typography and Layout Design',
                    school: 'Visual Communication College',
                    rating: '4.4',
                    students: '3457',
                    //  imagePath: 'assets/images/courses/typography.png',
                  ),
                  _buildCourseCard(
                    title: 'Branding and Identity Design',
                    school: 'Brand Strategy College',
                    rating: '4.3',
                    students: '1457',
                    //imagePath: 'assets/images/courses/branding.png',
                  ),
                  _buildCourseCard(
                    title: 'Game Design and Development',
                    school: 'Game Development Academy',
                    rating: '4.4',
                    students: '5679',
                    // imagePath: 'assets/images/courses/game_design.png',
                  ),
                  _buildCourseCard(
                    title: 'Animation and Motion Graphics',
                    school: 'Animation Institute of Digital Arts',
                    rating: '4.7',
                    students: '5679',
                    //imagePath: 'assets/images/courses/animation.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Custom Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
      ),
    );
  }

  // Helper method to build the tabs
  Widget _buildTab(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        // Handle tab change
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.black,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Helper method to build the course card
  Widget _buildCourseCard({
    required String title,
    required String school,
    required String rating,
    required String students,
    //required String imagePath,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Course Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            /*child: Image.asset(
             imagePath,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),*/
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  school,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    // Rating
                    const Icon(Icons.star, color: secondaryColor, size: 16),
                    const SizedBox(width: 5),
                    Text(
                      rating,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Students
                    const Icon(Icons.people, color: secondaryColor, size: 16),
                    const SizedBox(width: 5),
                    Text(
                      students,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle course inscription
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Inscris',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
