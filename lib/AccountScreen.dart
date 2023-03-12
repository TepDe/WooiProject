import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  var glb = GlobalController();
  var getLatitude;
  var getLongitude;
  var getIsGoOnline;
  var getPhoneNumber;
  var getEmail;
  var getPassword;
  var getUserName;
  var getUserID;
  var getUid;
  var getLocation;
  var getQty;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    driverMarkerList();
    //fetchLocalStorage();
    fetchUserData();
  }

  getDatsa(getUid) async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(getUid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      getUserID = documentSnapshot['qty'];

    });
  }

  fetchLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    getLatitude = prefs.getString(str.latitude) ?? '';
    getLongitude = prefs.getString(str.longitude) ?? '';
    getUid = prefs.getString(str.uid) ?? '';
    getEmail = prefs.getString(str.email) ?? '';
    getPassword = prefs.getString(str.password) ?? '';
    getUserID = prefs.getString(str.userID) ?? '';

    setState(() {
    });
  }


  fetchUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid.toString())
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      getLatitude = await documentSnapshot['latitude'];
      getLongitude = await documentSnapshot['longitude'];
      getUid = await documentSnapshot['uid'];
      getEmail = await documentSnapshot['email'];
      getPassword = await documentSnapshot['password'];
      getUserID = await documentSnapshot['userID'];
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text('AccountScreen'),
            ElevatedButton(
                onPressed: () {
                  setState(() async{
                    await auth.signOut();
                    Get.to(LogInScreen());
                  });
                },
                child: Text('Sign Out')),
            Text('${driverList.length}'),
            Text('${getLatitude ?? 'loading...'}'),
            Text('${getLongitude ?? 'loading...'}'),
            Text('${getUid ?? 'loading...'}'),
            Text('${getEmail ?? 'loading...'}'),
            Text('${getPassword ?? 'loading...'}'),
            Text('${getUserID ?? 'loading...'}'),
          ],
        ),
      ),
    );
  }

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
}

class driverData {
  double latitude = 0;
  double longitude = 0;
}
