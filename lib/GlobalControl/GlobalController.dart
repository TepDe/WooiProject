import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wooiproject/LoginScreen.dart';

class GlobalController extends GetxController {
  var UID = ''.obs;
  var userEmail = ''.obs;

  late Position position;
  late LatLng currentPostion;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

  }

  Future<Position> requestUserPermissionLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  getUserLocation() async {
    position = await GeolocatorPlatform.instance.getCurrentPosition();
    currentPostion = LatLng(position.latitude, position.longitude);
    latitude.value = position.latitude;
    longitude.value = position.longitude;
    uploadLocation(la:latitude.value,long: longitude.value );

    update();
  }

  DatabaseReference goOnline = FirebaseDatabase.instance.ref("Driver");
  CollectionReference userSign =
      FirebaseFirestore.instance.collection('UserSign');
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  reInsert() {
    firebaseAuth = FirebaseAuth.instance;
    userSign.doc(UID.value).set({
      "latitude": latitude.value.toString(),
      "longitude": longitude.value.toString(),
      "email": firebaseAuth.currentUser?.email.toString(),
      "uid": firebaseAuth.currentUser?.uid,
    });
    update();
  }

  uploadLocation({la, long}) async {
    await userSign.doc(UID.value).update({
      "latitude": la.toString(),
      "longitude": long.toString()
    });

    update();
  }

  fetchUserData() async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('UserSign').doc(UID.value.toString()).get();
    userEmail.value = documentSnapshot.get('email');
    longitude.value = documentSnapshot.get('longitude');
    latitude.value = documentSnapshot.get('latitude');
    UID.value = documentSnapshot.get('uid');
    update();
  }

  userLogOut() async {
    await firebaseAuth.signOut().then((value) => Get.to(LogInScreen()));
    update();
  }

}
