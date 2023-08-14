
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wooiproject/AccountScreen.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/HomeScreen.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({Key? key}) : super(key: key);

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  var viewScreen = [
    const HomeScreen(),
    //ActivityScreen(),
    //NotificationScreen(),
    const AccountScreen(),
  ];

  final themes = ThemesApp();

  final glb = GlobalController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    glb.checkUserInformation();
    showNotification();
  }
  var ctime;
  final clsLan = ClsLanguage();
  void showNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'channel_id', 'channel_name',
        importance: Importance.high, priority: Priority.high);

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, 'Notification', 'This is a notification', platformChannelSpecifics);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          DateTime now = DateTime.now();
          if (ctime == null || now.difference(ctime) > const Duration(seconds: 2)) {
            //add duration of press gap
            ctime = now;
            // ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(content: Text('Press Back Button Again to Exit'))
            // ); //scaffold message, you can show Toast message too.
            Fluttertoast.showToast(
                msg: clsLan.backMessage,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
            return Future.value(false);
          }

          return Future.value(true);
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  tooltip: null,
                  icon: Image.asset(
                    'assets/images/home_icon.png',
                    width: 30,
                    height: 30,
                    //alignment: Alignment.topRight,
                    color: changeColor ?? themes.deepOrange,
                  ),
                  label: 'ទំព័រដើម',
                ),
                BottomNavigationBarItem(
                  icon: reUseIcon(icons: Icons.account_circle),
                  label: 'គណនី',
                ),
              ],
              iconSize: 60,
              unselectedFontSize: 12,
              unselectedLabelStyle: TextStyle(
                  color: themes.deepOrange,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              selectedLabelStyle: TextStyle(
                  color: themes.deepOrange,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              selectedItemColor: themes.deepOrange,
              unselectedItemColor: themes.grey,
              currentIndex: selectedIndex,
              backgroundColor: themes.white,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                  if (index == 0) {
                    changeColor = themes.deepOrange;
                  } else {
                    changeColor = themes.grey;
                  }
                });
              },
            ),
            body: viewScreen[selectedIndex]),
      ),
    ));
  }

  int selectedIndex = 0;
  var changeColor;

  reUseIcon({icons}) {
    return Icon(
      icons,
      size: 40,
    );
  }
}
