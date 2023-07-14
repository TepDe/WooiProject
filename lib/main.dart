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
  // await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         authDomain: 'wooi-c715e.web.app',
  //         databaseURL: "https://wooi-c715e-default-rtdb.firebaseio.com",
  //         apiKey: 'AIzaSyCXD78daMICVTVAXsmzNTvlk5TjDAgGdNQ',
  //         appId: '1:1093614007557:android:9efb550fcadd369394f36c',
  //         messagingSenderId: '1093614007557',
  //         projectId: 'wooi-c715e'));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: mc.isSignIn.value == true ? const LogInScreen() : const ViewScreen(),
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
  final glb = GlobalController();

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
