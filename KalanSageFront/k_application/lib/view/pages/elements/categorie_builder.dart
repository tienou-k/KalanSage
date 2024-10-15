import 'package:flutter/material.dart';
<<<<<<< HEAD

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
=======
import 'package:k_application/models/categorie_model.dart';
import 'package:k_application/services/cartegorie_service.dart';

class CategoriesSection extends StatefulWidget {
  const CategoriesSection({super.key});

  @override
  _CategoriesSectionState createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  final CategorieService categorieService = CategorieService();
  late Future<List<CategorieModel>> categories;

  @override
  void initState() {
    super.initState();
    categories =
        categorieService.fetchCategories(); 
  }

  @override
>>>>>>> 6044997 (repusher)
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        const Text(
          'Explorer les Categories',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        // Categories Row
<<<<<<< HEAD
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCategoryChip(Icons.brush, 'Design'),
              _buildCategoryChip(Icons.code, 'Code'),
              _buildCategoryChip(Icons.camera_alt, 'Photo'),
              _buildCategoryChip(Icons.grid_view, 'UI/UX'),
              _buildCategoryChip(Icons.school, 'Education'),
              _buildCategoryChip(Icons.settings, 'Tech'),
            ],
          ),
=======
        FutureBuilder<List<CategorieModel>>(
          future: _categories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No categories found'));
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: snapshot.data!.map((category) {
                  return _buildCategoryChip(category.nomCategorie);
                }).toList(),
              ),
            );
          },
>>>>>>> 6044997 (repusher)
        ),
      ],
    );
  }

<<<<<<< HEAD
  
  Widget buildCategoryChip(IconData iconData, String label) {
=======
  Widget _buildCategoryChip(String label) {
>>>>>>> 6044997 (repusher)
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
<<<<<<< HEAD
            backgroundColor:const Color.fromARGB(48, 25, 72, 96), 
            child: Icon(iconData,
                color: Colors.black, size: 20), 
=======
            backgroundColor: const Color.fromARGB(48, 25, 72, 96),
            child: const Icon(Icons.category, color: Colors.black, size: 20),
>>>>>>> 6044997 (repusher)
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
