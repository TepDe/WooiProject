import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wooiproject/CompleteScreen.dart';
import 'package:wooiproject/CreatePackageScreen.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/HomeScreen.dart';
import 'package:wooiproject/LoginScreen.dart';
import 'package:wooiproject/MapScreen.dart';
import 'package:wooiproject/PaidScreen.dart';
import 'package:wooiproject/PendingScreen.dart';
import 'package:wooiproject/ProfileScreen.dart';
import 'package:wooiproject/RenderListDetail.dart';
import 'package:wooiproject/ReturnScreen.dart';
import 'package:wooiproject/RevenueList.dart';
import 'package:wooiproject/TotalPackageScreen.dart';
import 'package:wooiproject/ViewScreen.dart';
import 'package:wooiproject/WidgetReUse/SuperController.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';
import 'package:flutter/services.dart';

class ReUseWidget {
  topButtonLeft({function, icon}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.yellow,
          ),
          child: Center(
            child: IconButton(
                splashColor: Colors.grey,
                color: Colors.black,
                onPressed: () {
                  if (function == 'home') {
                    Get.to(const ViewScreen());
                  }
                },
                icon: Icon(icon)),
          ),
        ),
      ),
    );
  }

  final msc = Get.put(MapScreenController());
  late GoogleMapController mapController;
  final theme = ThemesApp();

  topButtonRight({function, icon}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.yellow,
          ),
          child: IconButton(
              splashColor: Colors.grey,
              color: Colors.black,
              onPressed: () {
                if (function == 'crlocation') {
                  msc.request();
                  msc.moveCamera();
                }
              },
              icon: Icon(icon)),
        ),
      ),
    );
  }

  topBarHomeScreen() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          // IconButton(
          //     iconSize: 40,
          //     splashRadius: 30,
          //     onPressed: () {},
          //     icon: Center(
          //       child: Icon(
          //         Icons.menu,
          //         color: theme.deepOrange,
          //       ),
          //     )),
          // Align(
          //     alignment: Alignment.topCenter,
          //     child: Image.asset(
          //       'assets/images/WooiIcon.png',
          //       height: 100,
          //       width: 100,
          //     )),
          SizedBox(
            height: 0,
            width: 0,
          )
        ],
      ),
    );
  }

  unitOneHomeScreen({getTime, function, String? userID, context}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              getTime,
              style: TextStyle(color: theme.black, fontWeight: FontWeight.bold),
            ),
            reUseText(
                size: 20.0,
                color: theme.black,
                weight: FontWeight.bold,
                content: userID ?? 'loading'),
          ],
        ),
        const Icon(Icons.account_circle, size: 60, color: Colors.transparent)
      ],
    );
  }

  reUseTopBar({name, context}) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
                color: theme.deepOrange,
                fontSize: 28,
                fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Your activity will record down here",
                  style: TextStyle(
                      color: theme.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "15",
                  style: TextStyle(
                      color: theme.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
              reUseSquareButton(icon: Icons.filter_alt_rounded),
            ],
          ),
          Divider(
            color: theme.grey,
          ),
        ],
      ),
    );
  }

  // reUseSquareButton({icon}) {
  //   return Material(
  //     color: Colors.transparent,
  //     child: InkWell(
  //       onTap: () {},
  //       splashColor: Colors.red,
  //       child: Container(
  //         height: 50,
  //         width: 50,
  //         decoration: BoxDecoration(
  //           color: theme.litestOrange,
  //           borderRadius: BorderRadius.circular(10),
  //           // boxShadow: [
  //           //   BoxShadow(
  //           //     color: Colors.grey,
  //           //     blurRadius: 1,
  //           //     //offset: Offset(4, 8), // Shadow position
  //           //   ),
  //           // ],
  //         ),
  //         child: InkWell(
  //           onTap: () {},
  //           child: Icon(
  //             icon ?? null,
  //             color: theme.orange,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  reUseSquareButton({icon}) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          onTap: () {
            print("tapped");
          },
          child: Icon(
            icon ?? null,
            color: theme.orange,
          ),
        ),
      ),
      color: theme.litestOrange,
    );
  }

  final clsLan = ClsLanguage();

  unitTwoHomeScreen(
      {int? totalLength,
      List? totalPackageData,
      List? totalPackageDataKey,
      int? pendingLength,
      List? pendingData,
      int? completeLength,
      List? completeData,
      int? returnLength,
      List? returnData,
      context}) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1,
            //offset: Offset(4, 8), // Shadow position
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => const TotalPackageScreen(),
                    //   ),
                    // );
                    Get.to(const TotalPackageScreen(), arguments: [
                      {'data': totalPackageData},
                      {'key': totalPackageDataKey}
                    ]);
                  },
                  child: unitTwoText(
                      label: clsLan.totalPackage,
                      qty: totalLength.toString(),
                      assetsIconColor: theme.deepPumpkin,
                      assetsIcon: 'assets/images/box.png',
                      borderbottom: BorderSide(width: 1, color: theme.liteGrey),
                      borderright: BorderSide(width: 1, color: theme.liteGrey)),
                ),
              ),
              Flexible(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    Get.to(const PendingScreen(), arguments: pendingData);
                  },
                  child: unitTwoText(
                      label: clsLan.pending,
                      qty: pendingLength.toString(),
                      assetsIcon: 'assets/images/delivery_man.png',
                      borderbottom: BorderSide(width: 1, color: theme.liteGrey),
                      borderleft: BorderSide(width: 1, color: theme.liteGrey)),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      Get.to(
                        const CompleteScreen(),
                        arguments: completeData,
                      );
                    },
                    child: unitTwoText(
                        label: clsLan.complete,
                        qty: completeLength.toString(),
                        assetsIcon: 'assets/images/check.png',
                        borderright:
                            BorderSide(width: 1, color: theme.liteGrey),
                        bordertop: BorderSide(width: 1, color: theme.liteGrey),
                        assetsIconColor: theme.liteGreen),
                  )),
              Flexible(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      Get.to(
                        const ReturnScreen(),
                        arguments: returnData,
                      );
                    },
                    child: unitTwoText(
                        label: clsLan.returns,
                        qty: returnLength.toString(),
                        assetsIcon: 'assets/images/return-box.png',
                        bordertop: BorderSide(width: 1, color: theme.liteGrey),
                        borderleft: BorderSide(width: 1, color: theme.liteGrey),
                        assetsIconColor: theme.liteRed),
                  )),
            ],
          )
        ],
      ),
    );
  }

  unitTwoText({
    label,
    qty,
    assetsIcon,
    assetsIconColor,
    borderbottom,
    borderright,
    borderleft,
    bordertop,
  }) {
    return Container(
      width: Get.width,
      height: 100,
      padding: const EdgeInsets.all(9),
      //margin: EdgeInsets.all(9),
      decoration: BoxDecoration(
        border: Border(
          bottom: borderbottom ??
              const BorderSide(width: 1.5, color: Colors.transparent),
          right: borderright ??
              const BorderSide(width: 1.5, color: Colors.transparent),
          left: borderleft ??
              const BorderSide(width: 1.5, color: Colors.transparent),
          top: bordertop ??
              const BorderSide(width: 1.5, color: Colors.transparent),
        ),
        // color: theme.white,
        // borderRadius: BorderRadius.circular(10),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey,
        //     blurRadius: 1,
        //     //offset: Offset(4, 8), // Shadow position
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label',
            style: TextStyle(
                fontSize: 12, color: theme.grey, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                assetsIcon ?? null,
                height: 30,
                width: 30,
                color: assetsIconColor ?? theme.orange,
              ),
              Row(
                children: [
                  // Text('$qty',
                  //     overflow: TextOverflow.ellipsis,
                  //     style: TextStyle(
                  //         fontSize: 25,
                  //         color: theme.black,
                  //         fontWeight: FontWeight.bold)
                  // ),
                  reUseText(
                      content: '$qty',
                      size: 24.0,
                      weight: FontWeight.bold,
                      color: theme.black),
                  // Text('pc',
                  //     overflow: TextOverflow.ellipsis,
                  //     style: TextStyle(
                  //         fontSize: 10,
                  //         color: theme.minGrey,
                  //         fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  unitThreeHomeScreen(
      {icon, lable, price, funtion, context, latitude, longitude}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 18, right: 18),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.transparent,
        onTap: () {
          Get.to(MapScreen());
        },
        child: Container(
          decoration: BoxDecoration(
            color: theme.midGrey,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              const BoxShadow(
                color: Colors.grey,
                blurRadius: 2,
                //offset: Offset(4, 8), // Shadow position
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    icon,
                    size: 60,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(lable,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 15,
                                color: theme.black,
                                fontWeight: FontWeight.bold)),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(price,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 15,
                                color: theme.black,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  unitProfile() {
    return const Padding(
      padding: EdgeInsets.all(18.0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        leading: Icon(
          Icons.account_circle,
          size: 80,
        ),
        title: Center(
          child: Text(
            '',
          ),
        ),
        subtitle: Text(
          'Name',
        ),
        trailing: Icon(
          Icons.edit,
        ),
      ),
    );
  }

  signInForm() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: nameControl,
            decoration: const InputDecoration(
              fillColor: Colors.blue,
              border: OutlineInputBorder(),
              hintText: 'Name',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: phoneControl,
            decoration: const InputDecoration(
              fillColor: Colors.blue,
              border: OutlineInputBorder(),
              hintText: 'Phone Number',
            ),
          ),
        ),
        // reuseTextField(label: 'Phone Number'),
        reuseButton(label: 'Confirm', function: 'storeUserLogin')
      ],
    );
  }

  final nameControl = TextEditingController();
  final phoneControl = TextEditingController();
  final dialogPhoneNum = TextEditingController();

  reUseHeader(
      {TextEditingController? searchcontroll,
      headercolor,
      title,
      List? packageList,
      label,
      titleColor,
      context}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
          //color: headercolor,
          //borderRadius: BorderRadius.circular(6),
          // boxShadow: [
          //   BoxShadow(
          //     color: theme.grey,
          //     blurRadius: 4,
          //     offset: Offset(0, 1), // Shadow position
          //   ),
          // ],
          ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  // decoration: BoxDecoration(
                  //   color: theme.litestOrange,
                  //   borderRadius: BorderRadius.circular(60),
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: theme.minGrey,
                  //       blurRadius: 6,
                  //       offset: const Offset(0, 0), // Shadow position
                  //     ),
                  //   ],
                  // ),
                  child: IconButton(
                      splashRadius: 25,
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: theme.black,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Text(
                    title ?? '',
                    style: TextStyle(
                        fontSize: 18,
                        color: titleColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                      color: Colors.transparent,
                    )),
              ],
            ),
          ),
          Row(
            children: [
              Flexible(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: TextFormField(
                    autofocus: false,
                    controller: searchcontroll,
                    decoration: InputDecoration(
                      filled: true,
                      hintStyle: const TextStyle(fontSize: 12),

                      fillColor: theme.midGrey,
                      hintText: 'Search ID or Phone number',
                      border: OutlineInputBorder(
                        // borderSide:
                        //      BorderSide(color:theme.minGrey ,width: 0.0),
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        splashColor: Colors.transparent,
                        onPressed: () => {
                          searchcontroll!.clear(),
                          //packageList!.clear(),
                          FocusManager.instance.primaryFocus?.unfocus(),
                        },
                        icon: const Icon(Icons.close),
                      ),

                      // contentPadding:
                      // EdgeInsets.only(left: 14.0, bottom: 12.0, top: 12.0),
                      // focusedBorder: OutlineInputBorder(
                      //   borderSide: BorderSide(color: Colors.white),
                      //   borderRadius: BorderRadius.circular(25.7),
                      //
                      // ),
                      // enabledBorder: UnderlineInputBorder(
                      //   borderSide: BorderSide(color: Colors.red),
                      //   borderRadius: BorderRadius.circular(25.7),
                      // ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: theme.liteBlue,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: theme.minGrey,
                      blurRadius: 6,
                      offset: const Offset(0, 0), // Shadow position
                    ),
                  ],
                ),
                child: IconButton(
                    splashRadius: 20,
                    onPressed: () {
                      List results = packageList!
                          .where((user) => user['packageID']
                              .toLowerCase()
                              .contains(searchcontroll!.text
                                  .toString()
                                  .toLowerCase()))
                          .toList();
                      print(results);
                      print(results);
                    },
                    icon: Icon(
                      Icons.search,
                      color: theme.blue,
                    )),
              )
            ],
          ),
          Row(
            children: [
              reUseText(content: 'Total : '),
              const Flexible(child: Divider()),
              Container(
                decoration: BoxDecoration(
                  color: theme.litestOrange,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: IconButton(
                    splashRadius: 20,
                    onPressed: () {},
                    icon: Icon(
                      Icons.filter_alt_outlined,
                      color: theme.orange,
                    )),
              )
            ],
          )
        ],
      ),
    );
  }

  reUseTopHeader({headercolor, title, label, titleColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: headercolor,
        //borderRadius: BorderRadius.circular(6),
        // boxShadow: [
        //   BoxShadow(
        //     color: theme.grey,
        //     blurRadius: 4,
        //     offset: Offset(0, 1), // Shadow position
        //   ),
        // ],
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                IconButton(
                    splashRadius: 25,
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_outlined)),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    title ?? '',
                    style: TextStyle(
                        fontSize: 18,
                        color: titleColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  reUseText({content, size, weight, color}) {
    return Text(
      content ?? '',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: size ?? 12,
          color: color ?? theme.black,
          overflow: TextOverflow.ellipsis,
          fontWeight: weight ?? FontWeight.normal),
    );
  }

  reUseTextNote({content, size, weight, color}) {
    return Text(
      content ?? "",
      maxLines: 5,
      style: TextStyle(
          fontSize: size ?? 12,
          color: color ?? theme.black,
          fontWeight: weight ?? FontWeight.normal),
    );
  }

  reUseColumnText(
      {double? lableSize, content, size, weight, color, title, titleColor}) {
    return Flexible(
      child: SizedBox(
        width: Get.width,
        child: Column(
          children: [
            Text(
              title ?? "",
              softWrap: true,
              maxLines: 2,
              style: TextStyle(
                  fontSize: lableSize ?? 10.0,
                  color: titleColor ?? theme.black,
                  fontWeight: weight ?? FontWeight.normal),
            ),
            Text(
              content ?? "",
              softWrap: true,
              maxLines: 2,
              style: TextStyle(
                  fontSize: size ?? 12.0,
                  color: color ?? theme.black,
                  fontWeight: weight ?? FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  reUseRowText(
      {double? lableSize, content, size, weight, color, title, titleColor}) {
    return Flexible(
      child: SizedBox(
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                softWrap: true,
                maxLines: 2,
                style: TextStyle(
                    fontSize: lableSize ?? 10.0,
                    color: titleColor ?? theme.black,
                    fontWeight: weight ?? FontWeight.normal),
              ),
              Text(
                content,
                softWrap: true,
                maxLines: 2,
                style: TextStyle(
                    fontSize: size ?? 12.0,
                    color: color ?? theme.black,
                    fontWeight: weight ?? FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final gsc = Get.put(GlbSuperController());

  reuseButton({label, function}) {
    return Container(
      width: Get.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: theme.deepOrange),
        child: Text(
          "$label",
          style: const TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          if (function == 'storeUserLogin') {
            print('${nameControl.text} ${phoneControl.text}');
            gsc.storeUserLogin(
                name: nameControl.text, phone: phoneControl.text);
            // gsc.storeUserLogin(name: '',phone:'' );
          }
          if (function == 'requestDriver') {
            if (gsc.requestStatus == 'Request') {
              gsc.onRequestLocation();
              gsc.requestStatus.value = 'Cancel';
            } else if (gsc.requestStatus == 'Cancel') {
              gsc.removeRequest();
            }
          }
        },
      ),
    );
  }

  ruTextBox({hind, icon, controller, obscureText, keyboardType}) {
    return TextFormField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        disabledBorder: InputBorder.none,
        hintText: hind,
        filled: true,
        labelText: hind,
      ),
      obscureText: obscureText ?? false,
      controller: controller,
      // decoration: InputDecoration(
      //
      //   //<-- SEE HERE
      //
      //   //iconColor: theme.grey,
      //   //enabled: true,
      //   //focusColor: Colors.grey,
      //   //prefix: Icon(Icons.phone),
      //
      // ),
    );
  }

  renderListView() {
    return Expanded(
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: 12,
          itemBuilder: (BuildContext context, int index) {
            return reUseNotificationBox();
          }),
    );
  }

  final phoneBox = TextEditingController();
  final locationBox = TextEditingController();
  final qtyBox = TextEditingController();

  reUseCreatePackage({context, padding, height}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: Get.height * 0.06,
      width: Get.width,
      child: TextButton.icon(
        style: TextButton.styleFrom(backgroundColor: theme.litestOrange),
        onPressed: () async {
          try {
            final result = await InternetAddress.lookup('example.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              Get.to(CreatePackageScreen());
            }
          } on SocketException catch (_) {
            final reUse = ReUseWidget();
            reUse.reUseCircleDialog(
                function: 'nointernet',
                context: context,
                icon: Icons.wifi,
                title: 'Connection Lost',
                content: Center(
                  child: Text(
                    'No internet connection please try again',
                    style: TextStyle(
                      color: theme.black,
                    ),
                  ),
                ));
          }
          //Get.to(const CreatePackageScreen());
        },
        icon: Image.asset(
          'assets/images/box.png',
          height: 20,
          width: 20,
          color: theme.orange,
        ),
        label: Text(
          clsLan.create,
          style: TextStyle(
            color: theme.orange,
          ),
        ),
      ),
    );
  }

  final glb = GlobalController();

  reUseCustomizeButton(
      {isDispose,
      colorBC,
      isBcColor,
      icon,
      function,
      context,
      text,
      textcolor,
      showIcon,
      iconcolor,
      fontsize,
      value,
      weight}) {
    return Container(
      height: 40,
      width: Get.width,
      decoration: BoxDecoration(
        color: colorBC,
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
          onTap: () {
            if (function == 'minus') {
              Fluttertoast.showToast(
                msg: 'Maximum input is 9',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            } else if (function == 'add') {
              int qty = int.parse(value) + 1;
              print(qty);
            } else if (function == 'pincode') {
              glb.insertTelegramToken();
            } else if (function == 'token') {
              print(value);
              print(value);
              glb.insertTelegramToken(token: value);
            } else if (function == 'nointernet') {
              exit(0);
            } else if (function == 'logOut') {
              FirebaseAuth.instance.signOut();
              Get.to(const LogInScreen());
            } else {
              Get.back();
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showIcon == true
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        icon,
                        color: iconcolor,
                      ),
                    )
                  : Container(),
              Text(
                text ?? '',
                style: TextStyle(
                    fontSize: fontsize ?? 14,
                    color: textcolor ?? theme.black,
                    fontWeight: weight ?? FontWeight.normal),
              )
            ],
          ),
        ),
      ),
    );
  }

  reUseOKCancelDialog(context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: reUseText(
            content: 'Create Package', weight: FontWeight.bold, size: 18.0),
        // content: Text('Result is'),
        actions: [
          reUseText(content: 'Are you sure you want to delete this package'),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: () async {
                    await glb
                        .createPackage(
                            //qty: qtyBox.text.trim().toString(),
                            phoneNumber: phoneBox.text.trim().toString(),
                            location: locationBox.text.trim().toString())
                        .then((value) {
                      //qtyBox.clear();
                      phoneBox.clear();
                      locationBox.clear();
                    });

                    Navigator.pop(context);
                  },
                  child: const Text('OK')),
            ],
          )
        ],
      ),
    );
  }

  reuseTextField(
      {mixLength,
      prefixIcon,
      prefixIconColor,
      label,
      controller,
      textIcon,
      inputType,
      require,
      formater}) {
    return TextFormField(
      controller: controller ?? dialogPhoneNum,
      // keyboardType: inputType,
      maxLength: mixLength,
      keyboardType: inputType,
      inputFormatters: formater,
      // onChanged: (value) => doubleVar = double.parse(value),
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefixIcon ?? Icons.help_outline,
          color: prefixIconColor ?? Colors.transparent,
        ),
        //icon: Icon(textIcon ?? null),
        // fillColor: theme.liteGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        //border: InputBorder.none,

        hintStyle: const TextStyle(fontSize: 12),
      ),
    );
  }

  reUseRowTextFieldText(
      {mixLength,
      prefixIcon,
      prefixIconColor,
      label,
      controller,
      textIcon,
      inputType,
      require,
      textSize,
      suffixTap,
      formater}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: reUseText(
                content: label ?? "",
                size: textSize ?? 14.0,
                weight: FontWeight.w500,
                color: theme.black),
          ),
          TextFormField(
            controller: controller ?? dialogPhoneNum,
            // keyboardType: inputType,
            maxLength: mixLength,
            keyboardType: inputType,
            inputFormatters: formater,
            // onChanged: (value) => doubleVar = double.parse(value),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: suffixTap,
                icon: const Icon(Icons.close),
              ),
              prefixIcon: Icon(
                prefixIcon ?? Icons.help_outline,
                color: prefixIconColor ?? Colors.transparent,
              ),
              //icon: Icon(textIcon ?? null),
              // fillColor: theme.liteGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              //border: InputBorder.none,

              hintStyle: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  reUseTextField({label, controller, textIcon}) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextFormField(
          controller: controller ?? dialogPhoneNum,
          decoration: InputDecoration(
            //icon: Icon(textIcon ?? null),
            // fillColor: theme.liteGrey,
            //border: OutlineInputBorder(),
            //border: InputBorder.none,
            labelText: '$label',
            border: const OutlineInputBorder(),
            hintStyle: const TextStyle(fontSize: 10),
            suffixIcon: Icon(
              textIcon,
            ),
            //filled: true,
            //hintText: '$label',
          ),
        ));
  }

  // reUseListPackage(
  //     {Title, headerColor, removeFoot, List? pakageTotal, showList}) {
  //   print(pakageTotal);
  //   print(pakageTotal);
  //   return Column(
  //     children: [
  //       reUseHeader(title: Title, label: 'Search', headercolor: headerColor),
  //       if (pakageTotal == null)
  //         const Flexible(child: Center(child: Text('No Package')))
  //       else if (showList == false)
  //         const Flexible(child: Center(child: CircularProgressIndicator()))
  //       else
  //         reTotalPackageListview(removeStatus: removeFoot, pkc: pakageTotal)
  //     ],
  //   );
  // }

  reTotalPackageListview({removeStatus, List? pkc}) {
    return Expanded(
      child: Scrollbar(
        thickness: 6,
        radius: const Radius.circular(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  itemCount: pkc!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: Get.width,
                      margin: const EdgeInsets.all(6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.liteGrey,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: theme.grey,
                            blurRadius: 4,
                            offset: const Offset(0, 1), // Shadow position
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              reUseText(
                                  weight: FontWeight.w400,
                                  size: 12.0,
                                  color: theme.grey,
                                  content: 'SHIPPING ID :'),
                              Row(
                                children: [
                                  reUseText(
                                      weight: FontWeight.bold,
                                      size: 16.0,
                                      color: theme.blue,
                                      content: pkc[index]['packageID']),
                                  SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: PopupMenuButton<int>(
                                      onSelected: (item) => {},
                                      itemBuilder: (context) => [
                                        const PopupMenuItem<int>(
                                            value: 0, child: Text('Edit')),
                                        const PopupMenuItem<int>(
                                            value: 1, child: Text('Delete')),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            color: theme.grey,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              reUseColumnText(
                                  titleColor: theme.grey,
                                  title: 'Destination',
                                  size: 14.0,
                                  color: theme.black,
                                  content: pkc[index]['location'],
                                  weight: FontWeight.w500),
                              reUseColumnText(
                                  titleColor: theme.grey,
                                  title: 'Phone number',
                                  size: 14.0,
                                  color: theme.black,
                                  content: pkc[index]['phoneNumber'],
                                  weight: FontWeight.w500),
                              reUseColumnText(
                                  titleColor: theme.grey,
                                  title: 'Qty',
                                  size: 14.0,
                                  color: theme.black,
                                  content: '1',
                                  weight: FontWeight.w500),
                            ],
                          ),
                          Row(
                            children: [
                              reUseText(
                                  weight: FontWeight.bold,
                                  size: 12.0,
                                  color: theme.darkGrey,
                                  content: 'Price '),
                              reUseText(
                                  weight: FontWeight.bold,
                                  size: 18.0,
                                  color: theme.blue,
                                  content: pkc[index]['price']),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              reUseText(
                                  weight: FontWeight.bold,
                                  size: 12.0,
                                  color: theme.darkGrey,
                                  content: 'Note :'),
                              Flexible(
                                child: Container(
                                  width: Get.width,
                                  margin: const EdgeInsets.all(8.0),
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: theme.grey)),
                                  child: reUseTextNote(
                                      weight: FontWeight.w400,
                                      size: 14.0,
                                      color: theme.grey,
                                      content: pkc[index]['note']),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              reUseText(
                                  weight: FontWeight.w400,
                                  size: 12.0,
                                  color: theme.grey,
                                  content: 'Date : '),
                              reUseText(
                                  weight: FontWeight.w400,
                                  size: 12.0,
                                  color: theme.darkGrey,
                                  content: pkc[index]['date']),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  reCompletePackageListview({removeStatus, List? pkc}) {
    return Flexible(
      child: Scrollbar(
        thickness: 2,
        child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: pkc!.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: Get.width,
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.liteGrey,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: theme.minGrey,
                      blurRadius: 4,
                      offset: const Offset(0, 0), // Shadow position
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        reUseText(
                            weight: FontWeight.w400,
                            size: 12.0,
                            color: theme.grey,
                            content: 'SHIPPING ID :'),
                        reUseText(
                            weight: FontWeight.bold,
                            size: 16.0,
                            color: theme.blue,
                            content: pkc[index]['packageID']),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          reUseText(
                              weight: FontWeight.bold,
                              size: 12.0,
                              color: theme.grey,
                              content: 'Location'),
                          reUseText(
                              size: 12.0,
                              weight: FontWeight.bold,
                              color: theme.grey,
                              content: 'Phone number'),
                          reUseText(
                              size: 12.0,
                              weight: FontWeight.bold,
                              color: theme.grey,
                              content: 'Qty'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          reUseText(
                              size: 14.0,
                              color: theme.black,
                              content: pkc[index]['location'],
                              weight: FontWeight.w500),
                          reUseText(
                              size: 14.0,
                              color: theme.black,
                              weight: FontWeight.w500,
                              content: pkc[index]['phoneNumber']),
                          reUseText(
                              size: 14.0,
                              color: theme.black,
                              content: '1',
                              weight: FontWeight.w500),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Divider(
                        height: 1,
                        color: theme.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          reUseText(
                              size: 12.0,
                              weight: FontWeight.bold,
                              color: theme.grey,
                              content: 'Status'),
                          Container(
                            width: 100,
                            child: reUseText(
                                size: 12.0,
                                color: theme.liteGreen,
                                content: pkc[index]['status']
                                    .toString()
                                    .toUpperCase(),
                                weight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  double reUseReturnPadding = 2.0;

  reUsePendingList({removeStatus, List? pkc}) {
    print(pkc);
    print(pkc);
    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  itemCount: pkc!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: Get.width,
                      margin: const EdgeInsets.all(6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.liteGrey,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: theme.grey,
                            blurRadius: 4,
                            offset: const Offset(0, 1), // Shadow position
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(reUseReturnPadding),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                reUseText(
                                    weight: FontWeight.w400,
                                    size: 12.0,
                                    color: theme.grey,
                                    content: 'SHIPPING ID :'),
                                reUseText(
                                    weight: FontWeight.bold,
                                    size: 16.0,
                                    color: theme.blue,
                                    content:
                                        pkc[index]['packageID'] ?? 'No ID'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(reUseReturnPadding),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                reUseText(
                                    weight: FontWeight.bold,
                                    size: 12.0,
                                    color: theme.grey,
                                    content: 'Location'),
                                reUseText(
                                    size: 12.0,
                                    weight: FontWeight.bold,
                                    color: theme.grey,
                                    content: 'Phone number'),
                                reUseText(
                                    size: 12.0,
                                    weight: FontWeight.bold,
                                    color: theme.grey,
                                    content: 'Qty'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(reUseReturnPadding),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                reUseText(
                                    size: 14.0,
                                    color: theme.black,
                                    content: pkc[index]['location'],
                                    weight: FontWeight.w500),
                                reUseText(
                                    size: 14.0,
                                    color: theme.black,
                                    weight: FontWeight.w500,
                                    content: pkc[index]['phoneNumber']),
                                reUseText(
                                    size: 14.0,
                                    color: theme.black,
                                    content: '1',
                                    weight: FontWeight.w500),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(reUseReturnPadding),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                reUseText(
                                    size: 12.0,
                                    weight: FontWeight.bold,
                                    color: theme.grey,
                                    content: 'Status'),
                                reUseText(
                                    size: 12.0,
                                    color: theme.liteGreen,
                                    content: 'PENDING',
                                    weight: FontWeight.w900),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  reUseRerurnPackageList({returnData, List? pkc}) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                itemCount: pkc!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: Get.width,
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.liteGrey,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: theme.minGrey,
                          blurRadius: 4,
                          offset: const Offset(0, 0), // Shadow position
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            reUseText(
                                weight: FontWeight.w400,
                                size: 12.0,
                                color: theme.grey,
                                content: 'SHIPPING ID :'),
                            Row(
                              children: [
                                reUseText(
                                    weight: FontWeight.bold,
                                    size: 16.0,
                                    color: theme.blue,
                                    content:
                                        pkc[index]['packageID'] ?? "No ID"),
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: PopupMenuButton<int>(
                                    onSelected: (item) => {},
                                    itemBuilder: (context) => [
                                      const PopupMenuItem<int>(
                                          value: 0,
                                          child: Text('Return to request')),
                                      const PopupMenuItem<int>(
                                          value: 1, child: Text('Delete')),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          color: theme.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // reSetUseText(
                              //     titleColor: theme.grey,
                              //     title: 'Destination',
                              //     size: 14.0,
                              //     color: theme.black,
                              //     content: pkc[index]['location'],
                              //     weight: FontWeight.w500),
                              reUseColumnText(
                                  titleColor: theme.grey,
                                  title: 'Destination',
                                  size: 14.0,
                                  color: theme.black,
                                  content: pkc[index]['location'],
                                  weight: FontWeight.w500),
                              reUseColumnText(
                                  titleColor: theme.grey,
                                  title: 'Phone number',
                                  size: 14.0,
                                  color: theme.black,
                                  content: pkc[index]['phoneNumber'],
                                  weight: FontWeight.w500),
                              reUseColumnText(
                                  titleColor: theme.grey,
                                  title: 'Qty',
                                  size: 14.0,
                                  color: theme.black,
                                  content: '1',
                                  weight: FontWeight.w500),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Row(
                            children: [
                              reUseText(
                                  weight: FontWeight.bold,
                                  size: 12.0,
                                  color: theme.darkGrey,
                                  content: 'Price : '),
                              reUseText(
                                  weight: FontWeight.bold,
                                  size: 12.0,
                                  color: theme.blue,
                                  content: pkc[index]['price'] ?? "No price"),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            reUseText(
                                weight: FontWeight.bold,
                                size: 12.0,
                                color: theme.darkGrey,
                                content: 'Note :'),
                            Flexible(
                              child: Container(
                                width: Get.width,
                                margin: const EdgeInsets.all(8.0),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: theme.grey)),
                                child: reUseTextNote(
                                    weight: FontWeight.w400,
                                    size: 14.0,
                                    color: theme.grey,
                                    content: pkc[index]['note'] ?? "No reason"),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            reUseText(
                                weight: FontWeight.w400,
                                size: 12.0,
                                color: theme.grey,
                                content: 'Return Time : '),
                            reUseText(
                                weight: FontWeight.w400,
                                size: 12.0,
                                color: theme.darkGrey,
                                content: pkc[index]['date']),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  reUseUpdateStatusList({List? data}) {
    return Flexible(
      child: ListView.builder(
          itemCount: data!.length,
          itemBuilder: (BuildContext context, int index) {
            return reUseNotificationBox(
                value: data[index], status: data[index]['status']);
          }),
    );
  }

  reUseNotificationBox({value, status}) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: theme.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: theme.grey,
            blurRadius: 1,
            //offset: Offset(4, 8), // Shadow position
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 6, right: 16),
                height: 60,
                width: 3,
                color: theme.liteGreen,
              ),
              Container(
                margin: const EdgeInsets.only(left: 0, right: 16),
                child: Image.asset(
                  'assets/images/check.png',
                  height: 30,
                  width: 30,
                  color: theme.liteGreen,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      reUseText(
                        content: 'Your package ID',
                      ),
                      reUseText(content: '_', weight: FontWeight.bold),
                    ],
                  ),
                  reUseText(content: '${value['date']}'),
                ],
              ),
            ],
          ),
          reUseStatusBox(value: status)
        ],
      ),
    );
  }

  reUseStatusBox({color, value}) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: value == 'complete' ? theme.liteGreen : theme.liteRed,
        borderRadius: BorderRadius.circular(10),
        // boxShadow: [
        //   BoxShadow(
        //
        //     color: theme.liteGreen,
        //     blurRadius: 1,
        //     //offset: Offset(4, 8), // Shadow position
        //   ),
        // ],
      ),
      child: reUseText(
          content: value == 'complete' ? 'Complete' : 'Return',
          color: theme.white,
          weight: FontWeight.w500),
    );
  }

  reUseCircleDialog(
      {disposeAllow, data, context, icon, title, content, function}) {
    return showDialog(
      barrierDismissible: disposeAllow ?? true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          actions: [
            Stack(
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: Get.height * 0.08, left: 4, right: 4),
                      child: Text(
                        title ?? "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
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
                      child: reUseCustomizeButton(
                          value: data,
                          function: function,
                          textcolor: theme.orange,
                          weight: FontWeight.bold,
                          text: "OK",
                          fontsize: 16.0,
                          isBcColor: true,
                          colorBC: theme.litestOrange),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  reUseTextFormField(
      {TextEditingController? textController, prefixIcon, hintText}) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
      child: TextFormField(
        controller: textController,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: const Icon(
            Icons.search,
            color: Colors.transparent,
          ),
          filled: true,
          fillColor: theme.white,
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          ),
        ),
      ),
    );
  }

  final token = TextEditingController();

  reUseSettingItem(
      {data,
      function,
      title,
      trailingIcon,
      trailingIconColor,
      context,
      leading}) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
      child: Material(
        color: theme.white,
        child: InkWell(
          onTap: () {
            if (function == 'token') {
              showDialog(
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
                              Icons.telegram_rounded,
                              color: theme.orange,
                              size: 100.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 80.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'title',
                                textAlign: TextAlign.center,
                                style: TextStyle(
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
                              reUseTextFormField(
                                  hintText: 'your token',
                                  textController: token),
                              const SizedBox(height: 20.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: reUseCustomizeButton(
                                    value: token.text,
                                    function: function,
                                    textcolor: theme.orange,
                                    weight: FontWeight.bold,
                                    text: "OK",
                                    fontsize: 16.0,
                                    isBcColor: true,
                                    colorBC: theme.litestOrange),
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
          },
          child: Center(
            child: ListTile(
              title: title,
              trailing: trailingIcon,
              leading: leading,
            ),
          ),
        ),
      ),
    );
  }

  alertDialog(context) {
    return showDialog(
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
                    height: 40, width: 40, child: CircularProgressIndicator()),
              )
            ],
          ),
        );
      },
    );
  }

  reUseBoxText(
      {title,
      value,
      data,
      witchClick,
      assetImage,
      valueTextSize,
      labelTextSize,
      textColor,
      valueColor,
      backgroundColor}) {
    return Container(
      width: Get.width,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: theme.midGrey,
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(2, 2), // Shadow position
          ),
        ],
        // image: DecorationImage(
        //   image: AssetImage(assetImage??""),
        //   fit: BoxFit.cover,
        // ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            if (witchClick == "revenue") {
              Get.to(const RevenueList(), arguments: data);
            } else {
              Get.to(const PaidScreen(), arguments: data);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                reUseText(
                    content: title ?? "",
                    size: labelTextSize ?? 16.0,
                    weight: FontWeight.bold,
                    color: valueColor ?? theme.black),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                reUseText(
                    content: value ?? "",
                    size: valueTextSize ?? 24.0,
                    weight: FontWeight.bold,
                    color: textColor ?? theme.black),
              ],
            ),
          ),
        ),
      ),
    );
  }

  reUseEditProfile(context) {
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
                    Icons.telegram_rounded,
                    color: theme.orange,
                    size: 100.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 80.0, left: 15, right: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    reUseText(
                        content: clsLan.insertAbaDec,
                        color: theme.black,
                        weight: FontWeight.w400,
                        size: 14.0),
                    const SizedBox(height: 20.0),
                    // Text(
                    //   content,
                    //   textAlign: TextAlign.center,
                    //   style: const TextStyle(
                    //     fontSize: 16.0,
                    //   ),
                    // ),
                    Container(
                      height: 60,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
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
                      child: TextFormField(
                        //controller: abaCode,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.key_rounded),
                          suffixIcon: InkWell(
                            onTap: () {},
                            child: const Icon(
                              Icons.clear,
                              color: Colors.grey,
                            ),
                          ),
                          filled: true,
                          fillColor: theme.white,
                          hintText: clsLan.insertAbaDec,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Flexible(
                        child: Container(
                          height: 40,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: theme.litestOrange,
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
                            child: TextButton(
                              onPressed: () async {
                                // if (abaCode.text ==
                                //     userData[fieldInfo
                                //         .ABACode]) {
                                //   Get.back();
                                // } else {
                                //   await glb.insertABACode(
                                //       abaCode:
                                //       abaCode.text);
                                // }
                                // setState(() {});
                              },
                              child: Text(
                                clsLan.insert,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: theme.orange,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
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

  reUseColumnTextField(
      {hintText, controller, labelSize, label, VoidCallback? suffixTap}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: reUseText(
              content: label ?? "",
              size: labelSize ?? 14.0,
              weight: FontWeight.w500,
              color: theme.black),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            controller: controller,
            // keyboardType: inputType,
            //keyboardType: inputType,
            //inputFormatters: formater,
            onChanged: (value) {},
            decoration: InputDecoration(
              hintText: hintText ?? "",
              suffixIcon: IconButton(
                onPressed: suffixTap,
                icon: const Icon(Icons.close),
              ),
              //icon: Icon(textIcon ?? null),
              // fillColor: theme.liteGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              //border: InputBorder.none,
              hintStyle: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}
