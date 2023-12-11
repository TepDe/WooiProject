import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final reUse = ReUseWidget();
  final theme = ThemesApp();
  List driverList = [];
  List lstRequest = [];
  List lstComplete = [];
  List lstReturn = [];
  final field = FieldData();
  int doubleClick = 0;
  final glb = GlobalController();
  List distince = [];

  final str = StorageKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onGetUserData(context).then((value){
      onInitialize();
    });
  }

  Map generalInfo = {};

  Future<void> onInitialize() async {
    await fetchImage();
    latPending = await glb.onGetPendingPackage();
    lstReturn = await glb.onGetReturnPackage();
    lstRequest = await glb.onGetRequestPackage();
    lstComplete = await glb.onGetCompletePackage();
    driverList = lstRequest;
    compSort = List.from(lstComplete);
    retSort = List.from(lstReturn);
    forSort = mergeList(comp: compSort, ret: retSort);
    setState(() {
      forSort = glb.onSortTodayTwoKey(forSort);
    });
  }

  alertNoInternet(context) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
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

  Map userData = {};
  var userInfo = FirebaseFirestore.instance.collection('Users');

  Future<void> onGetUserData(context) async {
    try {
      userData = await glb.onGetUserInfo();
      generalInfo = await glb.onGetGeneralInfo();
      if (userData.isEmpty) {
        auth.signOut();
        Get.to(() => const LogInScreen());
      } else {
        if (userData["accountType"] == "Users" && userData["isBanned"] == "false" && "1" == generalInfo["version"]) {
        } else {
          reUse.reUseCircleDialog(
            disposeAllow: false,
            onTap: () {
              glb.auth.signOut();
              Get.to(() => const LogInScreen());
            },
            context: context,
            icon: userData["accountType"] != "Users" ? Icons.wifi : Icons.cancel_outlined,
            title: userData["accountType"] != "Users" ? 'មិនមាន' : 'ផ្អាក',
            content: Center(
              child: Text(
                userData["accountType"] != "Users"
                    ? 'គណនីនេះមិនមានទេ សូមពិនិត្យមើលម្តងទៀត!'
                    : 'បច្ចុប្បន្នគណនីនេះត្រូវបានផ្អាក',
                style: TextStyle(
                  color: theme.black,
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      // Handle errors, e.g., sign out and navigate to the login screen
      auth.signOut();
      Get.to(() => const LogInScreen());
    }
  }

  List latPending = [];

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

  Future<void> fetchImage() async {
    final prefs = await SharedPreferences.getInstance();
    getImageFileFromPath(prefs.getString(str.profileImg).toString());
  }

  Future<File> getImageFileFromPath(String imagePath) async {
    return File(imagePath);
  }

  final _controller = StreamController<SwipeRefreshState>.broadcast();

  Stream<SwipeRefreshState> get _stream => _controller.stream;

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    onInitialize();
    _controller.sink.add(SwipeRefreshState.hidden);
  }

  @override
  Widget build(BuildContext context) {
    alertNoInternet(context);
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
                              "${userData['phoneNumber']},${userData['email']},${userData['firstname']},${userData['lastname']},${auth.currentUser!.uid}",
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
            child: Icon(Icons.qr_code_scanner_rounded,color: theme.white, size: flotIcon),
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
                        content: '${currentTime()}\nID ${userData.isEmpty ? "" : userData['userID']}'),
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
                            totalPackageDataKey: lstRequest,
                            totalPackageData: driverList,
                            returnData: lstReturn,
                            completeData: lstComplete,
                            returnLength: lstReturn.length,
                            completeLength: lstComplete.length,
                            pendingData: latPending,
                            totalLength: driverList.length,
                            pendingLength: latPending.length),
                      ),
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
                              child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(8),
                                  itemCount: forSort.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return reUse.reUseTodayComponent(
                                        onTap: () {
                                          if (forSort[index][field.status] == 'complete') {
                                            Get.to(() => const CompleteDetail(), arguments: {"data": forSort[index]});
                                          } else if (forSort[index][field.status] == 'return') {
                                            Get.to(() => const ReturnDetail(), arguments: forSort[index]);
                                          }
                                        },
                                        value: forSort[index],
                                        dateTime: forSort[index]["completeDate"] ?? forSort[index]["returnDate"],
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
