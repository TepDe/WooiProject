import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

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
                          icon: const Icon(Icons.email), controller: userEmail, hind: 'អ៊ីមែល', obscureText: false),
                      const SizedBox(
                        height: 20,
                      ),
                      reUse.reUseTextBox(
                          suffixIconOnTap: () {
                            if (obscureText == false) {
                              obscureText = true;
                            } else {
                              obscureText = false;
                            }
                            setState(() {});
                          },
                          suffixIcon: Icons.remove_red_eye,
                          icon: const Icon(Icons.password),
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
                            Icon(
                              Icons.navigate_next_rounded,
                              color: theme.white,
                            ),
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

  Future<void> onUserSignIn({email, password, context}) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.isNull) {
        auth.signOut();
        Navigator.pop(context);
      } else {
        reUse.reUseWaitingDialog(context);
        Map userObj = await glb.onGetUserData();
        Map generalInfo = await glb.onGetGeneralInfo();
        if (userObj["accountType"] == "Users" && userObj["isBanned"] == "false" && generalInfo["userVersion"] == "712023") {
          await glb.storeUser(
            uid: auth.currentUser!.uid,
            email: email.toString(),
            password: password.toString(),
          );
        } else {
          auth.signOut();
          Navigator.pop(context);
          reUse.reUseCircleDialog(
              disposeAllow: false,
              onTap: () {
                Get.to(() => const LogInScreen());
              },
              context: context,
              icon: Icons.cancel_outlined,
              title: 'មានបញ្ហា',
              content: Center(
                child: Text(
                  'ព្យាយាមម្តងទៀតនៅពេលក្រោយ',
                  style: TextStyle(
                    color: theme.black,
                  ),
                ),
              ));
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
      auth.signOut();
      Navigator.pop(context);
      reUse.reUseCircleDialog(
          disposeAllow: false,
          onTap: () {
            Navigator.pop(context);
          },
          context: context,
          icon: Icons.cancel_outlined,
          title: 'មានបញ្ហា',
          content: Center(
            child: Text(
              'ព្យាយាមម្តងទៀតនៅពេលក្រោយ',
              style: TextStyle(
                color: theme.black,
              ),
            ),
          ));
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
