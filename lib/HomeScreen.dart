import 'dart:io';
import 'package:intl/intl.dart'; // for date formatting and parsing
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wooiproject/CompleteDetail.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/GlobalControl/StorageKey.dart';
import 'package:wooiproject/GlobalControl/clsField.dart';
import 'package:wooiproject/ReturnDetail.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final reUse = ReUseWidget();
  final theme = ThemesApp();
  List driverList = [];
  List totalPackageIndex = [];
  List completeData = [];
  List returnData = [];
  final field = FieldData();
  int doubleClick = 0;
  final glb = GlobalController();
  List distince = [];

  String getUserID = '';
  final str = StorageKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalListLength();
    completeListLength();
    pendingListLength();
    returnListLength();
    fetchImage();
    onGetUserData();
    alertNoInternet();
  }

  alertNoInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      return reUse.reUseCircleDialog(
          function: 'nointernet',
          disposeAllow: false,
          context: context,
          icon: Icons.wifi,
          title: 'Connection Lost',
          content: Center(
            child: Text(
              'No internet connection please try again',
              style: TextStyle(
                color: theme.black,
              ),
            ),
          ));
    }
  }

  late Map data;

  onGetUserData() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await FirebaseFirestore.instance.collection('Users').doc(auth.currentUser!.uid).get().then((doc) async {
        data = await doc.data() as Map;
        if (data["accountType"] != "Users") {
          await reUse.reUseCircleDialog(
              disposeAllow: false,
              onTap: () => glb.isLogOut(),
              context: context,
              icon: Icons.wifi,
              title: 'មិនមាន',
              content: Center(
                child: Text(
                  'គណនីនេះមិនមានទេ សូមពិនិត្យមើលម្តងទៀត!',
                  style: TextStyle(
                    color: theme.black,
                  ),
                ),
              ));
          setState(() {});
        } else if (data["isBanned"] != "false") {
          await reUse.reUseCircleDialog(
              disposeAllow: false,
              onTap: () => glb.isLogOut(),
              context: context,
              icon: Icons.cancel_outlined,
              title: 'ផ្អាក',
              content: Center(
                child: Text(
                  'បច្ចុប្បន្នគណនីនេះត្រូវបានផ្អាក',
                  style: TextStyle(
                    color: theme.black,
                  ),
                ),
              ));
          setState(() {});
        }
        getUserID = data['userID'];
        await prefs.setString(str.userID, getUserID.toString());
        setState(() {});
      });
    } catch (e) {}
  }

  totalListLength() async {
    try {
      DatabaseReference refs = FirebaseDatabase.instance.ref('PackageRequest').child(auth.currentUser!.uid);
      await refs.onValue.listen((event) {
        driverList.clear();
        totalPackageIndex.clear();
        DataSnapshot driver = event.snapshot;
        Map<dynamic, dynamic> values = driver.value as Map<dynamic, dynamic>;
        values.forEach((key, values) async {
          Map<dynamic, dynamic> data = await values as Map<dynamic, dynamic>;
          data.forEach((key, value) async {
            totalPackageIndex.add(key);
            driverList.add(value);
            setState(() {});
          });
        });
      });
    } catch (e) {
      print('totalListLength $e');
    }
  }

  List pendingList = [];

  pendingListLength() async {
    try {
      DatabaseReference refs = await FirebaseDatabase.instance.ref('Pending');
      await refs.onValue.listen((event) async {
        pendingList.clear();
        DataSnapshot driver = await event.snapshot;
        Map<dynamic, dynamic> values = await driver.value as Map<dynamic, dynamic>;
        values.forEach((key, value) async {
          Map data = await value[auth.currentUser!.uid] as Map<dynamic, dynamic>;
          data.forEach((key, value) {
            pendingList.add(value);
            setState(() {});
          });
        });
      });
    } catch (e) {
      print('pendingListLength $e');
    }
  }

  completeListLength() async {
    try {
      DatabaseReference refs = FirebaseDatabase.instance.ref('Complete').child(auth.currentUser!.uid);
      refs.onValue.listen((event) async {
        completeData.clear();
        forSort.clear();
        compSort.clear();
        DataSnapshot driver = await event.snapshot;
        Map<dynamic, dynamic> values = driver.value as Map<dynamic, dynamic>;
        values.forEach((key, value) async {
          completeData.add(value);
          compSort.add(value);
          setState(() {});
        });
      });
      mergeList(ret: completeData);
    } catch (e) {
      print('completeListLength $e');
    }
  }

  Future<void> returnListLength() async {
    try {
      DatabaseReference refs = await FirebaseDatabase.instance.ref('Return').child(auth.currentUser!.uid);
      await refs.onValue.listen((event) async {
        returnData.clear();
        forSort.clear();
        retSort.clear();
        DataSnapshot driver = await event.snapshot;
        Map<dynamic, dynamic> values = await driver.value as Map<dynamic, dynamic>;
        values.forEach((key, value) async {
          returnData.add(value);
          retSort.add(value);
          setState(() {});
        });
      });
    } catch (e) {
      print('returnListLength $e');
    }
    mergeList(ret: returnData);
  }

  List mergeList({List? comp, List? ret}) {
    List merge = comp! + ret!;
    List Result = [];
    merge.forEach((element) async {
      DateTime frmDate = DateFormat("dd-MM-yyyy").parse(element[field.returnDate] ?? element[field.completeDate]);
      if (frmDate.day == today.day && frmDate.month == today.month && frmDate.year == today.year) {
        Result.add(element);
        setState(() {});
      }
    });
    Result.sort((a, b) {
      DateTime dateA = DateFormat("dd-MM-yyyy  hh:mm a").parse(a[field.completeDate] ?? a[field.returnDate]);
      DateTime dateB = DateFormat("dd-MM-yyyy  hh:mm a").parse(b[field.completeDate] ?? b[field.returnDate]);
      setState(() {});
      return dateB.compareTo(dateA);
    });
    return Result;
  }

  DateTime today = DateTime.now();

  String currentTime() {
    String greeting = '';
    int hours = today.hour;
    if (hours >= 1 && hours <= 12) {
      greeting = "អរុណ សួស្តី";
    } else if (hours >= 12 && hours <= 16) {
      greeting = "ទិវា សួស្ដី";
    } else if (hours >= 16 && hours <= 21) {
      greeting = "សាយ័ណ សួរស្តី";
    } else if (hours >= 21 && hours <= 24) {
      greeting = "រាត្រី សួស្តី";
    } else {
      greeting = "រាត្រី សួស្តី";
    }
    return greeting;
  }

  bool circleIndicator = false;
  var _image = null;

  // late File _image = 'assets/images/no_photo.png';

  double paddings = 10.0;
  final clsLan = ClsLanguage();

  fetchImage() async {
    final prefs = await SharedPreferences.getInstance();
    getImageFileFromPath(prefs.getString(str.profileImg).toString());
  }

  Future<File> getImageFileFromPath(String imagePath) async {
    return File(imagePath);
  }

  // List todayDateStrings=[];
  @override
  Widget build(BuildContext context) {
    forSort = mergeList(comp: compSort, ret: retSort);
    var imageSize = MediaQuery.of(context).size.height * 0.08;
    var qrSize = MediaQuery.of(context).size.height * 0.25;
    var flotBtn = MediaQuery.of(context).size.height * 0.08;
    var flotIcon = MediaQuery.of(context).size.height * 0.045;
    return Scaffold(
        backgroundColor: theme.liteGrey,
        floatingActionButton: SizedBox(
          width: flotBtn,
          height: flotBtn,
          child: FloatingActionButton(
            elevation: 3,
            backgroundColor: theme.deepOrange,
            onPressed: () async {
              reUse.reUseCircleDialog(
                  context: context,
                  onTap: () => Navigator.pop(context),
                  title: 'Qr កូត',
                  content: Column(
                    children: [
                      SizedBox(
                        height: qrSize,
                        width: qrSize,
                        child: QrImageView(
                          data:
                              "${data['phoneNumber']},${data['email']},${data['firstname']},${data['lastname']},${auth.currentUser!.uid}",
                          version: QrVersions.auto,
                          size: qrSize,
                        ),
                      ),
                      reUse.reUseText(
                          content: "សូមបង្ហាញកូដនេះដល់អ្នកដឹកជញ្ជូនរបស់យើងនៅពេលគាត់មកទទួលទំនិញ",
                          maxLines: 3,
                          size: 14.0),
                    ],
                  ),
                  icon: Icons.qr_code_scanner_rounded);
            },
            child: Icon(Icons.qr_code_scanner_rounded, size: flotIcon),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Padding(
              //   padding: EdgeInsets.only(top: 10, right: paddings, left: paddings),
              //   child: reUse.unitOneHomeScreen(userID: '$greeting\nID $getUserID', context: context),
              // ),
              // SizedBox(
              //   height: 100,
              //   width: 100,
              //   child: QrImageView(
              //     data: '1234567890',
              //     version: QrVersions.auto,
              //     size: 200.0,
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(top: 10, right: paddings, left: paddings),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    reUse.reUseText(
                        size: 20.0,
                        color: theme.black,
                        weight: FontWeight.bold,
                        content: '${currentTime()}\nID $getUserID'),
                    FutureBuilder<String?>(
                      future: SharedPreferences.getInstance().then((prefs) => prefs.getString(str.profileImg)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Display a loading indicator while waiting for data
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          // Handle error case
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData && snapshot.data != null) {
                          String imagePath = snapshot.data!;
                          return FutureBuilder<File>(
                            future: getImageFileFromPath(imagePath),
                            builder: (context, fileSnapshot) {
                              if (fileSnapshot.connectionState == ConnectionState.waiting) {
                                // Display a loading indicator while waiting for image file
                                return const Center(child: CircularProgressIndicator());
                              } else if (fileSnapshot.hasError) {
                                // Handle error case
                                return Center(child: Text('Error: ${fileSnapshot.error}'));
                              } else if (fileSnapshot.hasData && fileSnapshot.data != null) {
                                File imageFile = fileSnapshot.data!;
                                return SizedBox(
                                  height: imageSize,
                                  width: imageSize,
                                  child: CircleAvatar(backgroundImage: FileImage(imageFile)),
                                );
                              } else {
                                // Image not found
                                return const Center(child: Text('Image not found'));
                              }
                            },
                          );
                        } else {
                          // No image stored
                          return Icon(
                            Icons.account_circle_rounded,
                            size: imageSize,
                            color: theme.grey,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(paddings),
                child: reUse.unitTwoHomeScreen(
                    context: context,
                    totalPackageDataKey: totalPackageIndex,
                    totalPackageData: driverList,
                    returnData: returnData,
                    completeData: completeData,
                    returnLength: returnData.length,
                    completeLength: completeData.length,
                    pendingData: pendingList,
                    totalLength: driverList.length,
                    pendingLength: pendingList.length),
              ),

              //wr.unitThreeHomeScreen(icon: Icons.directions_car, lable: 'Car',price: '2143', funtion: 'motor',context: context),
              // wr.unitThreeHomeScreen(icon: Icons.motorcycle, lable: 'Motorcycle',price: '2143', funtion: '',context: context),
              //reUse.renderListView(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: paddings),
                child: reUse.reUseCreatePackage(context: context, padding: paddings, height: Get.height * 0.02),
              ),
              Row(
                children: [
                  reUse.reUseText(content: "   ${clsLan.today} : ${forSort.length}", color: theme.grey),
                  Divider(
                    height: 1,
                    color: theme.grey,
                  ),
                ],
              ),
              forSort.isNotEmpty
                  ? Flexible(
                      child: SingleChildScrollView(
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            itemCount: forSort.length,
                            itemBuilder: (BuildContext context, int index) {
                              return reUse.reUseTodayComponent(
                                  onTap: () {
                                    if (forSort[index][field.status] == 'complete') {
                                      Get.to(() => const CompleteDetail(), arguments: forSort[index]);
                                    } else if (forSort[index][field.status] == 'return') {
                                      Get.to(() => const ReturnDetail(), arguments: forSort[index]);
                                    }
                                  },
                                  value: forSort[index],
                                  completeDate: forSort[index][field.completeDate],
                                  returnDate: forSort[index][field.returnDate],
                                  status: forSort[index][field.status]);
                            }),
                      ),
                    )
                  : Container(),
            ],
          ),
        ));
  }

  List filterAndSortDatesForToday() {
    DateTime today = DateFormat("dd-MM-yyyy  HH:mm a").parse(DateTime.now().toString());
    List todayDateStrings = [];
    (returnData + completeData).forEach((element) {
      DateTime data = DateFormat("dd-MM-yyyy  HH:mm a").parse(element[field.completeDate] ?? element[field.returnDate]);
      if (data.day == today.day && data.month == today.month && data.year == today.year) {
        todayDateStrings.add(element);
      } else {}
    });
    return todayDateStrings;
  }

  List retSort = [];
  List forSort = [];
  List compSort = [];
  FirebaseAuth auth = FirebaseAuth.instance;

// isNullUserID() async {
//   final prefs = await SharedPreferences.getInstance();
//
//   CollectionReference users = FirebaseFirestore.instance.collection('Users');
//   int? userID;
//   var rng = Random();
//   userID = rng.nextInt(999999);
//   await users
//       .doc(auth.currentUser!.uid)
//       .update({'userID': userID}).then((value) async {
//     await prefs.setString(str.userID, userID.toString());
//
//     print("User Updated");
//   }).catchError((error) => print("Failed to update user: $error"));
//   await checkID();
//   setState(() {});
// }
}

class QrData {
  String phoneNumber = '';
  String email = '';
  String firstname = '';
  String lastname = '';
  String userID = '';
// QrData({required this.phoneNumber, required this.email, required this.firstname, required this.lastname, required this.userID});
}
