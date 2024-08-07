// ignore_for_file: unused_import

import 'dart:async';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/features/auth/views/login_screen.dart';
import 'package:company_application/features/home/views/home_screen.dart';
import 'package:company_application/features/onboarding/views/carousel_page.dart';
import 'package:company_application/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
 
   Timer(Duration(seconds: 3), () {
      checkLoginStatus();
    });
  }

  void checkLoginStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.checkLoginStatus();

    if (authProvider.isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/387-3872576_purple-home-5-icon-free-icons-house-with.png'),
              fit: BoxFit.fill)
            ),
          ),
           SizedBox(
                height: 20,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'ALFA\n',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryColor,
                      ),
                    ),
                    TextSpan(
                      text: 'Aluminium works',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
        ],
        )
      ),
    );
  }
}
