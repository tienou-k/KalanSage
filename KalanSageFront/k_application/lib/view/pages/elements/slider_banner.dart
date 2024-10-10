import 'package:flutter/material.dart';
import 'package:k_application/utils/constants.dart';

class SliderBanner extends StatefulWidget {
  const SliderBanner({super.key});

  @override
  _SliderBannerState createState() => _SliderBannerState();
}

class _SliderBannerState extends State<SliderBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> sliderImages = [
    'assets/images/slider/slider 1.png',
    'assets/images/slider/slider 2 .png',
    'assets/images/slider/slider 3.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 170,
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
                    // Adding the text overlay
                    // Positioned(
                    //   bottom: 20,
                    //   left: 20,
                    //   // child: Text(
                    //   //   'Intelligence Artificielle',
                    //   //   style: TextStyle(
                    //   //     color: Colors.white,
                    //   //     fontSize: 24,
                    //   //     fontWeight: FontWeight.bold,
                    //   //     shadows: [
                    //   //       Shadow(
                    //   //         color: Colors.black.withOpacity(0.7),
                    //   //         offset: Offset(2, 2),
                    //   //         blurRadius: 10,
                    //   //       ),
                    //   //     ],
                    //   //   ),
                    //   // ),
                    // ),
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
        color: _currentPage == index ? primaryColor: Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
