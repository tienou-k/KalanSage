import 'package:flutter/material.dart';
import 'package:k_application/view/custom_nav_bar.dart';
import 'package:k_application/view/pages/elements/categorie_builder.dart';
import 'package:k_application/view/pages/elements/slider_banner.dart';
import 'package:k_application/view/pages/elements/tabs_popular.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Profile and Notification Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            AssetImage('assets/images/profile.png'),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //backgroundColor:
                        children: [
                          Text(
                            'Mariame Daou',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '@jessbailey',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      // Handle notification tap
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const SliderBanner(),

              const SizedBox(height: 20),
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Category Section
              const CategoriesSection(),

              const SizedBox(height: 20),
              // Tabs for All
              const TabSection(),

              const SizedBox(height: 19),
              // Module Grid Section (Course Cards)
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 0.75,
                crossAxisSpacing: 15,
                mainAxisSpacing: 08,
                children: [
                  _buildCourseCard('HTML - Learn and practice', '45 Leçons',
                      '15 Quiz', 'assets/images/modules/html.png'),
                  _buildCourseCard('Figma - Learn and practice', '45 Leçons',
                      '5 Quiz', 'assets/images/modules/figma.png'),
                  _buildCourseCard('JavaScript - Learn and practice',
                      '45 Leçons', '9 Quiz', 'assets/images/modules/js.png'),
                  _buildCourseCard('Python - Learn and practice', '45 Leçons',
                      '50 Quiz', 'assets/images/modules/python.png'),
                ],
              ),

              const SizedBox(height: 20),
              // "Mes Cours" Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mes Cours',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to "Voir" page
                    },
                    child: const Text(
                      'voir',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // My Courses Cards
              Row(
                children: [
                  _buildMyCourseCard('Modern Web Tools', Colors.purple),
                  const SizedBox(width: 10),
                  _buildMyCourseCard('Modern Web Tools', Colors.blue),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      // Custom Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
      ),
    );
  }

  // Helper method to build category icon
  Widget _buildCategoryIcon(IconData iconData, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey.shade200,
          child: Icon(iconData, color: Colors.blueAccent),
        ),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }

  Widget _buildCourseCard(
      String title, String lessons, String quizzes, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image
            Center(
              child: Image.asset(
                imagePath,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 07),
            // Course Title
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
            // 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lessons,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle quizzes click
                      },
                      child: Text(
                        quizzes,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                // Bookmark Icon
                IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  onPressed: () {
                    // Handle bookmark action
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build "Mes Cours" cards
  Widget _buildMyCourseCard(String title, Color color) {
    return Expanded(
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
