import 'package:flutter/material.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

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
        const SizedBox(height: 10),
        // Categories Row
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
        ),
      ],
    );
  }

  
  Widget _buildCategoryChip(IconData iconData, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor:const Color.fromARGB(48, 25, 72, 96), 
            child: Icon(iconData,
                color: Colors.black, size: 20), 
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
