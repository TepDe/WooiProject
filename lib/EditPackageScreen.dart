import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wooiproject/Distination/clsDistin.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/GlobalControl/clsField.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';

class EditPackageScreen extends StatefulWidget {
  const EditPackageScreen({Key? key}) : super(key: key);

  @override
  State<EditPackageScreen> createState() => _EditPackageScreenState();
}

class _EditPackageScreenState extends State<EditPackageScreen> {

  final reUse = ReUseWidget();
  final theme = ThemesApp();
  final glb = GlobalController();
  final clsDis = ClsDestination();
  final clsLan = ClsLanguage();
  final phoneBox = TextEditingController(text: '0');
  final locationBox = TextEditingController();
  final priceBox = TextEditingController();
  final qtyBox = TextEditingController();
  final noteBox = TextEditingController();
  String packageID = '';
  double textSize = 14;
  List distince = [];
  List eng_distin = [];
  List forDisplay = [];
  String userName = '';
  String phoneNumber = '';
  String getToken = '';
  String chatid = '';
  var argumentData = Get.arguments;
  final fieldData = FieldData();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(argumentData);
    print(argumentData);
    phoneBox.text = argumentData[fieldData.phoneNumber];
    locationBox.text = argumentData[fieldData.location];
    priceBox.text = argumentData[fieldData.price];
    qtyBox.text = argumentData[fieldData.qty];
    noteBox.text = argumentData[fieldData.note];
    packageID = argumentData[fieldData.packageID];
    fetchUserInformation();
  }

  fetchUserInformation() async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((doc) async {
      Map data = doc.data() as Map;
      userName = data['firstname'] + ' ' + data['lastname'].toString();
      phoneNumber = data['phoneNumber'].toString();
      setState(() {});
    });
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
                      icon: Icon(Icons.arrow_back_rounded, color: theme.black),
                      label: Text(
                        'Back',
                        style: TextStyle(color: theme.black),
                      ),
                    ), TextButton.icon(
                      onPressed: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => const ViewScreen(),
                        //   ),
                        // );
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.delete_forever, color: theme.red),
                      label: Text(
                        'លុប',
                        style: TextStyle(color: theme.red),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      reUse.reUseText(
                        content: clsLan.packageID+' : ',
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
                  padding: const EdgeInsets.only(left: 20, bottom: 10),
                  child: reUse.reUseText(
                      content: 'លេខទូរស័ព្ទអ្នកទទួល :',
                      size: textSize,
                      weight: FontWeight.w500,
                      color: theme.black),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: phoneBox,
                    // keyboardType: inputType,
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 10,
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
                  padding: const EdgeInsets.only(left: 20, bottom: 10),
                  child: reUse.reUseText(
                      content: 'ទីតាំងអ្នកទទួល : ( សូមបញ្ចូលទីតាំងអ្នកទទួលជាអក្សរខ្មែរ )',
                      size: textSize,
                      weight: FontWeight.w500,
                      color: theme.black),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: locationBox,
                    // keyboardType: inputType,
                    //keyboardType: inputType,
                    //inputFormatters: formater,
                    onChanged: (value) {
                      List results = clsDis.destination
                          .where((user) => user.toLowerCase().contains(
                          locationBox.text.toString().toLowerCase()))
                          .toList();
                      if (results == null) {
                        results = eng_distin
                            .where((user) => user.toLowerCase().contains(
                            locationBox.text.toString().toLowerCase()))
                            .toList();
                      }
                      print(results);
                      print(results);
                      forDisplay = results;
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          locationBox.clear();
                          locationBox.text = '';
                          setState(() {});
                        },
                        icon: const Icon(Icons.close),
                      ),
                      hintText: locationBox.text.toString() ?? '',
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
                              locationBox.text = forDisplay[index]
                                  .toString()
                                  .trim()
                                  .toLowerCase();
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
                  padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
                  child: reUse.reUseText(
                      content: clsLan.price+" : ( សូមបញ្ចូលតំលៃគិតជាដុល្លារ )",
                      size: textSize,
                      weight: FontWeight.w500,
                      color: theme.black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 6,
                      child: reUse.reuseTextField(
                          controller: priceBox,
                          formater: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[0-9.,]+')),
                          ],
                          inputType: const TextInputType.numberWithOptions(
                              decimal: true),
                          label: ' ',
                          textIcon: Icons.location_on),
                    ),
                    Flexible(
                      flex: 1,
                      child: reUse.reUseText(content: '\$', size: 20.0),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
                  child: reUse.reUseText(
                      content: clsLan.qty+" :",
                      size: textSize,
                      weight: FontWeight.w500,
                      color: theme.black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 6,
                      child: reUse.reuseTextField(
                          controller: qtyBox,
                          formater: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[0-9.,]+')),
                          ],
                          inputType: const TextInputType.numberWithOptions(
                              decimal: true),
                          label: ' ',
                          textIcon: Icons.location_on),
                    ),
                    Flexible(
                      flex: 1,
                      child: reUse.reUseText(content: '', size: 20.0),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                const SizedBox(
                  height: 18,
                ),
                reUse.reUseText(
                    content: 'ចំណាំ :', size: textSize, color: theme.black),
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
                                    .editPackage(
                                  data: argumentData,
                                    userName: userName.trim().toString(),
                                    userPhoneNumber:
                                    phoneNumber.trim().toString(),
                                    tokenKey: getToken.trim().toString(),
                                    chatid: chatid.trim().toString(),
                                    price: priceBox.text.trim().toString(),
                                    note: noteBox.text.toString(),
                                    packageID: packageID.toString(),
                                    qty: qtyBox.text.trim().toString(),
                                    phoneNumber:
                                    phoneBox.text.trim().toString(),
                                    location:
                                    locationBox.text.trim().toString())
                                    .then((value) {
                                  // phoneBox.clear();
                                  // priceBox.clear();
                                  // locationBox.clear();
                                  // qtyBox.clear();
                                  // noteBox.clear();
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
                const SizedBox(
                  height: 18,
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
