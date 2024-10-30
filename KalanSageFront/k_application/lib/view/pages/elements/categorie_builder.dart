import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:k_application/models/categorie_model.dart';
import 'package:k_application/services/cartegorie_service.dart';
import 'package:k_application/utils/constants.dart';

class CategoriesSection extends StatefulWidget {
  const CategoriesSection({super.key});

  @override
  _CategoriesSectionState createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  final CategorieService _categorieService = CategorieService();
  late Future<List<CategorieModel>> _categories;

  @override
  void initState() {
    super.initState();
    _categories = _categorieService.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Explorer les categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/categorie');
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
        const SizedBox(height: 20),
        // Categories Row
        FutureBuilder<List<CategorieModel>>(
          future: _categories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    secondaryColor),
                strokeWidth: 5.0,
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No categories found'));
            }
             // afficher seulement les 4 premier categorie
            final categorieToShow = snapshot.data!.take(3);
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: categorieToShow.map((category) {
                  return _buildCategoryChip(category);
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryChip(CategorieModel category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:  20.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color.fromARGB(48, 25, 72, 96),
            child: SvgPicture.asset(
              category.getIconPath(),
              color:  Colors.black,
              height: 20,
              width: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            category.nomCategorie,
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
