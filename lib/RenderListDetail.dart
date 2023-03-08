import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (argumentData == 0) {
      renderList = reUse.reUseListPackage(
          removeFoot: true, Title: 'Total Package', headerColor: theme.dirt);
    } else if (argumentData == 1) {
      renderList =
          reUse.reUseListPackage(Title: 'Pending', headerColor: theme.orange);
    } else if (argumentData == 2) {
      renderList = reUse.reUseListPackage(
          Title: 'Complete', headerColor: theme.liteGreen);
    } else if (argumentData == 3) {
      renderList =
          reUse.reUseListPackage(Title: 'Return', headerColor: theme.liteRed);
    }
  }

  var renderList;
  List totalPackage = [];
  List pendingPackage = [];
  List completePackage = [];
  List returnPackage = [];
  var getUid;
  final str = StorageKey();
  var getUserID;

  onGetLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    getUid = prefs.getString(str.uid);
    getUserID = prefs.getString(str.userID);

  }

  totalPackageData() async {
    DatabaseReference packageRequest =
        FirebaseDatabase.instance.ref("PackageRequest");
    packageRequest.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      Map mapdata  = data as Map;
      print(mapdata );
      print(mapdata );

      mapdata.forEach((key, value) {
        totalPackage.add(value['package']['latitude']);

      });

      print(totalPackage );
      print(totalPackage );

    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    totalPackageData();

    return SafeArea(
      child: Scaffold(body: renderList),
    );
  }
}
