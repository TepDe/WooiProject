import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wooiproject/AccountScreen.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/HomeScreen.dart';
import 'package:wooiproject/NotificationScreen.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';
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
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        // Handle the initial message when the app is launched from a notification
        _handleMessage(message);
      }
    });
  }

  Future<void> showNotification() async {
    try{
      AndroidNotificationDetails androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'channel_id', 'channel_name',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: BigTextStyleInformation(''),
      );

      NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0, 'Notification Title', 'Notification Body', platformChannelSpecifics,
      );
      setState(() {

      });
    }catch(e){
      print(e);
    }

  }

  Future<void> requestNotificationPermissions() async {
    final PermissionStatus status = await Permission.notification.request();
    final PermissionStatus statusSms = await Permission.sms.request();
    if (status.isGranted) {
      // Notification permissions granted
    } else if (status.isDenied) {
      // Notification permissions denied
    } else if (status.isPermanentlyDenied) {
      // Notification permissions permanently denied, open app settings
      await openAppSettings();
    }
    if (statusSms.isDenied) {

      // We didn't ask for permission yet or the permission has been denied before but not permanently.

      await Permission.sms.request();

    }
  }
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<NotificationDetails> _notificationDetails() async {


    AndroidNotificationDetails androidPlatformChannelSpecifics =
    const AndroidNotificationDetails(
      '3213213',
      'channel name',
      groupKey: 'com.example.flutter_push_notifications',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      ticker: 'ticker',
      largeIcon: DrawableResourceAndroidBitmap('justwater'),
      color: Color(0xff2196f3),
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics);

    return platformChannelSpecifics;
  }

  void _handleMessage(RemoteMessage message) {
    print('Message received: ${message.notification?.body}');


    final reUse = ReUseWidget();
    reUse.reUseCircleDialog(content: Text("${message.notification?.title}"));
    setState(() {

    });
    // Handle the message when the app is opened from a notification
    // Add your custom logic to handle the message here
  }

  Future<void> _onSelectNotification(String? payload) async {
    // Handle notification selection here
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
       FlutterLocalNotificationsPlugin();

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your_channel_id', 'your_channel_name',
            importance: Importance.max, priority: Priority.high);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Database Updated',
      'New data has been added to the database.',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  late DateTime currentBackPressTime;

  bool onWillPop() {
    return true;
  }

  int doubleClick = 0;
  var ctime;
  final clsLan = ClsLanguage();

  @override
  Widget build(BuildContext context) {
    glb.configureFirebaseMessaging(context);
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
                  label: 'Home',
                ),
                // BottomNavigationBarItem(
                //   icon: reUseIcon(icons: Icons.menu),
                //   label: 'Activity',
                // ),
                // BottomNavigationBarItem(
                //   icon: Stack(
                //     children: <Widget>[
                //       // Image.asset(
                //       //   'assets/images/box.png',
                //       //   scale: 16,
                //       //   alignment: Alignment.topRight,
                //       //   color: changeColor ?? themes.grey,
                //       // ),
                //       Icon(
                //         Icons.notifications,
                //         size: 40,
                //       ),
                //       Positioned(
                //         right: 0,
                //         child: Container(
                //           padding: EdgeInsets.all(3),
                //           decoration: BoxDecoration(
                //             color: themes.red,
                //             borderRadius: BorderRadius.circular(60),
                //           ),
                //           child: const Text(
                //             '+9',
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 8,
                //             ),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                //   label: 'Notifications',
                // ),
                BottomNavigationBarItem(
                  icon: reUseIcon(icons: Icons.account_circle),
                  label: 'Account',
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
              //
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
