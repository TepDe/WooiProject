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
  List driverList = [];
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
    driverList = argumentData;
    forDisplay = driverList;
    isShow = true;
    glb.onSearchControl(list: driverList);

    print(driverList);
    print(driverList);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //totalListLength();
  }

  final search = TextEditingController();
  final glb = GlobalController();

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
                // reUse.reUseHeader(
                //     packageList: driverList,
                //     searchcontroll: search,
                //     context: context,
                //     label: 'Total Package',
                //     title: 'Total Package',
                //     headercolor: theme.dirt),

                // isShow == false
                //     ? const Flexible(
                //         child: Center(
                //             child: SizedBox(
                //                 height: 50,
                //                 width: 50,
                //                 child: CircularProgressIndicator())))
                //     : reUse.reTotalPackageListview(
                //         pkc: glb.onSearchControl(list: forDisplay)),
                Container(
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
                              padding: EdgeInsets.only(left: 18.0),
                              child: Text(
                                '',
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
                                    onPressed: ()
                                    {
                                      search.clear();
                                      //packageList!.clear(),
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      forDisplay = driverList;
                                      setState(() {

                                      });

                                    },
                                    icon: const Icon(Icons.close),
                                  ),
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
                                  List results = driverList
                                      .where((user) =>
                                      user['packageID']
                                          .toLowerCase()
                                          .contains(search.text
                                          .toString()
                                          .toLowerCase()))
                                      .toList();
                                  forDisplay = results;
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {

                                  });

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
                          reUse.reUseText(content: 'Total : '),
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
                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(8),
                              itemCount: forDisplay.length,
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
                                                  content: forDisplay[index]['packageID']),
                                              SizedBox(
                                                height: 40,
                                                width: 40,
                                                child: PopupMenuButton<int>(
                                                  onSelected: (item) => {},
                                                  itemBuilder: (context) =>
                                                  [
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
                                          reUse.reSetUseText(
                                              titleColor: theme.grey,
                                              title: 'Destination',
                                              size: 14.0,
                                              color: theme.black,
                                              content: forDisplay[index]['location'],
                                              weight: FontWeight.w500),
                                          reUse.reSetUseText(
                                              titleColor: theme.grey,
                                              title: 'Phone number',
                                              size: 14.0,
                                              color: theme.black,
                                              content: forDisplay[index]['phoneNumber'],
                                              weight: FontWeight.w500),
                                          reUse.reSetUseText(
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
                                          reUse.reUseText(
                                              weight: FontWeight.bold,
                                              size: 12.0,
                                              color: theme.darkGrey,
                                              content: 'Price '),
                                          reUse.reUseText(
                                              weight: FontWeight.bold,
                                              size: 18.0,
                                              color: theme.blue,
                                              content: forDisplay[index]['price']),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          reUse.reUseText(
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
                                              child: reUse.reUseTextNote(
                                                  weight: FontWeight.w400,
                                                  size: 14.0,
                                                  color: theme.grey,
                                                  content: forDisplay[index]['note']),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          reUse.reUseText(
                                              weight: FontWeight.w400,
                                              size: 12.0,
                                              color: theme.grey,
                                              content: 'Date : '),
                                          reUse.reUseText(
                                              weight: FontWeight.w400,
                                              size: 12.0,
                                              color: theme.darkGrey,
                                              content: forDisplay[index]['date']),
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
          reUse.reUseCreatePackage(context: context),
        ],
      ),
    ));
  }
}
