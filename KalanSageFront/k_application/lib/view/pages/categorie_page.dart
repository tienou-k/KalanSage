import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:k_application/view/custom_nav_bar.dart';

class CategoriePage extends StatefulWidget {
  const CategoriePage({super.key});

  @override
  _CategoriePage createState() => _CategoriePage();
}

class _CategoriePage extends State<CategoriePage> {
  int _currentIndex = 1;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        
        break;
      case 2:
      Navigator.pushNamed(context, '/mes_modules');
        break;
      case 3:
        Navigator.pushNamed(context, '/chats');
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
      appBar: AppBar(
        title: const Text(
          'Categorie',
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher....',
                prefixIcon: const Icon(Icons.search, color: Colors.orange),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Explorer les Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.0,
                children: [
                  _buildCategoryCard('Art & Design', '20 Cours',
                      'assets/icons/art_design.svg'),
                  _buildCategoryCard(
                      'Développement', '138 Cours', 'assets/icons/dev.svg'),
                  _buildCategoryCard(
                      'Communication', '07 Cours', 'assets/icons/com.svg'),
                  _buildCategoryCard(
                      'Vidéographie', '14 Cours', 'assets/icons/video.svg'),
                  _buildCategoryCard(
                      'Photographie', '01 Cours', 'assets/icons/photo.svg'),
                  _buildCategoryCard(
                      'Marketing', '38 Cours', 'assets/icons/marketing.svg'),
                  _buildCategoryCard(
                      'Redaction', '02 Cours', 'assets/icons/content.svg'),
                  _buildCategoryCard(
                      'Finance', '20 Cours', 'assets/icons/finanace.svg'),
                  _buildCategoryCard(
                      'Science', '05 Cours', 'assets/icons/science.svg'),
                  _buildCategoryCard(
                      'Reseau', '18 Cours', 'assets/icons/reseau.svg'),
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

  Widget _buildCategoryCard(String title, String subtitle, String iconPath) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            height: 40,
            color: Colors.orange,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
