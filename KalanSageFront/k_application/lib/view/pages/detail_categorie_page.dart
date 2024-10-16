import 'package:flutter/material.dart';
import 'package:k_application/models/module_model.dart';
import 'package:k_application/services/module_service.dart';
import 'package:k_application/utils/constants.dart';
import 'package:k_application/view/pages/details_module_page.dart';

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

  @override
  void initState() {
    super.initState();
    _modules = ModuleService().fetchModulesByCategory(widget.categoryId);
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
              widget.categoryName,
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
                  Icon(Icons.hourglass_empty, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Aucun module disponible dans cette catégorie.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
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

// Helper function to get asset image path based on module name
String getModuleImage(String moduleName) {
  switch (moduleName) {
    case 'Java':
      return 'assets/images/modules/java.jpg';
    case 'SpringBoot':
      return 'assets/images/modules/SpringBoot.png';
    case 'INFORMATIQUE':
      return 'assets/images/modules/informatique.jpg';
    // Add more cases as per your modules
    default:
      return 'assets/images/default_module.png';
  }
}

// Course Highlight Card Widget
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
        child: Container(
          width: 230, 
          padding: const EdgeInsets.all(10.0), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row (Icon and Lesson/Quiz Information)
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor:
                        secondaryColor, 
                    child: Icon(
                      Icons.school, 
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${module.leconCount} leçons • ${module.quiz} quizzes',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10), 
              Text(
                module.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5),
              Text(
                module.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  'assets/images/illustration.png', 
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Popular Course Card Widget with Asset Images
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
  @override
  Widget build(BuildContext context) {
    String imagePath = getModuleImage(widget.module.title);

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
            // Display image from assets
            Expanded(
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
            SizedBox(height: 0),
            Text(widget.module.title,
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${widget.module.leconCount} Lessons',
                    style: TextStyle(fontSize: 12)),
                Text('${widget.module.quiz} Quiz',
                    style: TextStyle(fontSize: 12)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${widget.module.price} CFA',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: secondaryColor,
                    )),
                IconButton(
                  icon: Icon(
                    widget.module.isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: secondaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.module.isBookmarked = !widget.module.isBookmarked;
                      ModuleService().updateBookmarkStatus(widget.module);
                    });
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
