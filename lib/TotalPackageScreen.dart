import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipe_refresh/swipe_refresh.dart';
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
  List sortList = [];
  List forDisplay = [];
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isShow = false;
  final clsLan = ClsLanguage();
  final field = FieldData();
  final fieldInfo = FieldInfo();
  DatabaseReference requestDB = FirebaseDatabase.instance.ref('PackageRequest');

  Future<void> totalListLength() async {
    try {
      final isRequestDB = await requestDB.child(auth.currentUser!.uid).onValue.first;
      totalList.clear();
      forDisplay.clear();
      sortList.clear();
      DataSnapshot driver = isRequestDB.snapshot;
      Map values = driver.value as Map;
      values.forEach((key, values) async {
        Map data = await values as Map;
        data.forEach((key, value) async {
          totalList.add(value);
          sortList.add(value);
          setState(() {});
        });
      });
      forDisplay = sortDateTime(totalList);
    } catch (e) {
      print('totalListLength $e');
    }
  }

  List sortDateTime(sortDateTime) {
    DateTime parseDate(String dateString) {
      return DateTime.parse(dateString);
    }

    sortDateTime.sort((a, b) {
      DateTime dateA = parseDate(a["date"]);
      DateTime dateB = parseDate(b["date"]);
      return dateB.compareTo(dateA);
    });
    return sortDateTime;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //totalListLength();
    onInitialize();
  }

  Future<void> onInitialize() async {
    totalList = argumentData[0]['data'];
    if (totalList.isNotEmpty) {
      forDisplay = totalList;
      setState(() {});
    } else {
      await totalListLength();
    }
  }

  final search = TextEditingController();
  final glb = GlobalController();
  double padding = 8.0;
  double labelSize = 10.0;
  double textSize = 14.0;
  final _controller = StreamController<SwipeRefreshState>.broadcast();

  Stream<SwipeRefreshState> get _stream => _controller.stream;
  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    await totalListLength();
    _controller.sink.add(SwipeRefreshState.hidden);
  }
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                  style: TextStyle(fontSize: 18, color: theme.deepPumpkin, fontWeight: FontWeight.bold),
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
                                        FocusManager.instance.primaryFocus?.unfocus();
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
                                            .contains(search.text.toString().toLowerCase()))
                                        .toList();
                                    if (results.isEmpty) {
                                      results = totalList
                                          .where((user) => user['phoneNumber']
                                              .toLowerCase()
                                              .contains(search.text.toString().toLowerCase()))
                                          .toList();
                                    }
                                    forDisplay = results;
                                    FocusManager.instance.primaryFocus?.unfocus();
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
                        reUse.reUseText(size: 14.0, content: '${clsLan.totalPackage} : ${forDisplay.length}'),
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
                    child: SwipeRefresh.material(
                      stateStream: _stream,
                      onRefresh: _refresh,
                      shrinkWrap: true,
                      children: [
                        Flexible(
                          child: Scrollbar(
                            thickness: 6,
                            radius: const Radius.circular(6.0),
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
                                        padding: EdgeInsets.symmetric(horizontal: padding),
                                        decoration: BoxDecoration(
                                          color: theme.liteGrey,
                                          borderRadius: BorderRadius.circular(6),
                                          boxShadow: [
                                            BoxShadow(
                                              color: theme.grey,
                                              blurRadius: 4,
                                              offset: const Offset(0, 0), // Shadow position
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
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  reUse.reUseText(
                                                      weight: FontWeight.w400,
                                                      size: 14.0,
                                                      color: theme.darkGrey,
                                                      content: "${index + 1}./  ${clsLan.packageID}"),
                                                  Row(
                                                    children: [
                                                      reUse.reUseText(
                                                          weight: FontWeight.bold,
                                                          size: 16.0,
                                                          color: theme.blue,
                                                          content: (forDisplay[index]['packageID'] ?? "No Data")),
                                                      if (forDisplay[index]['status'] == 'pending')
                                                        Container()
                                                      else if (forDisplay[index]['status'] == 'complete')
                                                        Container()
                                                      else if (forDisplay[index]['status'] == 'return')
                                                          SizedBox(
                                                            height: 40,
                                                            width: 40,
                                                            child: PopupMenuButton<String>(
                                                              onSelected: (value) {
                                                                isAction(
                                                                    data: forDisplay[index], value: value, context: context);
                                                              },
                                                              itemBuilder: (BuildContext context) {
                                                                return <PopupMenuEntry<String>>[
                                                                  const PopupMenuItem<String>(
                                                                    value: 'requestAgain',
                                                                    child: Text('ហៅម្ដងទៀត'),
                                                                  ),
                                                                  const PopupMenuItem<String>(
                                                                    value: 'delete',
                                                                    child: Text('លុប'),
                                                                  ),
                                                                ];
                                                              },
                                                            ),
                                                          )
                                                        else
                                                          SizedBox(
                                                            height: 40,
                                                            width: 40,
                                                            child: PopupMenuButton<String>(
                                                              onSelected: (value) {
                                                                isAction(
                                                                    data: forDisplay[index], value: value, context: context);
                                                              },
                                                              itemBuilder: (BuildContext context) {
                                                                return <PopupMenuEntry<String>>[
                                                                  const PopupMenuItem<String>(
                                                                    value: 'edit',
                                                                    child: Text('កែ'),
                                                                  ),
                                                                  const PopupMenuItem<String>(
                                                                    value: 'delete',
                                                                    child: Text('លុប'),
                                                                  ),
                                                                ];
                                                              },
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
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                reUse.reUseColumnText(
                                                    titleColor: theme.darkGrey,
                                                    title: clsLan.receiverLocation,
                                                    size: textSize,
                                                    color: theme.black,
                                                    lableSize: labelSize,
                                                    content: forDisplay[index]['location'] ?? "No Data",
                                                    weight: FontWeight.w500),
                                                reUse.reUseColumnText(
                                                    titleColor: theme.darkGrey,
                                                    title: clsLan.receiverPhoneNumber,
                                                    size: textSize,
                                                    color: theme.black,
                                                    lableSize: labelSize,
                                                    content: forDisplay[index]['phoneNumber'] ?? "No Data",
                                                    weight: FontWeight.w500),
                                                reUse.reUseColumnText(
                                                    titleColor: theme.darkGrey,
                                                    title: clsLan.qty,
                                                    size: textSize,
                                                    color: theme.black,
                                                    lableSize: labelSize,
                                                    content: forDisplay[index]['qty'] ?? "No Data",
                                                    weight: FontWeight.w500),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                                          size: labelSize, color: theme.darkGrey, content: clsLan.price),
                                                      Container(
                                                        margin: const EdgeInsets.all(8),
                                                        width: Get.width,
                                                        decoration: BoxDecoration(
                                                          color: theme.blue,
                                                          borderRadius: BorderRadius.circular(6),
                                                        ),
                                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                        child: Center(
                                                            child: reUse.reUseText(
                                                                weight: FontWeight.bold,
                                                                size: 16.0,
                                                                color: theme.white,
                                                                content: (forDisplay[index]['price'] ?? "0") + " \$")),
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
                                                    padding: EdgeInsets.only(right: padding),
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
                                                      decoration: BoxDecoration(border: Border.all(color: theme.minGrey)),
                                                      child: reUse.reUseTextNote(
                                                          weight: FontWeight.w400,
                                                          size: 14.0,
                                                          color: theme.black,
                                                          content: forDisplay[index]['note'] ?? 'No note'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(padding),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      reUse.reUseText(
                                                          weight: FontWeight.w400,
                                                          size: 12.0,
                                                          color: theme.grey,
                                                          content: '${clsLan.createDate} : '),
                                                      reUse.reUseText(
                                                          weight: FontWeight.w400,
                                                          size: 14.0,
                                                          color: theme.black,
                                                          content: glb.formatDateTime(forDisplay[index]['date'])),
                                                    ],
                                                  ),
                                                  if (forDisplay[index]['status'] == 'pending')
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: theme.litestOrange,
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                      child: reUse.reUseText(
                                                          weight: FontWeight.bold,
                                                          size: 10.0,
                                                          color: theme.orange,
                                                          content: clsLan.stPend),
                                                    )
                                                  else if (forDisplay[index]['status'] == 'complete')
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: theme.litestGreen,
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                      child: reUse.reUseText(
                                                          weight: FontWeight.bold,
                                                          size: 12.0,
                                                          color: theme.green,
                                                          content: clsLan.stCom),
                                                    )
                                                  else if (forDisplay[index]['status'] == 'return')
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: theme.litestRed,
                                                          borderRadius: BorderRadius.circular(6),
                                                        ),
                                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                                                          borderRadius: BorderRadius.circular(6),
                                                        ),
                                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                          ),
                        )

                      ],
                    ),
                  ),

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

  DatabaseReference userReturn = FirebaseDatabase.instance.ref("Return");
  DatabaseReference driverReturn = FirebaseDatabase.instance.ref("DriverReturn");

  Future<void> requestAgain(data) async {
    try {
      await glb.backToReturn(data: data);
      await glb.deleteFromDriver(data: data, witchDataBase: driverReturn);
      await glb.deleteFromReturn(data: data, witchDataBase: userReturn);
    } catch (e) {}
    //await refetchData();
  }

  filterView(String value) {
    if (value == 'all') {
      forDisplay = totalList;
    } else {
      List results =
          totalList.where((user) => user['status'].toLowerCase().contains(value.toString().toLowerCase())).toList();
      forDisplay = results;
    }
  }

  Future<void> isAction({data, value, context}) async {
    reUse.reUseWaitingDialog(context);
    if (value == 'edit') {
      Navigator.pop(context);
      Get.to(() => const EditPackageScreen(), arguments: data);
    } else if (value == "requestAgain") {
      await requestAgain(data);
      Navigator.pop(context);
      reUse.reUseCircleDialog(
          context: context,
          icon: Icons.check_circle_rounded,
          title: 'ជោគជ័យ',
          content: Center(
            child: Text(
              'ទំនិញរបស់លោកអ្នកហៅបានជោគជ័យ',
              style: TextStyle(
                color: theme.black,
              ),
            ),
          ));
    } else if (value == "delete") {
      try {
        await requestDB.child(auth.currentUser!.uid).child('package').child(data["pushKey"]).remove();
        setState(() {
          totalList.removeWhere((item) => item == data);
          forDisplay.removeWhere((item) => item == data);
        });
        Navigator.pop(context);
        reUse.reUseCircleDialog(
            context: context,
            icon: Icons.check_circle_rounded,
            title: 'ជោគជ័យ',
            content: Center(
              child: Text(
                'ទំនិញរបស់លោកអ្នកហៅបានជោគជ័យ',
                style: TextStyle(
                  color: theme.black,
                ),
              ),
            ));
      } catch (e) {
        reUse.reUseCircleDialog(
            onTap: () => Get.back(),
            context: context,
            title: 'បរាជ័យ',
            content: reUse.reUseText(content: "បរាជ័យ សូម​ព្យាយាម​ម្តង​ទៀត​នៅ​ពេល​ក្រោយ"));
      }
    }
  }
}
