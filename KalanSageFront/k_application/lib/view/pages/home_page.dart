import 'package:flutter/material.dart';
import 'package:k_application/models/module_model.dart';
import 'package:k_application/services/module_service.dart';
import 'package:k_application/view/custom_nav_bar.dart';
import 'package:k_application/view/pages/detail_categorie_page.dart';
import 'package:k_application/view/pages/details_module_page.dart';
import 'package:k_application/view/pages/elements/header.dart';
import 'package:k_application/view/pages/elements/slider_banner.dart';
import 'package:k_application/view/pages/elements/categorie_builder.dart';
import 'package:k_application/view/pages/elements/tabs_popular.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<ModuleModel> _modules = [];
  List<ModuleModel> _filteredModules = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchModules();
  }

  Future<void> _fetchModules() async {
    try {
      List<Map<String, dynamic>> fetchedModules =
          await ModuleService().listerModules();
      setState(() {
        _modules =
            fetchedModules.map((json) => ModuleModel.fromJson(json)).toList();
        _filteredModules = _modules;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur dans la récupération des modules: $e')),
      );
    }
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      if (_searchQuery.isEmpty) {
        _filteredModules = _modules;
      } else {
        _filteredModules = _modules
            .where((module) =>
                module.title.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        //nous sommes ici...................
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
        Navigator.pushNamed(context, '/dashboard');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth < 600 ? 2 : 3;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: HeaderPage(
          height: 120,
          width: MediaQuery.of(context).size.width,
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const SliderBanner(),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    CategoriesSection(),
                    const SizedBox(height: 20),
                    const TabSection(),
                    const SizedBox(height: 20),
                    // GridView.builder with filtered modules
                    const SizedBox(height: 10),
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: _filteredModules.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailModulePage(
                                  module: _filteredModules[index],
                                ),
                              ),
                            );
                          },
                          child: CourseCard(module: _filteredModules[index]),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
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
                            Navigator.pushNamed(context, '/mes_modules');
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
                    Row(
                      children: [
                        _buildMyCourseCard(
                            'Modern Web Tools', Colors.purple, screenWidth),
                        const SizedBox(width: 10),
                        _buildMyCourseCard(
                            'Modern Web Tools', Colors.blue, screenWidth),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
      ),
    );
  }

  Widget _buildMyCourseCard(String title, Color color, double screenWidth) {
    return Expanded(
      child: Container(
        height: screenWidth < 600 ? 120 : 140,
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
