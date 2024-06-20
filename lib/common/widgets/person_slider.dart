import 'package:flutter/material.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PersonSlider extends StatelessWidget {
  final int itemCount;

  PersonSlider({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 100, // Set height for the scrollable section
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(itemCount, (index) {
                  return GestureDetector(
                    onTap: () {
                      // Handle tap
                    },
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      width: 80, // Set width and height for the round container
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.textPrimaryColor, // Background color of the container
                        shape: BoxShape.circle, // Round shape
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 80, // Icon size
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        SmoothPageIndicator(
          controller: _pageController,
          count: itemCount, // Replace 10 with your dynamic list length
          effect: WormEffect(
            dotWidth: 8.0,
            dotHeight: 8.0,
            activeDotColor: AppColors.textPrimaryColor,
            dotColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}
