import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:wooiproject/Distination/clsDistin.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/GlobalControl/clsField.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final reUse = ReUseWidget();
  final theme = ThemesApp();
  final glb = GlobalController();
  final clsDis = ClsDestination();
  final clsLan = ClsLanguage();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneBox = TextEditingController();
  final bankCode = TextEditingController();
  final telegramToken = TextEditingController();
  final chatID = TextEditingController();
  String packageID = '';
  double textSize = 14;
  List distince = [];
  List eng_distin = [];
  List forDisplay = [];
  String userName = '';
  String phoneNumber = '';
  String getToken = '';
  String chatid = '';
  var mainData = {};
  var argumentData = Get.arguments;
  final fieldData = FieldData();
  final fieldInfo = FieldInfo();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainData = argumentData;
    firstName.text = mainData[fieldInfo.firstName] ?? '';
    lastName.text = mainData[fieldInfo.lastName] ?? '';
    phoneBox.text = mainData[fieldInfo.phoneNumber] ?? '';
    bankCode.text = mainData[fieldInfo.ABACode] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      icon: Icon(Icons.arrow_back_rounded,
                          color: theme.black, size: 30),
                      label: reUse.reUseText(
                          content: "Back", size: 20.0, weight: FontWeight.w500),
                    ),
                  ],
                ),
                reUse.reUseColumnTextField(
                    suffixTap: () {
                      firstName.clear();
                      setState(() {});
                    },
                    label: clsLan.fname,
                    controller: firstName,
                    hintText: ""),
                reUse.reUseColumnTextField(
                    suffixTap: () {
                      lastName.clear();
                      setState(() {});
                    },
                    label: clsLan.lname,
                    controller: lastName,
                    hintText: ""),
                reUse.reUseColumnTextField(
                    suffixTap: () {
                      firstName.clear();
                      setState(() {});
                    },
                    label: clsLan.phoneNumber,
                    controller: firstName,
                    hintText: ""),
                reUse.reUseColumnTextField(
                    suffixTap: () {
                      lastName.clear();
                      setState(() {});
                    },
                    label: clsLan.receiveMoneyNumber,
                    controller: lastName,
                    hintText: ""),
                reUse.reUseColumnTextField(
                    suffixTap: () {
                      lastName.clear();
                      setState(() {});
                    },
                    label: clsLan.insertTelegramToken,
                    controller: telegramToken,
                    hintText: ""),
                reUse.reUseColumnTextField(
                    suffixTap: () {
                      lastName.clear();
                      setState(() {});
                    },
                    label: clsLan.insertTelegramChatID,
                    controller: chatID,
                    hintText: ""),
                SizedBox(height: Get.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        height: 50,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: theme.orange,
                          borderRadius: BorderRadius.circular(12),
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
                              if (firstName.text ==
                                      argumentData[fieldInfo.firstName] &&
                                  lastName.text ==
                                      argumentData[fieldInfo.lastName] &&
                                  phoneBox.text ==
                                      argumentData[fieldInfo.phoneNumber] &&
                                  bankCode.text ==
                                      argumentData[fieldData.qty] &&
                                  chatID.text == argumentData[fieldData.note]) {
                                Get.back();
                                setState(() {});
                              } else {
                                alertDialog(context);
                                await glb
                                    .editPackage(
                                        data: argumentData,
                                        userName: userName.trim().toString(),
                                        userPhoneNumber:
                                            phoneNumber.trim().toString(),
                                        tokenKey: getToken.trim().toString(),
                                        chatid: chatid.trim().toString(),
                                        price: phoneBox.text.trim().toString(),
                                        note: chatID.text.toString(),
                                        packageID: packageID.toString(),
                                        qty: bankCode.text.trim().toString(),
                                        phoneNumber:
                                            firstName.text.trim().toString(),
                                        location:
                                            lastName.text.trim().toString())
                                    .then((value) {});
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
                                  'UPDATE',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: theme.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.5,
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

  bool hasNullValues(obj) {
    if (obj == null) return true;

    return [
      obj[fieldData.phoneNumber],
      obj[fieldData.location],
      obj[fieldData.price],
      obj[fieldData.qty],
      obj[fieldData.note],
      obj[fieldData.packageID]
    ].any((value) => value == null);
  }
}
