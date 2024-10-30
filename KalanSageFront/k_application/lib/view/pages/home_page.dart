import 'package:flutter/material.dart';
import 'package:k_application/models/module_model.dart';
import 'package:k_application/services/module_service.dart';
import 'package:k_application/utils/constants.dart';
import 'package:k_application/view/custom_nav_bar.dart';
import 'package:k_application/view/pages/detail_categorie_page.dart';
import 'package:k_application/view/pages/details_module_page.dart';
import 'package:k_application/view/pages/elements/header.dart';
import 'package:k_application/view/pages/elements/slider_banner.dart';
import 'package:k_application/view/pages/elements/categorie_builder.dart';

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
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur dans la récupération des modules: $e')),
      );
    }
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      _filteredModules = _searchQuery.isEmpty
          ? _modules
          : _modules
              .where((module) => module.title
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
              .toList();
    });
  }

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
    switch (index) {
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: HeaderPage(height: 120, width: screenWidth),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const SliderBanner(),
                    const SizedBox(height: 20),
                    const CategoriesSection(),
                    const SizedBox(height: 20),
                    TabSection(filteredModules: _filteredModules),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Mes Cours',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/mes_modules'),
                          child: const Text(
                            'voir',
                            style: TextStyle(color: Colors.blue, fontSize: 16),
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
                            'Advanced Flutter', Colors.blue, screenWidth),
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

class TabSection extends StatefulWidget {
  final List<ModuleModel> filteredModules;

  const TabSection({required this.filteredModules, super.key});

  @override
  _TabSectionState createState() => _TabSectionState();
}

class _TabSectionState extends State<TabSection> {
  int _selectedTabIndex = 0;
  Future<List<ModuleModel>>? _popularModulesFuture;
  final ModuleService _moduleService = ModuleService();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth < 600 ? 2 : 3;

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTab('Toutes les Modules', 0),
              _buildTab('Modules Gratuites', 1),
              _buildTab('Modules populaires', 2),
              _buildTab('Nouveaux Modules', 3),
            ],
          ),
        ),
        const SizedBox(height: 30),
        _buildTabContent(crossAxisCount),
      ],
    );
  }

  Widget _buildTab(String title, int index) {
    bool isSelected = _selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;

          // Fetch popular modules if popular tab is selected
          if (_selectedTabIndex == 2) {
            _popularModulesFuture = _moduleService.fetchPopularModules();
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          border:
              Border.all(color: isSelected ? Colors.transparent : Colors.black),
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5)]
              : [],
        ),
        child: Text(
          title,
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
        ),
      ),
    );
  }

  Widget _buildTabContent(int crossAxisCount) {
    List<ModuleModel> filteredModules;
    if (_selectedTabIndex == 1) {
      // Free modules
      filteredModules =
          widget.filteredModules.where((module) => module.price <= 0).toList();
    } else if (_selectedTabIndex == 2) {
      // Popular modules: Use FutureBuilder to fetch top subscribed modules
      return FutureBuilder<List<ModuleModel>>(
        future: _popularModulesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Text("Error loading popular modules.");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text("No popular modules available.");
          }

          List<ModuleModel> popularModules = snapshot.data!;
          return _buildModuleGrid(crossAxisCount, popularModules);
        },
      );
    } else if (_selectedTabIndex == 3) {
      // New modules: take last 5 modules
      filteredModules = widget.filteredModules.take(5).toList();
    } else {
      // All modules
      filteredModules = widget.filteredModules;
    }

    return _buildModuleGrid(crossAxisCount, filteredModules);
  }

  Widget _buildModuleGrid(int crossAxisCount, List<ModuleModel> modules) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: modules.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailModulePage(module: modules[index]),
              ),
            );
          },
          child: CourseCard(module: modules[index]),
        );
      },
    );
  }
  

}

