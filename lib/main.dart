import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wooiproject/LoginScreen.dart';
import 'package:wooiproject/ViewScreen.dart';
import 'dart:async';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.notification?.body}');
  // Add your custom logic to handle the background message here
}
FirebaseMessaging messaging = FirebaseMessaging.instance;

void requestNotificationPermission() async {
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  print('Notification permission granted: ${settings.authorizationStatus}');
}
void configureFirebaseMessaging() {
  FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  FirebaseMessaging.onMessage.listen(_handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
}

Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  print('Received background message: ${message.notification?.title}');
  // Handle the message in the background
}

void _handleMessage(RemoteMessage message) {
  print('Received message: ${message.notification?.title}');
  // Handle the message when the app is in the foreground
}

void _handleMessageOpenedApp(RemoteMessage message) {
  print('Opened app from notification: ${message.notification?.title}');
  // Handle the message when the app is opened from a notification
}
void main() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings('app_icon');
  InitializationSettings initializationSettings = InitializationSettings(android: androidInitializationSettings);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  requestNotificationPermission();
  configureFirebaseMessaging();
  await Firebase.initializeApp();
  // await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         authDomain: 'wooi-c715e.web.app',
  //         databaseURL: "https://wooi-c715e-default-rtdb.firebaseio.com",
  //         apiKey: 'AIzaSyCXD78daMICVTVAXsmzNTvlk5TjDAgGdNQ',
  //         appId: '1:1093614007557:android:9efb550fcadd369394f36c',
  //         messagingSenderId: '1093614007557',
  //         projectId: 'wooi-c715e'));
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler );
  runApp(GetMaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final mc = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: mc.isSignIn.value == true ? LogInScreen() : ViewScreen(),
    );
  }
}

class MainController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    // changeColorButton();
    await onAlreadySignIn();
    await request();
    await requestUserPermissionLocation();
  }

  Future<Position> requestUserPermissionLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  var protect = false.obs;
  Position? currentPosition;

  request() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print('$error' + "" + '$stackTrace');
      printError();
    });
    protect.value = true;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) => currentPosition = position);
    protect.value = true;
    update();
  }

  var isSignIn = false.obs;
  final glb = Get.put(GlobalController());

  onAlreadySignIn() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        isSignIn.value = true;
      } else {
        // Get.to(HomeScreen());
        print('User is currently signed in!');
        request();
        glb.UID = (user.uid).toString();
        isSignIn.value = false;
      }
    });
    update();
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return  HomeScreen();
//   }
// }
