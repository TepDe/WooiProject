import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatelessWidget {
  MapScreen({Key? key}) : super(key: key);

  final _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              buildingsEnabled: true,
              compassEnabled: true,
              myLocationButtonEnabled: true,
              indoorViewEnabled: true,
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(ft.currentPosition!.latitude,
                    ft.currentPosition!.longitude),
                zoom: 11.0,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: Get.width,
                height: 200,
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [

                      Row(
                        children: [
                          Text('status request:'),
                          Text('processing'),
                        ],
                      ),
                      FlatButton(
                          minWidth: Get.width,
                          color: Colors.yellow,
                          onPressed: () {},
                          child: const Text(
                            "Request",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  final ft = Get.put(FirebaseText());
}

class FirebaseText extends GetxController {
  FirebaseFirestore dsad = FirebaseFirestore.instance;
  var winner = false.obs;
  int age = 321324;
  var name = 'dasdasd'.obs;
  var note = 'dasdasd'.obs;
  var currentAddress = '0'.obs;
  Position? currentPosition;
  var spin = false.obs;

  @override
  void onInit() async {
    request();
    super.onInit();
  }

  CollectionReference users = FirebaseFirestore.instance.collection('user');
  DatabaseReference ref = FirebaseDatabase.instance.ref("user");
  final readStorage = FirebaseDatabase.instance;

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
          'name': 'dasdasd', // John Doe
          'age': 3213, // Stokes and Sons
          'note': 'age' // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  readDataBase() {
    var send = readStorage.reference();
    send
        .child('location')
        .push()
        .child('User location')
        .set("phnom pehn")
        .asStream();
  }

  request() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print('$error' + "" + '$stackTrace');
      printError();
    });

    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best)
        .then((Position position) => currentPosition = position);
  }
}
