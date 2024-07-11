// ignore_for_file: unused_local_variable, unnecessary_import

import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HorizontalSlider extends StatefulWidget {
  @override
  _HorizontalSliderState createState() => _HorizontalSliderState();
}

class _HorizontalSliderState extends State<HorizontalSlider> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.5);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          height: screenWidth * 0.3, // Adjust the height based on screen width
          child: PageView(
            controller: _pageController,
            children: [
              _buildSliderCard('New Order'),
              _buildSliderCard('Ongoing Project'),
              _buildSliderCard('Completed Works'),
              _buildSliderCard('Recent Payments'),
              _buildSliderCard('New Worker Alert'),
              _buildSliderCard('Total Workers'),
            ],
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (index) => _buildDotIndicator(index),
          ),
        ),
      ],
    );
  }

  Widget _buildSliderCard(String title) {
    return GestureDetector(
      onTap: () {
        // Handle card tap
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: AppTextStyles.subheading(context)
            ),
          ),
        ),
      );
    
  }

  Widget _buildDotIndicator(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double selectedness = _pageController.page == null
            ? (_pageController.initialPage == index ? 1.0 : 0.0)
            : (_pageController.page! - index).abs().clamp(0.0, 1.0);
        double zoom = 1.0 + (1.0 - selectedness) * 0.3;
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Container(
            
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selectedness < 0.5 ? AppColors.textPrimaryColor : Colors.grey,
            ),
          ),
        );
      },
    );
  }
}
