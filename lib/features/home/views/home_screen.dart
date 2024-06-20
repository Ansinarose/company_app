
// ignore_for_file: unused_local_variable

import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/widgets/person_slider.dart';
import 'package:company_application/features/auth/models/user_model.dart';
// Import the new widget
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final PageController _pageController = PageController();
 
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.textPrimaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Logout user
              user.logout();
              // Navigate back to login page
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          IconButton(
            onPressed: (){}, 
            icon: Icon(Icons.notification_important, color: AppColors.textsecondaryColor)
          )
        ],
      ),
      body: Column(
        children: [
          //Added personal slider from the widget
          PersonSlider(itemCount: 10), 
         
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: AppColors.textPrimaryColor,
        color: AppColors.textPrimaryColor,
        animationDuration: Duration(milliseconds: 500),
        items: <Widget>[
          Icon(Icons.home, size: 26, color: Colors.white),
          Icon(Icons.shopping_cart, size: 26, color: Colors.white),
          Icon(Icons.payment, size: 26, color: Colors.white),
          Icon(Icons.settings, size: 26, color: Colors.white),
        ]
      ),
    );
  }
}
