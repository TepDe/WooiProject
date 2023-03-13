import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wooiproject/GlobalControl/StorageKey.dart';
import 'package:wooiproject/LoginScreen.dart';

import '../ViewScreen.dart';

class GlobalController {
  var UID = '';
  var userEmail = '';
  late Position position;
  late LatLng currentPostion;
  var latitude = 0.0;
  var longitude = 0.0;
  var getLatitude;
  var getLocation;
  var getLongitude;
  var getIsGoOnline;
  var getPhoneNumber;
  var getEmail;
  var getPassword;
  var getUserName;
  var getUserID;
  var getUid;

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
    latitude = position.latitude;
    longitude = position.longitude;
    uploadLocation(la: latitude, long: longitude);
  }

  DatabaseReference goOnline = FirebaseDatabase.instance.ref("Driver");
  CollectionReference userSign =
      FirebaseFirestore.instance.collection('UserSign');
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  reInsert() {
    userSign.doc(UID).set({
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "email": auth.currentUser?.email.toString(),
      "uid": auth.currentUser?.uid,
    });
  }

  uploadLocation({la, long}) async {
    await userSign
        .doc(UID)
        .update({"latitude": la.toString(), "longitude": long.toString()});
  }

  fetchUserData() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid.toString())
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      getLatitude = await documentSnapshot['latitude'];
      getLongitude = await documentSnapshot['longitude'];
      getUid = await documentSnapshot['uid'];
      getEmail = await documentSnapshot['email'];
      getPassword = await documentSnapshot['password'];
      getUserID = await documentSnapshot['userID'];
    });
  }

  userLogOut() async {
    await auth.signOut().then((value) => Get.to(LogInScreen()));
  }

  onCreatePackage() {}
  final str = StorageKey();

  Future<void> storeUser({email, password, uid}) async {
    // CollectionReference collectionReference =
    //     FirebaseFirestore.instance.collection('Users').doc(uid);
    position = await GeolocatorPlatform.instance.getCurrentPosition();
    latitude = position.latitude;
    longitude = position.longitude;
    var documentStream =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    try {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .get()
          .then((doc) async {
        print('User name: ${doc.exists}');
        print('User name: ${doc.exists}');
        if (doc.exists == false) {
          await documentStream
              .set({
                'email': email,
                'password': password,
                'uid': uid,
                'longitude': longitude,
                'latitude': latitude,
              })
              .then((value) => Get.to(const ViewScreen()))
              .catchError((error) => print("Failed to add user: $error"));
          print('User name: ${doc.exists}');
        } else {
          await documentStream
              .update({
                'email': email,
                'password': password,
                'uid': uid,
                'longitude': longitude,
                'latitude': latitude,
              })
              .then((value) => Get.to(const ViewScreen()))
              .catchError((error) => print("Failed to add user: $error"));
          print('Name field does not exist in document${doc.exists}');
        }
      });
    } catch (e) {
      print('login screen error $e');
    }

    // if (getUserID != null) {
    //
    // } else {
    //   int? userID;
    //   var rng = Random();
    //   userID = rng.nextInt(999999);
    //
    //   documentStream
    //       .update({
    //         'email': email,
    //         'password': password,
    //         'uid': uid,
    //         'longitude': longitude,
    //         'latitude': latitude,
    //         'userID': userID,
    //       })
    //       .then((value) => print("User Added"))
    //       .catchError((error) => print("Failed to add user: $error"));
    // }
  }

  globalSetData({email, password, uid}) {
    var documentStream =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    documentStream
        .set({
          'email': email,
          'password': password,
          'uid': uid,
          'longitude': longitude,
          'latitude': latitude
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  ///Working
  // Future<void> checkUserID(uid) async {
  //   // CollectionReference collectionReference =
  //   //     FirebaseFirestores.instance.collection('Users').doc(uid);
  //   var documentStream =
  //       FirebaseFirestore.instance.collection('Users').doc(uid);
  //   await documentStream.get().then((DocumentSnapshot documentSnapshot) {
  //     var a = documentSnapshot['email'];
  //     var asdd = documentSnapshot['password'];
  //     var dsaa = documentSnapshot['uid'];
  //     print('$a, $asdd, $dsaa');
  //     print('$a, $asdd, $dsaa');
  //   });
  // }

  checkUserID(uid) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {});
    // FirebaseFirestore.instance
    //     .collection('Users')
    //     .doc(uid)
    //     .get()
    //     .then((DocumentSnapshot documentSnapshot) async {
    //   Map data = documentSnapshot as Map;
    //   print(data);
    //   print(data);
    //   data.forEach((key, value) {});
    // });
    print(getUserID);
    print(getUserID);
  }

  Future<SharedPreferences> onSaveLocalStorage(
      {latitude,
      longitude,
      isGoOnline,
      phoneNumber,
      email,
      password,
      userID,
      userName,
      uid}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(str.latitude, latitude ?? 0.0);
    await prefs.setDouble(str.longitude, longitude ?? 0.0);
    await prefs.setBool(str.isGoOnline, isGoOnline ?? false);
    await prefs.setInt(str.phoneNumber, phoneNumber ?? 0);
    await prefs.setString(str.email, email ?? '');
    await prefs.setString(str.uid, uid ?? '');
    await prefs.setString(str.userID, userID ?? '');
    await prefs.setString(str.password, password ?? '');
    await prefs.setString(str.userName, userName ?? '');
    return prefs;
  }

  Future<SharedPreferences> onGetLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    getLatitude = prefs.getDouble(str.latitude);
    getLongitude = prefs.getDouble(str.longitude);
    getIsGoOnline = prefs.getBool(str.isGoOnline);
    getPhoneNumber = prefs.getInt(str.phoneNumber);
    getEmail = prefs.getString(str.email);
    getUid = prefs.getString(str.uid);
    getUserID = prefs.getString(str.userID);
    getPassword = prefs.getString(str.password);
    getUserName = prefs.getString(str.userName);
    return prefs;
  }

  Future<String> fetchUserID() async {
    String UserID = '';
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid.toString())
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      UserID = await documentSnapshot['userID'];
    });
    return UserID;
  }

  // Future<void> requestPackage({uid, phoneNumber, location}) async {
  //   position = await GeolocatorPlatform.instance.getCurrentPosition();
  //   latitude = position.latitude;
  //   longitude = position.longitude;
  //   DatabaseReference packageRequest =
  //       FirebaseDatabase.instance.ref("PackageRequest");
  //   await packageRequest
  //       .child(auth.currentUser!.uid)
  //       //.child(getUserID.toString())
  //       .push()
  //       .set({
  //     "userName": 'Tep',
  //     "uLatitude": latitude,
  //     "uLongitude": longitude,
  //     "package": {
  //       "latitude": latitude,
  //       "longitude": longitude,
  //       "phoneNumber": phoneNumber,
  //       "location": location,
  //       //"qty": qty,
  //     }
  //   });
  // }
  Future<void> requestPackage({uid, phoneNumber, location}) async {
    position = await GeolocatorPlatform.instance.getCurrentPosition();
    latitude = position.latitude;
    longitude = position.longitude;
    DatabaseReference packageRequest =
        FirebaseDatabase.instance.ref("PackageRequest");
    await packageRequest.child(auth.currentUser!.uid)
        //.child(getUserID.toString())
        .update({
      "userName": 'Tep',
      "uLatitude": latitude,
      "uLongitude": longitude,
    }).then((value) =>
            packageRequest.child(auth.currentUser!.uid).child('package').push().update({
              'location': location,
              'phoneNumber': phoneNumber,
            }));
  }
}

class PackageData {
  String latitude = '';
  String longitude = '';
  String phoneNumber = '';
  String location = '';
  String qty = '';
}
