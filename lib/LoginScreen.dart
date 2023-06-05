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
                  reUse.reUseText(
                      content: 'Sign in',
                      color: theme.black,
                      size: 25.0,
                      weight: FontWeight.bold),
                  reUse.reUseText(
                    content: 'Please sign in to Continue (User)',
                    size: 12.0,
                  ),
                  SizedBox(
                    height: Get.height * 0.09,
                  ),
                  Column(
                    children: [
                      reUse.ruTextBox(
                          icon: Icon(Icons.email),
                          controller: userEmail,
                          hind: 'Email',
                          obscureText: false),
                      const SizedBox(
                        height: 20,
                      ),
                      reUse.ruTextBox(
                          icon: Icon(Icons.password),
                          controller: userPassword,
                          hind: 'Password',
                          obscureText: true),
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
                      width: Get.width * 0.33,
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
                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return const SizedBox(
                          //         height: 60,
                          //         width: 60,
                          //         child: Align(
                          //             alignment: Alignment.center,
                          //             child: CircularProgressIndicator()));
                          //   },
                          // );
                          if (userEmail.text.isEmpty) {
                            onDialogOK(
                                context: context,
                                title: 'Not Found',
                                content: 'Email is missing');
                          } else if (userPassword.text.isEmpty) {
                            onDialogOK(
                                context: context,
                                title: 'Not Found',
                                content: 'Password is missing');
                          } else {
                            onUserSignIn(
                                email: userEmail.text.trim(),
                                // email: 'u3@gmail.com',
                                password: userPassword.text.trim(),
                                // password: '111111',
                                context: context);
                          }
                          reUse.alertDialog(context);
                          // password: '111111');

                          // lc._phoneVerify(context);
                          // phoneAuth();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Continue',
                              style: TextStyle(
                                  color: theme.white,
                                  fontWeight: FontWeight.w700),
                            ),
                            Icon(Icons.navigate_next_rounded),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: const [
                  //     Flexible(
                  //       child: Divider(
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //     Padding(
                  //       padding: EdgeInsets.all(8.0),
                  //       child: Text("Already have Account?"),
                  //     ),
                  //     Flexible(
                  //       child: Divider(
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const Align(
                  //     alignment: Alignment.topCenter,
                  //     child: Text(
                  //       "Sign in",
                  //       style: TextStyle(color: Colors.blue),
                  //     )),
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

  phoneAuth() async {
  await auth.verifyPhoneNumber(
      phoneNumber: '+85578344511',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        Get.to(ViewScreen());
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        String smsCode = '124578';
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);
        await auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId)async {
        verificationId = verificationId;
        print(verificationId);
        print("Timout");
      },
    );
  }

  onUserSignIn({email, password, context}) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.isNull) {
      } else {
        userEmail.clear();
        userPassword.clear();
        await glb.storeUser(
          uid: auth.currentUser!.uid,
          email: email.toString(),
          password: password.toString(),
        );
        reUse.alertDialog(context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        onDialogOK(
            context: context,
            title: 'Wrong Password',
            content: 'Please check your password and again!');
      } else if (e.code == 'invalid-email') {
        onDialogOK(
            context: context,
            title: 'Wrong Email',
            content: 'Please check your Email and again!');
      } else if (e.code == 'user-not-found') {
        onDialogOK(
            context: context,
            title: 'Not Found',
            content: 'This User is not found please check and again!');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    setState(() {});
  }

  onDialogOK({context, title, content}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title'),
          content: Text('$content'),
          actions: [
            TextButton(
              onPressed: () {
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

class LoginController extends GetxController {
  var test = false.obs;
  var codeSent = ''.obs;
  var codeAutoRetrievalTimeout = ''.obs;
  var verificationId = ''.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  var receivedID = '';
  final textphone = TextEditingController().obs;
  var userEmail = TextEditingController().obs;
  var userPassword = TextEditingController().obs;

  final glb = GlobalController();

  bool showDialogWiating = false;
  int userID = 0;

  onUserSignIn({email, password, context}) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.isNull) {
      } else {
        glb.UID = (userCredential.user?.uid).toString();
        userEmail.value.clear();
        userPassword.value.clear();
        await glb.storeUser(
          uid: auth.currentUser!.uid,
          email: email.toString(),
          password: password.toString(),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
      } else if (e.code == 'email-already-in-use') {
        // onDialog(context: context);
      } else if (e.code == 'wrong-password') {
        onDialogOK(
            context: context,
            title: 'Wrong Password',
            content: 'Please check your password and again!');
      } else if (e.code == 'wrong-email') {
        onDialogOK(
            context: context,
            title: 'Wrong Email',
            content: 'Please check your password and again!');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    update();
  }

  onDialogOK({context, title, content}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: AlertDialog(
            title: Text('$title'),
            content: Text('$content'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  onDialogWaiting({context, title, content}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('wait'),
          // content: Text('wait'),
          actions: const [
            SizedBox(
                height: 60,
                width: 60,
                child: Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator()))
          ],
        );
      },
    );
  }

  final _codeController = TextEditingController();
  var smsCode;
  var _credential;
  var credential = PhoneAuthProvider.credential(
      verificationId: 'dasd', smsCode: 'dasjdasdasd');

  Future registerUser(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: '+85578344511',
        timeout: Duration(seconds: 25),
        verificationCompleted: (AuthCredential authCredential) {
          _auth.signInWithCredential(credential).then((UserCredential result) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }).catchError((e) {
            print(e);
          });
        },
        verificationFailed: (FirebaseAuthException authException) {
          print(authException.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                    title: Text("Enter SMS Code"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _codeController,
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        child: Text("Done"),
                        onPressed: () {
                          FirebaseAuth auth = FirebaseAuth.instance;

                          smsCode = _codeController.text.trim();

                          _credential = PhoneAuthProvider.credential(
                              verificationId: verificationId, smsCode: smsCode);
                          auth
                              .signInWithCredential(_credential)
                              .then((UserCredential result) {
                            Get.to(HomeScreen());
                          }).catchError((e) {
                            print(e);
                          });
                        },
                      )
                    ],
                  ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print(verificationId);
          print("Timout");
        });
  }

  @override
  void onInit() {
    super.onInit();
    changeColorButton();
    update();
  }

  var bannerPosition = 0;
  var moviePhotos = [
    '1',
    '1',
  ];

  changeColorButton() async {
    // while (true) {
    //   await new Future.delayed(const Duration(seconds: 1));
    //   if (bannerPosition < moviePhotos.length) {
    //     print("Banner Position Pre");
    //     print(bannerPosition);
    //     bannerPosition = bannerPosition + 1;
    //     if (test.value == true) {
    //       test.value = false;
    //       update();
    //     } else {
    //       test.value = true;
    //       update();
    //     }
    //     update();
    //     print("Banner Position Post");
    //     print(bannerPosition);
    //   } else {
    //     bannerPosition = 0;
    //     update();
    //   }
    //   update();
    // }
  }
}
