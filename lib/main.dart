import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task7/login/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreenPage(),
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(useMaterial3: true),
    );
  }
}

