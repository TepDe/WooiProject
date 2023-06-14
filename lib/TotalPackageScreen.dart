import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/EditPackageScreen.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/GlobalControl/clsField.dart';

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
  final clsLan = ClsLanguage();

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

  final field = FieldData();
  final fieldInfo = FieldInfo();

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
  double labelSize = 10.0;
  double textSize = 14.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/PackageHead.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  color: theme.deepPumpkin,
                                ),
                                label: Text(
                                  clsLan.totalPackage,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: theme.deepPumpkin,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 18.0),
                              //   child: Text(
                              //     clsLan.totalPackage,
                              //     style: TextStyle(
                              //         fontSize: 18,
                              //         color: theme.deepPumpkin,
                              //         fontWeight: FontWeight.bold),
                              //   ),
                              // ),
                              // IconButton(
                              //     onPressed: () {},
                              //     icon: const Icon(
                              //       Icons.search,
                              //       color: Colors.transparent,
                              //     )),
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
                                    hintStyle: const TextStyle(fontSize: 14),
                                    fillColor: theme.white,
                                    hintText: clsLan.searchIDorPhoneNumber,
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
                                color: theme.dirt,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.grey,
                                    blurRadius: 3,
                                    offset:
                                        const Offset(0, 0), // Shadow position
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
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.search,
                                    color: theme.deepPumpkin,
                                  )),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        reUse.reUseText(
                            size: 14.0,
                            content:
                                '${clsLan.totalPackage} : ${forDisplay.length}'),
                        const Flexible(child: Divider()),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.litestOrange,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: PopupMenuButton<String>(
                            icon: Icon(
                              Icons.filter_alt_rounded,
                              color: theme.deepOrange,
                            ),
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem<String>(
                                  value: 'all',
                                  child: Text(clsLan.all),
                                ),
                                PopupMenuItem<String>(
                                  value: 'request',
                                  child: Text(clsLan.stReq),
                                ),
                                PopupMenuItem<String>(
                                  value: 'pending',
                                  child: Text(clsLan.stPend),
                                ),
                                PopupMenuItem<String>(
                                  value: 'complet',
                                  child: Text(clsLan.stCom),
                                ),
                                PopupMenuItem<String>(
                                  value: 'return',
                                  child: Text(clsLan.stReturn),
                                ),
                              ];
                            },
                            onSelected: (String value) {
                              filterView(value);
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
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
                                              size: 14.0,
                                              color: theme.darkGrey,
                                              content: clsLan.packageID),
                                          Row(
                                            children: [
                                              reUse.reUseText(
                                                  weight: FontWeight.bold,
                                                  size: 16.0,
                                                  color: theme.blue,
                                                  content:
                                                      (forDisplay[index]['packageID']??"No Data")),
                                              if (forDisplay[index]['status'] ==
                                                  'pending')
                                                Container()
                                              else if (forDisplay[index]
                                                      ['status'] ==
                                                  'complete')
                                                Container()
                                              else if (forDisplay[index]
                                                      ['status'] ==
                                                  'return')
                                                SizedBox(
                                                  height: 40,
                                                  width: 40,
                                                  child: PopupMenuButton<int>(
                                                    onSelected: (item) async {
                                                      if (item == 0) {
                                                        requestAgein(
                                                            forDisplay[index]);
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
                                                      PopupMenuItem<int>(
                                                          value: 0,
                                                          child: Text(clsLan
                                                              .requestAgain)),
                                                      PopupMenuItem<int>(
                                                          value: 1,
                                                          child: Text(
                                                              clsLan.delete)),
                                                    ],
                                                  ),
                                                )
                                              else
                                                SizedBox(
                                                  height: 40,
                                                  width: 40,
                                                  child: PopupMenuButton<int>(
                                                    onSelected: (item) async {
                                                      if (item == 0) {
                                                        Get.to(
                                                            const EditPackageScreen(),
                                                            arguments:
                                                                forDisplay[
                                                                    index]);
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
                                                      PopupMenuItem<int>(
                                                          value: 0,
                                                          child: Text(
                                                              clsLan.edit)),
                                                      PopupMenuItem<int>(
                                                          value: 1,
                                                          child: Text(
                                                              clsLan.delete)),
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
                                            titleColor: theme.darkGrey,
                                            title: clsLan.receiverLocation,
                                            size: textSize,
                                            color: theme.black,
                                            lableSize: labelSize,
                                            content: forDisplay[index]
                                                    ['location'] ??
                                                "No Data",
                                            weight: FontWeight.w500),
                                        reUse.reUseColumnText(
                                            titleColor: theme.darkGrey,
                                            title: clsLan.receiverPhoneNumber,
                                            size: textSize,
                                            color: theme.black,
                                            lableSize: labelSize,
                                            content: forDisplay[index]
                                                    ['phoneNumber'] ??
                                                "No Data",
                                            weight: FontWeight.w500),
                                        reUse.reUseColumnText(
                                            titleColor: theme.darkGrey,
                                            title: clsLan.qty,
                                            size: textSize,
                                            color: theme.black,
                                            lableSize: labelSize,
                                            content: forDisplay[index]['qty'] ??
                                                "No Data",
                                            weight: FontWeight.w500),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        reUse.reUseColumnText(
                                            titleColor: theme.grey,
                                            title: '',
                                            size: textSize,
                                            color: theme.black,
                                            lableSize: labelSize,
                                            content: '',
                                            weight: FontWeight.w500),
                                        reUse.reUseColumnText(
                                            titleColor: theme.grey,
                                            title: '',
                                            size: textSize,
                                            color: theme.black,
                                            lableSize: labelSize,
                                            content: '',
                                            weight: FontWeight.w500),
                                        Flexible(
                                          child: Column(
                                            children: [
                                              reUse.reUseText(
                                                  size: labelSize,
                                                  color: theme.darkGrey,
                                                  content: clsLan.price),
                                              Container(
                                                margin: EdgeInsets.all(8),
                                                width: Get.width,
                                                decoration: BoxDecoration(
                                                  color: theme.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4),
                                                child: Center(
                                                    child: reUse.reUseText(
                                                        weight: FontWeight.bold,
                                                        size: 16.0,
                                                        color: theme.white,
                                                        content:
                                                            (forDisplay[index]
                                                            ['price'] ?? "0") +" \$" )),
                                              ),
                                            ],
                                          ),
                                        )
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
                                                content: '${clsLan.note} :'),
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
                                                  color: theme.black,
                                                  content: forDisplay[index]
                                                          ['note'] ??
                                                      'No note'),
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
                                                  content:
                                                      '${clsLan.createDate} : '),
                                              reUse.reUseText(
                                                  weight: FontWeight.w400,
                                                  size: 14.0,
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
                                                  content: clsLan.stPend),
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
                                                  size: 12.0,
                                                  color: theme.green,
                                                  content: clsLan.stCom),
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
                                                  size: 12.0,
                                                  color: theme.liteRed,
                                                  content: clsLan.stReturn),
                                            )
                                          else
                                            Container(
                                              decoration: BoxDecoration(
                                                color: theme.dirt,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                              child: reUse.reUseText(
                                                  weight: FontWeight.bold,
                                                  size: 12.0,
                                                  color: theme.deepPumpkin,
                                                  content: clsLan.stReq),
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
      ),
    );
  }

  String userName = "";
  String phoneNumber = "";

  fetchUserInformation() async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((doc) async {
      Map data = doc.data() as Map;
      userName = data['firstname'] + ' ' + data['lastname'].toString();
      phoneNumber = data['phoneNumber'].toString();
      setState(() {});
    });
  }

  DatabaseReference userReturn = FirebaseDatabase.instance.ref("Return");
  DatabaseReference driverReturn =
      FirebaseDatabase.instance.ref("DriverReturn");

  requestAgein(data) async {
    await fetchUserInformation();
    await glb.backToReturn(data: data);
    // await glb.deletePackage(witchDataBase: packageRequest,data:data);
    await glb.deleteFromDriver(data: data, witchDataBase: driverReturn);
    await glb.deleteFromReturn(data: data, witchDataBase: userReturn);
    // totalList.removeWhere((item) => item == data);
    // forDisplay.removeWhere((item) => item == data);
    await refetchData();
    // reUse.reUseCircleDialog(
    //     context: context,
    //     icon: Icons.check_circle_rounded,
    //     title: 'Success',
    //     content: Center(
    //       child: Text(
    //         'Your package is successfully request',
    //         style: TextStyle(
    //           color: theme.black,
    //         ),
    //       ),
    //     ));
    setState(() {});
  }

  refetchData() async {
    try {
      DatabaseReference refs = FirebaseDatabase.instance
          .ref('PackageRequest')
          .child(auth.currentUser!.uid);
      refs.onValue.listen((event) {
        setState(() {});
        totalList.clear();
        forDisplay.clear();
        DataSnapshot driver = event.snapshot;
        Map values = driver.value as Map;
        values.forEach((key, values) async {
          Map data = await values as Map;
          data.forEach((key, value) async {
            totalList.add(value);
            setState(() {});
          });
        });
      });
    } catch (e) {
      print('totalListLength $e');
    }
    setState(() {
      print(totalList);
      forDisplay = totalList;
    });
  }

  filterView(String value) {
    if (value == 'all') {
      forDisplay = totalList;
    } else {
      List results = totalList
          .where((user) => user['status']
              .toLowerCase()
              .contains(value.toString().toLowerCase()))
          .toList();
      forDisplay = results;
    }
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

  statusBox({value, backgrondcolor, color}) {
    // if(value == 'request'){
    //   backgrondcolor = theme.dirt;
    // }else if(value == 'pending'){
    //   backgrondcolor = theme.litestOrange;
    // }else if(value == 'return'){
    //   backgrondcolor = theme.litestRed;
    // }else if(value == 'complete'){
    //   backgrondcolor = theme.green;
    // }else{
    //   backgrondcolor = theme.blue;
    // }
    return Column(
      children: [
        reUse.reUseText(
            size: labelSize, color: theme.grey, content: clsLan.price),
        Container(
          decoration: BoxDecoration(
            color: backgrondcolor,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: reUse.reUseText(
              weight: FontWeight.bold,
              size: 12.0,
              color: theme.deepPumpkin,
              content: value),
        ),
      ],
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
