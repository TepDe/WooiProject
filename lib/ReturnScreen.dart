import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';

class ReturnScreen extends StatefulWidget {
  const ReturnScreen({Key? key}) : super(key: key);

  @override
  State<ReturnScreen> createState() => _ReturnScreenState();
}

class _ReturnScreenState extends State<ReturnScreen> {
  final reUse = ReUseWidget();
  final theme = ThemesApp();
  final glb = GlobalController();
  final search = TextEditingController();
  var argumentData = Get.arguments;
  List returnList = [];
  List forDisplay = [];
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isShow = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    returnList = argumentData;
    forDisplay =  returnList;
    print(returnList);
    isShow = true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          // reUse.reUseHeader(
          //     label: 'Return', title: 'Return', headercolor: theme.liteRed),
          // returnList.isEmpty
          //     ? Flexible(
          //         flex: 3,
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //            Image.asset('assets/images/return-box.png',scale: 12,color: theme.grey,),
          //             reUse.reUseText(content: 'No Return \n Available', color: theme.grey)
          //           ],
          //         ))
          //     : reUse.reUseRerurnPackageList(returnData: returnList,pkc:returnList ),
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
                          'Return',
                          style: TextStyle(
                              fontSize: 18,
                              //color: titleColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                          onPressed: () {


                          },
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
                              onPressed: () =>
                              {
                                search.clear(),
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
                            List results = returnList
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
          Expanded(
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
                                          content:
                                          forDisplay[index]['packageID'] ?? "No ID"),
                                      SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: PopupMenuButton<int>(
                                          onSelected: (item) => {},
                                          itemBuilder: (context) =>
                                          [
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
                                    // reUse.reSetUseText(
                                    //     titleColor: theme.grey,
                                    //     title: 'Destination',
                                    //     size: 14.0,
                                    //     color: theme.black,
                                    //     content: forDisplay[index]['location'],
                                    //     weight: FontWeight.w500),
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
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  children: [
                                    reUse.reUseText(
                                        weight: FontWeight.bold,
                                        size: 12.0,
                                        color: theme.darkGrey,
                                        content: 'Price : '),
                                    reUse.reUseText(
                                        weight: FontWeight.bold,
                                        size: 12.0,
                                        color: theme.blue,
                                        content: forDisplay[index]['price'] ?? "No price"),
                                  ],
                                ),
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
                                          content: forDisplay[index]['note'] ?? "No reason"),
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
                                      content: 'Return Time : '),
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
          )
        ],
      ),
    ));
  }
}
