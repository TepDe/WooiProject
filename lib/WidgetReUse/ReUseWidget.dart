import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/HomeScreen.dart';
import 'package:wooiproject/MapScreen.dart';
import 'package:wooiproject/ProfileScreen.dart';
import 'package:wooiproject/RenderListDetail.dart';
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

  unitOneHomeScreen({function, userID}) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, top: 20, right: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
            onTap: () async {},
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

  unitTwoHomeScreen({int? totalLength}) {
    return Container(
      width: Get.width,
      margin: EdgeInsets.only(top: 30, right: 10, left: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
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
                child: InkWell(
                  onTap: () {
                    Get.to(
                      RenderListDetail(),
                      arguments: 0,
                    );
                  },
                  child: unitTwoText(
                      label: "Total package",
                      qty: totalLength.toString() ?? '0',
                      assetsIconColor: theme.dirt,
                      assetsIcon: 'assets/images/box.png',
                      borderbottom: BorderSide(width: 1, color: theme.liteGrey),
                      borderright: BorderSide(width: 1, color: theme.liteGrey)),
                ),
              ),
              Flexible(
                child: InkWell(
                  onTap: () {
                    Get.to(
                      RenderListDetail(),
                      arguments: 1,
                    );
                  },
                  child: unitTwoText(
                      label: "Pending",
                      qty: '0',
                      assetsIcon: 'assets/images/process.png',
                      borderbottom: BorderSide(width: 1, color: theme.liteGrey),
                      borderleft: BorderSide(width: 1, color: theme.liteGrey)),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                  child: InkWell(
                onTap: () {
                  Get.to(
                    RenderListDetail(),
                    arguments: 2,
                  );
                },
                child: unitTwoText(
                    label: "Complete",
                    qty: '0',
                    assetsIcon: 'assets/images/check.png',
                    borderright: BorderSide(width: 1, color: theme.liteGrey),
                    bordertop: BorderSide(width: 1, color: theme.liteGrey),
                    assetsIconColor: theme.liteGreen),
              )),
              Flexible(
                  child: InkWell(
                onTap: () {
                  Get.to(
                    RenderListDetail(),
                    arguments: 3,
                  );
                },
                child: unitTwoText(
                    label: "Return Ship",
                    qty: '0',
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

  reUseHeader({headercolor, title, label}) {
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
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back)),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    title ?? '',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
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
                    controller: nameControl,
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

  reUseText({content, size, weight, color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text(
        content,
        maxLines: 2,
        style: TextStyle(
            fontSize: size ?? 12,
            color: color ?? theme.black,
            fontWeight: weight ?? FontWeight.normal),
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

  // final qtyBox = TextEditingController();
  final glb = GlobalController();

  reUseCustomizeButton(context) {
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
        // style: ButtonStyle(
        //   // overlayColor:
        //   //     MaterialStateColor.resolveWith((states) => Colors.white70),
        //
        // ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: reUseText(
                  content: 'Create Package',
                  weight: FontWeight.bold,
                  size: 18.0),
              // content: Text('Result is'),
              actions: [
                reuseTextField(
                    textIcon: Icons.phone,
                    label: 'Phone Number',
                    controller: phoneBox),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.remove)),
                    // Container(
                    //   width: 60,
                    //   margin: const EdgeInsets.symmetric(horizontal: 30),
                    //   child: TextField(
                    //     controller: qtyBox,
                    //     decoration: const InputDecoration(
                    //       //icon: Icon(textIcon ?? null),
                    //       // fillColor: theme.liteGrey,
                    //       border: OutlineInputBorder(),
                    //       //border: InputBorder.none,
                    //       hintStyle: TextStyle(fontSize: 12),
                    //       //filled: true,
                    //       hintText: 'Qty',
                    //     ),
                    //   ),
                    // ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                  ],
                ),
                reuseTextField(
                    controller: locationBox,
                    label: 'Location',
                    textIcon: Icons.location_on),
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

  reuseTextField({label, controller, textIcon}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller ?? dialogPhoneNum,
        decoration: InputDecoration(
          icon: Icon(textIcon ?? null),
          // fillColor: theme.liteGrey,
          border: OutlineInputBorder(),
          //border: InputBorder.none,

          hintStyle: TextStyle(fontSize: 12),
          //filled: true,
          hintText: '$label',
        ),
      ),
    );
  }

  reUseListPackage(
      {Title, headerColor, removeFoot, List? pakageTotal, showList}) {
    return Column(
      children: [
        reUseHeader(title: Title, label: 'Search', headercolor: headerColor),
        if (pakageTotal == null)
          const Flexible(child: Center(child: Text('No Package')))
        else if (showList == false)
          const Flexible(child: Center(child: CircularProgressIndicator()))
        else
          reTotalPackageListview(removeStatus: removeFoot, pkc: pakageTotal)
      ],
    );
  }

  reTotalPackageListview({removeStatus, List? pkc}) {
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
                          color: theme.Blue,
                          content: '000214'),
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
                  removeStatus == true
                      ? Container()
                      : Divider(
                          color: theme.grey,
                        ),
                  removeStatus == true
                      ? Container()
                      : Row(
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

  reUseNotificationBox() {
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
                      reUseText(content: ' 000123', weight: FontWeight.bold),
                    ],
                  ),
                  reUseText(content: '24/05/2023 03:36 PM'),
                ],
              ),
            ],
          ),
          reUseStatusBox()
        ],
      ),
    );
  }

  reUseStatusBox({accentcolor}) {
    return Container(
      margin: EdgeInsets.all(6),
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: theme.liteGreen,
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
          content: 'Complete', color: theme.white, weight: FontWeight.w500),
    );
  }
}
