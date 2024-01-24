import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/GlobalControl/clsField.dart';
import 'package:wooiproject/LoginScreen.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';
import 'GlobalControl/GlobalController.dart';

class SetUpScreen extends StatefulWidget {
  const SetUpScreen({super.key});

  @override
  State<SetUpScreen> createState() => _SetUpScreenState();
}

class _SetUpScreenState extends State<SetUpScreen> {
  final lastName = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  final bankCode = TextEditingController();
  final theme = ThemesApp();
  final reUse = ReUseWidget();
  final glb = GlobalController();
  final clsLan = ClsLanguage();
  var labelSize = 11.0;
  var valueSize = 14.0;
  double textSize = 14;
  int selectedItemIndex = -1;
  String bankName = "";
  var fetch = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  var userData = {};
  final fieldInfo = FieldInfo();

  fetchUserData() async {
    fetch
        .doc(auth.currentUser!.uid.toString())
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      userData = documentSnapshot.data() as Map<String, dynamic>;
      lastName.text = userData['lastname'] ?? "";
      firstName.text = userData["firstname"] ?? "";
      phoneNumber.text = userData['phoneNumber'] ?? "";
      bankCode.text = userData[fieldInfo.bankCode] ?? "";
      setState(() {});
    });

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.white,
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            if (lastName.text.isEmpty ||
                firstName.text.isEmpty ||
                phoneNumber.text.isEmpty ||
                bankCode.text.isEmpty ||
                bankName == "") {
              await reUse.reUseYesNoDialog(
                  icon: Icons.question_mark_outlined,
                  content: Text(clsLan.emptyFill),
                  context: context,
                  noText: clsLan.exit,
                  yesText: clsLan.continues,
                  noTap: () {
                    exit(0);
                  },
                  yesTap: () {
                    Navigator.pop(context);
                  },
                  title: clsLan.remainEmpty);
            } else {
              Get.to(const LogInScreen());
              setState(() {});
            }
            return false;
          },
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/login_background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: Get.height * 0.15,
                          left: Get.width * 0.05,
                          right: Get.width * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          reUse.reUseText(
                              content: clsLan.register,
                              color: theme.black,
                              size: 25.0,
                              weight: FontWeight.bold),
                          reUse.reUseText(
                            content: clsLan.fillRequirement,
                            size: 12.0,
                          ),
                          SizedBox(
                            height: Get.height * 0.09,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  clsLan.inputName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                flex: 8,
                                child: reUse.reUseTextBox(
                                  controller: firstName,
                                  hind: clsLan.fname,
                                  obscureText: false,
                                ),
                              ),
                              Flexible(
                                child: SizedBox(
                                  height: Get.height * 0.01,
                                ),
                              ),
                              Flexible(
                                flex: 8,
                                child: reUse.reUseTextBox(
                                  controller: lastName,
                                  hind: clsLan.lname,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          reUse.reUseTextBox(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.,]+')),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            controller: phoneNumber,
                            keyboardType: TextInputType.number,
                            hind: clsLan.phoneNumber,
                          ),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          reUse.reUseText(
                              content: clsLan.payWay,
                              size: textSize,
                              weight: FontWeight.w500,
                              color: theme.black),
                          SizedBox(
                              height: 100,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.all(8),
                                  itemCount: glb.payWay.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: SizedBox(
                                        height: 100,
                                        child: InkWell(
                                          onTap: () async {
                                            selectedItemIndex = index;
                                            bankName = await glb.selectPayWay(
                                                glb.payWay[index]['name']);
                                            setState(() {});
                                          },
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Image(
                                                  image: AssetImage(glb
                                                      .payWay[index]["img"])),
                                              CircleAvatar(
                                                minRadius: 20,
                                                backgroundColor: index ==
                                                        selectedItemIndex
                                                    ? Colors
                                                        .white // Change the color of the selected item
                                                    : Colors.transparent,
                                                child: Icon(
                                                  Icons.check_circle,
                                                  size: 50,
                                                  color: index ==
                                                          selectedItemIndex
                                                      ? Colors
                                                          .blue // Change the color of the selected item
                                                      : Colors.transparent,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  })),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          reUse.reUseTextBox(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.,]+')),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            controller: bankCode,
                            keyboardType: TextInputType.number,
                            hind: clsLan.receiveCode,
                          ),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          previewImg == null
                              ? SizedBox(
                                  width: Get.width * 1,
                                  height: Get.width * 0.3,
                                  child: const Center(
                                      child: Text("បញ្ចូល QR កូត")))
                              : Center(
                                  child: SizedBox(
                                    width: Get.width * 1,
                                    child: Image.file(previewImg!),
                                  ),
                                ),
                          SizedBox(
                            width: Get.width * 1,
                            child: ElevatedButton(
                              onPressed: _pickImage,
                              child: reUse.reUseText(
                                  content: "រើស Qr កូតរបស់អ្នក",
                                  size: 16.0,
                                  weight: FontWeight.w500,
                                  color: theme.black),
                            ),
                          ),
                          // SizedBox(
                          //   width: Get.width * 1,
                          //   child: ElevatedButton(
                          //     onPressed: () async {
                          //       if (urlImageTwo != "") {
                          //         reUse.reUseCircleDialog(
                          //             context: context,
                          //             icon: Icons.qr_code_scanner,
                          //             title: 'ផ្លាស់ប្តូរលេខកូដ Qr',
                          //             onTap: () async {
                          //               reUse.reUseWaitingDialog(context);
                          //               await _uploadImage(context);
                          //               Navigator.pop(context);
                          //               Navigator.pop(context);
                          //             },
                          //             content: Center(
                          //               child: Text(
                          //                 'តើអ្នកចង់ផ្លាស់ប្តូរកូដ Qr ចាស់របស់អ្នកមែនឬ?',
                          //                 style: TextStyle(
                          //                   color: theme.black,
                          //                 ),
                          //               ),
                          //             ));
                          //       } else {
                          //         // reUse.reUseWaitingDialog(context);
                          //         // await _uploadImage(context);
                          //         // Navigator.pop(context);
                          //       }
                          //     },
                          //     child: reUse.reUseText(
                          //         content: "បង្ហោះ",
                          //         size: 16.0,
                          //         weight: FontWeight.w500,
                          //         color: theme.black),
                          //   ),
                          // ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: SizedBox(
                                  width: Get.width,
                                  child: TextButton(
                                      // style: ElevatedButton.styleFrom(
                                      //   elevation: 1,
                                      //   backgroundColor: Colors.transparent,
                                      //   shape: RoundedRectangleBorder(
                                      //     borderRadius: BorderRadius.circular(6),
                                      //   ),
                                      // ),
                                      onPressed: () async {
                                        await FirebaseAuth.instance
                                            .signOut()
                                            .then((value) => Get.to(
                                                () => const LogInScreen()));
                                      },
                                      child:
                                          reUse.reUseText(content: "Log Out")),
                                ),
                              ),
                              Flexible(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 1,
                                    backgroundColor: theme.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (firstName.text.trim().toString() ==
                                        '') {
                                      await reUse.reUseCircleDialog(
                                          context: context,
                                          icon: Icons.account_circle_rounded,
                                          title: 'Error',
                                          content: Center(
                                            child: Text(
                                              'First name Must Include',
                                              style: TextStyle(
                                                color: theme.black,
                                              ),
                                            ),
                                          ));
                                    } else if (lastName.text
                                            .trim()
                                            .toString() ==
                                        '') {
                                      await reUse.reUseCircleDialog(
                                          context: context,
                                          icon: Icons.account_circle_rounded,
                                          title: 'Error',
                                          content: Center(
                                            child: Text(
                                              'Last Name Must Include',
                                              style: TextStyle(
                                                color: theme.black,
                                              ),
                                            ),
                                          ));
                                    } else if (phoneNumber.text
                                            .trim()
                                            .toString() ==
                                        '') {
                                      await reUse.reUseCircleDialog(
                                          context: context,
                                          icon: Icons.phone_rounded,
                                          title: 'Error',
                                          content: Center(
                                            child: Text(
                                              'Phone Number Must Include',
                                              style: TextStyle(
                                                color: theme.black,
                                              ),
                                            ),
                                          ));
                                    } else if (bankName == '') {
                                      await reUse.reUseCircleDialog(
                                          context: context,
                                          icon: Icons.monetization_on,
                                          title: 'Error',
                                          content: Center(
                                            child: Text(
                                              'Phone choose bank name',
                                              style: TextStyle(
                                                color: theme.black,
                                              ),
                                            ),
                                          ));
                                    } else if (lastName.text.isEmpty ||
                                        firstName.text.isEmpty ||
                                        phoneNumber.text.isEmpty ||
                                        bankCode.text.isEmpty) {
                                      await reUse.reUseCircleDialog(
                                          context: context,
                                          icon: Icons.close_rounded,
                                          title: clsLan.remainEmpty,
                                          function: '',
                                          content: Center(
                                            child: Text(
                                              clsLan.emptyFill,
                                              style: TextStyle(
                                                color: theme.black,
                                              ),
                                            ),
                                          ));
                                    } else {
                                      reUse.reUseWaitingDialog(context);
                                      try {
                                        if (previewImg != null) {
                                          await _uploadImage(context);
                                        }
                                        await glb.storeSetUpAccount(
                                            bankCode: bankCode.text.trim(),
                                            bankName: bankName.trim(),
                                            phoneNumber:
                                                phoneNumber.text.trim(),
                                            firstname: firstName.text.trim(),
                                            lastname: lastName.text.trim());
                                      } catch (e) {}
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        clsLan.continues,
                                        style: TextStyle(
                                            color: theme.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const Icon(Icons.navigate_next_rounded),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.6,
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

  File? previewImg;

  Future<void> _uploadImage(context) async {
    if (previewImg == null) {
      print('No image selected.');
      return;
    }
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      final storageReference =
          storage.ref("QrCodeImage").child(glb.auth.currentUser!.uid);
      var metadata = SettableMetadata(
        contentType: "image/jpeg",
      );
      final uploadTask = storageReference.putFile(previewImg!, metadata);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      print('Image uploaded successfully. Download URL: $downloadURL');
    } catch (e) {
      Navigator.pop(context);
      print('Error uploading image: $e');
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        final fileBytes = File(pickedFile.path);
        setState(() {
          previewImg = fileBytes;
        });
      } else {
        print('No image selected.');
      }
    });
  }
}
