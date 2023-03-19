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
  List completeList = ['dasdasd'];
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              reUse.reUseHeader(
                  label: 'Return', title: 'Return', headercolor: theme.liteRed),
              // reUse.reTotalPackageListview(pkc: completeList)
            ],
          ),
        ));
  }
}
