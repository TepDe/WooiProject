import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';

class CompleteScreen extends StatefulWidget {
  const CompleteScreen({Key? key}) : super(key: key);

  @override
  State<CompleteScreen> createState() => _CompleteScreenState();
}

class _CompleteScreenState extends State<CompleteScreen> {
  final reUse = ReUseWidget();
  final theme = ThemesApp();
  final glb = GlobalController();
  var argumentData = Get.arguments;
  List completeList = [];
  List forDisplay = [];
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(argumentData);
    print(argumentData);
    completeList = argumentData;
    forDisplay = argumentData;
  }

  final search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          // reUse.reUseHeader(
          //     title: 'Complete',
          //     headercolor: theme.liteGreen,
          //     titleColor: theme.black
          // ),
          // // reUse.reCompletePackageListview(pkc: completeList),
          // completeList.isEmpty
          //     ? Flexible(
          //     flex: 3,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Image.asset('assets/images/check.png', color: theme.grey,scale: 12),
          //         reUse.reUseText(content: 'Pending not available', color: theme.grey)
          //       ],
          //     ))
          //     : reUse.reCompletePackageListview(pkc: completeList),
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
                          'Complete',
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
                                forDisplay = completeList;
                                FocusManager.instance.primaryFocus?.unfocus();
                                setState(() {});
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
                        color: theme.btnBlue,
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
                            List results = completeList
                                .where((user) => user['packageID']
                                    .toLowerCase()
                                    .contains(
                                        search.text.toString().toLowerCase()))
                                .toList();
                            if (results == null || results.isEmpty) {
                              results = completeList
                                  .where((user) => user['phoneNumber']
                                      .toLowerCase()
                                      .contains(
                                          search.text.toString().toLowerCase()))
                                  .toList();
                            }
                            forDisplay = results;
                            setState(() {});
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          icon: Icon(
                            Icons.search,
                            color: theme.white,
                          )),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      reUse.reUseText(content: 'Total : ${forDisplay.length}'),
                      const Flexible(child: Divider()),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: theme.litestOrange,
                      //     borderRadius: BorderRadius.circular(6),
                      //   ),
                      //   child: IconButton(
                      //       splashRadius: 20,
                      //       onPressed: () {},
                      //       icon: Icon(
                      //         Icons.filter_alt_outlined,
                      //         color: theme.orange,
                      //       )),
                      // )
                    ],
                  ),
                )
              ],
            ),
          ),
          forDisplay == []
              ? Flexible(
                  child: Scrollbar(
                    thickness: 2,
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: forDisplay.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: Get.width,
                            margin: const EdgeInsets.all(6),
                            padding: const EdgeInsets.all(6),
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
                                            content: forDisplay[index]
                                                ['packageID']),
                                        // SizedBox(
                                        //   height: 40,
                                        //   width: 40,
                                        //   child: PopupMenuButton<int>(
                                        //     onSelected: (item) async {
                                        //       if (item == 0) {
                                        //       } else {}
                                        //     },
                                        //     itemBuilder: (context) => [
                                        //       PopupMenuItem<int>(
                                        //           value: 1,
                                        //           child: Row(
                                        //             mainAxisAlignment:
                                        //                 MainAxisAlignment.spaceAround,
                                        //             children: [
                                        //               Icon(Icons
                                        //                   .delete_forever_rounded),
                                        //               Text('Delete'),
                                        //             ],
                                        //           )),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      reUse.reUseText(
                                          weight: FontWeight.bold,
                                          size: 12.0,
                                          color: theme.grey,
                                          content: 'Location'),
                                      reUse.reUseText(
                                          size: 12.0,
                                          weight: FontWeight.bold,
                                          color: theme.grey,
                                          content: 'Phone number'),
                                      reUse.reUseText(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      reUse.reUseText(
                                          size: 14.0,
                                          color: theme.black,
                                          content: forDisplay[index]
                                              ['location'],
                                          weight: FontWeight.w500),
                                      reUse.reUseText(
                                          size: 14.0,
                                          color: theme.black,
                                          weight: FontWeight.w500,
                                          content: forDisplay[index]
                                              ['phoneNumber']),
                                      reUse.reUseText(
                                          size: 14.0,
                                          color: theme.black,
                                          content: '1',
                                          weight: FontWeight.w500),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Divider(
                                    height: 1,
                                    color: theme.grey,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    reUse.reUseText(
                                        size: 12.0,
                                        weight: FontWeight.bold,
                                        color: theme.grey,
                                        content: 'Status'),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: theme.litestGreen,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      child: reUse.reUseText(
                                          size: 10.0,
                                          color: theme.liteGreen,
                                          content: forDisplay[index]['status']
                                              .toString()
                                              .toUpperCase(),
                                          weight: FontWeight.w900),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                )
              : Expanded(child: Center(child: Column(
                children: [
                  Image.asset(
                    'assets/images/check.png',
                    height: 30,
                    width: 30,
                    color:   theme.liteGreen,
                  ),
                  reUse.reUseText(content: "No Data"),
                ],
              ))),
        ],
      ),
    ));
  }

  removeItem({keyIndex, listIndex}) async {
    DatabaseReference packageRequest =
        FirebaseDatabase.instance.ref("PackageRequest");
    await packageRequest
        .child(auth.currentUser!.uid)
        .child('package')
        .child(keyIndex)
        .remove();
    completeList.removeWhere((item) => item == listIndex);
    // keyList.removeWhere((item) => item == keyIndex);
    // forDisplay = totalList;
    setState(() {});
  }
}
