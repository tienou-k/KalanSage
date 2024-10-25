import 'package:flutter/material.dart';
import 'package:k_application/models/module_model.dart';
import 'package:k_application/services/module_service.dart';
import 'package:k_application/utils/constants.dart';

class SliderBanner extends StatefulWidget {
  const SliderBanner({super.key});

  @override
  _SliderBannerState createState() => _SliderBannerState();
}


class _SliderBannerState extends State<SliderBanner> {
  List<ModuleModel> _modules = [];
  List<ModuleModel> _filteredModules = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchModules();
  }
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> sliderImages = [
    'assets/images/slider/slider 1.png',
    'assets/images/slider/slider 2.png',
    'assets/images/slider/slider 3.png'
  ];

  Future<void> _fetchModules() async {
    try {
      List<Map<String, dynamic>> fetchedModules =
          await ModuleService().listerModules();
      setState(() {
        _modules =
            fetchedModules.map((json) => ModuleModel.fromJson(json)).toList();
        _filteredModules = _modules;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur dans la récupération des modules: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    final double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 150,
            width: screenWidth,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: sliderImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      sliderImages[index],
                      fit: BoxFit.cover,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Dot Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(sliderImages.length, (index) {
            return _buildDot(index);
          }),
        ),
        const SizedBox(height: 10),
        // Search Field
        TextField(
          onChanged: _onSearch,
          decoration: InputDecoration(
            hintText: 'Rechercher...',
            prefixIcon: const Icon(Icons.search, color: secondaryColor),
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // Method to build dots for page indicators
  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 8,
      width: _currentPage == index ? 12 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? primaryColor : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  // Method to handle search input changes
   void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      if (_searchQuery.isEmpty) {
        _filteredModules = _modules;
      } else {
        _filteredModules = _modules
            .where((module) =>
                module.title.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

}
