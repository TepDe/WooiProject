// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:get/get.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/HomeScreen.dart';
import 'package:wooiproject/ViewScreen.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final theme = ThemesApp();
  final reUse = ReUseWidget();

  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login_background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Get.height * 0.1,
                  ),
                  reUse.reUseText(content: 'ចូលគណនី', color: theme.black, size: 25.0, weight: FontWeight.bold),
                  reUse.reUseText(
                    content: 'សូមបំពេញព័ត៌មានដើម្បីបន្ត',
                    size: 12.0,
                  ),
                  SizedBox(
                    height: Get.height * 0.09,
                  ),
                  Column(
                    children: [
                      reUse.reUseTextBox(
                          icon: Icon(Icons.email), controller: userEmail, hind: 'អ៊ីមែល', obscureText: false),
                      const SizedBox(
                        height: 20,
                      ),
                      reUse.reUseTextBox(
                          suffixIconOnTap: () {
                            if(obscureText == false){
                              obscureText = true;
                            }else{
                              obscureText = false;
                            }
                            setState(() {});
                          },
                          suffixIcon: Icons.remove_red_eye,
                          icon: Icon(Icons.password),
                          controller: userPassword,
                          hind: 'ពាក្យសម្ងាត់',
                          obscureText: obscureText),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  // SizedBox(
                  //   width: Get.width,
                  //   height: 50,
                  //   child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         elevation: 0,
                  //         backgroundColor: theme.deepOrange,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(6),
                  //         ),
                  //       ),
                  //       onPressed: () async {
                  //         // lc.onDialogWaiting();
                  //
                  //         // showDialog(
                  //         //   context: context,
                  //         //   builder: (BuildContext context) {
                  //         //     return SizedBox(
                  //         //         height: 60,
                  //         //         width: 60,
                  //         //         child: Align(
                  //         //             alignment: Alignment.center,
                  //         //             child: CircularProgressIndicator()));
                  //         //   },
                  //         // );
                  //         if (userEmail.text.isEmpty) {
                  //           onDialogOK(
                  //               context: context,
                  //               title: 'Not Found',
                  //               content: 'Email is missing');
                  //         } else if (userPassword.text.isEmpty) {
                  //           onDialogOK(
                  //               context: context,
                  //               title: 'Not Found',
                  //               content: 'Password is missing');
                  //         } else {
                  //           onUserSignIn(
                  //               email: userEmail.text.trim(),
                  //               // email: 'u3@gmail.com',
                  //               password: userPassword.text.trim(),
                  //               // password: '111111',
                  //               context: context);
                  //         }
                  //
                  //         // lc._phoneVerify(context);
                  //       },
                  //       child: Text(
                  //         'Continue',
                  //         style: TextStyle(color: theme.white),
                  //       )),
                  // ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: Get.width * 0.45,
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
                          if (userEmail.text.isEmpty) {
                            onDialogOK(context: context, title: 'ខ្វះព័ត៌មាន', content: 'ខ្វះអ៊ីមែល');
                          } else if (userPassword.text.isEmpty) {
                            onDialogOK(context: context, title: 'ខ្វះព័ត៌មាន', content: 'ខ្វះពាក្យសម្ងាត់');
                          } else if (userPassword.text.isEmpty && userEmail.text.isEmpty) {
                            onDialogOK(context: context, title: 'ខ្វះព័ត៌មាន', content: 'ខ្វះអ៊ីមែល និង ពាក្យសម្ងាត់');
                          } else {
                            await onUserSignIn(
                                email: userEmail.text.trim(),
                                // email: 'u@gmail.com',
                                password: userPassword.text.trim(),
                                // password: 'qqqqqq',
                                context: context);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                            Text(
                              'បន្ត',
                              style: TextStyle(color: theme.white, fontWeight: FontWeight.w700),
                            ),
                            Icon(Icons.navigate_next_rounded),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  FirebaseAuth auth = FirebaseAuth.instance;

  final glb = GlobalController();
  final textphone = TextEditingController();
  var userEmail = TextEditingController();
  var userPassword = TextEditingController();

  onUserSignIn({email, password, context}) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.isNull) {
      } else {
        reUse.waitingDialog(context);
        var result = await glb.checkAccountType();
        if (result == "type") {
          Get.back();
          auth.signOut();
          await onDialogOK(context: context, title: 'មិនមាន', content: 'គណនីនេះមិនមានទេ សូមពិនិត្យមើលម្តងទៀត!');
        }
        // else if (result == "token") {
        //   Get.back();auth.signOut();
        //   await onDialogOK(context: context, title: 'ផ្សេងទៀត', content: 'គណនីនេះកំពុងប្រើនៅលើឧបករណ៍ផ្សេងទៀត');
        //
        // }
        else if (result == "banned") {
          Get.back();auth.signOut();
          await onDialogOK(context: context, title: 'ផ្អាក', content: 'បច្ចុប្បន្នគណនីនេះត្រូវបានផ្អាក');

        } else if (result == "") {
          Get.back();auth.signOut();
          await onDialogOK(context: context, title: 'មិនមាន', content: 'គណនីនេះមិនមានទេ សូមពិនិត្យមើលម្តងទៀត!');

        } else if (result == "true") {
          // await glb.updateOneField(
          //     field: 'signInToken',
          //     firebaseFireStore: 'Users',
          //     value: "true",
          //     data: auth.currentUser!.uid,
          //     allowDialog: false);
          await glb.storeUser(
            uid: auth.currentUser!.uid,
            email: email.toString(),
            password: password.toString(),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        onDialogOK(context: context, title: 'Wrong Password', content: 'Please check your password and again!');
      } else if (e.code == 'invalid-email') {
        onDialogOK(context: context, title: 'Wrong Email', content: 'Please check your Email and again!');
      } else if (e.code == 'user-not-found') {
        onDialogOK(context: context, title: 'Not Found', content: 'This User is not found please check and again!');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  onDialogOK({context, title, content}) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title'),
          content: Text('$content'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
