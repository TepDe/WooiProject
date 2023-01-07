import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapScreen extends StatelessWidget {
  MapScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('user');
    DatabaseReference ref = FirebaseDatabase.instance.ref("user");
    final readStorage = FirebaseDatabase.instance;
    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
        'name': 'dasdasd', // John Doe
        'age': 3213, // Stokes and Sons
        'note': 'age' // 42
      })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }
    readDataBase(){
      var send = readStorage.reference();
      send.child('location').push().child('User location').set("phnom pehn").asStream();
    }
    return Scaffold(
      body: Column(
        children: [
          TextButton(
            onPressed: addUser,
            child: Text(
              "Add User",
            ),
          ),
          TextButton(
            onPressed: readDataBase,
            child: Text(
              "real time database",
            ),
          ),
        ],
      ),
    );
  }

  final ft = Get.put(FirebaseText());
}

class FirebaseText extends GetxController {
  FirebaseFirestore dsad = FirebaseFirestore.instance;

  int age = 321324;
  var name = 'dasdasd'.obs;
  var note = 'dasdasd'.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  CollectionReference users = FirebaseFirestore.instance.collection('user');

  Future<void>addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
          'name': 'dasdsa', // John Doe
          'note': 'erwrfewrwf', // Stokes and Sons
          'age': 321 // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error")

    );

  }
}
