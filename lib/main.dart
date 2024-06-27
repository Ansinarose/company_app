
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'features/auth/models/user_model.dart';
import 'features/splash/views/splash_screen.dart';
import 'features/onboarding/views/carousel_page.dart';
import 'features/auth/views/login_screen.dart';
import 'features/home/views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => User()),
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
          '/carousel': (context) => CarouselPage(),
          '/login': (context) => LoginPage(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}
