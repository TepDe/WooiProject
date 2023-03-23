import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'GlobalControl/GlobalController.dart';
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
  final qtyBox = TextEditingController();
  final noteBox = TextEditingController();
  double textSize = 12;
  String packageID = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    packageID = glb.generatePackageID();
  }

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 50),
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                          splashRadius: 25,
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.arrow_back)),
                      Text(
                        'Back',
                        style: TextStyle(
                            fontSize: 14,
                            color: theme.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 25.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // reUse.reUseText(
                        //     content: '    ID: ',
                        //     size: textSize,
                        //     color: theme.grey),
                        reUse.reUseText(
                            content: 'ID : ',
                            size: 26.0,
                            color: theme.black,
                            weight: FontWeight.bold),
                        reUse.reUseText(
                            content: packageID,
                            size: 26.0,
                            color: theme.black,
                            weight: FontWeight.bold),
                      ],
                    ),
                  ),
                  Divider(
                    color: theme.grey,
                    height: 1,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: reUse.reUseText(
                        content: 'Receiver Phone Number:',
                        size: textSize,
                        color: theme.grey),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: reUse.reuseTextField(
                        textIcon: Icons.phone,
                        label: 'Receiver Phone Number',
                        controller: phoneBox),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: reUse.reUseText(
                        content: 'Receiver Location :',
                        size: textSize,
                        color: theme.grey),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: reUse.reuseTextField(
                        controller: locationBox,
                        label: 'Receiver Location',
                        textIcon: Icons.location_on),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      reUse.reUseCustomizeButton(
                          icon: Icons.remove,
                          showIcon: true,
                          iconcolor: theme.orange,
                          colorBC: theme.liteOrange,
                          isBcColor: true),
                      Container(
                        width: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextField(
                          controller: qtyBox,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(fontSize: 12),
                            hintText: 'Qty',
                          ),
                        ),
                      ),
                      reUse.reUseCustomizeButton(
                          icon: Icons.add,
                          showIcon: true,
                          iconcolor: theme.orange,
                          colorBC: theme.liteOrange,
                          isBcColor: true)
                    ],
                  ),
                  SizedBox(
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
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 0.0),
                          ),

                          // hintText: "Enter Remarks",
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: theme.hiLiteBlue))),
                    ),
                  ),
                  SizedBox(
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
                                FocusScope.of(context).unfocus();
                                await glb
                                    .requestPackage(
                                        note: noteBox.text.trim().toString(),
                                        packageID: packageID.toString(),
                                        qty: qtyBox.text.trim().toString(),
                                        phoneNumber:
                                            phoneBox.text.trim().toString(),
                                        location:
                                            locationBox.text.trim().toString())
                                    .then((value) {
                                  //qtyBox.clear();
                                  phoneBox.clear();
                                  locationBox.clear();
                                  qtyBox.clear();
                                  noteBox.clear();
                                });
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
      ),
    );
  }
}
