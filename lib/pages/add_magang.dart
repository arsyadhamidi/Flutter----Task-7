import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddMagangPage extends StatefulWidget {
  const AddMagangPage({Key? key}) : super(key: key);

  @override
  State<AddMagangPage> createState() => _AddMagangPageState();
}

class _AddMagangPageState extends State<AddMagangPage> {

  File? _imgFile;
  late User? _user;
  GlobalKey<FormState> _formKey = GlobalKey();
  late StreamSubscription<User?> _userSubscription;

  final picker = ImagePicker();
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

  @override
  void initState() {
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
    var placeholder = Container(
      width: 200,
      height: 200,
      child: Image.asset("assets/images/foto-profile.png"),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(
          child: Text("Add Magang"),
        ),
      ),

      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [

              Container(
                child: InkWell(
                  onTap: (){
                    getImage();
                  },
                  child: _imgFile == null
                      ? placeholder
                      : Image.file(_imgFile!, width: 200, height: 200,),
                ),
              ),

              SizedBox(height: 30),
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
                controller: _gender,
                decoration: InputDecoration(
                    hintText: "Gender",
                    prefixIcon: Icon(CupertinoIcons.person_2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide()
                    )
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _agama,
                decoration: InputDecoration(
                    hintText: "Agama",
                    prefixIcon: Icon(CupertinoIcons.macwindow),
                    border: OutlineInputBorder(
                        borderSide: BorderSide()
                    )
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _kampus,
                decoration: InputDecoration(
                    hintText: "Campus",
                    prefixIcon: Icon(CupertinoIcons.calendar),
                    border: OutlineInputBorder(
                        borderSide: BorderSide()
                    )
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: MaterialButton(
          onPressed: () async{
              if(_formKey.currentState!.validate()){
                if(_imgFile != null &&  _user != null){
                  FirebaseStorage storage = FirebaseStorage.instance;
                  Reference ref = storage.ref().child(DateTime.now().toString() + ".jpg");

                  UploadTask uploadTask = ref.putFile(_imgFile!);
                  TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

                  String _imageUrl = await taskSnapshot.ref.getDownloadURL();

                  FirebaseFirestore firestore = FirebaseFirestore.instance;

                  CollectionReference addMagang = firestore.collection("magang");

                  await addMagang.add({
                    "name": _name.text,
                    "gender": _gender.text,
                    "agama": _agama.text,
                    "kampus": _kampus.text,
                    "imgUrl": _imageUrl,
                    "userId": _user!.uid,
                  });

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green,
                        content: Row(
                          children: [
                            Icon(Icons.verified, color: Colors.white,),
                            SizedBox(width: 15),
                            Text("Data Add Magang Successfully!"),
                          ],
                        ),
                      )
                  );

                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                        content: Text("Data Add failed!"),
                    )
                  );
                }
              }
          },
          color: Colors.green,
          height: 50,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none
          ),
          child: Text("Save", style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
