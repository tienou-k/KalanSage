import 'package:flutter/material.dart';
import 'package:k_application/models/module_model.dart';
import 'package:k_application/services/module_service.dart';
import 'package:k_application/utils/constants.dart';
import 'package:k_application/view/custom_nav_bar.dart';
import 'package:k_application/view/pages/details_module_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavorisPage extends StatefulWidget {
  const FavorisPage({super.key});

  @override
  _FavorisPage createState() => _FavorisPage();
}

class _FavorisPage extends State<FavorisPage> {
  int _currentIndex = 3;
  final ModuleService _moduleService = ModuleService();
  late Future<List<ModuleModel>> _bookmarkedModules;
  SharedPreferences? _prefs;
  bool _hasError = false;
  bool _isLoading = true;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  // Load SharedPreferences instance
  void _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    userId = _prefs?.getString('userId');
    if (userId != null && userId!.isNotEmpty) {
      // Assign the future for fetching bookmarked modules
      _bookmarkedModules = _fetchBookmarkedModulesWithDetails();
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

Future<List<ModuleModel>> _fetchBookmarkedModulesWithDetails() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final bookmarks = await _moduleService.getBookmarkedModules();
      List<ModuleModel> modules = [];
      for (var bookmark in bookmarks) {
        // Convert `moduleId` to `String` if it is an `int`
        final module = await _fetchModuleDetails(bookmark.moduleId.toString());
        modules.add(module);
      }

      setState(() {
        _isLoading = false;
        _hasError = false;
      });
      return modules;
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      throw Exception('Failed to fetch bookmarked modules: $error');
    }
  }
  // Fetch details for a specific module by its ID
  Future<ModuleModel> _fetchModuleDetails(String moduleId) async {
    try {
      // Assuming _moduleService.getModuleDetails exists and fetches details by moduleId
      return await _moduleService.getModuleDetails(moduleId);
    } catch (error) {
      throw Exception('Failed to load module details: $error');
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
        // Current page
        break;
      case 4:
        Navigator.pushNamed(context, '/dashboard');
        break;
    }
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
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'Favoris',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            automaticallyImplyLeading: false,
            centerTitle: true,
            elevation: 0,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Center(child: Text('Error loading bookmarks'))
              : FutureBuilder<List<ModuleModel>>(
                  future: _bookmarkedModules,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return _buildEmptyState();
                    }

                    final modules = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: modules.length,
                      itemBuilder: (context, index) {
                        final module = modules[index];
                        return ListTile(
                          title: Text(module.title),
                          subtitle:
                              Text(module.description ?? 'No description'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailModulePage(module: module),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.bookmark_border,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 10),
          Text(
            'No bookmarked modules yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
