import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wooiproject/LoginScreen.dart';
import 'package:wooiproject/ViewScreen.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// DEVELOPMENT DATABASE
  // await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         authDomain: 'wooi-c715e.web.app',
  //         databaseURL: "https://wooi-c715e-default-rtdb.firebaseio.com",
  //         apiKey: 'AIzaSyCXD78daMICVTVAXsmzNTvlk5TjDAgGdNQ',
  //         appId: '1:1093614007557:android:9efb550fcadd369394f36c',
  //         messagingSenderId: '1093614007557',
  //         storageBucket: "wooi-c715e.appspot.com",
  //         projectId: 'wooi-c715e'));

  /// PRODUCTION DATABASE
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDz7MalonN-BxrNkBjdmj9w1hrRvN0N0hc",
          appId: "1:465350719340:android:75108ec5c673679a176549",
          messagingSenderId: '1093614007557',
          databaseURL: "https://macawproduction-8fff6-default-rtdb.firebaseio.com",
          storageBucket: "macawproduction-8fff6.appspot.com",
          projectId: "macawproduction-8fff6"));
  ///     flutter build apk --obfuscate --split-debug-info=build/app/outputs/

  runApp(const GetMaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const MyHomePage({super.key});

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
    await Geolocator.requestPermission().then((value) {}).onError((error, stackTrace) {
      printError();
    });
    protect = true;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) => currentPosition = position);
    protect = true;
  }

  Future<Position> requestUserPermissionLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError((error, stackTrace) async {
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
