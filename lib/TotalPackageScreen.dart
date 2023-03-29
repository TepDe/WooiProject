import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'WidgetReUse/ReUseWidget.dart';
import 'WidgetReUse/Themes.dart';

class TotalPackageScreen extends StatefulWidget {
  const TotalPackageScreen({Key? key}) : super(key: key);

  @override
  State<TotalPackageScreen> createState() => _TotalPackageScreenState();
}

class _TotalPackageScreenState extends State<TotalPackageScreen> {
  final reUse = ReUseWidget();
  final theme = ThemesApp();
  var argumentData = Get.arguments;
  List driverList = [];
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isShow = false;

  // totalListLength() async {
  //   DatabaseReference refs = FirebaseDatabase.instance
  //       .ref('PackageRequest')
  //       .child(auth.currentUser!.uid);
  //   refs.onValue.listen((event) async {
  //     driverList.clear();
  //     DataSnapshot driver = event.snapshot;
  //     Map values = driver.value as Map;
  //     values.forEach((key, values) {
  //       Map data = values as Map;
  //       data.forEach((key, value) async {
  //         setState(() {
  //           driverList.add(value);
  //         });
  //         isShow = true;
  //       });
  //     });
  //   });
  // }

  _TotalPackageScreenState() {
    driverList = argumentData;
    isShow = true;

    print(driverList);
    print(driverList);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //totalListLength();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              children: [
                reUse.reUseHeader(
                    context: context,
                    label: 'Total Package',
                    title: 'Total Package',
                    headercolor: theme.dirt),

                isShow == false
                    ? const Flexible(
                        child: Center(
                            child: SizedBox(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator())))
                    : reUse.reTotalPackageListview(pkc: driverList),

                // isShow == true
                //     ? driverList == []
                //         ? Flexible(child: Center(child: Text('No Package')))
                //         : reUse.reTotalPackageListview(pkc: driverList)
                //     : const Flexible(
                //         child: Center(
                //             child: SizedBox(
                //                 height: 50,
                //                 width: 50,
                //                 child: CircularProgressIndicator()))),
              ],
            ),
          ),
          reUse.reUseCreatePackage(context: context),
        ],
      ),
    ));
  }
}
