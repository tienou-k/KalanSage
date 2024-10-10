import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:k_application/utils/constants.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      items: [
        _buildBottomNavItem(
            'assets/icons/home.svg', 0),
        _buildBottomNavItem(
            'assets/icons/grid_view.svg', 1), 
        _buildBottomNavItem(
            'assets/icons/book.svg', 2), 
        _buildBottomNavItem('assets/icons/chat_bubble_outline.svg',
            3), 
        _buildBottomNavItem(
            'assets/icons/User.svg', 4),
      ],
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }

  // Helper method to build each Bottom Navigation Item with Underline Effect
  BottomNavigationBarItem _buildBottomNavItem(String assetPath, int index) {
    bool isSelected = widget.currentIndex == index;

    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            assetPath,
            height: 24,
            width: 24,
            color: isSelected ? primaryColor : Colors.grey,
          ),
          const SizedBox(height: 4),
          isSelected
              ? Container(
                  width: 20, 
                  height: 3, 
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(2), 
                  ),
                )
              : Container(), 
        ],
      ),
      label: '',
    );
  }
}
