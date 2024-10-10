import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/icons/home.svg',
            height: 24,
            width: 24,
            color: widget.currentIndex == 0
                ? const Color(0xFF2C3E50)
                : Colors.grey,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/icons/grid_view.svg',
            height: 24,
            width: 24,
            color: widget.currentIndex == 1
                ? const Color(0xFF2C3E50)
                : Colors.grey,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/icons/book.svg', // Ensure this path is correct
            height: 24,
            width: 24,
            color: widget.currentIndex == 2
                ? const Color(0xFF2C3E50)
                : Colors.grey,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/icons/chat_bubble_outline.svg',
            height: 24,
            width: 24,
            color: widget.currentIndex == 3
                ? const Color(0xFF2C3E50)
                : Colors.grey,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/icons/person_outline.svg',
            height: 24,
            width: 24,
            color: widget.currentIndex == 4
                ? const Color(0xFF2C3E50)
                : Colors.grey,
          ),
          label: '',
        ),
      ],
      selectedItemColor: const Color(0xFF2C3E50),
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}
