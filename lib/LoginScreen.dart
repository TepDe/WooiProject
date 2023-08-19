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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = "";
  String phoneNumberUser = '+85511111111';

  Future<void> _signInWithPhoneNumber({BuildContext? context, String? phoneNumber}) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          print("Verification Completed Automatically.");
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification Failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          print("OTP Code Sent: $verificationId");
          _showOTPDialog(context!);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          print("Auto Retrieval Timeout: $verificationId");
        },
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  void _showOTPDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter OTP"),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              // OTP input handling if needed
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                String otp = ""; // Get the entered OTP from the TextField
                _verifyOTP(context, otp);
              },
              child: Text("Verify"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _verifyOTP(BuildContext context, String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);
      print("OTP Verification Success!");
    } catch (e) {
      print("Error: $e");
    }
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
        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
        await auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) async {
        verificationId = verificationId;
        print(verificationId);
        print("Timout");
      },
    );
  }

  onUserSignIn({email, password, context}) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.isNull) {
      } else {
        userEmail.clear();
        userPassword.clear();
        reUse.waitingDialog(context);
        var result = await glb.checkAccountType();
        if (result == "type") {
          Get.back();
          await onDialogOK(context: context, title: 'មិនមាន', content: 'គណនីនេះមិនមានទេ សូមពិនិត្យមើលម្តងទៀត!');
          await FirebaseAuth.instance.signOut();
        } else if (result == "token") {
          Get.back();
          await onDialogOK(context: context, title: 'ផ្សេងទៀត', content: 'គណនីនេះកំពុងប្រើនៅលើឧបករណ៍ផ្សេងទៀត');
          await FirebaseAuth.instance.signOut();
        } else if (result == "banned") {
          Get.back();
          await onDialogOK(context: context, title: 'ផ្អាក', content: 'បច្ចុប្បន្នគណនីនេះត្រូវបានផ្អាក');
          await FirebaseAuth.instance.signOut();
        } else if (result == "true") {
          await glb.updateOneField(
              field: 'signInToken',
              firebaseFireStore: 'Users',
              value: "true",
              data: auth.currentUser!.uid,
              allowDialog: false);
          await glb.storeUser(
            uid: auth.currentUser!.uid,
            email: email.toString(),
            password: password.toString(),
          );
        }
        // else {
        //   await glb.storeUser(
        //     uid: auth.currentUser!.uid,
        //     email: email.toString(),
        //     password: password.toString(),
        //   );
        // }

        // if (await glb.checkAccountType() == false) {
        //   Get.back();
        //   await onDialogOK(
        //       context: context,
        //       title: 'បរាជ័យ',
        //       content: 'សូម​ព្យាយាម​ម្តង​ទៀត​នៅ​ពេល​ក្រោយ!');
        //   await FirebaseAuth.instance.signOut();
        // } else {
        //   await glb.storeUser(
        //     uid: auth.currentUser!.uid,
        //     email: email.toString(),
        //     password: password.toString(),
        //   );
        // }

        setState(() {});
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
    setState(() {});
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
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
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
        onDialogOK(context: context, title: 'Wrong Password', content: 'Please check your password and again!');
      } else if (e.code == 'wrong-email') {
        onDialogOK(context: context, title: 'Wrong Email', content: 'Please check your password and again!');
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
                height: 60, width: 60, child: Align(alignment: Alignment.center, child: CircularProgressIndicator()))
          ],
        );
      },
    );
  }

  final _codeController = TextEditingController();
  var smsCode;
  var _credential;
  var credential = PhoneAuthProvider.credential(verificationId: 'dasd', smsCode: 'dasjdasdasd');

  Future registerUser(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: '+85578344511',
        timeout: Duration(seconds: 25),
        verificationCompleted: (AuthCredential authCredential) {
          _auth.signInWithCredential(credential).then((UserCredential result) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
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

                          _credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
                          auth.signInWithCredential(_credential).then((UserCredential result) {
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
