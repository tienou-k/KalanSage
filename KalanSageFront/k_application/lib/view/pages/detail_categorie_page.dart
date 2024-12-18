import 'package:flutter/material.dart';
import 'package:k_application/models/module_model.dart';
import 'package:k_application/services/auth_service.dart';
import 'package:k_application/services/module_service.dart';
import 'package:k_application/utils/constants.dart';
import 'package:k_application/view/pages/details_module_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryDetailsPage extends StatefulWidget {
  final String categoryName;
  final String categoryId;

  const CategoryDetailsPage({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  _CategoryDetailsPage createState() => _CategoryDetailsPage();
}

class _CategoryDetailsPage extends State<CategoryDetailsPage> {
  late Future<List<ModuleModel>> _modules;
  // ignore: unused_field
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _modules = ModuleService().fetchModulesByCategory(widget.categoryId);
  }

  // ignore: unused_element
  void _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

// Retrieve the current user's ID from SharedPreferences
  Future<int?> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    debugPrint('Retrieved userId: $userId');
    return userId;
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
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              EncodingUtils.decode(widget.categoryName),
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
      ),
      body: FutureBuilder<List<ModuleModel>>(
        future: _modules,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hourglass_empty,
                      size: 80, color: const Color.fromARGB(103, 25, 72, 96)),
                  SizedBox(height: 16),
                  Text(
                    'Aucun module disponible dans cette catégorie.',
                    style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(96, 237, 106, 25)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            List<ModuleModel> modules = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Field
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.search, color: secondaryColor),
                          hintText: 'Rechercher...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 19),
                    SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: modules.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailModulePage(
                                      module: modules[index],
                                    ),
                                  ),
                                );
                              },
                              child: CourseHighlightCard(
                                module: modules[index],
                                onTap: () {},
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),

                    // Grid of Modules
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemCount: modules.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailModulePage(
                                  module: modules[index],
                                ),
                              ),
                            );
                          },
                          child: CourseCard(
                            module: modules[index],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class CourseHighlightCard extends StatelessWidget {
  final ModuleModel module;
  final VoidCallback onTap;

  const CourseHighlightCard({
    super.key,
    required this.module,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: primaryColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.network(
                module.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: primaryColor,
                    child: const Center(child: Icon(Icons.error)),
                  );
                },
              ),
            ),
            // Content overlaying the background
            Container(
              width: 230,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                // Adding a gradient to make text more readable
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.6),
                    Colors.black.withOpacity(0.3),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row (Icon and Lesson/Quiz Information)
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: secondaryColor,
                        child: Icon(
                          Icons.school,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${module.leconsCount} lesson${module.leconsCount != 1 ? 's' : ''} leçons • ${module.quiz} quizzes',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    EncodingUtils.decode(module.title),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    EncodingUtils.decode(module.description),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[300],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatefulWidget {
  final ModuleModel module;

  const CourseCard({
    super.key,
    required this.module,
  });

  @override
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _isLoading = false;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _loadBookmarkStatus();
  }

  // Load bookmark status from the server
  Future<void> _loadBookmarkStatus() async {
    final currentUserId = await AuthService().getCurrentUserId();
    if (currentUserId != null) {
      bool isBookmarked = await ModuleService().isBookmarked(widget.module.id);
      setState(() {
        _isBookmarked = isBookmarked;
        widget.module.isBookmarked = isBookmarked; 
      });
    }
  }

  //
  Future<void> _updateBookmarkStatus(int currentUserId, int moduleId) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      if (_isBookmarked) {
        await ModuleService().removeFromBookmarks(moduleId);
      } else {
        await ModuleService().addToBookmarks(moduleId);
      }

      // Update the state immediately after toggling
      setState(() {
        _isBookmarked = !_isBookmarked;
        widget.module.isBookmarked = _isBookmarked;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isBookmarked
                ? 'Ajouté aux favoris!'
                : 'Enlevé des favoris!',
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint('Bookmark update failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la mise à jour des favoris.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                widget.module.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Center(child: Icon(Icons.error)),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(color: secondaryColor));
                },
              ),
            ),
            const SizedBox(height: 0),
            Text(
              EncodingUtils.decode(widget.module.title),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.module.leconsCount} Leçons',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  '${widget.module.quiz} Quiz',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.module.price} CFA',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: secondaryColor,
                  ),
                  onPressed: () async {
                    final currentUserId =
                        await AuthService().getCurrentUserId();
                    if (currentUserId != null) {
                      await _updateBookmarkStatus(
                          currentUserId, widget.module.id);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Vous devez être connecté pour ajouter ou supprimer des favoris.',
                            textAlign: TextAlign.center,
                          ),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
