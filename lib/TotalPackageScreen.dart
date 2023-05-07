import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';

import 'WidgetReUse/ReUseWidget.dart';
import 'WidgetReUse/Themes.dart';

class TotalPackageScreen extends StatefulWidget {
  const TotalPackageScreen({Key? key}) : super(key: key);

  @override
  State<TotalPackageScreen> createState() => _TotalPackageScreenState();
}

class _TotalPackageScreenState extends State<TotalPackageScreen> {
  final reUse = ReUseWidget();
  final theme = ThemesApp();
  var argumentData = Get.arguments;
  List totalList = [];
  List keyList = [];
  List forDisplay = [];
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isShow = false;

  // totalListLength() async {
  //   DatabaseReference refs = FirebaseDatabase.instance
  //       .ref('PackageRequest')
  //       .child(auth.currentUser!.uid);
  //   refs.onValue.listen((event) async {
  //     driverList.clear();
  //     DataSnapshot driver = event.snapshot;
  //     Map values = driver.value as Map;
  //     values.forEach((key, values) {
  //       Map data = values as Map;
  //       data.forEach((key, value) async {
  //         setState(() {
  //           driverList.add(value);
  //         });
  //         isShow = true;
  //       });
  //     });
  //   });
  // }

  _TotalPackageScreenState() {
    totalList = argumentData[0]['data'];
    forDisplay = totalList;
    keyList = argumentData[1]['key'];
    totalListLength();
  }

