import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wooiproject/WidgetReUse/SuperController.dart';
import 'dart:math' show cos, sqrt, asin;

import 'WidgetReUse/ReUseWidget.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final wr = ReUseWidget();
  final Completer<GoogleMapController> _controller = Completer();
  bool isloading = false;
  final gsc = Get.put(GlbSuperController());
  late Position position;
  double latitude = 0.0;
  double longitude = 0.0;
  late LatLng currentPostion;
  late LatLng driverPostion = const LatLng(11.568553, 104.893228);
  var dasdasd;
  final Set<Marker> _markers = {};
  LocationPermission? permission;
  LatLng? _currentPosition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    getLocation();
    onDisplayDriver();
  }

  onDisplayDriver() async {
    DatabaseReference refs = FirebaseDatabase.instance.ref('Driver');
    refs.onValue.listen((event) async {
      _latLen.clear();
      DataSnapshot location = event.snapshot;
      Map drvData = location.value as Map;
      drvData.forEach((key, value) async {
        _latLen.add(LatLng(value['latitude'], value['longitude']));
        loadData(_latLen);
      });
    });
  }

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  getLocation() async {
    permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;
    LatLng location = LatLng(lat, long);
    setState(() {
      _currentPosition = location;
      _isLoading = false;
    });
  }

  final List<LatLng> _latLen = <LatLng>[];

  loadData(List<LatLng> listData) async {
    for (int i = 0; i < listData.length; i++) {
      _markers.add(Marker(
        markerId: MarkerId(i.toString()),
        position: listData[i],
        infoWindow: InfoWindow(
          title: 'Location: ' + i.toString(),
        ),
      ));
      setState(() {});
    }
  }

  onMoveCameraAtLocation() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _isLoading == true
                ? Container()
                : GoogleMap(
                    indoorViewEnabled: true,
                    compassEnabled: true,
                    buildingsEnabled: true,
                    myLocationEnabled: true,
                    markers: Set<Marker>.of(_markers),
                    // markers: Set<Marker>.of(driverList),
                    onMapCreated: onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition!,
                      zoom: 16,
                    ),
                  ),
            wr.topButtonLeft(
                function: 'home', icon: Icons.arrow_back_ios_rounded),
            wr.topButtonRight(
                function: 'crlocation', icon: Icons.location_on_sharp),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 250,
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
                          Text('status request: '),
                          Text(' '),
                        ],
                      ),
                      ElevatedButton(
                          onPressed: () {
                            onDisplayDriver();
                            // udl.getLocation();
                          },
                          child: Text('Refesh')),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              mapController.animateCamera(
                                  CameraUpdate.newLatLngZoom(
                                      LatLng(_currentPosition!.latitude,
                                          _currentPosition!.longitude),
                                      14));
                            });
                          },
                          child: Text('My Location')),
                      Text('status request: (${_latLen.length})'),
                      Flexible(
                        child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: _latLen.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text('Entry (${_latLen[index]})');
                            }),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: wr.reuseButton(
                            function: 'requestDriver',
                            label: gsc.requestStatus),
                      ),
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

  diaplayDriverDistance() {
    double calculateDistance(lat1, lon1, lat2, lon2) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    }

    List<dynamic> data = [
      {"lat": 44.968046, "lng": -94.420307},
      {"lat": 44.33328, "lng": -89.132008},
      {"lat": 33.755787, "lng": -116.359998},
      {"lat": 33.844843, "lng": -116.54911},
      {"lat": 44.92057, "lng": -93.44786},
      {"lat": 44.240309, "lng": -91.493619},
      {"lat": 44.968041, "lng": -94.419696},
      {"lat": 44.333304, "lng": -89.132027},
      {"lat": 33.755783, "lng": -116.360066},
      {"lat": 33.844847, "lng": -116.549069},
    ];
    double totalDistance = 0;
    for (var i = 0; i < data.length - 1; i++) {
      totalDistance += calculateDistance(data[i]["lat"], data[i]["lng"],
          data[i + 1]["lat"], data[i + 1]["lng"]);
    }
    print(totalDistance);
  }
}

class driverData {
  double latitude = 0;
  double longitude = 0;
}

class MapScreenController {
  final dbRef = FirebaseDatabase.instance.ref().child("users");
  FirebaseFirestore dsad = FirebaseFirestore.instance;
  Position? currentPosition;
  CollectionReference users = FirebaseFirestore.instance.collection('User');
  DatabaseReference ref = FirebaseDatabase.instance.ref("user");
  final readStorage = FirebaseDatabase.instance;
  var readData = '';
  DatabaseReference refs = FirebaseDatabase.instance.ref("users/123");
  LatLng center = const LatLng(45.521563, -122.677433);
  late GoogleMapController mapController;
  var protect = false;

  final gsc = Get.put(GlbSuperController());

  var controllermap = Completer();

  readFireStore() {}

  onRequestLocation() async {
    await refs.set({"name": "John", "age": 18, "address": "100 Mountain View"});
  }

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
          'name': 'dasdasd', // John Doe
          'age': '3213', // Stokes and Sons
          'note': 'age' // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  addderewfg(we) {
    var s = we;
    var a = 09;
    var total;
    total = s + a;
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
  }

  request() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print('$error' + "" + '$stackTrace');
    });
    protect = true;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) => currentPosition = position);
    protect = true;
  }

  test() {}
}

class FetchDriver {}
