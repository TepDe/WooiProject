import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wooiproject/Distination/clsDistin.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/GlobalControl/clsField.dart';
import 'package:wooiproject/GlobalControl/moduleObject.dart';
import 'GlobalControl/GlobalController.dart';
import 'WidgetReUse/ReUseWidget.dart';
import 'WidgetReUse/Themes.dart';

class CreatePackageScreen extends StatefulWidget {
  const CreatePackageScreen({super.key});

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
  final qtyBox = TextEditingController(text: "1");
  final noteBox = TextEditingController();
  double textSize = 14;
  String packageID = '';

  generatePackageID() {
    Random random = Random();
    int randomNumber = random.nextInt(9999);
    String format = 'PK00';
    packageID = format + randomNumber.toString();
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  String userName = '';
  String phoneNumber = '';
  String bankName = '';
  String bankCode = '';
  final inFor = FieldInfo();

  fetchUserInformation() async {
    FirebaseFirestore.instance.collection('Users').doc(auth.currentUser!.uid).get().then((doc) async {
      Map data = doc.data() as Map;
      userName = data['firstname'] + ' ' + data['lastname'].toString();
      phoneNumber = data['phoneNumber'].toString();
      bankName = data['bankName'].toString();
      bankCode = data[inFor.bankCode].toString();
      setState(() {});
    });
  }

  var generalInfo = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generatePackageID();
    fetchUserInformation();
    onGetGeneral();
    fetchUserData();
    fetchToken();
    distince = clsDis.destination;
    forDisplay = clsDis.destination;
  }

  onGetGeneral() async {
    generalInfo = await glb.onGetGeneralInfo();
  }

  var userObject = {};