  totalListLength() async {
    try {
      DatabaseReference refs = FirebaseDatabase.instance
          .ref('PackageRequest')
          .child(auth.currentUser!.uid);
      refs.onValue.listen((event) {
        setState(() {});
        totalList.clear();
        DataSnapshot driver = event.snapshot;
        Map values = driver.value as Map;
        values.forEach((key, values) async {
          Map data = await values as Map;
          data.forEach((key, value) async {
            setState(() {
              totalList.add(value);
              forDisplay = totalList;
            });
          });
        });
      });
    } catch (e) {
      print('totalListLength $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //totalListLength();
  }

  final search = TextEditingController();
  final glb = GlobalController();
  double padding = 8.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                              padding: EdgeInsets.only(left: 18.0),
                              child: Text(
                                'Package',
                                style: TextStyle(
                                    fontSize: 18,
                                    // color: titleColor,
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
                                controller: search,
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
                                    onPressed: () {
                                      search.clear();
                                      //packageList!.clear(),
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      forDisplay = totalList;
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: theme.blue,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.grey,
                                  blurRadius: 3,
                                  offset: const Offset(0, 0), // Shadow position
                                ),
                              ],
                            ),
                            child: IconButton(
                                splashRadius: 20,
                                onPressed: () {
                                  List results = totalList
                                      .where((user) => user['packageID']
                                          .toLowerCase()
                                          .contains(search.text
                                              .toString()
                                              .toLowerCase()))
                                      .toList();
                                  if (results == null || results.isEmpty)
                                    results = totalList
                                        .where((user) => user['phoneNumber']
                                            .toLowerCase()
                                            .contains(search.text
                                                .toString()
                                                .toLowerCase()))
                                        .toList();
                                  forDisplay = results;
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.search,
                                  color: theme.white,
                                )),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          reUse.reUseText(
                              content: 'Total : ${forDisplay.length}'),
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
                ),
                Flexible(
                  child: Scrollbar(
                    thickness: 6,
                    radius: const Radius.circular(10),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(8),
                            itemCount: forDisplay.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                width: Get.width,
                                margin: const EdgeInsets.all(6),
                                padding:
                                    EdgeInsets.symmetric(horizontal: padding),
                                decoration: BoxDecoration(
                                  color: theme.liteGrey,
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.grey,
                                      blurRadius: 4,
                                      offset:
                                          const Offset(0, 0), // Shadow position
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          reUse.reUseText(
                                              weight: FontWeight.w400,
                                              size: 12.0,
                                              color: theme.grey,
                                              content: 'SHIPPING ID :'),
                                          Row(
                                            children: [
                                              reUse.reUseText(
                                                  weight: FontWeight.bold,
                                                  size: 16.0,
                                                  color: theme.blue,
                                                  content: (forDisplay[index]
                                                          ['packageID'])
                                                      .toString()),
                                              if (forDisplay[index]['status'] ==
                                                  'pending')
                                                Container()
                                              else
                                                SizedBox(
                                                  height: 40,
                                                  width: 40,
                                                  child: PopupMenuButton<int>(
                                                    onSelected: (item) async {
                                                      if (item == 0) {
                                                      } else {
                                                        alertDialog();
                                                        removeItem(
                                                            keyIndex:
                                                                keyList[index],
                                                            listIndex:
                                                                forDisplay[
                                                                    index]);
                                                        Get.back();
                                                      }
                                                    },
                                                    itemBuilder: (context) => [
                                                      const PopupMenuItem<int>(
                                                          value: 0,
                                                          child: Text('Edit')),
                                                      const PopupMenuItem<int>(
                                                          value: 1,
                                                          child:
                                                              Text('Delete')),
                                                    ],
                                                  ),
                                                )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: theme.grey,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        reUse.reUseColumnText(
                                            titleColor: theme.grey,
                                            title: 'Destination',
                                            size: 14.0,
                                            color: theme.black,
                                            content: forDisplay[index]
                                                ['location'],
                                            weight: FontWeight.w500),
                                        reUse.reUseColumnText(
                                            titleColor: theme.grey,
                                            title: 'Phone number',
                                            size: 14.0,
                                            color: theme.black,
                                            content: forDisplay[index]
                                                ['phoneNumber'],
                                            weight: FontWeight.w500),
                                        reUse.reUseColumnText(
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
                                        reUse.reUseColumnText(
                                            titleColor: theme.grey,
                                            title: 'Weight',
                                            size: 14.0,
                                            color: theme.black,
                                            content:
                                                "1 KG",
                                            weight: FontWeight.w500),
                                        reUse.reUseColumnText(
                                            titleColor: theme.grey,
                                            title: 'Price',
                                            size: 14.0,
                                            color: theme.black,
                                            content:
                                                "${forDisplay[index]['price']} \$",
                                            weight: FontWeight.w500),
                                      ],
                                    ),
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: padding),
                                            child: reUse.reUseText(
                                                weight: FontWeight.bold,
                                                size: 12.0,
                                                color: theme.darkGrey,
                                                content: 'Note :'),
                                          ),
                                          Flexible(
                                            child: Container(
                                              padding: EdgeInsets.all(padding),
                                              width: Get.width,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: theme.minGrey)),
                                              child: reUse.reUseTextNote(
                                                  weight: FontWeight.w400,
                                                  size: 14.0,
                                                  color: theme.grey,
                                                  content: forDisplay[index]['note'] ?? 'No note'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(padding),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              reUse.reUseText(
                                                  weight: FontWeight.w400,
                                                  size: 12.0,
                                                  color: theme.grey,
                                                  content: 'Date : '),
                                              reUse.reUseText(
                                                  weight: FontWeight.w400,
                                                  size: 12.0,
                                                  color: theme.black,
                                                  content: forDisplay[index]
                                                      ['date']),
                                            ],
                                          ),
                                          if (forDisplay[index]['status'] ==
                                              'pending')
                                            Container(
                                              decoration: BoxDecoration(
                                                color: theme.litestOrange,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                              child: reUse.reUseText(
                                                  weight: FontWeight.bold,
                                                  size: 10.0,
                                                  color: theme.orange,
                                                  content: forDisplay[index]
                                                          ['status']
                                                      .toString()
                                                      .toUpperCase()),
                                            )
                                          else if (forDisplay[index]
                                                  ['status'] ==
                                              'complete')
                                            Container(
                                              decoration: BoxDecoration(
                                                color: theme.litestGreen,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                              child: reUse.reUseText(
                                                  weight: FontWeight.bold,
                                                  size: 10.0,
                                                  color: theme.liteGreen,
                                                  content: forDisplay[index]
                                                          ['status']
                                                      .toString()
                                                      .toUpperCase()),
                                            )
                                          else if (forDisplay[index]
                                                  ['status'] ==
                                              'return')
                                            Container(
                                              decoration: BoxDecoration(
                                                color: theme.litestRed,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                              child: reUse.reUseText(
                                                  weight: FontWeight.bold,
                                                  size: 10.0,
                                                  color: theme.liteRed,
                                                  content: forDisplay[index]
                                                          ['status']
                                                      .toString()
                                                      .toUpperCase()),
                                            )
                                          else
                                            Container(
                                              decoration: BoxDecoration(
                                                //color: theme.litestRed,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                              child: reUse.reUseText(
                                                  weight: FontWeight.bold,
                                                  size: 10.0,
                                                  color: theme.dirt,
                                                  content: forDisplay[index]
                                                          ['status']
                                                      .toString()
                                                      .toUpperCase()),
                                            )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                // isShow == true
                //     ? driverList == []
                //         ? Flexible(child: Center(child: Text('No Package')))
                //         : reUse.reTotalPackageListview(pkc: driverList)
                //     : const Flexible(
                //         child: Center(
                //             child: SizedBox(
                //                 height: 50,
                //                 width: 50,
                //                 child: CircularProgressIndicator()))),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: reUse.reUseCreatePackage(context: context),
          )
        ],
      ),
    ));
  }

  alertDialog() {
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

  removeItem({keyIndex, listIndex}) async {
    DatabaseReference packageRequest =
        FirebaseDatabase.instance.ref("PackageRequest");
    await packageRequest
        .child(auth.currentUser!.uid)
        .child('package')
        .child(keyIndex)
        .remove();
    print(keyIndex);
    print(listIndex);
    totalList.removeWhere((item) => item == listIndex);
    keyList.removeWhere((item) => item == keyIndex);
    forDisplay = totalList;
    setState(() {});
  }
}
