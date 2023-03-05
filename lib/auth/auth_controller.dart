
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task7/login/login.dart';
import 'package:task7/login/splashscreen.dart';
import 'package:task7/pages/home_pages.dart';

class AuthController{

  Future<void> loginController(BuildContext context, String email, String password) async{
    try{
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password);

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false);


    }catch(exp){}
  }

  Future<void> logoutController(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder:
            (context) => SplashScreenPage()), (route) => false);
  }


  Future<void> registerController(
      BuildContext context,
      String name,
      String email,
      String password,
      ) async{

    try{
      UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password
      );

      User? user = result.user;
      user?.updateDisplayName(name);
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }catch(exp){}

  }


}