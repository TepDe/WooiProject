import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GlbSuperController extends GetxController {

  CollectionReference users = FirebaseFirestore.instance.collection('user');

  Future<void> storeUserLogin({name, phone}) {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
      'name': name, // John Doe
      'phone number': phone, // Stokes and Sons

    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  var requestId = 0.obs;
  var atRemove= 0.obs;
  DatabaseReference refs = FirebaseDatabase.instance.ref("users");
  DatabaseReference remove = FirebaseDatabase.instance.ref("users");
  Position? currentPosition;

  onRequestLocation() async {
    generateRequestId();
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) => currentPosition = position);
    await refs.child(requestId.value.toString()).set({
      "Phone Number": 078344511,
      "latitude": currentPosition!.latitude,
      "longitude": currentPosition!.longitude
    });
  }

  var requestStatus = 'Request'.obs;

  removeRequest()  {
    requestStatus.value = 'Request';
    remove
        .child(requestId.value.toString())
        .remove();

  }

  generateRequestId() {
    var rng = Random();
    for (var i = 0; i < 10; i++) {
      requestId.value = rng.nextInt(100);
    }

  }
}