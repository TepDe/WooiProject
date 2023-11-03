import 'dart:async';
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
import 'package:swipe_refresh/swipe_refresh.dart';
import 'package:wooiproject/CompleteDetail.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/GlobalControl/StorageKey.dart';
import 'package:wooiproject/GlobalControl/clsField.dart';
import 'package:wooiproject/LoginScreen.dart';
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
    fetchImage();
    alertNoInternet();
    onInitialize();
  }

  Future<void> onInitialize() async {
    await onGetUserData();
    await totalListLength();
    await completeListLength();
    await pendingListLength();
    await returnListLength();
    forSort = mergeList(comp: compSort, ret: retSort);
    setState(() {});
  }

  alertNoInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
       reUse.reUseCircleDialog(
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
  var userInfo = FirebaseFirestore.instance.collection('Users');

  Future<void> onGetUserData() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      var information = await userInfo.doc(auth.currentUser!.uid).get();
      final bool doesDocExist = information.exists;
      if (doesDocExist == false) {
        auth.signOut();
        Get.to(() => const LogInScreen());
      } else {
        await userInfo.doc(auth.currentUser!.uid).get().then((doc) async {
          data = doc.data() as Map;
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
          }
          getUserID = data['userID'];
          await prefs.setString(str.userID, getUserID.toString());
        });
      }
    } catch (e) {
      // FirebaseAuth.instance.signOut();
      // Get.to(()=> const LogInScreen());
    }
  }

  DatabaseReference requestDB = FirebaseDatabase.instance.ref('PackageRequest');

  Future<void> totalListLength() async {
    try {
      final isRequestDB = await requestDB.child(auth.currentUser!.uid).onValue.first;
      driverList.clear();
      totalPackageIndex.clear();
      DataSnapshot driver = isRequestDB.snapshot;
      Map values = driver.value as Map;
      values.forEach((key, values) {
        Map data = values as Map;
        data.forEach((key, value) {
          totalPackageIndex.add(key);
          driverList.add(value);
        });
      });
    } catch (e) {
      print('totalListLength $e');
      // FirebaseAuth.instance.signOut();
      // Get.to(() => const LogInScreen());
    }
  }

  List pendingList = [];
  DatabaseReference pendingDB = FirebaseDatabase.instance.ref('Pending');

  Future<void> pendingListLength() async {
    try {
      final isPendingDB = await pendingDB.onValue.first;
      pendingList.clear();
      DataSnapshot driver = isPendingDB.snapshot;
      Map values = driver.value as Map;
      values.forEach((key, value) {
        Map data = value as Map;
        data.forEach((key, value) {
          if( key.toString() == auth.currentUser?.uid.toString()){
            Map data = value as Map;
            data.forEach((key, value) {
              pendingList.add(value);
              setState(() {});
            });
          }
        });
      });
    } catch (e) {
      // print('pendingListLength $e');
      // FirebaseAuth.instance.signOut();
      // Get.to(()=> const LogInScreen());
    }
  }

  DatabaseReference completeDB = FirebaseDatabase.instance.ref('Complete');

  Future<void> completeListLength() async {
    try {
      final isCompleteDb = await completeDB.child(auth.currentUser!.uid).onValue.first;
      completeData.clear();
      forSort.clear();
      compSort.clear();
      DataSnapshot driver = isCompleteDb.snapshot;
      Map values = driver.value as Map;
      values.forEach((key, value) async {
        completeData.add(value);
        compSort.add(value);
      });
    } catch (e) {}
  }

  DatabaseReference returnDB = FirebaseDatabase.instance.ref('Return');

  Future<void> returnListLength() async {
    try {
      final isReturnDB = await returnDB.child(auth.currentUser!.uid).onValue.first;
      returnData.clear();
      forSort.clear();
      retSort.clear();
      DataSnapshot driver = isReturnDB.snapshot;
      Map values = driver.value as Map;
      values.forEach((key, value) async {
        returnData.add(value);
        retSort.add(value);
        setState(() {});
      });
    } catch (e) {
      // print('returnListLength $e');
      // FirebaseAuth.instance.signOut();
      // Get.to(()=> const LogInScreen());
    }
  }

  List mergeList({List? comp, List? ret}) {
    List merge = comp! + ret!;
    DateTime parseDate(String dateString) {
      return DateTime.parse(dateString);
    }

    merge.sort((a, b) {
      DateTime dateA = parseDate(a["completeDate"] ?? a["returnDate"]);
      DateTime dateB = parseDate(b["completeDate"] ?? b["returnDate"]);
      return dateB.compareTo(dateA);
    });
    return merge;
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
  double paddings = 10.0;
  final clsLan = ClsLanguage();

  fetchImage() async {
    final prefs = await SharedPreferences.getInstance();
    getImageFileFromPath(prefs.getString(str.profileImg).toString());
  }

  Future<File> getImageFileFromPath(String imagePath) async {
    return File(imagePath);
  }

  final _controller = StreamController<SwipeRefreshState>.broadcast();

  Stream<SwipeRefreshState> get _stream => _controller.stream;

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    onInitialize();
    _controller.sink.add(SwipeRefreshState.hidden);
  }

  @override
  Widget build(BuildContext context) {
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
                      future: SharedPreferences.getInstance()
                          .then((prefs) => prefs.getString(str.profileImg)),
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
              Flexible(
                child: SwipeRefresh.material(
                  stateStream: _stream,
                  onRefresh: _refresh,
                  shrinkWrap: true,
                  children: [
                    Column(mainAxisSize: MainAxisSize.min, children: [
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: paddings),
                        child: reUse.reUseCreatePackage(
                            context: context, padding: paddings, height: Get.height * 0.02),
                      ),
                      Row(
                        children: [
                          reUse.reUseText(
                              content: "   ${clsLan.today} : ${forSort.length}", color: theme.grey),
                          Divider(
                            height: 1,
                            color: theme.grey,
                          ),
                        ],
                      ),
                      forSort.isNotEmpty
                          ? Flexible(
                              child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(8),
                                  itemCount: forSort.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return reUse.reUseTodayComponent(
                                        onTap: () {
                                          if (forSort[index][field.status] == 'complete') {
                                            Get.to(() => const CompleteDetail(),
                                                arguments: {"data": forSort[index]});
                                          } else if (forSort[index][field.status] == 'return') {
                                            Get.to(() => const ReturnDetail(),
                                                arguments: forSort[index]);
                                          }
                                        },
                                        value: forSort[index],
                                        dateTime: forSort[index]["completeDate"]??forSort[index]["returnDate"],
                                        status: forSort[index][field.status]);
                                  }),
                            )
                          : Container(),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  List retSort = [];
  List forSort = [];
  List compSort = [];
  FirebaseAuth auth = FirebaseAuth.instance;
}

class QrData {
  String phoneNumber = '';
  String email = '';
  String firstname = '';
  String lastname = '';
  String userID = '';
// QrData({required this.phoneNumber, required this.email, required this.firstname, required this.lastname, required this.userID});
}
