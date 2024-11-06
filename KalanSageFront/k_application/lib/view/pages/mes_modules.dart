import 'package:flutter/material.dart';
import 'package:k_application/models/module_model.dart';
import 'package:k_application/services/user_service.dart';
import 'package:k_application/utils/constants.dart';
import 'package:k_application/view/custom_nav_bar.dart';
import 'package:k_application/services/module_service.dart';
import 'package:k_application/view/pages/details_module_page.dart';
import 'package:k_application/view/pages/elements/inscrire_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final bool _isAlreadyEnrolled = false;
  String _selectedTab = 'Tous';
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadPrefs();

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
        _filteredModules = _filterModules(_selectedTab);
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

  void _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<int?> _getCurrentUserId() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs?.getInt('userId');
  }

  //fetch user Modules liste
  void fetchUserModules() async {
    try {
      final userId = await _getCurrentUserId();
      if (userId == null) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _showErrorMessage('Utilisateur non connecté');
        });
        return;
      }

      var modulesData = await UserService().getModulesForUser(userId);
      setState(() {
        _modules = modulesData;
        _filteredModules = _filterModules(_selectedTab);
        _isLoading = false;
        _hasError = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _showErrorMessage('Erreur lors de la récupération des modules: $error');
      });
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Filter modules based on selected tab
  List<ModuleModel> _filterModules(String tabName) {
    switch (tabName) {
      case 'Inscris':
        return _modules.where((module) => module.isEnrolled == true).toList();
      case 'En cours':
        return _modules.where((module) => module.isInProgress == true).toList();
      case 'Finis':
        return _modules.where((module) => module.isCompleted == true).toList();
      default:
        return _modules;
    }
  }

  // Fetch the student count for each module
  void fetchStudentCountForModules() async {
    try {
      for (var module in _modules) {
        var studentCount =
            await ModuleService().getUserCountByModule(module.id);
        setState(() {
          module.studentCount = studentCount;
        });
      }
    } catch (error) {
      // ignore: avoid_print
      print('Error fetching student count: $error');
    }
  }

  // s'inscrire à une module logic
  void _enrollUser(int moduleId) async {
    setState(() {});
    try {
      final result = await UserService().enrollInModule(moduleId);
      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Inscription réussie !'),
            backgroundColor: Colors.green,
          ),
        );
        _fetchModules();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Échec de l\'inscription.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      String errorMessage = 'Erreur lors de l\'inscription.';
      if (e.toString().contains('User is already enrolled in this module')) {
        errorMessage = 'Vous êtes déjà inscrit à ce module.';
      } else {
        errorMessage = 'Erreur: ${e.toString()}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {});
    }
  }

  // Helper method to build the tabs with horizontal scroll
  Widget _buildTab(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = title;
          _filteredModules = _filterModules(title);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _selectedTab == title ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _selectedTab == title
                ? primaryColor
                : Colors.grey.withOpacity(0.5),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
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
                  _buildTab('Inscris'),
                  const SizedBox(width: 10),
                  _buildTab('Favoris'),
                  const SizedBox(width: 10),
                  _buildTab('En cours'),
                  const SizedBox(width: 10),
                  _buildTab('Finis'),
                ],
              ),
            ),
            const SizedBox(height: 50),

            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _hasError
                    ? Center(
                        child:
                            Text('Erreur lors de la récupération des modules'))
                    : _filteredModules.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.hourglass_disabled,
                                    color: const Color.fromARGB(
                                        255, 165, 165, 164),
                                    size: 16),
                                SizedBox(height: 30),
                                Text(
                                  'Aucun module trouvé',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: _filteredModules.length,
                              itemBuilder: (context, index) {
                                var module = _filteredModules[index];
                                return _buildCourseCard(
                                  title: EncodingUtils.decode(module.title),
                                  description:
                                      EncodingUtils.decode(module.description),
                                  students: module.studentCount.toString(),
                                  isEnrolled: module.isEnrolled,
                                  moduleId: module.id,
                                  index: index,
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
              Navigator.pushNamed(context, '/dashboard');
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
    required String students,
    required bool isEnrolled,
    required int moduleId,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailModulePage(
              module: _modules[index],
            ),
          ),
        );
      },
      child: Container(
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
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.people, color: secondaryColor, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        '$students Apprenants',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 120, 
              height: 66, 
              child: InscrireButton(
                module: _modules[index],
                isAlreadyEnrolled: isEnrolled,
                onEnrollmentStatusChanged: (isEnrolled) {
                  setState(() {
                    _modules[index].isEnrolled = isEnrolled;
                  });
                },
                onStartFirstLesson: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailModulePage(
                        module: _modules[index],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
