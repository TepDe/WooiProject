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
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/HomeScreen.dart';
import 'package:wooiproject/MapScreen.dart';
import 'package:wooiproject/PendingScreen.dart';
import 'package:wooiproject/ProfileScreen.dart';
import 'package:wooiproject/RenderListDetail.dart';
import 'package:wooiproject/ReturnScreen.dart';
import 'package:wooiproject/TotalPackageScreen.dart';
import 'package:wooiproject/ViewScreen.dart';
import 'package:wooiproject/WidgetReUse/SuperController.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';

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
                    Get.to(ViewScreen());
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

  unitOneHomeScreen({function, userID, context}) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, top: 20, right: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                'Good Morning',
                style: TextStyle(
                    color: theme.darkGrey, fontWeight: FontWeight.bold),
              ),
              reUseText(
                  size: 20.0,
                  color: theme.black,
                  weight: FontWeight.bold,
                  content: userID ?? 'no ID'),
            ],
          ),
          InkWell(
            onTap: () async {
              reUseCircleDialog(context: context);
            },
            child: Icon(
              Icons.account_circle,
              size: 60,
            ),
          )
        ],
      ),
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

  unitTwoHomeScreen(
      {pendingData,
      int? totalLength,
      List? totalPackageData,
      int? pendingLength,
      int? completeLength,
      List? completeData,
      int? returnLength,
      List? returnData,
      context}) {
    return Container(
      width: Get.width,
      margin: const EdgeInsets.only(top: 30, right: 10, left: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
                    Get.to(const TotalPackageScreen(),
                        arguments: totalPackageData);
                  },
                  child: unitTwoText(
                      label: "Total package",
                      qty: totalLength.toString(),
                      assetsIconColor: theme.dirt,
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
                      label: "Pending",
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
                        label: 'Complete',
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
                        label: "Return Ship",
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
      padding: EdgeInsets.all(9),
      //margin: EdgeInsets.all(9),
      decoration: BoxDecoration(
        border: Border(
          bottom:
              borderbottom ?? BorderSide(width: 1.5, color: Colors.transparent),
          right:
              borderright ?? BorderSide(width: 1.5, color: Colors.transparent),
          left: borderleft ?? BorderSide(width: 1.5, color: Colors.transparent),
          top: bordertop ?? BorderSide(width: 1.5, color: Colors.transparent),
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
                      color: theme.darkGrey),
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
              BoxShadow(
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
            decoration: InputDecoration(
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
            decoration: InputDecoration(
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
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    splashRadius: 25,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ViewScreen(),
                        ),
                      );
                      //Get.back();
                    },
                    icon: Icon(Icons.arrow_back)),
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
                  child: TextField(
                    controller: searchcontroll,
                    decoration: InputDecoration(
                      filled: true,
                      hintStyle: TextStyle(fontSize: 12),
                      fillColor: theme.white,
                      hintText: 'Search ID or Phone number',
                      border: OutlineInputBorder(
                          // borderSide:
                          //      BorderSide(color:theme.minGrey ,width: 0.0),
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none),
                      // contentPadding:
                      // EdgeInsets.only(left: 14.0, bottom: 12.0, top: 12.0),
                      // focusedBorder: OutlineInputBorder(
                      //   borderSide: BorderSide(color: Colors.white),
                      //   borderRadius: BorderRadius.circular(25.7),
                      // ),
                      // enabledBorder: UnderlineInputBorder(
                      //   borderSide: BorderSide(color: Colors.red),
                      //   borderRadius: BorderRadius.circular(25.7),
                      // ),
                    ),
                  ),
                ),
              ),
              Flexible(
                  flex: 1,
                  child: CircleAvatar(
                    backgroundColor: theme.litestOrange,
                    radius: 25,
                    child: IconButton(
                        splashRadius: 20,
                        onPressed: () {},
                        icon: Icon(
                          Icons.search,
                          color: theme.orange,
                        )),
                  ))
            ],
          )
          // reUseListview()
        ],
      ),
    );
  }

  reUseTopHeader({headercolor, title, label, titleColor}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                IconButton(
                    splashRadius: 25,
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back)),
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
      content,
      maxLines: 2,
      style: TextStyle(
          fontSize: size ?? 12,
          color: color ?? theme.black,
          fontWeight: weight ?? FontWeight.normal),
    );
  }

  reUseTextNote({content, size, weight, color}) {
    return Text(
      content,
      maxLines: 5,
      style: TextStyle(
          fontSize: size ?? 12,
          color: color ?? theme.black,
          fontWeight: weight ?? FontWeight.normal),
    );
  }

  reSetUseText({content, size, weight, color, title, titleColor}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(1),
          child: Text(
            title,
            softWrap: true,
            maxLines: 2,
            style: TextStyle(
                fontSize: 11,
                color: titleColor ?? theme.black,
                fontWeight: weight ?? FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(1),
          child: Text(
            content,
            softWrap: true,
            maxLines: 2,
            style: TextStyle(
                fontSize: size ?? 12,
                color: color ?? theme.black,
                fontWeight: weight ?? FontWeight.normal),
          ),
        ),
      ],
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

  ruTextBox({hind, icon, controller, obscureText}) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 3, bottom: 3),
      decoration: BoxDecoration(
          color: theme.liteGrey, borderRadius: BorderRadius.circular(9)),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          //<-- SEE HERE
          fillColor: theme.liteGrey,
          //iconColor: theme.grey,
          //enabled: true,
          //focusColor: Colors.grey,
          //prefix: Icon(Icons.phone),
          border: InputBorder.none,
          icon: icon,
          hintText: hind,
        ),
      ),
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

  reUseCreatePackage({context}) {
    return Container(
      width: Get.width,
      height: 50,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.litestOrange,
        borderRadius: BorderRadius.circular(6),
        // boxShadow: [
        //   BoxShadow(
        //     color: theme.grey,
        //     blurRadius: 4,
        //     offset: Offset(0, 1), // Shadow position
        //   ),
        // ],
      ),
      child: TextButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreatePackageScreen(),
            ),
          );
          //Get.to(const CreatePackageScreen());
        },
        icon: Image.asset(
          'assets/images/box.png',
          height: 20,
          width: 20,
          color: theme.orange,
        ),
        label: Text(
          'Create',
          style: TextStyle(
            color: theme.orange,
          ),
        ),
      ),
    );
  }

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
    return Flexible(
      child: Container(
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
                  child: Text('Cancel')),
              ElevatedButton(
                  onPressed: () async {
                    final glb = GlobalController();
                    await glb
                        .requestPackage(
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
                  child: Text('OK')),
            ],
          )
        ],
      ),
    );
  }

  reuseTextField({label, controller, textIcon, inputType}) {
    return TextField(
      controller: controller ?? dialogPhoneNum,
      keyboardType: inputType,
      decoration: InputDecoration(
        //icon: Icon(textIcon ?? null),
        // fillColor: theme.liteGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        //border: InputBorder.none,

        hintStyle: TextStyle(fontSize: 12),
        //filled: true,
        //hintText: '$label',
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
            border: OutlineInputBorder(),
            hintStyle: TextStyle(fontSize: 10),
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
                          offset: Offset(0, 1), // Shadow position
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
                            reSetUseText(
                                titleColor: theme.grey,
                                title: 'Destination',
                                size: 14.0,
                                color: theme.black,
                                content: pkc[index]['location'],
                                weight: FontWeight.w500),
                            reSetUseText(
                                titleColor: theme.grey,
                                title: 'Phone number',
                                size: 14.0,
                                color: theme.black,
                                content: pkc[index]['phoneNumber'],
                                weight: FontWeight.w500),
                            reSetUseText(
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
    );
  }

  reCompletePackageListview({removeStatus, List? pkc}) {
    return Flexible(
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: pkc!.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: Get.width,
              margin: EdgeInsets.all(6),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.liteGrey,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: theme.grey,
                    blurRadius: 4,
                    offset: Offset(0, 1), // Shadow position
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
                          content: 'PK000214'),
                    ],
                  ),
                  Row(
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
                  Row(
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
                  Divider(
                    height: 1,
                    color: theme.grey,
                  ),
                  Row(
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
                ],
              ),
            );
          }),
    );
  }

  reUsePendingList({removeStatus, List? pkc}) {
    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  itemCount: pkc!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: Get.width,
                      margin: EdgeInsets.all(6),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.liteGrey,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: theme.grey,
                            blurRadius: 4,
                            offset: Offset(0, 1), // Shadow position
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
                                  content: 'pkc[index][' 'packageID' ']'),
                            ],
                          ),
                          Row(
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
                          Row(
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
                          Row(
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
                          color: theme.grey,
                          blurRadius: 4,
                          offset: Offset(0, 1), // Shadow position
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
                                // reUseText(
                                //     weight: FontWeight.bold,
                                //     size: 16.0,
                                //     color: theme.blue,
                                //     content: pkc[index]['packageID']),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // reSetUseText(
                            //     titleColor: theme.grey,
                            //     title: 'Destination',
                            //     size: 14.0,
                            //     color: theme.black,
                            //     content: pkc[index]['location'],
                            //     weight: FontWeight.w500),
                            reSetUseText(
                                titleColor: theme.grey,
                                title: 'Phone number',
                                size: 14.0,
                                color: theme.black,
                                content: pkc[index]['phoneNumber'],
                                weight: FontWeight.w500),
                            reSetUseText(
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
                            // reUseText(
                            //     weight: FontWeight.bold,
                            //     size: 18.0,
                            //     color: theme.blue,
                            //     content: pkc[index]['price']),
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
                            // Flexible(
                            //   child: Container(
                            //     width: Get.width,
                            //     margin: const EdgeInsets.all(8.0),
                            //     padding: const EdgeInsets.all(8.0),
                            //     decoration: BoxDecoration(
                            //         border: Border.all(color: theme.grey)),
                            //     child: reUseTextNote(
                            //         weight: FontWeight.w400,
                            //         size: 14.0,
                            //         color: theme.grey,
                            //         content: pkc[index]['note']),
                            //   ),
                            // ),
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
    );
  }

  reUseUpdateStatusList({List? data}) {
    return Flexible(
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: data!.length,
          itemBuilder: (BuildContext context, int index) {
            return reUseNotificationBox(
                value: data[index], status: data[index]['status']);
          }),
    );
  }

  reUseNotificationBox({value, status}) {
    return Container(
      margin: EdgeInsets.all(6),
      padding: EdgeInsets.all(6),
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
                margin: EdgeInsets.only(left: 6, right: 16),
                height: 60,
                width: 3,
                color: theme.liteGreen,
              ),
              Container(
                margin: EdgeInsets.only(left: 0, right: 16),
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
      margin: EdgeInsets.all(6),
      padding: EdgeInsets.all(6),
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

  reUseCircleDialog({context, icon, title, content}) {
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
                padding: EdgeInsets.only(top: 80.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      content,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: reUseCustomizeButton(
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
}
