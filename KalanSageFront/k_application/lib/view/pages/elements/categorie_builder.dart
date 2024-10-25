import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:k_application/models/categorie_model.dart';
import 'package:k_application/services/cartegorie_service.dart';

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
    _categories =
        _categorieService.fetchCategories(); 
  }

  @override
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
        const SizedBox(height: 20),
        // Categories Row
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
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color.fromARGB(48, 25, 72, 96),
            child: SvgPicture.asset(
              category.getIconPath(), 
              color: Colors.black,
              height: 20,
              width: 20,
            ),
          ),
          const SizedBox(height: 20),
          // Text(
          //   category.nomCategorie,
          //   style: const TextStyle(color: Colors.black, fontSize: 14),
          // ),
        ],
      ),
    );
  }
}
