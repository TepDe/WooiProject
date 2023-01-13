import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
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

  onRequestLocationTest() async {
    generateRequestId();
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) => currentPosition = position);
    refs.onChildAdded.listen((dasd){

    });

    refs.onValue.listen((event) async {
      var as = event.snapshot.value;
      print('=====================${as}');
    });
  }

  var requestStatus = 'Request'.obs;

  removeRequest() {
    requestStatus.value = 'Request';
    remove.child(requestId.value.toString()).remove();
  }

  generateRequestId() {
    var rng = Random();
    for (var i = 0; i < 10; i++) {
      requestId.value = rng.nextInt(100);
    }
  }

  final firestore = FirebaseFirestore.instance;
  fireStore() {
    return ;
  }
}

class UpDateLocation extends GetxController {
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
  }

  var firestore = FirebaseFirestore.instance.collection('users').snapshots();
  var latitude = 0.obs;
  var longtitude = 0.obs;
  var text;

  getLocation() async {
    DatabaseReference updateLocation = FirebaseDatabase.instance.ref('users');
    DatabaseEvent event = await updateLocation.once();
    Stream<DatabaseEvent> stream = updateLocation.onValue;
    update();
    var t = event.snapshot.child('latitude').value.toString();
    var y = event.snapshot.child('longitude').value.toString();

    stream.listen((DatabaseEvent event) {
      print('Event Type: ${event.type}');
      print('Snapshot: ${event.snapshot}');
    });
  }
}