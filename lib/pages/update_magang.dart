import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task7/pages/home_pages.dart';

class UpdateMagangPage extends StatefulWidget {

  final dynamic data;
  final String id;

  UpdateMagangPage({Key? key, required this.data, required this.id}) : super(key: key);

  @override
  State<UpdateMagangPage> createState() => _UpdateMagangPageState();
}

class _UpdateMagangPageState extends State<UpdateMagangPage> {

  File? _imgFile;
  final picker = ImagePicker();
  late User? _user;
  late StreamSubscription<User?> _userSubscription;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController _name = TextEditingController();
  TextEditingController _gender = TextEditingController();
  TextEditingController _agama = TextEditingController();
  TextEditingController _kampus = TextEditingController();

  Future<void> getImage() async{
    try{
      var image = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _imgFile = File(image!.path);
      });
    }catch(exp){
      print(exp);
    }
  }

  Future<void> editDataMagang() async{
    try{
      DocumentReference<Map<String, dynamic>> editMagang =
      firestore.collection("magang").doc(widget.id);

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child(DateTime.now().toString() + ".jpg");

      UploadTask uploadTask = ref.putFile(_imgFile!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      String _imageUrl = await taskSnapshot.ref.getDownloadURL();

      await editMagang.update({
        "name": _name.text,
        "gender": _gender.text,
        "agama": _agama.text,
        "kampus": _kampus.text,
        "imgUrl": _imageUrl,
        "userId": _user!.uid,
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));

    }catch(exp){
      print(exp);
    }
  }

  @override
  void initState() {
    _name.text = widget.data["name"];
    _gender.text = widget.data["gender"];
    _agama.text = widget.data["agama"];
    _kampus.text = widget.data["kampus"];

    _userSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Update Magang"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [

            Container(
              child: InkWell(
                onTap: (){
                  getImage();
                },
                child: _imgFile == null
                  ? (
                    widget.data["imgUrl"] == null
                        ? Image.asset("assets/images/foto-profile.png")
                        : Image.network(widget.data["imgUrl"], width: 200, height: 200,)

                ) : Image.file(_imgFile!, width: 200, height: 200,),
              ),
            ),

            SizedBox(height: 50),
            TextFormField(
              controller: _name,
              decoration: InputDecoration(
                  prefixIcon: Icon(CupertinoIcons.person),
                  border: OutlineInputBorder(
                      borderSide: BorderSide()
                  )
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _gender,
              decoration: InputDecoration(
                  prefixIcon: Icon(CupertinoIcons.person),
                  border: OutlineInputBorder(
                      borderSide: BorderSide()
                  )
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _agama,
              decoration: InputDecoration(
                  prefixIcon: Icon(CupertinoIcons.person),
                  border: OutlineInputBorder(
                      borderSide: BorderSide()
                  )
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _kampus,
              decoration: InputDecoration(
                  prefixIcon: Icon(CupertinoIcons.person),
                  border: OutlineInputBorder(
                      borderSide: BorderSide()
                  )
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: MaterialButton(
          onPressed: (){
            editDataMagang();
          },
          color: Colors.green,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none
          ),
          height: 50,
          child: Text("Save Changes", style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
