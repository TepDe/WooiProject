import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/GlobalControl/StorageKey.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';

import 'WidgetReUse/Themes.dart';

class RenderListDetail extends StatefulWidget {
  const RenderListDetail({Key? key}) : super(key: key);

  @override
  State<RenderListDetail> createState() => _RenderListDetailState();
}

class _RenderListDetailState extends State<RenderListDetail> {
  final reUse = ReUseWidget();
  var argumentData = Get.arguments;
  final theme = ThemesApp();
  var renderList;
  //final glb = GlobalController();
  List totalPackage = [];
  List pendingPackage = [];
  List completePackage = [];
  List returnPackage = [];
  var getUid;
  final str = StorageKey();
  var getUserID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalPackageData();
  }

  onGetLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    getUid = prefs.getString(str.uid);
    getUserID = prefs.getString(str.userID);
  }

  List<User> userList = [];
  List pRequest = [];
  var totalList = '';

  totalPackageData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    DatabaseReference packageRequest = FirebaseDatabase.instance
        .ref("PackageRequest")
        .child(auth.currentUser!.uid);
    packageRequest.once().then((DatabaseEvent event) async {
      final data = event.snapshot.value;
      Map test = data as Map;
      test.forEach((key, value) async {
        Map package = await value as Map;
        package.forEach((key, value) async {
          pRequest.add(value['package']);
          print(pRequest);
          await returnData(pRequest);
          setState(() async {
            isLoading = false;
          });
        });
      });
    });
  }

  bool isLoading = true;

  fetching() {
    print("------------------------my data ${pRequest}");
    pRequest.map((e) => e['package']["phoneNumber"]);
  }

  returnData(List? pck) async {
    if (argumentData == 0) {
      renderList = await reUse.reUseListPackage(
          pakageTotal: pck,
          removeFoot: true,
          Title: 'Total Package',
          headerColor: theme.dirt);
    } else if (argumentData == 1) {
      renderList = await reUse.reUseListPackage(
          Title: 'Pending', headerColor: theme.orange);
    } else if (argumentData == 2) {
      renderList = await reUse.reUseListPackage(
          Title: 'Complete', headerColor: theme.liteGreen);
    } else if (argumentData == 3) {
      renderList = await reUse.reUseListPackage(
          Title: 'Return', headerColor: theme.liteRed);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: isLoading
              ? const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator())
              : renderList),
    );
  }
}

class User {
  String latitude;
  String longitude;
  String phoneNumber;
  String location;
  String qty;

  User(
      {required this.latitude,
      required this.longitude,
      required this.phoneNumber,
      required this.location,
      required this.qty});
}
