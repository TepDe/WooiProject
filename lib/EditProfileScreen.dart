import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wooiproject/Distination/clsDistin.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/GlobalControl/clsField.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

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
  int selectedBank = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onInitialize();
  }

  Map generalInfo = {};

  Future<void> onInitialize() async {
    generalInfo = await glb.onGetGeneralInfo();
    mainData = argumentData;
    firstName.text = mainData[fieldInfo.firstName] ?? '';
    lastName.text = mainData[fieldInfo.lastName] ?? '';
    phoneBox.text = mainData[fieldInfo.phoneNumber] ?? '';
    telegramToken.text = mainData[fieldInfo.token] ?? '';
    chatID.text = mainData[fieldInfo.chatid] ?? '';
    bankCode.text = mainData[fieldInfo.bankCode] ?? '';
    bankName = mainData[fieldInfo.bankName] ?? '';
    selectedBank = glb.getBank(bankName: bankName);
    await onGetQrCode();
    setState(() {});
  }

  String bankName = "";
  int bankIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
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
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back_rounded,
                        color: theme.black, size: 30),
                    label: reUse.reUseText(
                        content: "Back", size: 20.0, weight: FontWeight.w500),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: reUse.reUseText(
                    maxLines: 5,
                    size: 14.0,
                    color: theme.red,
                    content:
                        '* ចំណាំ : \nសូមកុំផ្លាស់ប្ដូរទិន្នន័យខាងក្រោមខណៈពេលដឹកជញ្ជូនមិនទាន់អស់ចៀសវាងការបាត់ និង ច្រឡំ'),
              ),
              reUse.reUseColumnTextField(
                  suffixTap: () {
                    firstName.clear();
                  },
                  label: clsLan.fname,
                  controller: firstName,
                  hintText: ""),
              reUse.reUseColumnTextField(
                  suffixTap: () {
                    lastName.clear();
                  },
                  label: clsLan.lname,
                  controller: lastName,
                  hintText: ""),
              reUse.reUseColumnTextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  suffixTap: () {
                    phoneBox.clear();
                  },
                  label: clsLan.phoneNumber,
                  controller: phoneBox,
                  hintText: ""),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: reUse.reUseText(
                    content: clsLan.payWay,
                    size: textSize,
                    weight: FontWeight.w500),
              ),
              SizedBox(
                  height: 100,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(8),
                      itemCount: glb.payWay.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SizedBox(
                            height: 100,
                            child: InkWell(
                              onTap: () async {
                                selectedBank = index;
                                bankName = await glb
                                    .selectPayWay(glb.payWay[index]['name']);
                                setState(() {});
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image(
                                      image:
                                          AssetImage(glb.payWay[index]["img"])),
                                  CircleAvatar(
                                    minRadius: 20,
                                    backgroundColor: index == selectedBank
                                        ? Colors
                                            .white // Change the color of the selected item
                                        : Colors.transparent,
                                    child: Icon(
                                      Icons.check_circle,
                                      size: 50,
                                      color: index == selectedBank
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
              reUse.reUseColumnTextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  suffixTap: () {
                    bankCode.clear();
                    setState(() {});
                  },
                  label: clsLan.receiveMoneyNumber,
                  controller: bankCode,
                  hintText: ""),
              reUse.reUseColumnTextField(
                  suffixTap: () {
                    telegramToken.clear();
                    setState(() {});
                  },
                  label: clsLan.insertTelegramToken,
                  controller: telegramToken,
                  hintText: ""),
              reUse.reUseColumnTextField(
                  suffixTap: () {
                    chatID.clear();
                    setState(() {});
                  },
                  label: clsLan.insertTelegramChatID,
                  controller: chatID,
                  hintText: ""),
              SizedBox(height: Get.height * 0.01),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: reUse.reUseText(
                    content: "Qr កូតរបស់អ្នក",
                    size: 18.0,
                    weight: FontWeight.w500,
                    color: theme.black),
              ),
              urlImage != ""
                  ? Center(
                      child: SizedBox(
                        height: Get.height * 0.5,
                        width: Get.width * 0.5,
                        child: Image.network(urlImage),
                      ),
                    )
                  : previewImg == null
                      ? const Center(child: Text("មិនមាន"))
                      : Center(
                          child: SizedBox(
                            height: Get.height * 0.5,
                            width: Get.width * 0.5,
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
              SizedBox(
                width: Get.width * 1,
                child: ElevatedButton(
                  onPressed: () async {
                    if (urlImageTwo != "") {
                      reUse.reUseCircleDialog(
                          context: context,
                          icon: Icons.qr_code_scanner,
                          title: 'ផ្លាស់ប្តូរលេខកូដ Qr',
                          onTap: () async {
                            reUse.reUseWaitingDialog(context);
                            await _uploadImage(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          content: Center(
                            child: Text(
                              'តើអ្នកចង់ផ្លាស់ប្តូរកូដ Qr ចាស់របស់អ្នកមែនឬ?',
                              style: TextStyle(
                                color: theme.black,
                              ),
                            ),
                          ));
                    } else {
                      reUse.reUseWaitingDialog(context);
                      await _uploadImage(context);
                      Navigator.pop(context);
                    }
                  },
                  child: reUse.reUseText(
                      content: "បង្ហោះ",
                      size: 16.0,
                      weight: FontWeight.w500,
                      color: theme.black),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
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
                            final profile = UpdateProfile(
                                firstName: firstName.text.trim().toString(),
                                lastName: lastName.text.trim().toString(),
                                phoneNumber: phoneBox.text.trim().toString(),
                                token: telegramToken.text.trim().toString(),
                                chatid: chatID.text.trim().toString(),
                                bankName: bankName,
                                bankCode: bankCode.text.trim().toString());
                            if (firstName.text == "" ||
                                lastName.text == "" ||
                                phoneBox.text == "" ||
                                bankCode.text == "" ||
                                bankName == "") {
                              reUse.reUseCircleDialog(
                                  context: context,
                                  icon: Icons.close_rounded,
                                  title: "សូមបំពេញព័ត៌មានដែលទទេ",
                                  onTap: () => Get.back(),
                                  content: Center(
                                    child: Text(
                                      clsLan.emptyFill,
                                      style: TextStyle(
                                        color: theme.black,
                                      ),
                                    ),
                                  ));
                            } else {
                              if (firstName.text ==
                                      mainData[fieldInfo.firstName] &&
                                  lastName.text ==
                                      mainData[fieldInfo.lastName] &&
                                  phoneBox.text ==
                                      mainData[fieldInfo.phoneNumber] &&
                                  telegramToken.text ==
                                      mainData[fieldInfo.token] &&
                                  chatID.text == mainData[fieldInfo.chatid] &&
                                  bankCode.text ==
                                      mainData[fieldInfo.bankCode] &&
                                  bankName == mainData[fieldInfo.bankName] &&
                                  previewImg == null) {
                                Get.back();
                              } else {
                                await reUse.reUseYesNoDialog(
                                    icon: Icons.account_circle,
                                    content:
                                        Center(child: Text(clsLan.emptyFill)),
                                    context: context,
                                    noText: clsLan.exit,
                                    yesText: clsLan.continues,
                                    noTap: () {
                                      Navigator.pop(context);
                                    },
                                    yesTap: () async {
                                      Get.back();
                                      reUse.reUseWaitingDialog(context);
                                      String userInfo = "||==========||\n\n${auth.currentUser!.uid}" +
                                          "\n${mainData[fieldInfo.firstName] ?? "មិនមាន"} | => | ${firstName.text} : ឈ្មោះដំបូង" +
                                          "\n${mainData[fieldInfo.lastName] ?? "មិនមាន"} | => | ${lastName.text} : នាមត្រកូល" +
                                          "\n${mainData[fieldInfo.phoneNumber] ?? "មិនមាន"} | => | ${phoneBox.text} : លេខទូរសព្ទ" +
                                          "\n${mainData[fieldInfo.bankCode] ?? "មិនមាន"} | => | ${bankCode.text} : លេខកូដធនាគារ" +
                                          "\n${mainData[fieldInfo.bankName] ?? "មិនមាន"} | => | ${bankName} : ឈ្មោះ​របស់​ធនាគារ" +
                                          "\n${mainData[fieldInfo.token] ?? "មិនមាន"} | => | ${telegramToken.text} : Telegram Token" +
                                          "\n${mainData[fieldInfo.chatid] ?? "មិនមាន"} | => | ${chatID.text} : Telegram ChatID" +
                                          "\n${glb.formatDateTime(DateTime.now().toString())} : ពេលវេលាផ្លាស់ប្តូរ" +
                                          "\n\n||==========||";
                                      try {
                                        await glb.editProfile(
                                            value: profile, context: context);
                                        await glb.onUserChangeInfo(
                                            token: generalInfo['userEditToken'],
                                            chatid:
                                                generalInfo['pendingChatId'],
                                            data: userInfo);
                                        if (previewImg != null) {
                                          await _uploadImage(context);
                                        }
                                        Get.back();
                                        reUse.reUseCircleDialog(
                                            icon: Icons.check_circle,
                                            content: Text("ជោគជ័យ"),
                                            title: "គណនីអាប់ដេតជោគជ័យ",
                                            onTap: () => Get.back());
                                      } catch (e) {
                                        Get.back();
                                        reUse.reUseCircleDialog(
                                            icon: Icons.cancel);
                                      }
                                    },
                                    title: clsLan.change);
                              }
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'រក្សាទុក',
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
    );
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        final fileBytes = File(pickedFile.path);
        setState(() {
          previewImg = fileBytes;
          urlImage = '';
        });
      } else {
        print('No image selected.');
      }
    });
  }

  final Reference ref = FirebaseStorage.instance.ref('QrCodeImage');
  File? previewImg;
  String urlImage = ''; // Store the download URL of the image
  String urlImageTwo = ''; // Store the download URL of the image

  Future<void> onGetQrCode() async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      final ref = storage.ref('QrCodeImage').child(auth.currentUser!.uid);
      String downloadURL = await ref.getDownloadURL();
      setState(() {
        urlImage = downloadURL;
        urlImageTwo = downloadURL;
      });
    } catch (e) {
      print('Error downloading image: $e');
    }
  }

  Future<void> _uploadImage(context) async {
    urlImage = "";
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

class UpdateProfile {
  String firstName = "firstName";
  String lastName = "lastName";
  String phoneNumber = "phoneNumber";
  String token = "token";
  String chatid = "chatid";
  String bankName = "bankName";
  String bankCode = "bankCode";

  toJson(data) {
    return {
      "firstName": data['firstName'],
      "lastName": data['lastName'],
      "phoneNumber": data['phoneNumber'],
      "receiveMoneyCode": data['receiveMoneyCode'],
      "token": data['token'],
      "chatid": data['chatid'],
      "bankName": data["bankName"],
      "bankCode": data["bankCode"],
    };
  }

  clsToJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "token": token,
      "chatid": chatid,
      "bankName": bankName,
      "bankCode": bankCode,
    };
  }

  UpdateProfile(
      {required this.bankCode,
      required this.bankName,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.token,
      required this.chatid});
}
