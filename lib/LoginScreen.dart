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

class LogInScreen extends StatelessWidget {
  LogInScreen({Key? key}) : super(key: key);

  final theme = ThemesApp();
  final rw = ReUseWidget();

  @override
  Widget build(BuildContext context) {
    var height =MediaQuery.of(context).size.width * 0.3;

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
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
                  const SizedBox(
                    height: 80,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: 83,
                      width: 83,
                      child: Text('MACAW'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text('Register',
                      //       style: TextStyle(
                      //         // decoration: TextDecoration.underline,
                      //         fontSize: 18,
                      //         color: theme.deepOrange,
                      //       )),
                      // ),
                      TextButton(
                        onPressed: () {},
                        child: Text('Sign In',
                            style: TextStyle(
                              // decoration: TextDecoration.underline,
                              fontSize: 18,
                              color: theme.grey,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      rw.ruTextBox(
                          icon: Icon(Icons.email),
                          controller: lc.userEmail.value,
                          hind: 'Email',
                          obscureText: false),
                      const SizedBox(
                        height: 20,
                      ),
                      rw.ruTextBox(
                          icon: Icon(Icons.password),
                          controller: lc.userPassword.value,
                          hind: 'Password',
                          obscureText: true),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: Get.width,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: theme.deepOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: () async {
                          // lc.onDialogWaiting();

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator()));
                            },
                          );
                          lc.onUserSignIn(
                              email: lc.userEmail.value.text.trim(),
                              // email: 'u@gmail.com',
                              password: lc.userPassword.value.text.trim(),
                              // password: '111111',
                              context: context);
                          // lc._phoneVerify(context);
                        },
                        child: Text(
                          'Sign in',
                          style: TextStyle(color: theme.white),
                        )),
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

  final lc = Get.put(LoginController());
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
