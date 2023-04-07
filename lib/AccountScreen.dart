import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/GlobalControl/StorageKey.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';

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
  String getUserID = 'loading...';
  var getUid;
  var getLocation;
  var getQty;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    driverMarkerList();
    var object = glb.getUserInformation();
    print(object);
    print(object);
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

  Future<void> insertTelegramToken() async {
    UserData userData = UserData();
    FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) {
      print(value);
      print(value);
      if (value.data()?.containsKey('telegramToken') == true) {
        print('true');
        print('true');
      } else {
        print('false');
        print('false');
      }
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

    setState(() {});
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

  final reUse = ReUseWidget();
  final theme = ThemesApp();
  bool light = false;

  @override
  Widget build(BuildContext context) {
    var imageSize = MediaQuery.of(context).size.height * 0.1;
    var viewHeight = MediaQuery.of(context).size.height * 0.05;
    var viewHeight2 = MediaQuery.of(context).size.height * 0.03;
    var viewHeight3 = MediaQuery.of(context).size.height * 0.08;
    var padding = MediaQuery.of(context).size.height * 0.01;
    return
        //   SafeArea(
        //   child: Scaffold(
        //     body: Column(
        //       children: [
        //         Text('AccountScreen'),
        //         ElevatedButton(
        //             onPressed: () {
        //               setState(() async{
        //                 await auth.signOut();
        //                 Get.to(LogInScreen());
        //               });
        //             },
        //             child: Text('Sign Out')),
        //         Text('${driverList.length}'),
        //         Text('${getLatitude ?? 'loading...'}'),
        //         Text('${getLongitude ?? 'loading...'}'),
        //         Text('${getUid ?? 'loading...'}'),
        //         Text('${getEmail ?? 'loading...'}'),
        //         Text('${getPassword ?? 'loading...'}'),
        //         Text('${getUserID ?? 'loading...'}'),
        //         ElevatedButton(
        //           onPressed: () {
        //             setState(() {
        //
        //               Fluttertoast.showToast(
        //                 msg: 'Hello, world!',
        //                 toastLength: Toast.LENGTH_SHORT,
        //                 gravity: ToastGravity.BOTTOM,
        //                 timeInSecForIosWeb: 1,
        //                 backgroundColor: Colors.red,
        //                 textColor: Colors.black,
        //                 fontSize: 16.0,
        //               );
        //             });
        //
        //           },
        //           child: Text('Show Toast'),
        //         ),
        //       ],
        //     ),
        //   ),
        // );
        SafeArea(
      child: Scaffold(
        backgroundColor: theme.liteGrey,
        body: SingleChildScrollView(
          child: Stack(children: [Center(
            child: Column(
              children: [
                SizedBox(
                  height: viewHeight2,
                ),
                reUse.reUseText(
                    content: 'Profile', weight: FontWeight.w500, size: 18.0),
                SizedBox(
                  height: viewHeight2,
                ),
                Container(
                  height: imageSize,
                  width: imageSize,
                  padding: const EdgeInsets.all(3.0),
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(50),
                  //     border: Border.all(color: theme.orange, width: 1.5)),
                  child: const CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSe1IKGF9z_2YNk4INs_zur1TjFIUtgpw_Ic2Jp2xxH5g&s"),
                  ),
                ),
                SizedBox(
                  height: viewHeight2,
                ),
                reUse.reUseText(
                    content: 'John Wick',
                    weight: FontWeight.bold,
                    size: 20.0,
                    color: theme.black),
                reUse.reUseText(
                    content: getUserID ?? 'loading...',
                    weight: FontWeight.bold,
                    size: 12.0,
                    color: theme.grey),
                SizedBox(
                  height: viewHeight2,
                ),
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: reUse.reUseText(
                        content: 'General',
                        weight: FontWeight.bold,
                        size: 16.0,
                        color: theme.black),
                  ),
                ),
                InkWell(
                    onTap: () {
                      reUse.reUseCircleDialog(
                          context: context,
                          title: 'title',
                          content: reUse.reUseTextFormField(),
                          icon: Icons.password);
                    },
                    child: Material(
                      color: Colors.transparent,
                      child: reUse.reUseSettingItem(
                          trailingIcon: Icon(Icons.visibility_off),
                          title: Text('Pin Code'),
                          context: context,
                          leading: Icon(Icons.password)),
                    )),
                reUse.reUseSettingItem(
                    trailingIcon: Switch(
                      // This bool value toggles the switch.
                      value: light,
                      activeColor: theme.btnBlue,
                      onChanged: (bool value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          light = value;
                        });
                      },
                    ),
                    title: Text('Light Mode'),
                    context: context,
                    leading: Icon(Icons.sunny)),
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: reUse.reUseText(
                        content: 'Account',
                        weight: FontWeight.bold,
                        size: 16.0,
                        color: theme.black),
                  ),
                ),
                reUse.reUseSettingItem(
                    trailingIcon: Text(
                      '${getEmail ?? 'loading...'}',
                      style: TextStyle(color: theme.grey),
                    ),
                    title: Text('Email'),
                    context: context,
                    leading: Icon(Icons.email)),
                reUse.reUseSettingItem(
                    trailingIcon: Text(
                      '${getPassword ?? 'loading...'}',
                      style: TextStyle(color: theme.grey),
                    ),
                    title: Text('Password'),
                    context: context,
                    leading: Icon(Icons.password_rounded)),
                reUse.reUseSettingItem(
                    function: 'token',
                    trailingIcon: Text(
                      '',
                      style: TextStyle(color: theme.grey),
                    ),
                    title: Text('Telegram Token'),
                    context: context,
                    leading: Icon(Icons.telegram_outlined)),
                Container(
                  margin: EdgeInsets.all(padding),
                  width: Get.width,
                  child: TextButton.icon(
                    onPressed: () {
                      reUse.reUseCircleDialog(
                          context: context,
                          function: 'logout',
                          title: 'Log Out',
                          content: Center(
                              child: Text('Are you sure you want to log out?')),
                          icon: Icons.login_outlined);
                    },
                    icon: Icon(Icons.login_rounded),
                    label: Text('Log Out'),
                    style: TextButton.styleFrom(
                      backgroundColor: theme.litestRed,
                      foregroundColor: theme.red,
                    ),
                  ),
                ),
              ],
            ),
          )],),
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
