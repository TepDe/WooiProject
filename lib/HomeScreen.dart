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
  final glb = GlobalController();

  exitApp() {
    SystemNavigator.pop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getCheckUserID();
    checkid();
    totalListLength();
  }

  String getUserID = '';
  final str = StorageKey();

  getCheckUserID() async {
    int? userID;
    var rng = Random();
    userID = rng.nextInt(999999);
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid.toString())
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      print(auth.currentUser!.uid.toString());
      try {
        String userid = await documentSnapshot['userID'] ?? ''.toString();
        print(userid);
        if (userid == "") {
          print('getUserID');
        } else {
          print('else');
        }
      } catch (e) {
        print(e);
      }
    });
    setState(() {});
  }

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
    setState(() {});
  }

  List driverList = [];

  totalListLength() async {
    DatabaseReference refs = FirebaseDatabase.instance
        .ref('PackageRequest')
        .child(auth.currentUser!.uid);
    refs.onValue.listen((event) async {
      driverList.clear();
      DataSnapshot driver = event.snapshot;
      Map values = driver.value as Map;
      values.forEach((key, values) async {
        print(values);
        print(values);
        Map data = values as Map;
        data.forEach((key, value) {
          setState(() {
            driverList.add(value);
          });
        });

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var viewHeight = MediaQuery.of(context).size.height * 0.3;
    return WillPopScope(
        onWillPop: () => exitApp(),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Container(
                  height: viewHeight,
                  decoration: BoxDecoration(
                    color: theme.liteOrange,
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(
                            MediaQuery.of(context).size.width, 100.0)),
                  ),
                ),
                Column(
                  children: [
                    reUse.topBarHomeScreen(),
                    reUse.unitOneHomeScreen(userID: 'ID $getUserID'),
                    reUse.unitTwoHomeScreen(totalLength: driverList.length),
                    //wr.unitThreeHomeScreen(icon: Icons.directions_car, lable: 'Car',price: '2143', funtion: 'motor',context: context),
                    // wr.unitThreeHomeScreen(icon: Icons.motorcycle, lable: 'Motorcycle',price: '2143', funtion: '',context: context),
                    //reUse.renderListView(),
                    reUse.reUseDialog(context: context)
                  ],
                ),
              ],
            ),
          ),
        ));
  }

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
