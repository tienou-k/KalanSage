import 'package:flutter/material.dart';
import 'package:k_application/models/module_model.dart';
import 'package:k_application/utils/constants.dart';
import 'package:k_application/view/custom_nav_bar.dart';
import 'package:k_application/services/module_service.dart';

class MesModulesPage extends StatefulWidget {
  const MesModulesPage({super.key});

  @override
  _MesModulesPageState createState() => _MesModulesPageState();
}

class _MesModulesPageState extends State<MesModulesPage> {
  int _currentIndex = 2;
  List<ModuleModel> _modules = [];
  List<ModuleModel> _filteredModules = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _selectedTab = 'Tous';

  @override
  void initState() {
    super.initState();
    _fetchModules();
  }

  // Fetch all modules and filter them for specific tabs
  void _fetchModules() async {
    try {
      var modulesData = await ModuleService().listerModules();
      setState(() {
        _modules = modulesData
            .map<ModuleModel>((moduleMap) => ModuleModel.fromJson(moduleMap))
            .toList();
        _filteredModules =
            _filterModules(_selectedTab);
        _isLoading = false;
        _hasError = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  // Filter modules based on selected tab
  List<ModuleModel> _filterModules(String tabName) {
    switch (tabName) {
      case 'Favoris':
        // Bookmark filter (with 'Inscris' button)
        return _modules
            .where((module) => module.isBookmarked && !module.isEnrolled)
            .toList();
      case 'Inscris':
        // Enrolled modules (modules the user has subscribed to)
        return _modules.where((module) => module.isEnrolled).toList();
      case 'En cours':
        // Modules the user has started but not finished
        return _modules.where((module) => module.isInProgress).toList();
      case 'Finis':
        // Completed modules
        return _modules.where((module) => module.isCompleted).toList();
      default:
        // 'Tous' shows all modules that are not subscribed yet
        return _modules.where((module) => !module.isEnrolled).toList();
    }
  }

  // Fetch the student count for each module
  void _fetchStudentCountForModules() async {
    try {
      for (var module in _modules) {
        var studentCount =
            await ModuleService().getUserCountByModule(module.id);
        setState(() {
          module.studentCount = studentCount; 
        });
      }
    } catch (error) {
      print('Error fetching student count: $error');
    }
  }


  // Helper method to build the tabs with horizontal scroll
  Widget _buildTab(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = title;
          _filteredModules =
              _filterModules(title);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: _selectedTab == title ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _selectedTab == title ? Colors.transparent : Colors.black,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: _selectedTab == title ? Colors.white : Colors.black,
            fontWeight:
                _selectedTab == title ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Horizontal Tabs Section
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTab('Tous'),
                  const SizedBox(width: 10),
                  _buildTab('Favoris'),
                  const SizedBox(width: 10),
                  _buildTab('Inscris'),
                  const SizedBox(width: 10),
                  _buildTab('En cours'),
                  const SizedBox(width: 10),
                  _buildTab('Finis'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Check if data is loading, error occurred, or data fetched
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _hasError
                    ? Center(
                        child:
                            Text('Error fetching modules. Please try again.'))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _filteredModules.length,
                          itemBuilder: (context, index) {
                            var module = _filteredModules[index];
                            return _buildCourseCard(
                              title: module.title,
                              description: module.description,
                              rating: module.rating.toString(),
                              students: module.studentCount.toString(),
                              isEnrolled: module.isEnrolled,
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
      // Custom Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
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
              // Current page
              break;
            case 3:
              Navigator.pushNamed(context, '/chats');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }

  // Helper method to build the course card
  Widget _buildCourseCard({
    required String title,
    required String description,
    required String rating,
    required String students,
    required bool isEnrolled,
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
                  description,
                  style: const TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    // Rating
                    const Icon(Icons.star, color: secondaryColor, size: 16),
                    const SizedBox(width: 5),
                    Text(
                      ' rating',
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
                      '$students Apprenant',
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
          if (!isEnrolled)
            ElevatedButton(
              onPressed: () {
                // Handle course inscription logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'S\'inscrire',
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