import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
  int selectedBank = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onInitialize();
  }

  onInitialize(){
    mainData = argumentData;
    firstName.text = mainData[fieldInfo.firstName] ?? '';
    lastName.text = mainData[fieldInfo.lastName] ?? '';
    phoneBox.text = mainData[fieldInfo.phoneNumber] ?? '';
    telegramToken.text = mainData[fieldInfo.token] ?? '';
    chatID.text = mainData[fieldInfo.chatid] ?? '';
    bankCode.text = mainData[fieldInfo.bankCode] ?? '';
    bankName = mainData[fieldInfo.bankName] ?? '';
    selectedBank = glb.getBank(bankName: bankName);
    setState(() {});
  }


  String bankName = "";
  int bankIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  suffixTap: () {
                    phoneBox.clear();
                    setState(() {});
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
                                      image: AssetImage(
                                          glb.payWay[index]["img"])),
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
                                bankName == mainData[fieldInfo.bankName]) {
                              Get.back();
                            } else if (firstName.text.isEmpty ||
                                lastName.text.isEmpty ||
                                phoneBox.text.isEmpty ||
                                bankCode.text.isEmpty ||
                                bankName == "") {
                              await reUse.reUseCircleDialog(
                                  function: '',
                                  context: context,
                                  icon: Icons.close_rounded,
                                  title: clsLan.empty,
                                  content: Center(
                                    child: Text(
                                      clsLan.emptyFill,
                                      style: TextStyle(
                                        color: theme.black,
                                      ),
                                    ),
                                  ));
                            } else {
                              // await reUse.reUseOKCancelDialog(
                              //     data: profile,
                              //     icon: Icons.account_circle,
                              //     content: Text(clsLan.changeInfo),
                              //     context: context,
                              //     title: clsLan.change);
                              await reUse.reUseYesNoDialog(
                                  icon: Icons.account_circle,
                                  content: Text(clsLan.emptyFill),
                                  context: context,
                                  noText: clsLan.exit,
                                  yesText: clsLan.continues,
                                  noTap: () {
                                    Navigator.pop(context);
                                  },
                                  yesTap: () async {
                                    await glb.editProfile(
                                        value: profile, context: context);
                                    setState(() {});
                                  },
                                  title: clsLan.change);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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

  void handleListItemTap(int index) {
    // Perform actions using the index
    print('Index: $index');
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
