import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({Key? key}) : super(key: key);

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  final reUse = ReUseWidget();
  final theme = ThemesApp();
  final glb = GlobalController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pendingListLength();
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  List pendingList = [];

  pendingListLength() async {
    DatabaseReference refs = FirebaseDatabase.instance.ref('Pending');
    refs.onValue.listen((event) async {
      pendingList.clear();
      DataSnapshot driver = event.snapshot;
      Map values = driver.value as Map;
      values.forEach((key, value) async {
        Map data = value[auth.currentUser!.uid] as Map;
        data.forEach((key, value) {
          setState(() {
            pendingList.add(value);
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          reUse.reUseHeader(
              label: 'Pending', title: 'Pending', headercolor: theme.orange),
          pendingList.isEmpty
              ? Flexible(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/delivery_man.png', color: theme.grey,scale: 12),
                      reUse.reUseText(content: 'Pending not available', color: theme.grey)
                    ],
                  ))
              : reUse.reUsePendingList(pkc: pendingList),
        ],
      ),
    ));
  }
}
