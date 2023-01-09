import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class GlbSuperController extends GetxController{

  CollectionReference users = FirebaseFirestore.instance.collection('user');
  Future<void> storeUserLogin({name,phone}) {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
      'name': name, // John Doe
      'phone number': phone, // Stokes and Sons

    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }


  DatabaseReference refs = FirebaseDatabase.instance.ref("users/123");
  onRequestLocation() async {
    await refs.set({"name": "John", "age": 18, "address": "100 Mountain View"});
  }
}