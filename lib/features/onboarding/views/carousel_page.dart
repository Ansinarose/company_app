

import 'package:company_application/common/constants/app_button_styles.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselPage extends StatelessWidget {
  const CarouselPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 99, 122, 106), AppColors.textPrimaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 50), // Add spacing from top
            Column(
              children: [
                Text(
                  'ALFA Aluminium Works',
                  style: AppTextStyles.whitetext(context)),
                  SizedBox(height: 10,),
                  Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/387-3872576_purple-home-5-icon-free-icons-house-with.png'),
                        fit: BoxFit.fill)),
              ),
              
              ],
            ),
            SizedBox(height: 20), // Add spacing between heading and carousel
            Container(
              height: 400, // Specific size for the carousel
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 400,
                  
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(seconds: 1),
                  viewportFraction: 0.6,
                ),
                items: [
                  // Add your carousel items here
                  _buildCarouselItem(context, 'assets/images/R.png'),
                  _buildCarouselItem(context, 'assets/images/interior-design-violet-22273327.webp'),
                  _buildCarouselItem(context, 'assets/images/R.png'),
                ],
              ),
            ),
            SizedBox(height: 20), // Add spacing between carousel and button
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
              child: Text(
                'Get Started',),
                style: AppButtonStyles.largeButton(context)
              
            ),
            SizedBox(height: 50), // Add spacing from bottom
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselItem(BuildContext context, String imagePath,) {
    return Container(
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}