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

// class MapScreen extends StatelessWidget {
//   final wr = ReUseWidget();
//   late GoogleMapController mapController;
//   final ft = Get.put(MapScreenController());
//   final udl = Get.put(UpDateLocation());
//   final gsc = Get.put(GlbSuperController());
//
//   MapScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }

class MapScreen extends StatefulWidget {
  MapScreen({Key? key, this.las, this.longs}) : super(key: key);
  var las;
  var longs;

  @override
  State<MapScreen> createState() => _MapScreenState(las, longs);
}

class _MapScreenState extends State<MapScreen> {
  var las;
  var longs;

  _MapScreenState(this.las, this.longs);

  late GoogleMapController mapController;
  final wr = ReUseWidget();

  final gsc = Get.put(GlbSuperController());

  @override
  void initState() {
    super.initState();
    diaplayDriverDistance();
    getLocation();
    onDisplayDriver();
  }

  late Position position;
  double latitude = 0.0;
  double longitude = 0.0;
  late LatLng currentPostion;
  late LatLng driverPostion = const LatLng(11.568553, 104.893228);

  void getUserLocation() async {
    position = await GeolocatorPlatform.instance.getCurrentPosition();
    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
      latitude = position.latitude;
      longitude = position.longitude;
    });
    await onDisplayDriver();
  }

  static const LatLng showLocation =
      LatLng(27.7089427, 85.3086209); //location to show in map
  final Set<Marker> markerList = {};
  Set<Marker> driverList = {};
  List laList = [];
  List longList = [];

  Set<Marker> onFeatchDriver() {
    setState(() {
      for (var i = 0; i < latitudeList.length; i++) {
        markerList.add(Marker(
          //add first marker
          markerId: MarkerId(showLocation.toString()),
          position:
              LatLng(latitudeList[i]['latitude'], latitudeList[i]['longitude']),
          //position of marker
          infoWindow: const InfoWindow(
            //popup info
            title: 'Marker Title First ',
            snippet: 'My Custom Subtitle',
          ),
          icon: BitmapDescriptor.defaultMarker, //Icon for Marker
        ));
      }
    });
    return markerList;
  }

  displayDriver() {
    DatabaseReference refs = FirebaseDatabase.instance.ref('Driver');
    refs.onValue.listen((event) {
      DataSnapshot latitude = event.snapshot;
      Map la = latitude.value as Map;
      la.forEach((key, value) {
        setState(() {
          latitudeList.add(value);
          for (var i = 0; i < latitudeList.length; i++) {
            onFeatchDriver();
          }
        });
      });
    });
    setState(() {});
  }

  List<LatLng> latLen = [
    // LatLng(19.0759837, 72.8776559),
    // LatLng(28.679079, 77.069710),
    // LatLng(26.850000, 80.949997),
    // LatLng(24.879999, 74.629997),
    // LatLng(16.166700, 74.833298),
    // LatLng(12.971599, 77.594563),
  ];

  var dasdasd;
  List latitudeList = [];
  final Set<Marker> _markers = {};

  onDisplayDriver() async {
    DatabaseReference refs = FirebaseDatabase.instance.ref('Driver');
    // latLen.add(currentPostion);
    refs.onValue.listen((event) async {
      DataSnapshot latitude = event.snapshot;
      Map la = latitude.value as Map;
      la.forEach((key, value) {
        setState(() async {
          latitudeList.add(value);
          print(latitudeList);

          // latLen.add(LatLng(latitudeList[i]['latitude'], latitudeList[i]['longitude']));
          for (var i = 0; i < latitudeList.length; i++) {
            latLen.add(LatLng(
                latitudeList[i]['latitude'], latitudeList[i]['longitude']));
            // driverList.add(Marker(
            //   //add first marker
            //   markerId: MarkerId(showLocation.toString()),
            //   position: LatLng(
            //       latitudeList[i]['latitude'], latitudeList[i]['longitude']),
            //   //position of marker
            //   infoWindow: const InfoWindow(
            //     //popup info
            //     title: 'Marker Title First ',
            //     snippet: 'My Custom Subtitle',
            //   ),
            //   icon: BitmapDescriptor.defaultMarker, //Icon for Marker
            // ));
            _markers.add(
              // added markers
              Marker(
                markerId: MarkerId(i.toString()),
                position: latLen[i],
                infoWindow: InfoWindow(
                  title: 'HOTEL',
                  snippet: '5 Star Hotel',
                ),
                icon: BitmapDescriptor.defaultMarker,
              ),
            );
            setState(() {});
          }
        });
      });
    });
   }

  Set<Marker> onGetDriver() {
    setState(() {
      markerList.add(Marker(
        //add first marker
        markerId: MarkerId(showLocation.toString()),
        position: currentPostion, //position of marker
        infoWindow: const InfoWindow(
          //popup info
          title: 'Marker Title First ',
          snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
      markerList.add(Marker(
        //add first marker
        markerId: MarkerId(showLocation.toString()),
        position: currentPostion, //position of marker
        infoWindow: const InfoWindow(
          //popup info
          title: 'Marker Title First ',
          snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
    });

    return markerList;
  }

  final Completer<GoogleMapController> _controller = Completer();
  bool isloading = false;

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  LocationPermission? permission;
  LatLng? _currentPosition;
  bool _isLoading = true;

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
                    markers: _markers,
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
                            // udl.getLocation();
                          },
                          child: Text('dad')),
                      Flexible(
                        child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: latitudeList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Text(
                                      'Entry ${latitudeList[index]['latitude']}'),
                                  Text(
                                      'Entry ${latitudeList[index]['longitude']}'),
                                ],
                              );
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
  Getter? gets = Getter();
  LatLng center = const LatLng(45.521563, -122.677433);
  late GoogleMapController mapController;
  var protect = false;

  final gsc = Get.put(GlbSuperController());

  var controllermap = Completer();

  readFireStore() {}

  onRequestLocation() async {
    await refs.set({"name": "John", "age": 18, "address": "100 Mountain View"});
  }

  findDriver() {
    refs.onValue.listen((DatabaseEvent event) {
      gets?.age = int.parse(event.snapshot.child('age').value.toString());
      readData = (gets?.age).toString();
    });
    addderewfg(readData);
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

class Getter {
  String name = '';
  int age = 0;
  String note = '';
}
