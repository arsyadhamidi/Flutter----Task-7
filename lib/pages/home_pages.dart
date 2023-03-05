import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task7/auth/auth_controller.dart';
import 'package:task7/pages/add_magang.dart';
import 'package:task7/pages/profile.dart';
import 'package:task7/pages/update_magang.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String name = '';
  String email = '';

  void getUser(){
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        name = user.displayName ?? '';
        email = user.email ?? '';
      });
    }
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Object?>> streamData(){
    CollectionReference datamagang = firestore.collection("magang");

    return datamagang.snapshots();
  }

  Future<void> deleteDataMagang(String id) async{
    DocumentReference docRef = firestore.collection("magang").doc(id);
    try{
      docRef.delete();
    }catch(exp){}

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
        title: Text("Udacoding Store"),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => ProfilePage()));
              },
              icon: Icon(CupertinoIcons.person_crop_circle, size: 30,)
          ),
          IconButton(onPressed: (){
            AuthController().logoutController(context);
          },
              icon: Icon(Icons.login)
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Object?>>(
        stream: streamData(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.active) {
            var lisAllDocument = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                  itemCount: lisAllDocument.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ListTile(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => UpdateMagangPage(
                                  id: snapshot.data!.docs[index].id,
                                  data: lisAllDocument[index],
                                )));
                          },
                          leading: lisAllDocument[index]["imgUrl"] == null
                              ? Image.asset("assets/images/foto-profile.png")
                              : Image.network(lisAllDocument[index]["imgUrl"])
                          ,
                          title: Text(lisAllDocument[index]["name"],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            )),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(lisAllDocument[index]["gender"]),
                              Text(lisAllDocument[index]["agama"]),
                              Text(lisAllDocument[index]["kampus"]),
                            ],
                          ),
                          trailing: IconButton(
                              onPressed: () async{
                                 await deleteDataMagang(
                                     snapshot.data!.docs[index].id,
                                 );
                              },
                              icon: Icon(CupertinoIcons.delete)
                          ),
                        ),
                      ),
                    );
                  },
              ),
            );

          }

          return Center(child: CircularProgressIndicator(),);
        },
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddMagangPage()));
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.green,
        child: Icon(CupertinoIcons.add),
      ),
    );
  }
}
