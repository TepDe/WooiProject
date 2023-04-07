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
  String getLatitude = 'loading...';
  String getLongitude = 'loading...';
  String getIsGoOnline = 'loading...';
  String getPhoneNumber = 'loading...';
  String getEmail = 'loading...';
  String getPassword = 'loading...';
  String getUserName = 'loading...';
  String getUserID = 'loading...';
  String getUid = 'loading';
  String getLocation = 'loading';
  String getQty = 'loading';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //fetchLocalStorage();
    fetchUserData();
    setState(() {});
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

  var fetch = FirebaseFirestore.instance.collection('Users');

  fetchUserData() async {
    fetch
        .doc(auth.currentUser!.uid.toString())
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      getLatitude = documentSnapshot['latitude'].toString();
      getLongitude = documentSnapshot['longitude'].toString();
      getUid = documentSnapshot['uid'].toString();
      getEmail = documentSnapshot['email'].toString();
      getPassword = documentSnapshot['password'].toString();
      getUserID = documentSnapshot['userID'].toString();
      setState(() {});
    });
    setState(() {});
  }

  final reUse = ReUseWidget();
  final theme = ThemesApp();
  bool light = false;

  final token = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var imageSize = MediaQuery.of(context).size.height * 0.1;
    var viewHeight2 = MediaQuery.of(context).size.height * 0.03;
    var padding = MediaQuery.of(context).size.height * 0.01;
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.liteGrey,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: viewHeight2,
                    ),
                    reUse.reUseText(
                        content: 'Profile',
                        weight: FontWeight.w500,
                        size: 18.0),
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
                        content: 'ID : $getUserID',
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
                          getEmail,
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
                    // reUse.reUseSettingItem(
                    //     function: 'token',
                    //     trailingIcon: Text(
                    //       '',
                    //       style: TextStyle(color: theme.grey),
                    //     ),
                    //     title: Text('Telegram Token'),
                    //     context: context,
                    //     leading: Icon(Icons.telegram_outlined)),
                    Container(
                      height: 60,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: theme.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: theme.midGrey,
                            blurRadius: 2,
                            offset: const Offset(0, 0), // Shadow position
                          ),
                        ],
                      ),
                      child: Material(
                        color: theme.white,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.topCenter,
                                    children: [
                                      Positioned(
                                        top: -60.0,
                                        child: CircleAvatar(
                                          radius: 60.0,
                                          backgroundColor: theme.white,
                                          child: Icon(
                                            Icons.telegram_rounded,
                                            color: theme.orange,
                                            size: 100.0,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 80.0, left: 15, right: 15),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            reUse.reUseText(
                                                content:
                                                    'Insert your telegram token down here',
                                                color: theme.grey,
                                                weight: FontWeight.w500,
                                                size: 14.0),
                                            const SizedBox(height: 20.0),
                                            // Text(
                                            //   content,
                                            //   textAlign: TextAlign.center,
                                            //   style: const TextStyle(
                                            //     fontSize: 16.0,
                                            //   ),
                                            // ),
                                            Container(
                                              height: 60,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 3),
                                              decoration: BoxDecoration(
                                                color: theme.white,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: theme.midGrey,
                                                    blurRadius: 2,
                                                    offset: const Offset(0,
                                                        0), // Shadow position
                                                  ),
                                                ],
                                              ),
                                              child: TextFormField(
                                                controller: token,
                                                decoration: InputDecoration(
                                                  prefixIcon:
                                                      Icon(Icons.key_rounded),
                                                  suffixIcon: const Icon(
                                                    Icons.search,
                                                    color: Colors.transparent,
                                                  ),
                                                  filled: true,
                                                  fillColor: theme.white,
                                                  hintText: 'hintText',
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.7),
                                                  ),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.7),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 20.0),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              child: Flexible(
                                                child: Container(
                                                  height: 40,
                                                  width: Get.width,
                                                  decoration: BoxDecoration(
                                                    color: theme.litestOrange,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    // boxShadow: [
                                                    //   BoxShadow(
                                                    //     color: Colors.grey,
                                                    //     blurRadius: 1,
                                                    //     //offset: Offset(4, 8), // Shadow position
                                                    //   ),
                                                    // ],
                                                  ),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: () {
                                                        glb.insertTelegramToken(
                                                            token: token.text);
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 8.0),
                                                            child: Icon(
                                                              null,
                                                              color:
                                                                  theme.orange,
                                                            ),
                                                          ),
                                                          Text(
                                                            'ok',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    theme.black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Center(
                            child: ListTile(
                              title: Text('Telegram Token'),
                              trailing: Text(''),
                              leading: Icon(Icons.telegram_rounded),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(padding),
                      width: Get.width,
                      child: TextButton.icon(
                        onPressed: () {
                          reUse.reUseCircleDialog(
                              data: token.text.toString(),
                              context: context,
                              function: 'logout',
                              title: 'Log Out',
                              content: Center(
                                  child: Text(
                                      'Are you sure you want to log out?')),
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
              )
            ],
          ),
        ),
      ),
    );
  }

  List driverList = [];

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
