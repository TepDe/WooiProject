import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final themes = ThemesApp();
  final reUse = ReUseWidget();
  FirebaseAuth auth = FirebaseAuth.instance;
  List completeList = [];
  List returnData = [];
  List statusData = [];
  completeListLength() async {
    DatabaseReference refs = FirebaseDatabase.instance
        .ref('Complete')
        .child(auth.currentUser!.uid);
    refs.onValue.listen((event) async {
      setState(() {});
      completeList.clear();
      DataSnapshot driver = event.snapshot;
      Map values = driver.value as Map;
      values.forEach((key, value) async {
        setState(() {
          completeList.add(value);
          statusData.add(value);

        });
      });
    });
    setState(() {});
  }

  returnListLength() async {
    DatabaseReference refs = FirebaseDatabase.instance
        .ref('Return')
        .child(auth.currentUser!.uid);
    refs.onValue.listen((event) async {
      setState(() {});
      returnData.clear();
      DataSnapshot driver = event.snapshot;
      Map values = driver.value as Map;
      values.forEach((key, value) async {
        setState(() {
          returnData.add(value);
          statusData.add(value);
        });
      });
    });
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    returnListLength();
    completeListLength();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            reUse.reUseTopBar(name: 'Notification', context: context),
            reUse.reUseUpdateStatusList(data: statusData)
          ],
        ),
      ),
    );
  }

  renderListView() {
    return Flexible(
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: 12,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 100,
                width: 100,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      // borderRadius: BorderRadius.only(
                      //     topLeft: Radius.circular(25),
                      //     topRight: Radius.circular(25),
                      //     bottomRight: Radius.circular(10),
                      //     bottomLeft: Radius.circular(10))),
                      borderRadius: BorderRadius.circular(12)),
                  tileColor: themes.orange,
                  title: Text('title'),
                  leading: CircleAvatar(
                    backgroundColor: Color(0xff764abc),
                    child: Text('h'),
                  ),
                  // trailing: Text('trailing'),
                  subtitle: Text('subtitle'),
                ),
              ),
            );
          }),
    );
  }
}
