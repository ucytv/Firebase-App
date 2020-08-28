import 'package:firebase_app/homepage_screen.dart';
import 'package:firebase_app/login_screen.dart';
import 'package:firebase_app/request_screen.dart';
import 'package:firebase_app/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: 'login',
      routes: {
        '/': (context) => LoginScreen(),
        'login': (context) => LoginScreen(),
        'login/homePage': (context) => HomePageScreen(),
        '/homePage': (context) => HomePageScreen(),
        '/homePage/login': (context) => LoginScreen(),
        'login/requestPassword': (context) => RequestScreen(),
        'login/requestPassword/login': (context) => LoginScreen(),
        '/requestPassword': (context) => RequestScreen(),
        '/signUp': (context) => SignUpScreen(),
      },

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
