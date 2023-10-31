import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/EditProfileScreen.dart';
import 'package:wooiproject/GlobalControl/StorageKey.dart';
import 'package:wooiproject/GlobalControl/clsField.dart';
import 'package:wooiproject/GlobalControl/jsonModule.dart';
import 'package:wooiproject/GlobalControl/moduleObject.dart';
import 'package:wooiproject/LoginScreen.dart';
import 'package:wooiproject/SetUpScreen.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';

import '../ViewScreen.dart';
import '../WidgetReUse/ReUseWidget.dart';

class GlobalController {
  late Position position;
  double latitude = 0.0;
  double longitude = 0.0;

  Future<Position> requestUserPermissionLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  DatabaseReference goOnline = FirebaseDatabase.instance.ref("Driver");
  FirebaseAuth auth = FirebaseAuth.instance;

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

  CollectionReference documentStream =
      FirebaseFirestore.instance.collection('Users');

  Future<void> storeUser({email, password, uid}) async {
    position = await GeolocatorPlatform.instance.getCurrentPosition();
    Random random = Random();
    try {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.currentUser!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          return;
        } else {
          await documentStream.doc(auth.currentUser!.uid).set({
            'email': email.toString(),
            'password': password.toString(),
            'uid': auth.currentUser!.uid.toString(),
            'userID': random.nextInt(999999).toString(),
            'latitude': position.latitude.toString(),
            'longitude': position.longitude.toString(),
          });
          await checkUserInformation();
        }
      });
      await checkUserInformation();
    } catch (e) {
      print('login screen error $e');
    }
  }

  Future<void> checkUserInformation() async {
    await documentStream
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
          data['phoneNumber'] == null ||
          data['bankCode'] == null ||
          data['bankName'] == null) {
        Get.to(() => SetUpScreen());
      } else {
        Get.to(() => ViewScreen());
      }
    });
  }

  DatabaseReference packageRequest =
      FirebaseDatabase.instance.ref("PackageRequest");

  final field = FieldData();
  final fieldInfo = FieldInfo();

  Future<void> createPackage(
      {price,
      userName,
        generalInfo,
      bankName,
      userPhoneNumber,
      note,
      packageID,
      uid,
      phoneNumber,
      location,
      qty,
      tokenKey,
      abaCode,
      chatid,
      data,
        genToken, genChatID

      }) async {
    try{

      position = await GeolocatorPlatform.instance.getCurrentPosition();
      latitude = position.latitude;
      longitude = position.longitude;
      String pushKey = generatePushKey();

      var json = {
        "uid": "${auth.currentUser!.uid.toString()}",
        "location": "${location.toString()}",
        "pushKey": "${pushKey.toString()}",
        "phoneNumber": "${phoneNumber.toString()}",
        "token": "${tokenKey.toString()}",
        "chatid": "${chatid.toString()}",
        "latitude": "${latitude.toString()}",
        "bankName": "${bankName.toString()}",
        "longitude": "${longitude.toString()}",
        "qty": "${qty.toString()}",
        "packageID": "${packageID.toString()}",
        "note": "${note.toString()}",
        "price": "${price.toString()}",
        "recLatitude": "${latitude.toString()}",
        "recLongitude": "${longitude.toString()}",
        "senderPhone": "${generalInfo['phoneNumber']}",
        "senderName": "${userName.toString()}",
        "bankCode": "${abaCode.toString()}",
        "paidStatus": "",
        "status": 'request',
        "date": DateTime.now().toString(),
      };
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
          .update(json));
      await uploadToTelegram(
        chatid: genChatID,
        token: genToken,
        data: json,
      );
    }catch(e){

    }

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

  final users = FirebaseFirestore.instance.collection('Users');

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

  storeSetUpAccount(
      {bankName, phoneNumber, firstname, lastname, bankCode}) async {
    try {
      users
          .doc(auth.currentUser!.uid)
          .update({
            fieldInfo.bankCode: bankCode,
            "bankName": bankName,
            'phoneNumber': phoneNumber,
            'firstname': firstname,
            'lastname': lastname,
          })
          .then((value) => print("User's Property Deleted"))
          .catchError(
              (error) => print("Failed to delete user's property: $error"));
      Get.to(() => ViewScreen());
    } catch (e) {
      final reUse = ReUseWidget();
      reUse.reUseCircleDialog(function: 'error', content: const Text("error"));
    }
  }

  Future<void> editPackage(
      {price,
      data,
      userName,
      userPhoneNumber,
      note,
      packageID,
      uid,
      bankCode,
      phoneNumber,
      location,
      qty,
      tokenKey,
      bankName,
      chatid}) async {
    // DateTime now = DateTime.now();
    // String formattedDate = DateFormat(' dd-MM-yyyy HH:mm aa').format(now);
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
              field.date: DateTime.now().toString(),
              field.qty: qty.toString(),
              field.packageID: packageID.toString(),
              field.note: note.toString(),
              field.status: 'request',
              field.price: price.toString(),
              field.bankCode: bankCode,
              field.bankName: bankName,
              field.recLatitude: latitude.toString(),
              field.recLongitude: longitude.toString(),
              field.senderPhone:
                  await fetchUserData(fieldInfo.phoneNumber).toString(),
            }));
  }

  updateStatus({uid, key, status}) async {
    await packageRequest.child(uid).child('package').child(key).update(
        {'status': status, field.packageID: auth.currentUser!.uid.toString()});
  }

  Future<void> backToReturn({data}) async {
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
      field.date: DateTime.now(),
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

  alertNoInternet(context) async {
    final reUse = ReUseWidget();
    final theme = ThemesApp();
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      reUse.reUseCircleDialog(
          function: 'nointernet',
          disposeAllow: false,
          context: context,
          icon: Icons.wifi,
          title: 'Connection Lost',
          content: Center(
            child: Text(
              'No internet connection please try again',
              style: TextStyle(
                color: theme.black,
              ),
            ),
          ));
    }
  }

  var showPrefix = false;
  var isLogin = true;
  var otp = "";
  var isOtpSent = false;
  var resendAfter = 30;
  var resendOTP = false;
  var firebaseVerificationId = "";
  var statusMessage = "".obs;
  var statusMessageColor = Colors.black;
  late Timer timer;

  String phoneNumber = '+85578344511';

  getOtp() async {
    try {
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          firebaseVerificationId = verificationId;
          isOtpSent = true;
          statusMessage.value = "OTP sent to " + phoneNumber;
          startResendOtpTimer();
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        print(e);
      }
    }
  }

  resendOtp() async {
    resendOTP = false;
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91' + phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        firebaseVerificationId = verificationId;
        isOtpSent = true;
        statusMessage.value = "OTP re-sent to +91" + phoneNumber;
        startResendOtpTimer();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  verifyOTP() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      statusMessage.value = "Verifying... " + otp;
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: firebaseVerificationId, smsCode: otp);
      // Sign the user in (or link) with the credential
      await auth.signInWithCredential(credential);
    } catch (e) {
      statusMessage.value = "Invalid  OTP";
      statusMessageColor = Colors.red;
    }
  }

  startResendOtpTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendAfter != 0) {
        resendAfter--;
      } else {
        resendAfter = 30;
        resendOTP = true;
        timer.cancel();
      }
    });
  }

  bool isSuccessEditProfile = false;
  final clsLan = ClsLanguage();

  editProfile({value, context}) async {
    final reUse = ReUseWidget();
    final theme = ThemesApp();
    try {
      await documentStream.doc(auth.currentUser!.uid).update({
        'firstname': value.firstName,
        'lastname': value.lastName,
        'phoneNumber': value.phoneNumber,
        'token': value.token,
        'chatid': value.chatid,
        'bankCode': value.bankCode,
        'bankName': value.bankName,
      }).then((value) async {
        print("User Added");
        Navigator.pop(context);
        await reUse.reUseCircleDialog(
            context: context,
            icon: Icons.check_circle_rounded,
            title: clsLan.stCom,
            content: Center(
              child: Text(
                clsLan.updatedAccount,
                style: TextStyle(
                  color: theme.black,
                ),
              ),
            ));
      }).catchError((error) async {
        print("Failed to add user: $error");
        await reUse.reUseCircleDialog(
            context: context,
            icon: Icons.close_rounded,
            title: clsLan.fail,
            content: Center(
              child: Text(
                clsLan.tryAgain,
                style: TextStyle(
                  color: theme.black,
                ),
              ),
            ));
      });
    } catch (e) {
      print(e);
    }
  }

  List payWay = [
    {
      "name": "wing",
      "img": "assets/images/wing.webp",
    },
    {
      "name": "aba",
      "img": "assets/images/aba.webp",
    },
    {
      "name": "vattanac",
      "img": "assets/images/vattanac.webp",
    }
  ];
  List filteredList = [];

  Future<String> selectPayWay(data) async {
    filteredList = payWay
        .where((item) =>
            item['name'].toLowerCase().toString().trim().contains(data))
        .toList();
    return filteredList[0]['name'];
  }

  getBank({bankName}) {
    int index = payWay.indexWhere((person) => person['name'] == bankName);
    return index;
  }

  getBankImage({bankName}) {
    var object =
        payWay.where((item) => item['name'].contains(bankName)).toList();
    return object;
  }

  Future<String> checkAccountType() async {
    String result = "";
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.currentUser!.uid.toString())
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          Map data = documentSnapshot.data() as Map;
          if (data["accountType"] != "Users") {
            return result = "type";
          }
          if (data["isBanned"] != "false") {
            return result = "banned";
          }
          // if (data["signInToken"] != "false") {
          //   return result = "token";
          // }
          else {
            return result = "true";
          }
        } else {
          return result = "";
        }
      });
    } on FirebaseFirestore catch (e) {
      print(e);
      Get.back();
      result = e.toString();
    }

    return result;
  }

  Future<bool> updateOneField(
      {required String field,
      required firebaseFireStore,
      data,
      required String value,
      context,
      required bool allowDialog}) async {
    final reUse = ReUseWidget();
    bool isReady = false;
    await FirebaseFirestore.instance
        .collection(firebaseFireStore)
        .doc(data)
        .update({
      field: value,
    }).then((value) async {
      isReady = true;
    }).catchError((error) async {
      isReady = false;
      if (allowDialog == true) {
        reUse.reUseCircleDialog(
            onTap: () => Get.back(),
            context: context,
            title: 'បរាជ័យ',
            content: reUse.reUseText(
                content: "បរាជ័យ សូម​ព្យាយាម​ម្តង​ទៀត​នៅ​ពេល​ក្រោយ"));
      } else {}
    });
    return isReady;
  }

  isLogOut() async {
    await updateOneField(
        field: 'signInToken',
        value: "false",
        firebaseFireStore: "Users",
        data: auth.currentUser!.uid,
        allowDialog: true);
    await auth.signOut().then((value) => Get.to(() => const LogInScreen()));
  }

  onGetGeneralInfo() async {
    var object;
    await FirebaseFirestore.instance
        .collection("General")
        .doc("GeneralInfo")
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      object = documentSnapshot.data();
    });
    return object;
  }

  uploadToTelegram({
    token,
    chatid,
    data,
  }) async {
    try{
      final String _sendMessageUrl =
          'https://api.telegram.org/bot$token/sendMessage';
      JsonModule jsonModule = JsonModule();
      var jsonConvert = jsonModule.toTelegramString(data);
      final response = await http.post(
        Uri.parse(_sendMessageUrl),
        body: {
          'chat_id': chatid,
          'text': jsonConvert,
        },
      );
      if (response.statusCode != 200) {
        print('Failed to send message: ${response.statusCode}');
      }
    }catch(e){

    }
  }

  String formatDateTime (dateTime) {
    DateTime result = DateTime.parse(dateTime);
    return DateFormat('yyyy-MM-dd HH:mm aa').format(result);
  }
}
