import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wooiproject/GlobalControl/StorageKey.dart';
import 'package:wooiproject/GlobalControl/clsField.dart';
import 'package:wooiproject/LoginScreen.dart';
import 'package:wooiproject/SetUpScreen.dart';

import '../ViewScreen.dart';
import '../WidgetReUse/ReUseWidget.dart';

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
  var getField;
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

  Future<String> fetchUserData(whichField) async {
    String whichOfField = '';
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid.toString())
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      whichOfField = await documentSnapshot[whichField];
    });
    return whichOfField;
  }

  userLogOut() async {
    await auth.signOut().then((value) => Get.to(const LogInScreen()));
  }

  onCreatePackage() {}
  final str = StorageKey();
  CollectionReference documentStream =
      FirebaseFirestore.instance.collection('Users');

  Future<void> storeUser({email, password, uid}) async {
    position = await GeolocatorPlatform.instance.getCurrentPosition();
    latitude = position.latitude;
    longitude = position.longitude;
    Random random = Random();
    int randomNumber = random.nextInt(999999);
    try {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.currentUser!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          return;
        } else {
          documentStream.doc(auth.currentUser!.uid).set({
            'email': email.toString(),
            'password': password.toString(),
            'uid': auth.currentUser!.uid.toString(),
            'userID': randomNumber.toString(),
            'latitude': latitude.toString(),
            'longitude': longitude.toString(),
          });
          await checkUserInformation();
        }
      });
      await checkUserInformation();
    } catch (e) {
      print('login screen error $e');
    }
    //
    // documentStream
    //     .doc(auth.currentUser!.uid)
    //     .get()
    //     .then((DocumentSnapshot documentSnapshot) async {
    //   Map data = documentSnapshot.data() as Map;
    //   if (data['userID'] == null) {
    //     Random random = Random();
    //     int randomNumber = random.nextInt(999999);
    //     documentStream
    //         .doc(auth.currentUser!.uid)
    //         .update({'userID': randomNumber.toString()})
    //         .then((value) => print("User's Property Deleted"))
    //         .catchError(
    //             (error) => print("Failed to delete user's property: $error"));
    //   } else {}
    //   if (data['firstname'] == null ||
    //       data['lastname'] == null ||
    //       data['phoneNumber'] == null) {
    //     Get.to(const SetUpScreen());
    //   } else {
    //     Get.to(const ViewScreen());
    //   }
    // });
  }

  checkUserInformation() async {
    documentStream
        .doc(auth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      Map data = documentSnapshot.data() as Map;
      if (data['userID'] == null) {
        Random random = Random();
        int randomNumber = random.nextInt(999999);
        await documentStream
            .doc(auth.currentUser!.uid)
            .update({'userID': randomNumber.toString()})
            .then((value) => print("User's Property Deleted"))
            .catchError(
                (error) => print("Failed to delete user's property: $error"));
      } else {}
      if (data['firstname'] == null ||
          data['lastname'] == null ||
          data['phoneNumber'] == null) {
        Get.to(const SetUpScreen());
      } else {
        Get.to(const ViewScreen());
      }
    });
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
  DatabaseReference packageRequest =
      FirebaseDatabase.instance.ref("PackageRequest");

  final field = FieldData();
  final fieldInfo = FieldInfo();

  Future<void> createPackage(
      {price,
      userName,
      userPhoneNumber,
      note,
      packageID,
      uid,
      phoneNumber,
      location,
      qty,
      tokenKey,
      chatid,
      data}) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat(' dd-MM-yyyy HH:mm aa').format(now);
    position = await GeolocatorPlatform.instance.getCurrentPosition();
    latitude = position.latitude;
    longitude = position.longitude;

    String pushKey = generatePushKey();
    await packageRequest
        .child(auth.currentUser!.uid)
        //.child(getUserID.toString())
        .update({
      "userName": userName,
      "userPhoneNumber": userPhoneNumber,
      "uLatitude": latitude.toString(),
      "uLongitude": longitude.toString(),
    }).then((value) async => packageRequest
                .child(auth.currentUser!.uid)
                .child('package')
                .child(pushKey)
                .update({
              field.uid: auth.currentUser!.uid.toString(),
              field.location: location.toString(),
              field.pushKey: pushKey.toString(),
              field.phoneNumber: phoneNumber.toString(),
              field.token: tokenKey.toString(),
              field.chatid: chatid.toString(),
              field.latitude: latitude.toString(),
              field.longitude: longitude.toString(),
              field.date: formattedDate.toString(),
              field.qty: qty.toString(),
              field.packageID: packageID.toString(),
              field.note: note.toString(),
              field.status: 'request',
              field.price: price.toString(),
              field.recLatitude: latitude.toString(),
              field.recLongitude: longitude.toString(),
              field.senderPhone: await fetchUserData(fieldInfo.phoneNumber),
              field.senderName: userName,
            }));
  }

  String generatePushKey() {
    String pushKey = packageRequest.push().key.toString().trim();
    return pushKey;
  }

  generatePackageID() {
    Random random = Random();
    int randomNumber = random.nextInt(9999);
    String format = 'PK00';
    var id = format + randomNumber.toString();
    return id.toString();
  }

  var iconDialog;
  bool checker = false;
  String title = '';

  checkInput({location, phoneNumber, price, qty, context, note}) async {
    if (phoneNumber == '') {
      title = 'Error';
      return 'Phone Number Must Include';
    }
    if (location == '') {
      title = 'Error';
      return 'Location Must Include';
    }
    if (price == '') {
      title = 'Error';
      return 'Price Must Include';
    } else {
      createPackage(
          note: note.text.trim().toString(),
          packageID: generatePackageID.toString(),
          qty: qty.text.trim().toString(),
          phoneNumber: phoneNumber.text.trim().toString(),
          location: location.text.trim().toString());
    }
  }

  changeIcon({value, location, phoneNumber, price, qty, context, note}) {
    if (phoneNumber == '') {
      title = 'Error';
      return Icons.phone;
    } else if (location == '') {
      title = 'Error';
      return Icons.location_on_rounded;
    } else if (price == '') {
      title = 'Error';
      return Icons.monetization_on;
    } else {
      createPackage(
          note: note.text.trim().toString(),
          packageID: generatePackageID.toString(),
          qty: qty.text.trim().toString(),
          phoneNumber: phoneNumber.text.trim().toString(),
          location: location.text.trim().toString());
    }
  }

  List returnData = [];
  List completeList = [];
  List pendingList = [];
  List totalPackageList = [];

  returnListLength() async {
    DatabaseReference refs =
        FirebaseDatabase.instance.ref('Return').child(auth.currentUser!.uid);
    refs.onValue.listen((event) async {
      returnData.clear();
      DataSnapshot driver = event.snapshot;
      Map values = driver.value as Map;
      values.forEach((key, value) async {
        returnData.add(value);
      });
    });
    return returnData;
  }

  completeListLength() async {
    DatabaseReference refs =
        FirebaseDatabase.instance.ref('Complete').child(auth.currentUser!.uid);
    refs.onValue.listen((event) async {
      completeList.clear();
      DataSnapshot driver = event.snapshot;
      Map values = driver.value as Map;
      values.forEach((key, value) async {
        completeList.add(value);
      });
    });
    print(completeList);
    print(completeList);
    return completeList;
  }

  pendingListLength() async {
    DatabaseReference refs = FirebaseDatabase.instance.ref('Pending');
    refs.onValue.listen((event) async {
      pendingList.clear();
      DataSnapshot driver = event.snapshot;
      Map values = driver.value as Map;
      values.forEach((key, value) async {
        Map data = value[auth.currentUser!.uid] as Map;
        data.forEach((key, value) {
          pendingList.add(value);
        });
      });
    });
    return pendingList;
  }

  totalListLength() async {
    DatabaseReference refs = FirebaseDatabase.instance
        .ref('PackageRequest')
        .child(auth.currentUser!.uid);
    refs.onValue.listen((event) async {
      totalPackageList.clear();
      DataSnapshot driver = event.snapshot;
      Map values = driver.value as Map;
      values.forEach((key, values) async {
        Map data = values as Map;
        data.forEach((key, value) {
          totalPackageList.add(value);
        });
      });
    });
    return totalPackageList;
  }

  getTelegramTooken() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users
        .add({'name': 'John Doe', 'phone': '1234567890'})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  final users = FirebaseFirestore.instance.collection('Users');

  insertTelegramToken({token}) async {
    users.doc(auth.currentUser!.uid).update({
      'token': token,
    }).then((value) {
      print("User Added");
      FocusManager.instance.primaryFocus?.unfocus();
      Get.back();
    }).catchError((error) => print("Failed to add user: $error"));
  }

  insertTelegramChatID({chatid}) async {
    users.doc(auth.currentUser!.uid).update({
      'chatid': chatid,
    }).then((value) {
      print("User Added");
      FocusManager.instance.primaryFocus?.unfocus();
      Get.back();
    }).catchError((error) => print("Failed to add user: $error"));
  }

  deletePackage({witchDataBase, data, witchUID, witchPushKey}) async {
    await witchDataBase
        .child(auth.currentUser!.uid)
        .child('package')
        .child(witchPushKey)
        .remove();
  }
  deleteFromDriver({witchDataBase, data, witchUID, witchPushKey}) async {
    await witchDataBase
        .child(data[field.driverUID])
        .child(data[field.pushKey])
        .remove();
  }
  deleteFromReturn({witchDataBase, data, witchUID, witchPushKey}) async {
    await witchDataBase
        .child(data[field.uid])
        .child(data[field.pushKey])
        .remove();
  }

  deleteUserPackage({witchDataBase, data, witchUID, witchPushKey}) async {
    await witchDataBase.child(data[field.driverUID]);
  }

  storeSetUpAccount({phoneNumber, firstname, lastname}) async {
    users
        .doc(auth.currentUser!.uid)
        .update({
          'phoneNumber': phoneNumber,
          'firstname': firstname,
          'lastname': lastname,
        })
        .then((value) => print("User's Property Deleted"))
        .catchError(
            (error) => print("Failed to delete user's property: $error"));
  }

  Future<void> editPackage(
      {price,
      data,
      userName,
      userPhoneNumber,
      note,
      packageID,
      uid,
      phoneNumber,
      location,
      qty,
      tokenKey,
      chatid}) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat(' dd-MM-yyyy HH:mm aa').format(now);
    position = await GeolocatorPlatform.instance.getCurrentPosition();
    latitude = position.latitude;
    longitude = position.longitude;
    await packageRequest
        .child(auth.currentUser!.uid)
        //.child(getUserID.toString())
        .update({
      "userName": userName,
      "userPhoneNumber": userPhoneNumber,
      "uLatitude": latitude.toString(),
      "uLongitude": longitude.toString(),
    }).then((value) async => packageRequest
                .child(auth.currentUser!.uid)
                .child('package')
                .child(data[field.pushKey])
                .update({
              field.uid: auth.currentUser!.uid.toString(),
              field.location: location.toString(),
              field.pushKey: data[field.pushKey].toString(),
              field.phoneNumber: phoneNumber.toString(),
              field.token: tokenKey.toString(),
              field.chatid: chatid.toString(),
              field.latitude: latitude.toString(),
              field.longitude: longitude.toString(),
              field.date: formattedDate.toString(),
              field.qty: qty.toString(),
              field.packageID: packageID.toString(),
              field.note: note.toString(),
              field.status: 'request',
              field.price: price.toString(),
              field.recLatitude: latitude.toString(),
              field.recLongitude: longitude.toString(),
              field.senderPhone: await fetchUserData(fieldInfo.phoneNumber).toString(),
            }));
  }

  updateStatus({uid, key, status}) async {
    await packageRequest
        .child(uid)
        .child('package')
        .child(key)
        .update({'status': status, field.packageID: auth.currentUser!.uid.toString()});
  }

  Future<void> backToReturn({data}) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat(' dd-MM-yyyy HH:mm aa').format(now);
    position = await GeolocatorPlatform.instance.getCurrentPosition();
    latitude = position.latitude;
    longitude = position.longitude;
    await packageRequest
        .child(auth.currentUser!.uid)
        .child('package')
        .child(data[field.pushKey])
        .update({
      field.uid: data[field.uid].toString(),
      field.location: data[field.location].toString(),
      field.pushKey: data[field.pushKey].toString(),
      field.phoneNumber: data[field.phoneNumber].toString(),
      field.token: data[field.token].toString(),
      field.chatid: data[field.chatid].toString(),
      field.latitude: latitude.toString(),
      field.longitude: longitude.toString(),
      field.date: formattedDate.toString(),
      field.qty: data[field.qty].toString(),
      field.packageID: data[field.packageID].toString(),
      field.note: data[field.note].toString(),
      field.status: 'request',
      field.price: data[field.price].toString(),
      field.recLatitude: data[field.recLatitude].toString(),
      field.recLongitude: data[field.recLongitude].toString(),
      field.senderPhone: data[field.senderPhone].toString(),
      field.driverUID: data[field.driverUID].toString(),
      field.dLastName: data[field.dLastName].toString(),
      field.dFirstName: data[field.dFirstName].toString(),
    });
  }
}
