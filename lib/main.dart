import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wooiproject/LoginScreen.dart';
import 'package:wooiproject/ViewScreen.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          authDomain: 'wooi-c715e.web.app',
          databaseURL: "https://wooi-c715e-default-rtdb.firebaseio.com",
          apiKey: 'AIzaSyCXD78daMICVTVAXsmzNTvlk5TjDAgGdNQ',
          appId: '1:1093614007557:android:9efb550fcadd369394f36c',
          messagingSenderId: '1093614007557',
          projectId: 'wooi-c715e'));
  // await Firebase.initializeApp();
  runApp(
      const GetMaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

// class MainController {
//   @override
//   void onInit() async {
//     super.onInit();
//     // changeColorButton();
//     await onAlreadySignIn();
//     await request();
//     await requestUserPermissionLocation();
//   }
//
//   Future<Position> requestUserPermissionLocation() async {
//     await Geolocator.requestPermission().then((value) {}).onError((error, stackTrace) async {
//       await Geolocator.requestPermission();
//     });
//     return await Geolocator.getCurrentPosition();
//   }
//
//   var protect = false.obs;
//   Position? currentPosition;
//
//   request() async {
//     await Geolocator.requestPermission().then((value) {}).onError((error, stackTrace) {
//       print('$error' + "" + '$stackTrace');
//       printError();
//     });
//     protect.value = true;
//     await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
//         .then((Position position) => currentPosition = position);
//     protect.value = true;
//   }
//
//   var isSignIn = false;
//
//   onAlreadySignIn() async {
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (user == null) {
//         print('User is currently signed out!');
//         isSignIn = true;
//       } else {
//         // Get.to(HomeScreen());
//         print('User is currently signed in!');
//         request();
//         isSignIn = false;
//       }
//     });
//   }
// }

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isSignIn = false;
  bool protect = false;
  Position? currentPosition;

  onAlreadySignIn() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          isSignIn = true;
        });
      } else {
        request();
        setState(() {
          isSignIn = false;
        });
      }
    });
  }

  request() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print('$error' + "" + '$stackTrace');
      printError();
    });
    protect = true;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) => currentPosition = position);
    protect = true;
  }

  Future<Position> requestUserPermissionLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onInitialize();
  }

  Future<void> onInitialize() async {
    await onAlreadySignIn();
    await request();
    await requestUserPermissionLocation();
  }

  @override
  Widget build(BuildContext context) {
    return isSignIn == true ? const LogInScreen() : const ViewScreen();
  }
}
