import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wooiproject/LoginScreen.dart';
import 'package:wooiproject/ViewScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );
  runApp(  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp()));
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

      home:  mc.isSignIn.value == true ? LogInScreen() : ViewScreen(),
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
        glb.UID.value = (user.uid).toString();
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
