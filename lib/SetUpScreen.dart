import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/ViewScreen.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';
import 'GlobalControl/GlobalController.dart';

class SetUpScreen extends StatefulWidget {
  const SetUpScreen({Key? key}) : super(key: key);

  @override
  State<SetUpScreen> createState() => _SetUpScreenState();
}

class _SetUpScreenState extends State<SetUpScreen> {
  final lastName = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  final abaNumber = TextEditingController();
  final theme = ThemesApp();
  final reUse = ReUseWidget();
  final glb = GlobalController();
  final clsLan = ClsLanguage();
  var labelSize = 11.0;
  var valueSize = 14.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.white,
      body: SafeArea(
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
                              child: reUse.ruTextBox(
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
                              child: reUse.ruTextBox(
                                controller: lastName,
                                hind: clsLan.lname,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                        reUse.ruTextBox(
                          controller: phoneNumber,
                          keyboardType: TextInputType.number,
                          hind: clsLan.phoneNumber,
                        ),
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                        reUse.ruTextBox(
                          controller: abaNumber,
                          keyboardType: TextInputType.number,
                          hind: clsLan.abaNumber,
                        ),
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: Get.width * 0.3,
                            height: Get.height * 0.05,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 1,
                                backgroundColor: theme.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              onPressed: () async {
                                if (firstName.text.trim().toString() == '') {
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
                                } else if (lastName.text.trim().toString() ==
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
                                } else if (phoneNumber.text.trim().toString() ==
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
                                } else {
                                  showDialog(
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
                                                  height: 40,
                                                  width: 40,
                                                  child:
                                                      CircularProgressIndicator()),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  );

                                  glb.storeSetUpAccount(
                                      phoneNumber: phoneNumber.text.trim(),
                                      firstname: firstName.text.trim(),
                                      lastname: lastName.text.trim());
                                  setState(() {
                                    Get.to(const ViewScreen());
                                  });
                                }

                                // await glb.setUpInfor(
                                //     phoneNumber: phoneNumber.text.trim(),
                                //     firstname: firstName.text.trim(),
                                //     lastname: lastName.text.trim());
                                // Get.to(const ViewScreen());

                                setState(() {});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
    );
  }
}
