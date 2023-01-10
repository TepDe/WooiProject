import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:get/get.dart';
import 'package:wooiproject/HomeScreen.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';
import 'package:wooiproject/WidgetReUse/WidGetReUse.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({Key? key}) : super(key: key);

  final wr = WidgetReUse();
  final textphone = TextEditingController();
  final theme = ThemesApp();

  readUser() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  readToken() {
    FirebaseAuth.instance.idTokenChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
              ),
              Text('Log In',
                  style: TextStyle(
                      fontSize: 24,
                      color: theme.black,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: theme.liteGrey,
                    borderRadius: BorderRadius.circular(6)),
                child: TextField(
                  controller: textphone,
                  decoration: InputDecoration(
                    filled: true,
                    //<-- SEE HERE
                    fillColor: theme.liteGrey,
                    //iconColor: theme.grey,
                    //enabled: true,
                    //focusColor: Colors.grey,
                    //prefix: Icon(Icons.phone),
                    border: InputBorder.none,
                    icon: Icon(Icons.phone),
                    hintText: 'Enter your phone number',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Obx(() => Text('lc.codeSent    ${lc.codeSent}')),
              Obx(() => Text('lc.codeSent    ${lc.codeSent}')),
              Obx(() => Text('lc.codeSent    ${lc.codeSent}')),
              Material(

                child: FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    height: 40,
                    splashColor: Colors.yellowAccent,
                    minWidth: Get.width,
                    color: theme.yellow,
                    onPressed: () async {
                      Get.to(HomeScreen());
                      // lc.test.value = true;
                    },

                    child: Text('Confirm')),
              ),
              // Obx(
              //   () => AnimatedButton(
              //     height: 70,
              //     width: Get.width,
              //     // borderColor: Colors.orange,
              //     selectedBackgroundColor: Colors.yellowAccent,
              //     text: 'SUBMIT',
              //     textStyle: const TextStyle(color: Colors.black),
              //     selectedTextColor: Colors.black,
              //     isReverse: false,
              //     transitionType: TransitionType.CENTER_LR_IN,
              //     backgroundColor: Colors.yellow,
              //     borderRadius: 0,
              //     borderWidth: 2,
              //     onPress: () {},
              //     animatedOn: AnimatedOn.onTap,
              //     isSelected: lc.test.value,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  final lc = Get.put(LoginController());


  timeOut(context) {}
}

class LoginController extends GetxController {
  var test = false.obs;
  var codeSent = ''.obs;
  var codeAutoRetrievalTimeout = ''.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  var verificationId = ''.obs;

  LogInScreen() {}

  @override
  void onInit() {
    super.onInit();
    auth = FirebaseAuth.instance;
    changeColor();
    update();
  }
  var bannerPosition = 0;
  var moviePhotos = [
    '1',
    '1',
  ];

  changeColor() async{
    while(true){
      await new Future.delayed(const Duration(seconds : 1));
      if (bannerPosition < moviePhotos.length){
        print("Banner Position Pre");
        print(bannerPosition);
          bannerPosition = bannerPosition + 1;
          if (test.value == true){
            test.value = false;
            update();
          }else {
            test.value =true;
            update();
          }
          update();
        print("Banner Position Post");
        print(bannerPosition);
      }
      else{
          bannerPosition = 0;
          update();
      }
      update();
    }
  }

  onLogin() async {
    await auth.verifyPhoneNumber(
      phoneNumber: '078344511',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        print('!!!!!!!!!!!The provided phone number is not valid.$credential');
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('============The provided phone number is not valid.');
          Get.snackbar('Error', 'valid $e');
        } else {
          Get.snackbar('Error', 'dasd $e');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        codeSent.value = verificationId.toString();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    update();
  }

  Future<bool> otpVerify(smsCode) async {
    var credential = await auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationId.value, smsCode: smsCode));
    return credential.user != null ? true : false;
  }
}
