import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task7/auth/auth_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String idUser = '';
  String name = '';
  String email = '';

  User? user;

  void getUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        name = user.displayName ?? '';
        email = user.email ?? '';
        idUser = user.uid ?? '';
      });
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }


      @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Profile"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Card(
              elevation: 3,
              child: ListTile(
                title: Text(name, style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                )),
                subtitle: Text(email),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20),
        child: MaterialButton(
          onPressed: (){
            AuthController().logoutController(context);
          },
          height: 50,
          color: Colors.green,
          shape: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text("Logout", style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
