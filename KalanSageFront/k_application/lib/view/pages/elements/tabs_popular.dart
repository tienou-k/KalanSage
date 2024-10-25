import 'package:flutter/material.dart';
import 'package:k_application/utils/constants.dart';

class TabSection extends StatefulWidget {
  const TabSection({super.key});

  @override
  _TabSectionState createState() => _TabSectionState();
}

class _TabSectionState extends State<TabSection> {
  int _selectedTabIndex = 0;
  Widget _buildTab(String title, int index) {
    bool isSelected = _selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10), 
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.black,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5)]
              : [],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, 
      child: Row(
        children: [
          _buildTab('Toutes les Modules', 0),
          _buildTab('Modules populaire', 1),
          _buildTab('Nouvelles Modules', 2),
          _buildTab('Autre Modules', 3),
        ],
      ),
    );
  }
}
