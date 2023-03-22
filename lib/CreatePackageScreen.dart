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
  double textSize = 14;

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Package'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 50),
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Row(
                      children: [
                        reUse.reUseText(
                            content: 'Package ID: ',
                            size: textSize,
                            color: theme.grey),
                        reUse.reUseText(
                            content: 'PK00256',
                            size: 20.0,
                            color: theme.black,
                            weight: FontWeight.bold),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  reUse.reUseText(
                      content: 'Receiver Phone Number:',
                      size: textSize,
                      color: theme.grey),
                  reUse.reuseTextField(
                      textIcon: Icons.phone,
                      label: 'Receiver Phone Number',
                      controller: phoneBox),
                  SizedBox(
                    height: 18,
                  ),
                  reUse.reUseText(
                      content: 'Receiver Location :',
                      size: textSize,
                      color: theme.grey),
                  reUse.reuseTextField(
                      controller: locationBox,
                      label: 'Receiver Location',
                      textIcon: Icons.location_on),
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
                          iconcolor: theme.white,
                          colorBC: theme.hiLiteBlue,
                          isBcColor: true),
                      Container(
                        width: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextField(
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
                          iconcolor: theme.white,
                          colorBC: theme.hiLiteBlue,
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
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 0.0),
                          ),

                          // hintText: "Enter Remarks",
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: theme.hiLiteBlue))),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel')),
                      ElevatedButton(
                          onPressed: () async {
                            await glb
                                .requestPackage(
                                    qty: qtyBox.text.trim().toString(),
                                    phoneNumber: phoneBox.text.trim().toString(),
                                    location: locationBox.text.trim().toString())
                                .then((value) {
                              //qtyBox.clear();
                              phoneBox.clear();
                              locationBox.clear();
                            });

                            Navigator.pop(context);
                          },
                          child: Text('OK')),
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
