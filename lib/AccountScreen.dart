import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/EditProfileScreen.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/GlobalControl/StorageKey.dart';
import 'package:wooiproject/GlobalControl/clsField.dart';
import 'package:wooiproject/LoginScreen.dart';
import 'package:wooiproject/PaidScreen.dart';
import 'package:wooiproject/RevenueList.dart';
import 'package:wooiproject/SetUpScreen.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  List lists = [];
  final str = StorageKey();
  var glb = GlobalController();
  String getLatitude = '';
  String getLongitude = '';
  String getFirstName = '';
  String getLastName = '';
  String getIsGoOnline = '';
  String getPhoneNumber = '';
  String getEmail = '';
  String getPassword = '';
  String getUserName = '';
  String getUserID = '';
  String getToken = '';
  String getChatId = '';
  String getUid = '';
  String getLocation = '';
  String getQty = '';

  bool cantEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //fetchLocalStorage();
    fetchUserData();
    totalRevenue();
    fetchImage();
  }

  fetchImage() async {
    final prefs = await SharedPreferences.getInstance();
    getImageFileFromPath(prefs.getString(str.profileImg).toString());
  }

  Future<void> insertTelegramToken() async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) {
      print(value);
      print(value);
      if (value.data()?.containsKey('telegramToken') == true) {
        print('true');
        print('true');
      } else {
        print('false');
        print('false');
      }
    });
  }

  var fetch = FirebaseFirestore.instance.collection('Users');
  var userData = {};
  var imagePath;
  File? _image;
  final passwordBox = TextEditingController();
  final strKey = StorageKey();

  Future<void> pickImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var picture = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picture != null) {
        setState(() async {
          _image = File(picture.path);
          await prefs.setString(strKey.profileImg, picture.path);
        });
      } else {
        // User canceled the image picking.
      }
    } catch (e) {
      // Handle any errors that might occur during image picking.
    }
    setState(() {});
  }

  fetchUserData() async {
    try{
      await fetch
          .doc(auth.currentUser!.uid.toString())
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        userData = await documentSnapshot.data() as Map<String, dynamic>;
        if (userData["accountType"] != "Users") {
          return await reUse.reUseCircleDialog(
              disposeAllow: false,
              onTap: () => glb.isLogOut(),
              context: context,
              icon: Icons.wifi,
              title: 'មិនមាន',
              content: Center(
                child: Text(
                  'គណនីនេះមិនមានទេ សូមពិនិត្យមើលម្តងទៀត!',
                  style: TextStyle(
                    color: theme.black,
                  ),
                ),
              ));
        } else if (userData["isBanned"] != "false") {
          return await reUse.reUseCircleDialog(
              disposeAllow: false,
              onTap: () => glb.isLogOut(),
              context: context,
              icon: Icons.cancel_outlined,
              title: 'ផ្អាក',
              content: Center(
                child: Text(
                  'បច្ចុប្បន្នគណនីនេះត្រូវបានផ្អាក',
                  style: TextStyle(
                    color: theme.black,
                  ),
                ),
              ));
        }
        imagePath =
        await glb.getBankImage(bankName: userData[fieldInfo.bankName]);
        setState(() {});
      });
    }catch(e){
      FirebaseAuth.instance.signOut();
      Get.to(()=> const LogInScreen());
    }

  }

  final reUse = ReUseWidget();
  final theme = ThemesApp();
  bool light = false;
  final fieldInfo = FieldInfo();
  final field = FieldData();

  final token = TextEditingController();
  final abaCode = TextEditingController();
  final chatid = TextEditingController();
  final clsLan = ClsLanguage();

  bool hindPassowrd = true;

  Future<File> getImageFileFromPath(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString(str.profileImg).toString());
    print(prefs.getString(str.profileImg).toString());
    return File(prefs.getString(str.profileImg).toString());
  }

  @override
  Widget build(BuildContext context) {
    var imageSize = MediaQuery.of(context).size.height * 0.15;
    var viewHeight2 = MediaQuery.of(context).size.height * 0.03;
    var padding = MediaQuery.of(context).size.height * 0.01;
    var textWidth = MediaQuery.of(context).size.width * 0.2;
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: viewHeight2,
                  ),
                  reUse.reUseText(
                      content: 'គណនី', weight: FontWeight.bold, size: 18.0),
                  SizedBox(
                    height: viewHeight2,
                  ),
                  FutureBuilder<String?>(
                    future: SharedPreferences.getInstance()
                        .then((prefs) => prefs.getString(str.profileImg)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Display a loading indicator while waiting for data
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        // Handle error case
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData && snapshot.data != null) {
                        String imagePath = snapshot.data!;
                        return FutureBuilder<File>(
                          future: getImageFileFromPath(imagePath),
                          builder: (context, fileSnapshot) {
                            if (fileSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              // Display a loading indicator while waiting for image file
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (fileSnapshot.hasError) {
                              // Handle error case
                              return Center(
                                  child: Text('Error: ${fileSnapshot.error}'));
                            } else if (fileSnapshot.hasData &&
                                fileSnapshot.data != null) {
                              File imageFile = fileSnapshot.data!;
                              return SizedBox(
                                height: imageSize,
                                width: imageSize,
                                child: InkWell(
                                  onTap: () => pickImage(),
                                  child: CircleAvatar(
                                      backgroundImage: FileImage(imageFile)),
                                ),
                              );
                            } else {
                              // Image not found
                              return const Center(
                                  child: Text('Image not found'));
                            }
                          },
                        );
                      } else {
                        // No image stored
                        return InkWell(
                            onTap: () {
                              pickImage();
                            },
                            child: Icon(
                              Icons.account_circle_rounded,
                              size: imageSize,
                              color: theme.grey,
                            ));
                      }
                    },
                  ),
                  SizedBox(
                    height: viewHeight2,
                  ),
                  reUse.reUseText(
                      content:
                          "${userData[fieldInfo.firstName] ?? " "} ${userData[fieldInfo.lastName] ?? " "}",
                      weight: FontWeight.bold,
                      size: 20.0,
                      color: theme.black),
                  reUse.reUseText(
                      content: 'ID : ${userData[fieldInfo.userID]}',
                      weight: FontWeight.bold,
                      size: 12.0,
                      color: theme.grey),
                  reUse.reUseText(
                      content: glb.auth.currentUser!.uid,
                      weight: FontWeight.bold,
                      size: 12.0,
                      color: theme.grey),
                  Row(
                    children: [
                      Flexible(
                        child: reUse.reUseBoxText(
                            backgroundColor: theme.white,
                            // assetImage: "assets/images/RevenueBtn.png",
                            data: revenuePrice,
                            value: "\$ ${revenue.toStringAsFixed(2)}",
                            textColor: theme.black,
                            witchClick: "revenue",
                            valueTextSize: 20.0,
                            onTap: () {
                              Get.to(() => const RevenueList(), arguments: {
                                "data": revenuePrice,
                                "price": revenue.toStringAsFixed(2)
                              });
                            },
                            labelTextSize: 14.0,
                            valueColor: theme.grey,
                            title: clsLan.revenue),
                      ),
                      Flexible(
                        child: reUse.reUseBoxText(
                            witchClick: "paid",
                            backgroundColor: theme.white,
                            // assetImage: "assets/images/TotalPaidBtn.png",
                            value: "\$ ${paid.toStringAsFixed(2)}",
                            onTap: () {
                              Get.to(() => const PaidScreen(), arguments: {
                                "data": paidPrice,
                                "price": paid.toStringAsFixed(2)
                              });
                            },
                            title: clsLan.paid,
                            valueTextSize: 20.0,
                            labelTextSize: 14.0,
                            valueColor: theme.grey,
                            textColor: theme.black,
                            data: paidPrice),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(padding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        reUse.reUseText(
                            content: 'Account',
                            //weight: FontWeight.bold,
                            size: 16.0,
                            color: theme.black),
                        TextButton.icon(
                          onPressed: () {
                            Get.to(() => const EditProfileScreen(),
                                arguments: userData);
                          },
                          icon: Icon(Icons.edit, color: theme.darkGrey),
                          label: reUse.reUseText(
                              content: 'Edit',
                              size: 16.0,
                              color: theme.darkGrey),
                        )
                      ],
                    ),
                  ),
                  reUse.reUseSettingItem(
                      trailing: Text(
                        "${userData[fieldInfo.email]}",
                        style: TextStyle(color: theme.grey),
                      ),
                      title: const Text('Email'),
                      context: context,
                      leading: const Icon(Icons.email)),
                  reUse.reUseSettingItem(
                      trailing: hindPassowrd == true
                          ? IconButton(
                              onPressed: () {
                                if (hindPassowrd == true) {
                                  hindPassowrd = false;
                                } else {
                                  hindPassowrd = true;
                                }
                                setState(() {});
                              },
                              icon: const Icon(Icons.visibility_off))
                          : InkWell(
                              onTap: () {
                                if (hindPassowrd == false) {
                                  hindPassowrd = true;
                                } else {
                                  hindPassowrd = false;
                                }
                                setState(() {});
                              },
                              child: Text(
                                ("${userData[fieldInfo.password]}"),
                                style: TextStyle(color: theme.grey),
                              ),
                            ),
                      title: const Text('Password'),
                      context: context,
                      leading: const Icon(Icons.password_rounded)),
                  reUse.reUseSettingItem(
                      trailing: Text(
                        "${userData[fieldInfo.phoneNumber]??"មិនមាន"}",
                        style: TextStyle(color: theme.grey),
                      ),
                      title: Text(clsLan.phoneNumber),
                      context: context,
                      leading: const Icon(Icons.phone)),
                  reUse.reUseSettingItem(
                      trailing: Text(
                        userData[fieldInfo.bankName].toString().toUpperCase(),
                        style: TextStyle(color: theme.grey),
                      ),
                      title: Text(clsLan.payService),
                      context: context,
                      leading: const Icon(Icons.monetization_on)),
                  // reUse.reUseSettingItem(
                  //     trailing: imagePath != null
                  //         ? Text(
                  //             imagePath[0]['name'].toString().toUpperCase(),
                  //             style: TextStyle(color: theme.grey),
                  //           )
                  //         : Container(),
                  //     title: Text(clsLan.payService),
                  //     context: context,
                  //     leading: const Icon(Icons.monetization_on)),
                  Container(
                    height: 60,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: theme.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: theme.midGrey,
                          blurRadius: 2,
                          offset: const Offset(0, 0), // Shadow position
                        ),
                      ],
                    ),
                    child: Center(
                      child: ListTile(
                        title: Text(clsLan.receiveMoneyNumber),
                        trailing: SizedBox(
                            width: textWidth,
                            child: Text(
                              "${userData[fieldInfo.bankCode]??"មិនមាន"}",
                              maxLines: 1,
                              style: TextStyle(
                                  color: theme.grey,
                                  overflow: TextOverflow.ellipsis),
                            )),
                        leading: const Text("123"),
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: theme.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: theme.midGrey,
                          blurRadius: 2,
                          offset: const Offset(0, 0), // Shadow position
                        ),
                      ],
                    ),
                    child: Center(
                      child: ListTile(
                        title: const Text('Telegram Token'),
                        trailing: SizedBox(
                            width: textWidth,
                            child: Text(
                              "${userData[fieldInfo.token]??"មិនមាន"}",
                              maxLines: 1,
                              style: TextStyle(
                                  color: theme.grey,
                                  overflow: TextOverflow.ellipsis),
                            )),
                        leading: const Icon(Icons.telegram_rounded),
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: theme.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: theme.midGrey,
                          blurRadius: 2,
                          offset: const Offset(0, 0), // Shadow position
                        ),
                      ],
                    ),
                    child: Center(
                      child: ListTile(
                        title: const Text('Chat ID'),
                        trailing: SizedBox(
                            width: textWidth,
                            child: Text(
                              "${userData[fieldInfo.chatid]??"មិនមាន"}",
                              maxLines: 1,
                              style: TextStyle(
                                  color: theme.grey,
                                  overflow: TextOverflow.ellipsis),
                            )),
                        leading: const Icon(Icons.telegram_rounded),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(padding),
                    width: Get.width,
                    child: TextButton.icon(
                      onPressed: () {
                        reUse.reUseCircleDialog(
                            context: context,
                            function: 'logOut',
                            icon: Icons.logout_rounded,
                            title: 'Log out',
                            onTap: () async {
                              reUse.reUseWaitingDialog(context);
                              await glb.isLogOut();
                            },
                            content: Center(
                              child: Text(
                                'Are sure you want to log out?',
                                style: TextStyle(
                                  color: theme.black,
                                ),
                              ),
                            ));
                      },
                      icon: const Icon(Icons.login_rounded),
                      label: const Text('Log Out'),
                      style: TextButton.styleFrom(
                        backgroundColor: theme.litestRed,
                        foregroundColor: theme.red,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List driverList = [];

  onFetchDriver() {
    DatabaseReference refs = FirebaseDatabase.instance.ref('Driver');
    refs.onValue.listen((event) {
      DataSnapshot latitude = event.snapshot.child('latitude');
      DataSnapshot longitude = event.snapshot.child('longitude');
      // Map driver = dataValues.value as Map;
      driverList.forEach((element) {
        element.latitude = latitude as double;
        element.longitude = longitude as double;
      });

      //
      // markerList.add(Marker(
      //   //add first marker
      //   markerId: MarkerId(showLocation.toString()),
      //   position: LatLng(312, 21313), //position of marker
      //   infoWindow: const InfoWindow(
      //     //popup info
      //     title: 'Marker Title First ',
      //     snippet: 'My Custom Subtitle',
      //   ),
      //   icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      // ));
    });
  }

  reUseCircleDialog({data, context, icon, title, content, function}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: -60.0,
                child: CircleAvatar(
                  radius: 60.0,
                  backgroundColor: theme.white,
                  child: Icon(
                    icon,
                    color: theme.orange,
                    size: 100.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    // Text(
                    //   content,
                    //   textAlign: TextAlign.center,
                    //   style: const TextStyle(
                    //     fontSize: 16.0,
                    //   ),
                    // ),
                    content,
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: reUseButton(text: "OK"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  var receivedID = '';
  bool otpFieldVisibility = false;
  String verificationId = '';
  String phoneNumber = "+855 78 344 511";
  String authStatus = "";
  String otp = "";

  Future<void> verifyUserPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        String smsCode = 'xxxx';
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);
        await auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  reUseButton({data, key, icon, text, backgroundColor, textColor}) {
    return SizedBox(
      width: Get.width,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
        ),
        onPressed: () async {
          FirebaseAuth.instance.signOut();
          Get.to(() => const LogInScreen());
          setState(() {});
        },
        child: Text(
          text,
          style: TextStyle(
              color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }

  List revenuePrice = [];
  List paidPrice = [];
  double revenue = 0.0;
  double paid = 0.0;

  totalRevenue() async {
    List mainData = [];
    try {
      DatabaseReference refs = await FirebaseDatabase.instance
          .ref('Complete')
          .child(auth.currentUser!.uid);
      refs.onValue.listen((event) async {
        revenuePrice.clear();
        paidPrice.clear();
        revenue = 0.0;
        paid = 0.0;
        DataSnapshot driver = await event.snapshot;
        Map values = driver.value as Map;
        values.forEach((key, value) async {
          mainData.add(value);
          if (value[field.paidStatus] == 'paid') {
            paidPrice.add(value);
          } else {
            revenuePrice.add(value);
          }
          setState(() {

          });
        });
        calculation(mainData);
      });
    } catch (e) {
      print('completeListLength $e');
    }
  }

  calculation(data) {
    for (int a = 0; a < data.length; a++) {
      if (data[a][field.paidStatus] == 'paid') {
        paid += double.parse(data[a][field.price]);
      } else {
        revenue += double.parse(data[a][field.price]);
      }
      setState(() {});
    }
  }
}
