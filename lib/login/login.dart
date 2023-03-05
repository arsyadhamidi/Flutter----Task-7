import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task7/auth/auth_controller.dart';
import 'package:task7/login/registrasi.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

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
                    Colors.lightGreen,
                    Colors.blue
                  ]
                )
              ),
              child: MaterialButton(
                  onPressed: (){
                    AuthController().loginController(
                        context,
                        _email.text,
                        _password.text
                    );
                  },
                child: Text("Login", style: TextStyle(color: Colors.white),),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account ?", style: TextStyle(fontSize: 16),),
                TextButton(
                    onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => RegistrasiPage()));
                    },
                    child: Text("Register !", style: TextStyle(fontSize: 16),),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
