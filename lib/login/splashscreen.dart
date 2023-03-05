import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task7/login/login.dart';
import 'package:task7/pages/home_pages.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  void splash(){
    Timer(Duration(seconds: 3), () async {
      var auth = await FirebaseAuth.instance.currentUser;
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => auth != null ? HomePage() :
          LoginPage()),
              (route) => false);
    });
  }

  @override
  void initState() {
    splash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          Center(
            child: Image.asset("assets/images/logo.png"),
          ),
          Spacer(),
          Text("Udacoding Firebase", style: TextStyle(fontSize: 20),),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
