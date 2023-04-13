import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'GlobalControl/GlobalController.dart';
import 'ViewScreen.dart';
import 'WidgetReUse/ReUseWidget.dart';
import 'WidgetReUse/Themes.dart';

class CreatePackageScreen extends StatefulWidget {
  const CreatePackageScreen({Key? key}) : super(key: key);

  @override
  State<CreatePackageScreen> createState() => _CreatePackageScreenState();
}

class _CreatePackageScreenState extends State<CreatePackageScreen> {
  final reUse = ReUseWidget();
  final theme = ThemesApp();
  final glb = GlobalController();

  final phoneBox = TextEditingController();
  final locationBox = TextEditingController();
  final priceBox = TextEditingController();
  final qtyBox = TextEditingController();
  final noteBox = TextEditingController();
  double textSize = 12;
  String packageID = '';
  generatePackageID() {
    Random random = Random();
    int randomNumber = random.nextInt(9999);
    String format = 'PK00';
    packageID = format + randomNumber.toString();

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generatePackageID();
    fetchToken();
  }

  String getToken = '';
  String chatid = '';

  fetchToken() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid.toString())
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      getToken = await documentSnapshot['token'];
      chatid = await documentSnapshot['chatid'];
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => const ViewScreen(),
                    //   ),
                    // );
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_rounded, color: theme.black),
                  label: Text(
                    'Back',
                    style: TextStyle(color: theme.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      reUse.reUseText(
                        content: 'Package ID : ',
                        size: 16.0,
                        color: theme.grey,
                      ),
                      reUse.reUseText(
                          content: packageID,
                          size: 26.0,
                          color: theme.black,
                          weight: FontWeight.bold),
                    ],
                  ),
                ),
                // Divider(
                //   color: theme.grey,
                //   height: 1,
                // ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: reUse.reUseText(
                      content: 'Receiver Phone Number:',
                      size: textSize,
                      weight: FontWeight.bold,
                      color: theme.black),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: reUse.reuseTextField(
                      inputType: TextInputType.number,
                      textIcon: Icons.phone,
                      label: 'Receiver Phone Number',
                      controller: phoneBox),
                ),
                const SizedBox(
                  height: 18,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: reUse.reUseText(
                      content: 'Receiver Location :',
                      size: textSize,
                      weight: FontWeight.bold,
                      color: theme.black),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: reUse.reUseText(
                      content: '$getToken',
                      size: textSize,
                      weight: FontWeight.bold,
                      color: theme.black),
                ),Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: reUse.reUseText(
                      content: '$chatid',
                      size: textSize,
                      weight: FontWeight.bold,
                      color: theme.black),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: reUse.reuseTextField(
                      controller: locationBox,
                      label: 'Receiver Location',
                      textIcon: Icons.location_on),
                ),
                const SizedBox(
                  height: 18,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: reUse.reUseText(
                      content: 'Price :',
                      size: textSize,
                      weight: FontWeight.bold,
                      color: theme.black),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: reUse.reuseTextField(
                      inputType: TextInputType.number,
                      controller: priceBox,
                      label: '',
                      textIcon: Icons.location_on),
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextField(
                          maxLines: 1,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              int? digit = int.tryParse(value);
                              if (digit == null || digit < 1 || digit > 9) {
                                qtyBox.clear();
                                Fluttertoast.cancel();
                                setState(() {
                                  Fluttertoast.showToast(
                                    msg: 'Maximum input is 9',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                });
                              }
                            }
                          },
                          keyboardType: TextInputType.number,
                          controller: qtyBox,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintStyle: TextStyle(fontSize: 12),
                              hintText: '1')),
                    ),
                    reUse.reUseCustomizeButton(
                        icon: Icons.remove,
                        value: 'minus',
                        showIcon: true,
                        iconcolor: theme.orange,
                        colorBC: theme.liteOrange,
                        isBcColor: true),
                    Container(
                      width: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextField(
                          maxLines: 1,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              int? digit = int.tryParse(value);
                              if (digit == null || digit < 1 || digit > 9) {
                                qtyBox.clear();
                                Fluttertoast.cancel();
                                setState(() {
                                  Fluttertoast.showToast(
                                    msg: 'Maximum input is 9',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                });
                              }
                            }
                          },
                          keyboardType: TextInputType.number,
                          controller: qtyBox,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintStyle: TextStyle(fontSize: 12),
                              hintText: '1')),
                    ),
                    reUse.reUseCustomizeButton(
                        function: 'add',
                        icon: Icons.add,
                        value: qtyBox.text,
                        showIcon: true,
                        iconcolor: theme.orange,
                        colorBC: theme.liteOrange,
                        isBcColor: true)
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                reUse.reUseText(
                    content: 'Note:', size: textSize, color: theme.grey),
                Container(
                  alignment: Alignment.center,
                  child: TextField(
                    controller: noteBox,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        ),

                        // hintText: "Enter Remarks",
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: theme.hiLiteBlue))),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        height: 40,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: theme.orange,
                          borderRadius: BorderRadius.circular(6),
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
                            onTap: () async {
                              if (phoneBox.text.trim().toString() == '') {
                                await reUse.reUseCircleDialog(
                                    context: context,
                                    icon: Icons.phone,
                                    title: 'Error',
                                    content: Center(
                                      child: Text(
                                        'Phone Number Must Include',
                                        style: TextStyle(
                                          color: theme.black,
                                        ),
                                      ),
                                    ));
                              } else if (locationBox.text.trim().toString() ==
                                  '') {
                                await reUse.reUseCircleDialog(
                                    context: context,
                                    icon: Icons.location_on_rounded,
                                    title: 'Error',
                                    content: Center(
                                      child: Text(
                                        'Location Must Include',
                                        style: TextStyle(
                                          color: theme.black,
                                        ),
                                      ),
                                    ));
                              } else if (priceBox.text.trim().toString() ==
                                  '') {
                                await reUse.reUseCircleDialog(
                                    context: context,
                                    icon: Icons.monetization_on,
                                    title: 'Error',
                                    content: Center(
                                      child: Text(
                                        'Price Must Include',
                                        style: TextStyle(
                                          color: theme.black,
                                        ),
                                      ),
                                    ));
                              } else {
                                alertDialog(context);
                                await glb
                                    .requestPackage(
                                        tokenKey: getToken.trim().toString(),
                                        chatid: chatid.trim().toString(),
                                        price: priceBox.text.trim().toString(),
                                        note: noteBox.text.trim().toString(),
                                        packageID: packageID.toString(),
                                        qty: qtyBox.text.trim().toString(),
                                        phoneNumber:
                                            phoneBox.text.trim().toString(),
                                        location:
                                            locationBox.text.trim().toString())
                                    .then((value) {
                                  phoneBox.clear();
                                  priceBox.clear();
                                  locationBox.clear();
                                  qtyBox.clear();
                                  noteBox.clear();
                                });
                                Get.back();
                                reUse.reUseCircleDialog(
                                    context: context,
                                    icon: Icons.check_circle_rounded,
                                    title: 'Success',
                                    content: Center(
                                      child: Text(
                                        'Your package is successfully request',
                                        style: TextStyle(
                                          color: theme.black,
                                        ),
                                      ),
                                    ));
                                setState(() {
                                  packageID = glb.generatePackageID();
                                });
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Padding(
                                //   padding: const EdgeInsets.only(right: 8.0),
                                //   child: Icon(
                                //     Icons,
                                //     color: iconcolor,
                                //   ),
                                // ),

                                Text(
                                  'OK',
                                  style: TextStyle(
                                      color: theme.white,
                                      fontWeight: FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  alertDialog(context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: [
              Center(
                child: SizedBox(
                    height: 40, width: 40, child: CircularProgressIndicator()),
              )
            ],
          ),
        );
      },
    );
  }
}
