import 'package:company_application/features/auth/models/user_model.dart';
import 'package:company_application/features/auth/views/login_screen.dart';
import 'package:company_application/features/home/views/home_screen.dart';
import 'package:company_application/features/onboarding/views/carousel_page.dart';
import 'package:company_application/features/splash/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Import the user model

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
       ChangeNotifierProvider(create: (_) => User(),),


      ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Company App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/', 
          routes: {
            '/': (context) => SplashScreen(),
            '/carousel':(context) => CarouselPage(),
            '/login': (context) => LoginPage(),
            '/home': (context) => HomeScreen(),
            
          },
        ),
      );
    
  }
}
