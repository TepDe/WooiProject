import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';

class ReturnScreen extends StatefulWidget {
  const ReturnScreen({Key? key}) : super(key: key);

  @override
  State<ReturnScreen> createState() => _ReturnScreenState();
}

class _ReturnScreenState extends State<ReturnScreen> {
  final reUse = ReUseWidget();
  final theme = ThemesApp();
  final glb = GlobalController();
  var argumentData = Get.arguments;
  List returnList = [];
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isShow = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    returnList = argumentData;
    print(returnList);
    isShow = true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          reUse.reUseHeader(
              label: 'Return', title: 'Return', headercolor: theme.liteRed),
          returnList.isEmpty
              ? Flexible(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications,
                        color: theme.grey,
                        size: 40,
                      ),
                      reUse.reUseText(content: 'No Return \n Available', color: theme.grey)
                    ],
                  ))
              : reUse.reUseRerurnPackageList(returnData: returnList,pkc:returnList ),
        ],
      ),
    ));
  }
}
