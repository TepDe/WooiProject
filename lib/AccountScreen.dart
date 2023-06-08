import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/GlobalControl/StorageKey.dart';
import 'package:wooiproject/GlobalControl/clsField.dart';
import 'package:wooiproject/LoginScreen.dart';
import 'package:wooiproject/SetUpScreen.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';
import 'package:http/http.dart' as http;

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  List lists = [];
  final str = StorageKey();
  var glb = GlobalController();
  String getLatitude = '';
  String getLongitude = '';
  String getFirstName = '';
  String getLastName = '';
  String getIsGoOnline = '';
  String getPhoneNumber = '';
  String getEmail = '';
  String getPassword = '';
  String getUserName = '';
  String getUserID = '';
  String getToken = '';
  String getChatId = '';
  String getUid = '';
  String getLocation = '';
  String getQty = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //fetchLocalStorage();
    fetchUserData();
    totalRevenue();
  }

  getDatsa(getUid) async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(getUid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      getUserID = documentSnapshot['qty'];
      getToken = documentSnapshot['token'];
      getChatId = documentSnapshot['chatid'];
    });
  }

  Future<void> insertTelegramToken() async {
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

  var fetch = FirebaseFirestore.instance.collection('Users');
  var userData = {};

  fetchUserData() async {
    fetch
        .doc(auth.currentUser!.uid.toString())
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      userData = documentSnapshot.data() as Map<String, dynamic>;
      // try {
      //   getLatitude = documentSnapshot['latitude'].toString();
      //   getLongitude = documentSnapshot['longitude'].toString();
      //   getUid = documentSnapshot['uid'].toString();
      //   getEmail = documentSnapshot['email'].toString();
      //   getPassword = documentSnapshot['password'].toString();
      //   getPhoneNumber = documentSnapshot['phoneNumber'].toString();
      //   getUserID = documentSnapshot['userID'].toString();
      //   getLastName = documentSnapshot['lastname'].toString();
      //   getFirstName = documentSnapshot['firstname'].toString();
      //   if (documentSnapshot['token'] == null) {
      //     getToken = 'not have';
      //     getChatId = 'not have';
      //   } else {
      //     getToken = documentSnapshot['token'].toString();
      //     getChatId = documentSnapshot['chatid'].toString();
      //   }
      // } catch (e) {
      //   print(e);
      // }
      setState(() {});
    });
    setState(() {});
  }

  final reUse = ReUseWidget();
  final theme = ThemesApp();
  bool light = false;
  final fieldInfo = FieldInfo();

  final token = TextEditingController();
  final abaCode = TextEditingController();
  final chatid = TextEditingController();
  final clsLan = ClsLanguage();

  bool hindPassowrd = true;

  @override
  Widget build(BuildContext context) {
    var imageSize = MediaQuery.of(context).size.height * 0.1;
    var viewHeight2 = MediaQuery.of(context).size.height * 0.03;
    var padding = MediaQuery.of(context).size.height * 0.01;
    var textWidth = MediaQuery.of(context).size.width * 0.2;
    return Scaffold(
      backgroundColor: theme.liteGrey,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
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
                  child: InkWell(
                    onTap: () {
                      Get.to(SetUpScreen());
                    },
                    child: const CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSe1IKGF9z_2YNk4INs_zur1TjFIUtgpw_Ic2Jp2xxH5g&s"),
                    ),
                  ),
                ),
                SizedBox(
                  height: viewHeight2,
                ),
                reUse.reUseText(
                    content:
                        '${userData[fieldInfo.firstName].toString()} ${userData[fieldInfo.lastName]}',
                    weight: FontWeight.bold,
                    size: 20.0,
                    color: theme.black),
                reUse.reUseText(
                    content: 'ID : ${userData[fieldInfo.userID]}',
                    weight: FontWeight.bold,
                    size: 12.0,
                    color: theme.grey),
                Row(
                  children: [
                    Flexible(
                      child: reUse.reUseBoxText(
                          assetImage: "assets/images/RevenueBtn.png",
                          data: completeList,
                          value: (revenue ?? "0") + " \$",
                          textColor: theme.blue,
                          title: clsLan.revenue),
                    ),
                    Flexible(
                      child: reUse.reUseBoxText(
                          assetImage: "assets/images/TotalPaidBtn.png",
                          value:   " \$",
                          title: clsLan.paid,
                          textColor: theme.deepOrange,
                          data: completeList),
                    ),
                  ],
                ),
                // Padding(
                //   padding:  EdgeInsets.only(left:8.0,top:padding,bottom:padding),
                //   child: Align(
                //     alignment: Alignment.topLeft,
                //     child: reUse.reUseText(
                //         content: 'General',
                //         //weight: FontWeight.bold,
                //         size: 16.0,
                //         color: theme.black),
                //   ),
                // ),
                // InkWell(
                //     onTap: () {
                //       reUse.reUseCircleDialog(
                //           context: context,
                //           title: 'title',
                //           content: reUse.reUseTextFormField(),
                //           icon: Icons.password);
                //     },
                //     child: Material(
                //       color: Colors.transparent,
                //       child: reUse.reUseSettingItem(
                //           trailingIcon: Icon(Icons.visibility_off),
                //           title: Text('Pin Code'),
                //           context: context,
                //           leading: Icon(Icons.password)),
                //     )),
                // reUse.reUseSettingItem(
                //     trailingIcon: Switch(
                //       // This bool value toggles the switch.
                //       value: light,
                //       activeColor: theme.btnBlue,
                //       onChanged: (bool value) {
                //         // This is called when the user toggles the switch.
                //         setState(() {
                //           light = value;
                //         });
                //       },
                //     ),
                //     title: Text('Light Mode'),
                //     context: context,
                //     leading: Icon(Icons.sunny)),

                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      reUse.reUseText(
                          content: 'Account',
                          //weight: FontWeight.bold,
                          size: 16.0,
                          color: theme.black),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.edit, color: theme.darkGrey),
                        label: reUse.reUseText(
                            content: 'Edit', size: 16.0, color: theme.darkGrey),
                      )
                    ],
                  ),
                ),
                reUse.reUseSettingItem(
                    trailingIcon: Text(
                      userData[fieldInfo.email] ?? 'loading...',
                      style: TextStyle(color: theme.grey),
                    ),
                    title: const Text('Email'),
                    context: context,
                    leading: const Icon(Icons.email)),
                reUse.reUseSettingItem(
                    trailingIcon: hindPassowrd == true
                        ? IconButton(
                            onPressed: () {
                              if (hindPassowrd == true) {
                                hindPassowrd = false;
                              } else {
                                hindPassowrd = true;
                              }
                              setState(() {});
                            },
                            icon: Icon(Icons.visibility_off))
                        : InkWell(
                            onTap: () {
                              if (hindPassowrd == false) {
                                hindPassowrd = true;
                              } else {
                                hindPassowrd = false;
                              }
                              setState(() {});
                            },
                            child: Text(
                              (userData[fieldInfo.password] ?? 'loading...'),
                              style: TextStyle(color: theme.grey),
                            ),
                          ),
                    title: const Text('Password'),
                    context: context,
                    leading: const Icon(Icons.password_rounded)),
                reUse.reUseSettingItem(
                    trailingIcon: Text(
                      userData[fieldInfo.phoneNumber] ?? 'loading...',
                      style: TextStyle(color: theme.grey),
                    ),
                    title: const Text('Phone Number'),
                    context: context,
                    leading: const Icon(Icons.phone)),
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                                            content: clsLan.insertAbaDec,
                                            color: theme.black,
                                            weight: FontWeight.w400,
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
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: theme.white,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            boxShadow: [
                                              BoxShadow(
                                                color: theme.midGrey,
                                                blurRadius: 2,
                                                offset: const Offset(
                                                    0, 0), // Shadow position
                                              ),
                                            ],
                                          ),
                                          child: TextFormField(
                                            controller: abaCode,
                                            decoration: InputDecoration(
                                              prefixIcon:
                                                  const Icon(Icons.key_rounded),
                                              suffixIcon: const Icon(
                                                Icons.search,
                                                color: Colors.transparent,
                                              ),
                                              filled: true,
                                              fillColor: theme.white,
                                              hintText: clsLan.insertAbaDec,
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(25.7),
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(25.7),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20.0),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: Flexible(
                                            child: Container(
                                              height: 40,
                                              width: Get.width,
                                              decoration: BoxDecoration(
                                                color: theme.litestOrange,
                                                borderRadius:
                                                    BorderRadius.circular(6),
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
                                                child: TextButton(
                                                  onPressed: () async {
                                                    glb.insertABACode(
                                                        abaCode: abaCode.text);
                                                    setState(() {});
                                                  },
                                                  child: Text(
                                                    clsLan.insert,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: theme.orange,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                          title: Text(clsLan.abaCode),
                          trailing: SizedBox(
                              width: textWidth,
                              child: Text(
                                userData[fieldInfo.ABACode] ??
                                    "Not Include Yet",
                                maxLines: 1,
                                style: TextStyle(
                                    color: theme.grey,
                                    overflow: TextOverflow.ellipsis),
                              )),
                          leading: const Text("ABA"),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                                            content: clsLan.insertTelegramToken,
                                            color: theme.black,
                                            weight: FontWeight.w400,
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
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: theme.white,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            boxShadow: [
                                              BoxShadow(
                                                color: theme.midGrey,
                                                blurRadius: 2,
                                                offset: const Offset(
                                                    0, 0), // Shadow position
                                              ),
                                            ],
                                          ),
                                          child: TextFormField(
                                            controller: token,
                                            decoration: InputDecoration(
                                              prefixIcon:
                                                  const Icon(Icons.key_rounded),
                                              suffixIcon: const Icon(
                                                Icons.search,
                                                color: Colors.transparent,
                                              ),
                                              filled: true,
                                              fillColor: theme.white,
                                              hintText: 'hintText',
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(25.7),
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(25.7),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20.0),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: Flexible(
                                            child: Container(
                                              height: 40,
                                              width: Get.width,
                                              decoration: BoxDecoration(
                                                color: theme.litestOrange,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                // boxShadow: [
                                                //   BoxShadow(
                                                //     color: Colors.grey,
                                                //     blurRadius: 1,
                                                //     //offset: Offset(4, 8), // Shadow position
                                                //   ),
                                                // ],
                                              ),
                                              child: TextButton(
                                                onPressed: () async {
                                                  if (token.text.isEmpty) {
                                                    Get.back();
                                                  } else {
                                                    glb.insertTelegramToken(
                                                        token: token.text);
                                                  }
                                                  setState(() {});
                                                },
                                                child: Text(
                                                  clsLan.insert,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: theme.orange,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                          title: const Text('Telegram Token'),
                          trailing: SizedBox(
                              width: textWidth,
                              child: Text(
                                userData[fieldInfo.token] ?? "Not Include Yet",
                                maxLines: 1,
                                style: TextStyle(
                                    color: theme.grey,
                                    overflow: TextOverflow.ellipsis),
                              )),
                          leading: const Icon(Icons.telegram_rounded),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                                                clsLan.insertTelegramChatID,
                                            color: theme.black,
                                            weight: FontWeight.w400,
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
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: theme.white,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            boxShadow: [
                                              BoxShadow(
                                                color: theme.midGrey,
                                                blurRadius: 2,
                                                offset: const Offset(
                                                    0, 0), // Shadow position
                                              ),
                                            ],
                                          ),
                                          child: TextFormField(
                                            controller: chatid,
                                            decoration: InputDecoration(
                                              prefixIcon:
                                                  const Icon(Icons.key_rounded),
                                              suffixIcon: const Icon(
                                                Icons.search,
                                                color: Colors.transparent,
                                              ),
                                              filled: true,
                                              fillColor: theme.white,
                                              hintText: 'hintText',
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(25.7),
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(25.7),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20.0),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: Flexible(
                                            child: Container(
                                              height: 40,
                                              width: Get.width,
                                              decoration: BoxDecoration(
                                                color: theme.litestOrange,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                // boxShadow: [
                                                //   BoxShadow(
                                                //     color: Colors.grey,
                                                //     blurRadius: 1,
                                                //     //offset: Offset(4, 8), // Shadow position
                                                //   ),
                                                // ],
                                              ),
                                              child: TextButton(
                                                onPressed: () {
                                                  if (token.text.isEmpty) {
                                                    Get.back();
                                                  } else {
                                                    glb.insertTelegramChatID(
                                                        chatid: chatid.text);
                                                  }
                                                  setState(() {});
                                                },
                                                child: Text(
                                                  clsLan.insert,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: theme.orange,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                          title: const Text('Chat ID'),
                          trailing: SizedBox(
                              width: textWidth,
                              child: Text(
                                userData[fieldInfo.chatid] ?? "Not Include Yet",
                                maxLines: 1,
                                style: TextStyle(
                                    color: theme.grey,
                                    overflow: TextOverflow.ellipsis),
                              )),
                          leading: const Icon(Icons.telegram_rounded),
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
                          context: context,
                          function: 'logOut',
                          icon: Icons.logout_rounded,
                          title: 'Log out',
                          content: Center(
                            child: Text(
                              'Are sure you want to log out?',
                              style: TextStyle(
                                color: theme.black,
                              ),
                            ),
                          ));
                    },
                    icon: const Icon(Icons.login_rounded),
                    label: const Text('Log Out'),
                    style: TextButton.styleFrom(
                      backgroundColor: theme.litestRed,
                      foregroundColor: theme.red,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  List driverList = [];

  onFetchDriver() {
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

  reUseCircleDialog({data, context, icon, title, content, function}) {
    return showDialog(
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
                    icon,
                    color: theme.orange,
                    size: 100.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    // Text(
                    //   content,
                    //   textAlign: TextAlign.center,
                    //   style: const TextStyle(
                    //     fontSize: 16.0,
                    //   ),
                    // ),
                    content,
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: reUseButton(text: "OK"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  var receivedID = '';
  bool otpFieldVisibility = false;
  String verificationId = '';
  String phoneNumber = "+855 78 344 511";
  String authStatus = "";
  String otp = "";

  Future<void> verifyUserPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        String smsCode = 'xxxx';
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);
        await auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  reUseButton({data, key, icon, text, backgroundColor, textColor}) {
    return SizedBox(
      width: Get.width,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
        ),
        onPressed: () async {
          FirebaseAuth.instance.signOut();
          Get.to(const LogInScreen());
          setState(() {});
        },
        child: Text(
          text,
          style: TextStyle(
              color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }

  List completeList = [];
  List totalPrice = [];
  String revenue='0';

  totalRevenue() {
    try {
      DatabaseReference refs = FirebaseDatabase.instance
          .ref('Complete')
          .child(auth.currentUser!.uid);
      refs.onValue.listen((event) {
        setState(() {});
        completeList.clear();
        DataSnapshot driver = event.snapshot;
        Map values = driver.value as Map;
        values.forEach((key, value) {
          completeList.add(value);
          totalPrice.add(int.parse(value['price']));
          revenue = totalPrice.reduce((a, b) => a + b).toString();
          setState(() {});
        });
      });
    } catch (e) {
      print('completeListLength $e');
    }
  }

  totalPaid() {
    try {
      DatabaseReference refs = FirebaseDatabase.instance
          .ref('Complete')
          .child(auth.currentUser!.uid);
      refs.onValue.listen((event) {
        setState(() {});
        completeList.clear();
        DataSnapshot driver = event.snapshot;
        Map values = driver.value as Map;
        values.forEach((key, value) {
          completeList.add(value);
          totalPrice.add(int.parse(value['price']));
          revenue = totalPrice.reduce((a, b) => a + b).toString();
          setState(() {});
        });
      });
    } catch (e) {
      print('completeListLength $e');
    }
  }
}

class driverData {
  double latitude = 0;
  double longitude = 0;
}
