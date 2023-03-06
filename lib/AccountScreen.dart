import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/GlobalControl/StorageKey.dart';
import 'package:wooiproject/LoginScreen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final dbRef =
      FirebaseDatabase.instance.reference().child("Driver").child("PlantData");

  List lists = [];
  final str = StorageKey();
  var getStr = GlobalController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    driverMarkerList();
  }

  @override
  Widget build(BuildContext context) {
    getStr.onGetLocalStorage();
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text('AccountScreen'),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    auth.signOut();
                    Get.to(LogInScreen());
                  });
                },
                child: Text('Sign Out')),
            // Flexible(
            //   child: ListView.builder(
            //       padding: const EdgeInsets.all(8),
            //       itemCount: lists.length,
            //       itemBuilder: (BuildContext context, int index) {
            //         return Center(child: Text('Entry '));
            //       }),
            // ),
            Text('${driverList.length}'),
            Text('${getStr.getLatitude}'),
            Text('${getStr.getLongitude}'),
            Text('${getStr.getUid}'),
            Text('${getStr.getEmail}'),
            Text('${getStr.getPassword}'),
          ],
        ),
      ),
    );
  }

  Query query = FirebaseDatabase.instance.ref().child('Driver');
  List driverList = [];

  driverMarkerList() {
    DatabaseReference refs = FirebaseDatabase.instance.ref('Driver');
    refs.onValue.listen((event) {
      DataSnapshot driver = event.snapshot;
      Map values = driver.value as Map;
      values.forEach((key, values) {
        setState(() {
          driverList.add(values);
        });
      });
      print(driverList);
    });
  }

  onFeatchDriver() {
    DatabaseReference refs = FirebaseDatabase.instance.ref('Driver');
    refs.onValue.listen((event) {
      DataSnapshot latitude = event.snapshot.child('latitude');
      DataSnapshot longitude = event.snapshot.child('longitude');
      // Map driver = dataValues.value as Map;
      driverList.forEach((element) {
        element.latitude = latitude as double;
        element.longitude = longitude as double;
      });

      //
      // markerList.add(Marker(
      //   //add first marker
      //   markerId: MarkerId(showLocation.toString()),
      //   position: LatLng(312, 21313), //position of marker
      //   infoWindow: const InfoWindow(
      //     //popup info
      //     title: 'Marker Title First ',
      //     snippet: 'My Custom Subtitle',
      //   ),
      //   icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      // ));
    });
  }

  shotData() {
    return Flexible(
        child: FirebaseAnimatedList(
            query: query,
            padding: const EdgeInsets.all(8.0),
            reverse: false,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int x) {
              // Map lati = snapshot.value as Map;
              // lati[auth.currentUser!.uid];
              return Column(
                children: [
                  Text('longitude=> ${snapshot.child('longitude').value}'),
                  Text('latitude=> ${snapshot.child('latitude').value}'),
                ],
              );
            }));
  }
}

class driverData {
  double latitude = 0;
  double longitude = 0;
}