  fetchUserData() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid.toString())
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      userObject = documentSnapshot.data() as Map;
    });
  }

  final clsLan = ClsLanguage();

  String getToken = '';
  String chatid = '';
  ModuleObject modObj = ModuleObject();

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

  List distince = [];
  List eng_distin = [];
  List forDisplay = [];
  final clsDis = ClsDestination();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => const ViewScreen(),
                    //   ),
                    // );
                    Get.back();
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
                        content: clsLan.packageID + ' : ',
                        size: 16.0,
                        color: theme.grey,
                      ),
                      reUse.reUseText(content: packageID, size: 26.0, color: theme.black, weight: FontWeight.bold),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: reUse.reUseText(
                      content: 'លេខទូរស័ព្ទអ្នកទទួល :', size: textSize, weight: FontWeight.w500, color: theme.black),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 10),
                //   child: reUse.reuseTextField(
                //       formater: [
                //         FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                //       ],
                //       inputType: TextInputType.numberWithOptions(decimal: true),
                //       textIcon: Icons.phone,
                //       label: 'Receiver Phone Number',
                //       controller: phoneBox),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: TextFormField(
                    controller: phoneBox,
                    // keyboardType: inputType,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 15,
                    onChanged: (value) async {},
                    decoration: InputDecoration(
                      //icon: Icon(textIcon ?? null),
                      // fillColor: theme.liteGrey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      //border: InputBorder.none,

                      hintStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: reUse.reUseText(
                      content: 'ទីតាំងអ្នកទទួល : ( សូមបញ្ចូលទីតាំងអ្នកទទួលជាអក្សរខ្មែរ )',
                      size: textSize,
                      weight: FontWeight.w500,
                      color: theme.black),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: TextFormField(
                    controller: locationBox,
                    // keyboardType: inputType,
                    //keyboardType: inputType,
                    //inputFormatters: formater,
                    onChanged: (value) {
                      List results = clsDis.destination
                          .where((user) => user.toLowerCase().contains(locationBox.text.toString().toLowerCase()))
                          .toList();
                      forDisplay = results;
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          forDisplay = clsDis.destination;

                          locationBox.clear();
                          locationBox.text = '';
                          setState(() {});
                        },
                        icon: const Icon(Icons.close),
                      ),
                      hintText: locationBox.text.toString(),
                      //icon: Icon(textIcon ?? null),
                      // fillColor: theme.liteGrey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      //border: InputBorder.none,

                      hintStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: reUse.reUseText(
                      content: 'ទីតាំង : ${forDisplay.length}',
                      size: textSize,
                      weight: FontWeight.w500,
                      color: theme.grey),
                ),
                SizedBox(
                  //color: theme.red,
                  height: Get.height * 0.08,
                  child: forDisplay != []
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.all(8),
                          itemCount: forDisplay.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              child: TextButton(
                                onPressed: () {
                                  locationBox.text = forDisplay[index].toString().trim().toLowerCase();
                                },
                                child: Text(forDisplay[index]),
                              ),
                            );
                          })
                      : const SizedBox(),
                ),
                const SizedBox(
                  height: 18,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: reUse.reUseText(
                      content: clsLan.price + " : ( សូមបញ្ចូលតំលៃគិតជាដុល្លារ )",
                      size: textSize,
                      weight: FontWeight.w500,
                      color: theme.black),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: reUse.reuseTextField(
                      controller: priceBox,
                      mixLength: 9,
                      prefixIconColor: theme.darkGrey,
                      prefixIcon: Icons.attach_money,
                      formater: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                      ],
                      inputType: const TextInputType.numberWithOptions(decimal: true),
                      label: ' ',
                      textIcon: Icons.location_on),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
                  child: reUse.reUseText(
                      content: clsLan.qty + " :", size: textSize, weight: FontWeight.w500, color: theme.black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 6,
                      child: reUse.reuseTextField(
                          mixLength: 3,
                          controller: qtyBox,
                          formater: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+'))],
                          inputType: TextInputType.number,
                          label: ' ',
                          textIcon: Icons.location_on),
                    ),
                    Flexible(
                      flex: 1,
                      child: reUse.reUseText(content: '', size: 20.0),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      reUse.reUseText(content: 'ចំណាំ :', size: textSize, color: theme.black),
                      Container(
                        alignment: Alignment.center,
                        child: TextFormField(
                          maxLength: 100,
                          controller: noteBox,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 0.0),
                              ),

                              // hintText: "Enter Remarks",
                              focusedBorder:
                                  OutlineInputBorder(borderSide: BorderSide(width: 1, color: theme.hiLiteBlue))),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
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
                                if (phoneBox.text.trim().toString() == '') {
                                  await reUse.reUseCircleDialog(
                                      context: context,
                                      icon: Icons.phone,
                                      title: 'Error',
                                      content: Center(
                                        child: Text(
                                          clsLan.noPhone,
                                          style: TextStyle(
                                            color: theme.black,
                                          ),
                                        ),
                                      ));
                                } else if (locationBox.text.trim().toString() == '') {
                                  await reUse.reUseCircleDialog(
                                      context: context,
                                      icon: Icons.location_on_rounded,
                                      title: 'Error',
                                      content: Center(
                                        child: Text(
                                          clsLan.noRecLocation,
                                          style: TextStyle(
                                            color: theme.black,
                                          ),
                                        ),
                                      ));
                                } else if (priceBox.text.trim().toString() == '') {
                                  await reUse.reUseCircleDialog(
                                      context: context,
                                      icon: Icons.monetization_on,
                                      title: 'Error',
                                      content: Center(
                                        child: Text(
                                          clsLan.noPrice,
                                          style: TextStyle(
                                            color: theme.black,
                                          ),
                                        ),
                                      ));
                                } else {
                                  if (bankCode.isEmpty) {
                                    await reUse.reUseCircleDialog(
                                        context: context,
                                        icon: Icons.code,
                                        title: 'Error',
                                        content: Center(
                                          child: Text(
                                            clsLan.noABA,
                                            style: TextStyle(
                                              color: theme.black,
                                            ),
                                          ),
                                        ));
                                  } else if (userName.isEmpty) {
                                    await reUse.reUseCircleDialog(
                                        context: context,
                                        icon: Icons.account_circle,
                                        title: 'Error',
                                        content: Center(
                                          child: Text(
                                            clsLan.noName,
                                            style: TextStyle(
                                              color: theme.black,
                                            ),
                                          ),
                                        ));
                                  } else {
                                    alertDialog(context);
                                    String modPrice = glb.removeLeadingZeros(priceBox.text.trim());
                                    await glb
                                        .onCreatePackage(
                                      generalInfo: userObject,
                                      genChatID: generalInfo['chatid'],
                                      genToken: generalInfo['token'],
                                      bankName: bankName.trim(),
                                      abaCode: bankCode.toString(),
                                      userName: userName.trim().toString(),
                                      userPhoneNumber: phoneNumber.trim().toString(),
                                      tokenKey: getToken.trim().toString(),
                                      chatid: chatid.trim().toString(),
                                      price: modPrice,
                                      note: noteBox.text.trim().toString(),
                                      packageID: packageID.toString(),
                                      qty: qtyBox.text.replaceAll(RegExp('^0'), '').trim().toString(),
                                      phoneNumber: phoneBox.text.trim().toString(),
                                      location: locationBox.text.trim().toString(),
                                    )
                                        .then((value) {
                                      phoneBox.clear();
                                      priceBox.clear();
                                      locationBox.clear();
                                      qtyBox.text = '1';
                                      noteBox.clear();
                                    });
                                    Get.back();
                                    reUse.reUseCircleDialog(
                                        context: context,
                                        icon: Icons.check_circle_rounded,
                                        title: 'ជោគជ័យ',
                                        content: Center(
                                          child: Text(
                                            'ទំនិញរបស់លោកអ្នកហៅបានជោគជ័យ',
                                            style: TextStyle(
                                              color: theme.black,
                                            ),
                                          ),
                                        ));
                                    setState(() {
                                      packageID = glb.generatePackageID();
                                    });
                                  }
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
                                    style: TextStyle(fontSize: 16, color: theme.white, fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.5,
                )
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
                child: SizedBox(height: 40, width: 40, child: CircularProgressIndicator()),
              )
            ],
          ),
        );
      },
    );
  }
}
