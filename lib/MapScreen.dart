import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wooiproject/WidgetReUse/SuperController.dart';

import 'WidgetReUse/WidGetReUse.dart';

class MapScreen extends StatelessWidget {

  final wr = WidgetReUse();
  late GoogleMapController mapController;
  final ft = Get.put(MapScreenController());

  //final udl = Get.put(UpDateLocation());
  final gsc = Get.put(GlbSuperController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GetBuilder<MapScreenController>(
              init: MapScreenController(),
              builder: (value) => ft.protect.value == true
                  ? GoogleMap(
                      indoorViewEnabled: true,
                      compassEnabled: true,
                      buildingsEnabled: true,
                      myLocationEnabled: true,
                      onMapCreated: ft.onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(ft.currentPosition!.latitude,
                            ft.currentPosition!.longitude),
                        zoom: 16.0,
                      ),
                    )
                  : Container(
                      color: Colors.blue,
                      child: Text('no permission'),
                    ),
            ),
            wr.topButtonLeft(
                function: 'home', icon: Icons.arrow_back_ios_rounded),
            wr.topButtonRight(
                function: 'crlocation', icon: Icons.location_on_sharp),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Obx(
                            () => Text('status request:${gsc.requestId.value}'),
                          ),
                          Obx(
                            () => Text('${ft.readData.value}'),
                          )
                        ],
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Obx(
                            () => wr.reuseButton(
                                function: 'requestDriver',
                                label: gsc.requestStatus),
                          )),
                      FlatButton(
                          onPressed: () {
                            //udl.getLocation();
                          },
                          child: Text('')),
                      // FlatButton(
                      //     minWidth: Get.width,
                      //     color: Colors.yellow,
                      //     onPressed: () {
                      //       ft.onRequestLocation();
                      //     },
                      //     child: const Text(
                      //       "read ",
                      //       style: TextStyle(
                      //           color: Colors.black,
                      //           fontWeight: FontWeight.bold),
                      //     )),
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
}

class UpDateLocation extends GetxController {
  DatabaseReference updateLocation = FirebaseDatabase.instance.ref('users');

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  var latitude = 0.obs;
  var longtitude = 0.obs;

  getLocation() {
    updateLocation.onValue.listen((DatabaseEvent event) {
      latitude.value =
          int.parse(event.snapshot.child('latitude').value.toString());
      longtitude.value =
          int.parse(event.snapshot.child('longitude').value.toString());
      print('${latitude} ${longtitude}');
    });
  }
}

class MapScreenController extends GetxController {
  FirebaseFirestore dsad = FirebaseFirestore.instance;
  var winner = false.obs;
  int age = 321324;
  var name = 'dasdasd'.obs;
  var note = 'dasdasd'.obs;
  var currentAddress = '0'.obs;
  Position? currentPosition;
  var spin = false.obs;
  CollectionReference users = FirebaseFirestore.instance.collection('user');
  DatabaseReference ref = FirebaseDatabase.instance.ref("user");
  final readStorage = FirebaseDatabase.instance;
  var readData = ''.obs;
  DatabaseReference refs = FirebaseDatabase.instance.ref("users/123");
  Getter? gets = Getter();
  LatLng center = const LatLng(45.521563, -122.677433);
  late GoogleMapController mapController;
  var protect = false.obs;

  @override
  void onInit() async {
    request();
    super.onInit();
  }

  var controllermap = Completer().obs;

  onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    update();
    controllermap.value.complete(controller);
  }

  readFireStore() {}

  onRequestLocation() async {
    await refs.set({"name": "John", "age": 18, "address": "100 Mountain View"});
  }

  findDriver() {
    refs.onValue.listen((DatabaseEvent event) {
      gets?.age = int.parse(event.snapshot.child('age').value.toString());
      readData.value = (gets?.age).toString();
    });
  }

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
    send.child('location').child('user location').set("phnom pehn").asStream();
  }

  moveCamera() {
    CameraPosition(
      target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
      zoom: 16.0,
    );
    update();
  }

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
  }
}

class Getter {
  String name = '';
  int age = 0;
  String note = '';
}
