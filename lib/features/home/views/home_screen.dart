// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/widgets/service_grid_widget.dart';
import 'package:company_application/common/widgets/worksfrom_workers_widget.dart';
import 'package:company_application/common/widgets/bottom_nav_bar.dart';
import 'package:company_application/features/auth/models/user_model.dart';
import 'package:company_application/common/widgets/person_slider.dart';
import 'package:company_application/common/widgets/horrizontal_slider.dart';
import 'package:company_application/features/notification/views/notification_screen.dart';
import 'package:company_application/common/widgets/highlights_widget.dart'; // Import the new widget
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.textPrimaryColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationScreen()));
            },
            icon: Icon(Icons.notification_important, color: AppColors.textsecondaryColor),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PersonSlider(),
              SizedBox(height: screenHeight * 0.02),

              HorizontalSlider(),
              SizedBox(height: screenHeight * 0.03),

              ServicesGridWidget(),
              SizedBox(height: screenHeight * 0.03),

              WorksFromWorkersWidget(),
              SizedBox(height: screenHeight * 0.03),
              
              HighlightsWidget(), // Use the new widget here
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}