import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/GlobalControl/StorageKey.dart';
import 'package:wooiproject/GlobalControl/clsField.dart';
import 'package:wooiproject/GlobalControl/jsonModule.dart';
import 'package:wooiproject/SetUpScreen.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';
import '../ViewScreen.dart';
import '../WidgetReUse/ReUseWidget.dart';

class GlobalController {
  late Position position;
  double latitude = 0.0;
  double longitude = 0.0;

  String currentVersion = "2";

  Future<Position> requestUserPermissionLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }

  DatabaseReference goOnline = FirebaseDatabase.instance.ref("Driver");
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<Map> onGetUserData() async {
    Map whichOfField = {};
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid.toString())
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      whichOfField = documentSnapshot.data() as Map;
    });
    return whichOfField;
  }

  CollectionReference userDB = FirebaseFirestore.instance.collection('Users');

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
          await userDB.doc(auth.currentUser!.uid).set({
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
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> checkUserInformation() async {
    await userDB.doc(auth.currentUser!.uid).get().then((DocumentSnapshot documentSnapshot) async {
      Map data = documentSnapshot.data() as Map;
      if (data['userID'] == null) {
        Random random = Random();
        int randomNumber = random.nextInt(999999);
        await userDB
            .doc(auth.currentUser!.uid)
            .update({'userID': randomNumber.toString()})
            .then((value) {})
            .catchError((error) {});
      } else {}
      if (data['firstname'] == null &&
          data['lastname'] == null &&
          data['phoneNumber'] == null &&
          data['bankCode'] == null &&
          data['bankName'] == null) {
        Get.to(() => const SetUpScreen());
      } else {
        Get.to(() => const ViewScreen());
      }
    });
  }

  DatabaseReference packageRequest = FirebaseDatabase.instance.ref("PackageRequest");
  DatabaseReference completeDB = FirebaseDatabase.instance.ref("Complete");

  final field = FieldData();
  final fieldInfo = FieldInfo();

  Future<void> onCreatePackage(
      {price,
        rielPrice,
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
      genToken,
      genChatID}) async {
    try {
      position = await GeolocatorPlatform.instance.getCurrentPosition();
      latitude = position.latitude;
      longitude = position.longitude;
      String pushKey = generatePushKey();

      var json = {
        "uid": auth.currentUser!.uid.toString(),
        "location": location.toString(),
        "pushKey": pushKey.toString(),
        "phoneNumber": phoneNumber.toString(),
        "token": tokenKey.toString(),
        "chatid": chatid.toString(),
        "latitude": latitude.toString(),
        "bankName": bankName.toString(),
        "longitude": longitude.toString(),
        "qty": qty.toString(),
        "packageID": packageID.toString(),
        "note": note.toString(),
        "price": price.toString(),
        "recLatitude": latitude.toString(),
        "recLongitude": longitude.toString(),
        "senderPhone": "${generalInfo['phoneNumber']}",
        "senderName": userName.toString(),
        "bankCode": abaCode.toString(),
        "paidStatus": "",
        "status": 'request',
        "date": DateTime.now().toString(),
        "rielPrice": rielPrice.toString(),
      };

      if (isFormDataValid(json) == true) {
      } else {
        final updatePath = "package/$pushKey"; // Path to the new data
        await packageRequest
            .child(auth.currentUser!.uid)
            //.child(getUserID.toString())
            .update({
          "userName": userName,
          "userPhoneNumber": userPhoneNumber,
          "uLatitude": latitude.toString(),
          "uLongitude": longitude.toString(),
          updatePath: json
        });
        await uploadToTelegram(
          chatid: genChatID,
          token: genToken,
          data: json,
        );
        String groupChatId = '-4109393904'; // Replace with your group's username or ID
        String botToken = '6682560929:AAGK8VhT_k1QyuvupI1X6aqGtQvucjsYarM';
        sentToGroup(json);
        await sendMessageToGroup(groupChatId: groupChatId, message: sentToGroup(json), botToken: botToken);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  String sentToGroup(objData) {
    return "សួស្ដីអ្នកទាំងអស់គ្នា\n\n====================\n\nអតិថិជនឈ្មោះ : ${objData[field.senderName]}\nលេខទូរស័ព្ទរបស់អតិថិជន : ${objData[field.senderPhone]}"+
        "\nលេខកូដធនាគារ : ${objData[field.bankCode]}\nឈ្មោះរបស់ធនាគារ : ${objData[field.bankName].toString().toUpperCase()}\nពេលហៅ : ${formatDateTime(objData[field.date])}\n\n------------------------------\n\n" +
        "ទីតាំងទំនិញ : ${objData[field.location]}\nទូរស័ព្ទអ្នកទទួល : ${objData[field.phoneNumber]}\nតំលៃ : ${objData[field.price]} \$\nលេខសម្គាល់កញ្ចប់ : ${objData[field.packageID]}\nចំនួន : ${objData[field.qty]}\nចំណាំ : \n${objData[field.note]}" +
        "\n\n------------------------------\n\nទីតាំង Map : ${"https://www.google.com/maps/place/11%C2%B035'34.5%22N+104%C2%B050'18.6%22E/@${objData[field.latitude]},${objData[field.longitude]},17z/data=!3m1!4b1!4m4!3m3!8m2!3d11.5929048!4d104.8385093?entry=ttu"}";
  }

  Future<void> sendMessageToGroup(
      {required String groupChatId, required String message, required String botToken}) async {
    final url = 'https://api.telegram.org/bot$botToken/sendMessage';
    final response = await http.post(Uri.parse(url), body: {
      'chat_id': groupChatId,
      'text': message,
    });

    if (response.statusCode == 200) {
      print('Message sent successfully');
    } else {
      print('Failed to send message. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  // toqwerywef(){
  //   var telegram = "6682560929:AAGK8VhT_k1QyuvupI1X6aqGtQvucjsYarM";
  //   var teledart = TeleDart(telegram, Event().);
  //
  //   teledart.start().then((me) => print('${me.username} is initialised'));
  //
  //   teledart.onMessage(entityType: 'bot_command', keyword: 'start')
  //       .listen((message) => teledart.telegram.sendMessage(message.chat.id, message.chat.id.toString()));
  //
  // }

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

  deletePackage({witchDataBase, data, witchUID, witchPushKey}) async {
    await witchDataBase.child(auth.currentUser!.uid).child('package').child(witchPushKey).remove();
  }

  Future<void> deleteFromDriver({witchDataBase, data, witchUID, witchPushKey}) async {
    try {
      await witchDataBase.child(data[field.driverUID]).child(data[field.pushKey]).remove();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> deleteFromReturn({witchDataBase, data, witchUID, witchPushKey}) async {
    try {
      await witchDataBase.child(data[field.uid]).child(data[field.pushKey]).remove();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  deleteUserPackage({witchDataBase, data, witchUID, witchPushKey}) async {
    await witchDataBase.child(data[field.driverUID]);
  }

  Future<void> storeSetUpAccount({bankName, phoneNumber, firstname, lastname, bankCode}) async {
    position = await GeolocatorPlatform.instance.getCurrentPosition();
    try {
      userDB
          .doc(auth.currentUser!.uid)
          .update({
            fieldInfo.bankCode: bankCode,
            "bankName": bankName,
            'phoneNumber': phoneNumber,
            'firstname': firstname,
            'lastname': lastname,
            'longitude': position.longitude,
            'latitude': position.latitude,
          })
          .then((value) {})
          .catchError((error) {});
      Get.to(() => const ViewScreen());
    } catch (e) {
      final reUse = ReUseWidget();
      reUse.reUseCircleDialog(function: 'error', content: const Text("error"));
    }
  }

  Future<void> editPackage(
      {price,
      required Map userData,
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
      token,
      bankName,
      chatid}) async {
    position = await GeolocatorPlatform.instance.getCurrentPosition();
    latitude = position.latitude;
    longitude = position.longitude;
    packageRequest.child(auth.currentUser!.uid).child('package').child(data[field.pushKey]).update({
      field.uid: auth.currentUser!.uid.toString(),
      field.location: location.toString(),
      field.pushKey: data[field.pushKey].toString(),
      field.phoneNumber: phoneNumber.toString(),
      field.token: token.toString(),
      field.chatid: chatid.toString(),
      field.latitude: latitude.toString(),
      field.longitude: longitude.toString(),
      field.date: DateTime.now().toString(),
      field.qty: qty.toString(),
      field.note: note.toString(),
      field.status: 'request',
      field.price: price.toString(),
      field.bankCode: bankCode,
      field.bankName: bankName,
      field.recLatitude: latitude.toString(),
      field.recLongitude: longitude.toString(),
      field.senderName: "${userData[field.firstname]} ${userData[field.lastname]}"
    });
  }

  updateStatus({uid, key, status}) async {
    await packageRequest
        .child(uid)
        .child('package')
        .child(key)
        .update({'status': status, field.packageID: auth.currentUser!.uid.toString()});
  }

  Future<void> backToReturn({data}) async {
    try {
      position = await GeolocatorPlatform.instance.getCurrentPosition();
      latitude = position.latitude;
      longitude = position.longitude;
      await packageRequest.child(auth.currentUser!.uid).child('package').child(data[field.pushKey]).update({
        field.uid: data[field.uid].toString(),
        field.location: data[field.location].toString(),
        field.pushKey: data[field.pushKey].toString(),
        field.phoneNumber: data[field.phoneNumber].toString(),
        field.token: data[field.token].toString(),
        field.chatid: data[field.chatid].toString(),
        field.latitude: latitude.toString(),
        field.longitude: longitude.toString(),
        field.date: DateTime.now().toString(),
        field.qty: data[field.qty].toString(),
        field.packageID: data[field.packageID].toString(),
        field.note: data[field.note].toString(),
        field.status: 'request',
        field.price: data[field.price].toString(),
        field.recLatitude: data[field.recLatitude].toString(),
        field.recLongitude: data[field.recLongitude].toString(),
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  alertNoInternet(context) async {
    final reUse = ReUseWidget();
    final theme = ThemesApp();
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (kDebugMode) {
          print(e);
        }
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

  final clsLan = ClsLanguage();

  Future<void> editProfile({value, context}) async {
    final reUse = ReUseWidget();
    final theme = ThemesApp();
    try {
      await userDB.doc(auth.currentUser!.uid).update({
        'firstname': value.firstName,
        'lastname': value.lastName,
        'phoneNumber': value.phoneNumber,
        'token': value.token,
        'chatid': value.chatid,
        'bankCode': value.bankCode,
        'bankName': value.bankName,
      });
    } catch (e) {
      reUse.reUseCircleDialog(
          context: context,
          icon: Icons.close_rounded,
          title: clsLan.fail,
          onTap: () {
            Get.back();
            Get.back();
          },
          content: Center(
            child: Text(
              clsLan.tryAgain,
              style: TextStyle(
                color: theme.black,
              ),
            ),
          ));
      if (kDebugMode) {
        print(e);
      }
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
    filteredList = payWay.where((item) => item['name'].toLowerCase().toString().trim().contains(data)).toList();
    return filteredList[0]['name'];
  }

  int getBank({bankName}) {
    int index = payWay.indexWhere((person) => person['name'] == bankName);
    return index;
  }

  getBankImage({bankName}) {
    var object = payWay.where((item) => item['name'].contains(bankName)).toList();
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
    await FirebaseFirestore.instance.collection(firebaseFireStore).doc(data).update({
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
            content: reUse.reUseText(content: "បរាជ័យ សូម​ព្យាយាម​ម្តង​ទៀត​នៅ​ពេល​ក្រោយ"));
      } else {}
    });
    return isReady;
  }

  // isLogOut() async {
  //   await updateOneField(
  //       field: 'signInToken',
  //       value: "false",
  //       firebaseFireStore: "Users",
  //       data: auth.currentUser!.uid,
  //       allowDialog: true);
  //   await auth.signOut().then((value) => Get.to(() => const LogInScreen()));
  // }

  Future<Map> onGetGeneralInfo() async {
    Map object = {};
    await FirebaseFirestore.instance
        .collection("General")
        .doc("GeneralInfo")
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      object = documentSnapshot.data() as Map;
    });
    return object;
  }

  Future<Map> onGetUserInfo() async {
    Map object = {};
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(auth.currentUser?.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      object = documentSnapshot.data() as Map;
    });
    return object;
  }

  uploadToTelegram({
    required String token,
    required String chatid,
    data,
  }) async {
    try {
      final String sendMessageUrl = 'https://api.telegram.org/bot$token/sendMessage';
      JsonModule jsonModule = JsonModule();
      var jsonConvert = jsonModule.toTelegramString(data);
      final response = await http.post(
        Uri.parse(sendMessageUrl),
        body: {
          'chat_id': chatid,
          'text': jsonConvert,
        },
      );
      if (response.statusCode != 200) {}
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  onUserChangeInfo({
    required String token,
    required String chatid,
    data,
  }) async {
    try {
      final String sendMessageUrl = 'https://api.telegram.org/bot$token/sendMessage';
      // JsonModule jsonModule = JsonModule();
      // var jsonConvert = jsonModule.toTelegramString(data);
      final response = await http.post(
        Uri.parse(sendMessageUrl),
        body: {
          'chat_id': chatid,
          'text': data,
        },
      );
      if (response.statusCode != 200) {}
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  String formatDateTime(dateTime) {
    DateTime result = DateTime.parse(dateTime);
    return DateFormat('dd-MM-yyyy HH:mm aa').format(result);
  }

  String removeLeadingZeros(String input) {
    double number = double.parse(input);
    return number.toStringAsFixed(2);
  }

  List onSearch(List lstObject, String search) {
    List result = [];

    // Define the list of keys to search for
    List<String> keysToSearch = ["phoneNumber", "packageID", "location", "price"];
    for (String key in keysToSearch) {
      result = lstObject.where((food) => food.containsKey(key) && food[key].toString().contains(search)).toList();
      if (result.isNotEmpty) {
        break; // Exit the loop if a match is found
      }
    }
    return result;
  }

  bool isFormDataValid(Map data) {
    bool result = data["packageID"] == "" &&
        data["price"] == "" &&
        data["senderPhone"] == "" &&
        data["pushKey"] == "" &&
        data["location"] == "" &&
        data["date"] == "" &&
        data["phoneNumber"] == "" &&
        data["uid"] == "";
    return result;
  }

  List sortNewest(List objList, String key) {
    objList.sort((a, b) {
      DateTime dateA = DateTime.parse(a[key]);
      DateTime dateB = DateTime.parse(b[key]);
      return dateB.compareTo(dateA);
    });
    return objList;
  }

  List sortOldest(List objList, String key) {
    objList.sort((a, b) {
      DateTime dateA = DateTime.parse(a[key]);
      DateTime dateB = DateTime.parse(b[key]);
      return dateA.compareTo(dateB);
    });
    return objList;
  }

  List onSortToday(List objList, String key) {
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    objList = objList
        .where((obj) =>
            DateTime.parse(obj[key]).year == today.year &&
            DateTime.parse(obj[key]).month == today.month &&
            DateTime.parse(obj[key]).day == today.day)
        .toList();
    return objList;
  }

  Future<List> onGetRequestPackage() async {
    List result = [];
    try {
      final isRequestDB = await packageRequest.child(auth.currentUser!.uid).child("package").onValue.first;
      DataSnapshot driver = isRequestDB.snapshot;
      Map values = driver.value as Map;
      values.forEach((key, values) {
        result.add(values);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return result;
  }

  Future<List> onGetCompletePackage() async {
    List result = [];
    try {
      final isCompleteDb = await completeDB.child(auth.currentUser!.uid).onValue.first;
      DataSnapshot driver = isCompleteDb.snapshot;
      Map values = driver.value as Map;
      values.forEach((key, value) async {
        result.add(value);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return result;
  }

  DatabaseReference pendingDB = FirebaseDatabase.instance.ref('Pending');

  Future<List> onGetPendingPackage() async {
    List result = [];
    try {
      final isPendingDB = await pendingDB.child(auth.currentUser!.uid).onValue.first;
      DataSnapshot driver = isPendingDB.snapshot;
      Map values = driver.value as Map;
      values.forEach((key, value) {
        result.add(value);
      });
    } catch (e) {
      // print('pendingListLength $e');
      // FirebaseAuth.instance.signOut();
      // Get.to(()=> const LogInScreen());
    }
    return result;
  }

  DatabaseReference returnDB = FirebaseDatabase.instance.ref('Return');

  Future<List> onGetReturnPackage() async {
    List result = [];
    try {
      final isReturnDB = await returnDB.child(auth.currentUser!.uid).onValue.first;
      DataSnapshot driver = isReturnDB.snapshot;
      Map values = driver.value as Map;
      values.forEach((key, value) async {
        result.add(value);
      });
    } catch (e) {
      // print('returnListLength $e');
      // FirebaseAuth.instance.signOut();
      // Get.to(()=> const LogInScreen());
    }
    return result;
  }

  List onSortTodayTwoKey(List objList) {
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    objList = objList
        .where((obj) =>
            DateTime.parse(obj["completeDate"] ?? obj["returnDate"]).year == today.year &&
            DateTime.parse(obj["completeDate"] ?? obj["returnDate"]).month == today.month &&
            DateTime.parse(obj["completeDate"] ?? obj["returnDate"]).day == today.day)
        .toList();
    return objList;
  }

  final strKey = StorageKey();

  Future<void> onContinueSave({required String key, required Map obj}) async {
    List deleteAccount = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(key);
    if (jsonString != null && jsonString.isNotEmpty) {
      deleteAccount = json.decode(jsonString);
      deleteAccount.add(obj);
      String saving = json.encode(deleteAccount);
      prefs.setString(strKey.userLocation, saving);
    } else {
      // If the string is null or empty, return an empty list
      deleteAccount.add(obj);
      String saving = json.encode(deleteAccount);
      prefs.setString(strKey.userLocation, saving);
    }
  }

  Future<List> onRemoveSaving({required String key, required int index}) async {
    List deleteAccount = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(key);
    if (jsonString != null && jsonString.isNotEmpty) {
      deleteAccount = json.decode(jsonString);
      deleteAccount.removeAt(index);
      String saving = json.encode(deleteAccount);
      prefs.setString(strKey.userLocation, saving);
    } else {}
    return deleteAccount;
  }
}
