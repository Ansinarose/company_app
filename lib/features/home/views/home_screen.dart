

import 'package:company_application/common/widgets/bottom_nav_bar.dart';
import 'package:company_application/features/onboarding/views/carousel_page.dart';
import 'package:company_application/features/services/views/add_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/features/auth/models/user_model.dart';
import 'package:company_application/common/widgets/person_slider.dart';
import 'package:company_application/common/widgets/horrizontal_slider.dart';
import 'package:company_application/common/constants/app_text_styles.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<String> services = [];
  int _selectedIndex = 0;

  void _addService(String service) {
    setState(() {
      services.add(service);
    });
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle navigation based on the selected index
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        backgroundColor: AppColors.textPrimaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              user.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          IconButton(
            onPressed: () {},
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
              PersonSlider(itemCount: 10),
              SizedBox(height: screenHeight * 0.02),
              HorizontalSlider(),
              SizedBox(height: screenHeight * 0.03),
              Text('Services:', style: AppTextStyles.subheading(context)),
              SizedBox(height: screenHeight * 0.02),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1 / 1.2, // Aspect ratio to fit the size
                ),
                itemCount: services.length + 1,
                itemBuilder: (context, index) {
                  if (index == services.length) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddServicePage(onAddService: _addService),
                        ));
                      },
                      child: Container(
                        width: screenWidth * 0.28,
                        height: screenHeight * 0.1,
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
                          child: Icon(Icons.add, size: 30, color: Colors.grey),
                        ),
                      ),
                    );
                  }
                  return Container(
                    width: screenWidth * 0.28, // Set explicit width
                    height: screenHeight * 0.15, // Set explicit height
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
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            services[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Positioned(
                          top: 15,
                          left: 15,
                          right: 15,
                          child: Container(
                            width: 20,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
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
}
