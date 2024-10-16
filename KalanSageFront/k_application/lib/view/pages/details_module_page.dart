import 'package:flutter/material.dart';
import 'package:k_application/models/leconModel.dart';
import 'package:k_application/models/module_model.dart';
import 'package:k_application/services/module_service.dart';
import 'package:k_application/services/user_service.dart';
import 'package:k_application/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailModulePage extends StatefulWidget {
  final ModuleModel module;

  const DetailModulePage({super.key, required this.module});

  @override
  State<DetailModulePage> createState() => _DetailModulePageState();
}

class _DetailModulePageState extends State<DetailModulePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<LeconModel>> _lessons;

  bool _isEnrolling = false;
  bool _isAlreadyEnrolled = false; 
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _tabController = TabController(length: 3, vsync: this);
    _lessons = ModuleService().getLeconsByModule(widget.module.id);
    _checkEnrollmentStatus();
  }

  // Load shared preferences
  void _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Check if the user is already enrolled in the module
  void _checkEnrollmentStatus() async {
    final userId = await _getCurrentUserId(); 
    if (userId != null) {
      try {
        bool isEnrolled = await UserService().isUserEnrolledInModule(userId, widget.module.id);
        setState(() {
          _isAlreadyEnrolled = isEnrolled; 
        });
      } catch (e) {
        // Handle error (optional)
        print('Error checking enrollment status: $e');
      }
    }
  }

  // Method to handle user enrollment logic
  void _enrollUser() async {
    setState(() {
      _isEnrolling = true;
    });

    try {
      final moduleId = widget.module.id;
      final result = await UserService().enrollInModule(moduleId);

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Inscription réussie !')),
        );
        _checkEnrollmentStatus(); // Refresh the enrollment status after enrolling
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de l\'inscription.')),
        );
      }
    } catch (e) {
      String errorMessage = 'Erreur lors de l\'inscription.';
      if (e.toString().contains('User is already enrolled in this module')) {
        errorMessage = 'Vous êtes déjà inscrit à ce module.';
      } else {
        errorMessage = 'Erreur: ${e.toString()}';
      }

      // Display the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        _isEnrolling = false;
      });
    }
  }

  // Get the current user ID (example method)
  Future<int?> _getCurrentUserId() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs?.getInt('userId'); // Assume you store userId in SharedPreferences
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildLessonPreview(),
          SizedBox(height: 16),
          _buildTabBar(),
          _buildTabBarView(),
        ],
      ),
      bottomNavigationBar: _buildEnrollButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            widget.module.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
      ),
    );
  }

  // Build the lesson preview section
  Widget _buildLessonPreview() {
    return FutureBuilder<List<LeconModel>>(
      future: _lessons,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 200,
              color: Colors.grey[200],
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No lessons available.'));
        } else {
          LeconModel firstLesson = snapshot.data![0];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 200,
              color: Colors.grey[200],
              child: Center(
                child: Text(
                  firstLesson.videoUrl,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  // Build the TabBar
  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: [
        Tab(text: 'General'),
        Tab(text: 'Leçons'),
        Tab(text: 'Fichiers'),
      ],
    );
  }

  // Build the TabBarView for General, Lessons, and Files tabs
  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          GeneralTab(module: widget.module),
          ModulesTab(lessons: _lessons),
          FilesTab(),
        ],
      ),
    );
  }

  // Build the Enroll button at the bottom
  Widget _buildEnrollButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: _isEnrolling || _isAlreadyEnrolled
            ? null
            : _enrollUser, 
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: _isEnrolling
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                _isAlreadyEnrolled ? 'Déjà inscrit' : 'S\'inscrire',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

// General Tab displaying module description and skills
class GeneralTab extends StatelessWidget {
  final ModuleModel module;

  const GeneralTab({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    Map<String, List<String>> moduleSkillsMap = {
      'HTML - Learn and practice': [
        'UX/UI',
        'Website design',
        'Figma',
        'Adobe XD',
        'Animations'
      ],
      'CSS - Styling the Web': [
        'Responsive Design',
        'Animations',
        'Flexbox',
        'Grid'
      ],
      'JavaScript - Interactive Web': [
        'DOM Manipulation',
        'ES6',
        'APIs',
        'Async Programming'
      ],
    };

    List<String> skills =
        moduleSkillsMap[module.title] ?? ['Skill not available'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Text(module.description, style: TextStyle(fontSize: 16)),
          SizedBox(height: 16),
          Text('Skills', style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: skills.map((skill) => Chip(label: Text(skill))).toList(),
          ),
        ],
      ),
    );
  }
}

// Modules Tab displaying the list of lessons
class ModulesTab extends StatelessWidget {
  final Future<List<LeconModel>> lessons;

  const ModulesTab({super.key, required this.lessons});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LeconModel>>(
      future: lessons,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No lessons available.'));
        } else {
          List<LeconModel> lessonList = snapshot.data!;
          return ListView.builder(
            itemCount: lessonList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(lessonList[index].title),
                subtitle: Text('Duration: ${lessonList[index].duration} mins'),
              );
            },
          );
        }
      },
    );
  }
}

// Files Tab (optional)
class FilesTab extends StatelessWidget {
  const FilesTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Assuming you have a way to check for files
    bool hasFiles = false; 

    return Center(
      child: hasFiles
          ? Text('Files content goes here') 
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_open, 
                  size: 60,
                  color: Colors.grey, 
                ),
                SizedBox(height: 16),
                Text(
                  'Pas de ressources !.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
    );
  }
}