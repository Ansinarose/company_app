import 'package:company_application/features/auth/views/login_screen.dart';
import 'package:company_application/features/home/views/home_screen.dart';
import 'package:company_application/features/onboarding/views/carousel_page.dart';
import 'package:company_application/features/photos/model/imageFormModel.dart';
import 'package:company_application/features/splash/views/splash_screen.dart';
import 'package:company_application/providers/category_provider.dart';
import 'package:company_application/providers/worker_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:company_application/features/services/model/service_model.dart';
import 'package:company_application/features/auth/models/user_model.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ServiceModel()),
        ChangeNotifierProvider(create: (context) => User()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => WorkerProvider()),
        ChangeNotifierProvider(create: (context) => ImageFormModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
    // home: HomeScreen(),
      // Other routes and configuration
      initialRoute: '/', 
        routes: {
          '/': (context) => SplashScreen(),
          '/carousel': (context) => CarouselPage(),
          '/login': (context) => LoginPage(),
          '/home': (context) => HomeScreen(),
        },
    );
  }
}
