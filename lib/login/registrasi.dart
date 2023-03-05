import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task7/auth/auth_controller.dart';
import 'package:task7/login/login.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  State<RegistrasiPage> createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

    bool _obsurce = true;

  void inHidePassword(){
    if(_obsurce == true){
      setState(() {
        _obsurce = false;
      });
    }else{
      setState(() {
        _obsurce = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Spacer(),
            Center(
              child: Image.asset("assets/images/logo.png", scale: 3),
            ),
            SizedBox(height: 50),
            TextFormField(
              controller: _name,
              decoration: InputDecoration(
                  hintText: "Full Name",
                  prefixIcon: Icon(CupertinoIcons.person),
                  border: OutlineInputBorder(
                      borderSide: BorderSide()
                  )
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _email,
              decoration: InputDecoration(
                  hintText: "Email Address",
                  prefixIcon: Icon(CupertinoIcons.envelope),
                  border: OutlineInputBorder(
                      borderSide: BorderSide()
                  )
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _password,
              obscureText: _obsurce,
              decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: IconButton(
                      onPressed: (){
                        inHidePassword();
                      },
                      icon: Icon(_obsurce
                          ? CupertinoIcons.eye_slash
                          : CupertinoIcons.eye
                      )
                  ),
                  prefixIcon: Icon(CupertinoIcons.padlock),
                  border: OutlineInputBorder(
                      borderSide: BorderSide()
                  )
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: [
                        Colors.green,
                        Colors.blue
                      ]
                  )
              ),
              child: MaterialButton(
                onPressed: (){
                  AuthController().registerController(
                      context,
                      _name.text,
                      _email.text,
                      _password.text
                  );
                },
                child: Text("Sign Up", style: TextStyle(color: Colors.white),),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Your have an account ?", style: TextStyle(fontSize: 16),),
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Login !", style: TextStyle(fontSize: 16),),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
