import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/GlobalControl/StorageKey.dart';
import 'package:wooiproject/GlobalControl/clsField.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';

import 'GlobalControl/createModule.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final reUse = ReUseWidget();
  final theme = ThemesApp();

  int doubleClick = 0;

  exitApp() {
    doubleClick += 1;
    if (doubleClick == 2) {
      exit(0);
    }
    return true;
  }

  final glb = GlobalController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    suggestionLocation();
    checkid();
    totalListLength();
    pendingListLength();
    completeListLength();
    returnListLength();
    currentTime();
    //testObj();
    alertNoIntenet();
    // glb.getOtp();
    showNotification();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> showNotification() async {
    try {
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          const AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: BigTextStyleInformation(''),
      );

      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        'Notification Title',
        'Notification Body',
        platformChannelSpecifics,
      );
    } catch (e) {
      print(e);
    }
  }

  List distince = [];

  Future<void> suggestionLocation() async {
    try {
      final jsonString = await rootBundle.loadString('assets/distination.json');
      var data = await json.decode(jsonString);
      Map dist = data as Map;
      dist.forEach((key, values) {
        distince.add(values[0]);
      });
    } catch (e) {
      print(e);
    }
  }

  alertNoIntenet() async {
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
      setState(() {});
    }
  }

  String getUserID = '';
  final str = StorageKey();

  checkid() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.currentUser!.uid)
          .get()
          .then((doc) async {
        Map data = doc.data() as Map;
        if (data.containsKey('userID')) {
          final name = data['userID'];
          getUserID = name.toString();
          await prefs.setString(str.userID, getUserID.toString());
          setState(() {});
          print('User name: $name');
        } else {
          isNullUserID();
          print('Name field does not exist in document');
        }
      });
    } catch (e) {}
  }

  List driverList = [];
  List totalPackageIndex = [];
  List completeList = [];
  List returnData = [];
  final field = FieldData();

  totalListLength() async {
    try {
      DatabaseReference refs = FirebaseDatabase.instance
          .ref('PackageRequest')
          .child(auth.currentUser!.uid);
      refs.onValue.listen((event) {
        setState(() {});
        driverList.clear();
        totalPackageIndex.clear();
        DataSnapshot driver = event.snapshot;
        Map values = driver.value as Map;
        values.forEach((key, values) async {
          Map data = await values as Map;
          data.forEach((key, value) async {
            setState(() {
              totalPackageIndex.add(key);
              driverList.add(value);
            });
          });
        });
      });
    } catch (e) {
      print('totalListLength $e');
    }
  }

  onGetLocalStorage(cantOrNot) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(str.cantEdit, findObject(driverList));
    setState(() {});
  }

  bool findObject(List objects) {
    // Filter the list to include only objects where `stringValue` is equal to `searchString`
    List filteredList =
        objects.where((obj) => obj.stringValue == 'request').toList();

    // Check if only one object was found with the specified string value
    return filteredList.length == 1 && filteredList[0].booleanValue == true;
  }

  List pendingList = [];

  pendingListLength() {
    try {
      DatabaseReference refs = FirebaseDatabase.instance.ref('Pending');
      refs.onValue.listen((event) {
        setState(() {});
        pendingList.clear();
        DataSnapshot driver = event.snapshot;
        Map values = driver.value as Map;
        values.forEach((key, value) {
          Map data = value[auth.currentUser!.uid] as Map;
          data.forEach((key, value) {
            setState(() {
              pendingList.add(value);
            });
          });
        });
      });
    } catch (e) {
      print('pendingListLength $e');
    }
  }

  completeListLength() {
    try {
      DatabaseReference refs = FirebaseDatabase.instance
          .ref('Complete')
          .child(auth.currentUser!.uid);
      refs.onValue.listen((event) {
        setState(() {});
        completeList.clear();
        DataSnapshot driver = event.snapshot;
        Map values = driver.value as Map;
        values.forEach((key, value) {
          setState(() {
            completeList.add(value);
          });
        });
      });
    } catch (e) {
      print('completeListLength $e');
    }
  }

  returnListLength() {
    try {
      DatabaseReference refs =
          FirebaseDatabase.instance.ref('Return').child(auth.currentUser!.uid);
      refs.onValue.listen((event) {
        setState(() {});
        returnData.clear();
        DataSnapshot driver = event.snapshot;
        Map values = driver.value as Map;
        values.forEach((key, value) {
          setState(() {
            returnData.add(value);
          });
        });
      });
    } catch (e) {
      print('returnListLength $e');
    }
  }

  String greeting = "";

  currentTime() {
    DateTime now = DateTime.now();
    int hours = now.hour;
    if (hours >= 1 && hours <= 12) {
      greeting = "អរុណ សួស្តី";
    } else if (hours >= 12 && hours <= 16) {
      greeting = "ទិវា សួស្ដី";
    } else if (hours >= 16 && hours <= 21) {
      greeting = "សាយ័ណ សួរស្តី";
    } else if (hours >= 21 && hours <= 24) {
      greeting = "រាត្រី សួស្តី";
    } else {
      greeting = "រាត្រី សួស្តី";
    }
    setState(() {});
  }

  bool circleIndicator = false;

  double paddings = 10.0;
  final clsLan = ClsLanguage();

  @override
  Widget build(BuildContext context) {
    showNotification();
    return Scaffold(
      backgroundColor: theme.liteGrey,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: 40, right: paddings, left: paddings),
              child: reUse.unitOneHomeScreen(
                  getTime: greeting, userID: 'ID $getUserID', context: context),
            ),

            Padding(
              padding: EdgeInsets.all(paddings),
              child: reUse.unitTwoHomeScreen(
                  context: context,
                  totalPackageDataKey: totalPackageIndex,
                  totalPackageData: driverList,
                  returnData: returnData,
                  completeData: completeList,
                  returnLength: returnData.length,
                  completeLength: completeList.length,
                  pendingData: pendingList,
                  totalLength: driverList.length,
                  pendingLength: pendingList.length),
            ),

            //wr.unitThreeHomeScreen(icon: Icons.directions_car, lable: 'Car',price: '2143', funtion: 'motor',context: context),
            // wr.unitThreeHomeScreen(icon: Icons.motorcycle, lable: 'Motorcycle',price: '2143', funtion: '',context: context),
            //reUse.renderListView(),
            // Padding(
            //   padding: EdgeInsets.all(paddings),
            //   child: reUse.reUseCreatePackage(
            //       context: context,
            //       padding: paddings,
            //       height: Get.height * 0.02),
            // ),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:
                      reUse.reUseText(content: 'Activity', color: theme.grey),
                ),
                Flexible(
                  child: Divider(
                    height: 1,
                    color: theme.grey,
                  ),
                ),
              ],
            ),

            // Row(
            //   children: [
            //     Flexible(
            //       flex: 1,
            //       child: ListView.builder(
            //           padding: const EdgeInsets.all(8),
            //           itemCount: distince.length,
            //           itemBuilder: (BuildContext context, int index) {
            //             return Container(
            //               height: 50,
            //               child: Center(child: Text('Entry ${distince[index]}')),
            //             );
            //           }),
            //     )
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  List statusData = [];

  FirebaseAuth auth = FirebaseAuth.instance;

  isNullUserID() async {
    final prefs = await SharedPreferences.getInstance();

    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    int? userID;
    var rng = Random();
    userID = rng.nextInt(999999);
    await users
        .doc(auth.currentUser!.uid)
        .update({'userID': userID}).then((value) async {
      await prefs.setString(str.userID, userID.toString());

      print("User Updated");
    }).catchError((error) => print("Failed to update user: $error"));
    await checkid();
    setState(() {});
  }
}
