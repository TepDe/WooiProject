import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/GlobalControl/StorageKey.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final reUse = ReUseWidget();
  final theme = ThemesApp();

  exitApp() {
    SystemNavigator.pop();
  }

  final glb = GlobalController();
  UserData userData = UserData();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkid();
    totalListLength();
    pendingListLength();
    completeListLength();
    returnListLength();
    currentTime();
  }

  _HomeScreenState() {
    totalListLength();
    pendingListLength();
    completeListLength();
    returnListLength();
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
      greeting = "Good Morning";
    } else if (hours >= 12 && hours <= 16) {
      greeting = "Good Afternoon";
    } else if (hours >= 16 && hours <= 21) {
      greeting = "Good Evening";
    } else if (hours >= 21 && hours <= 24) {
      greeting = "Good Night";
    }
    setState(() {});
  }

  bool circleIndicator = false;

  double paddings = 10.0;

  @override
  Widget build(BuildContext context) {
    double btnHeight = MediaQuery.of(context).size.height * 0.06;
    return WillPopScope(
      onWillPop: () => exitApp(),
      child: Scaffold(
        backgroundColor: theme.liteGrey,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 40, right: paddings, left: paddings),
                child: reUse.unitOneHomeScreen(
                    getTime: greeting,
                    userID: 'ID $getUserID',
                    context: context),
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
              Padding(
                padding: EdgeInsets.all(paddings),
                child: reUse.reUseCreatePackage(
                    context: context, padding: paddings, height: btnHeight),
              ),

              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: reUse.reUseText(
                        content: 'Activity', color: theme.grey),
                  ),
                  Flexible(
                    child: Divider(
                      height: 1,
                      color: theme.grey,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications,
                    color: theme.grey,
                    size: 40,
                  ),
                  reUse.reUseText(content: 'No Activity', color: theme.grey)
                ],
              )
            ],
          ),
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
