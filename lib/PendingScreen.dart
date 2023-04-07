import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({Key? key}) : super(key: key);

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  final reUse = ReUseWidget();
  final theme = ThemesApp();
  final glb = GlobalController();
  var argumentData = Get.arguments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pendingList = argumentData;
    forDisplay = pendingList;
    //pendingListLength();
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  List pendingList = [];
  List forDisplay = [];
  final searchController = TextEditingController();

  pendingListLength() async {
    DatabaseReference refs = FirebaseDatabase.instance.ref('Pending');
    refs.onValue.listen((event) async {
      pendingList.clear();
      DataSnapshot driver = event.snapshot;
      Map values = driver.value as Map;
      values.forEach((key, value) async {
        Map data = value[auth.currentUser!.uid] as Map;
        data.forEach((key, value) {
          setState(() {
            pendingList.add(value);
          });
        });
      });
    });
  }
  double reUseReturnPadding = 2.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          // reUse.reUseHeader(
          //     label: 'Pending', title: 'Pending', headercolor: theme.orange),
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
                           'Pending',
                          style: TextStyle(
                              fontSize: 18,
                              //color: titleColor,
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
                          controller: searchController,
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
                                forDisplay = pendingList;

                                searchController.clear();
                                //packageList!.clear(),
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
                            List results = pendingList
                                .where((user) =>
                                user['packageID']
                                    .toLowerCase()
                                    .contains(searchController!.text
                                    .toString()
                                    .toLowerCase()))
                                .toList();
                            results  = forDisplay;
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {});
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
          // pendingList.isEmpty
          //     ? Flexible(
          //         flex: 3,
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Image.asset('assets/images/delivery_man.png', color: theme.grey,scale: 12),
          //             reUse.reUseText(content: 'Pending not available', color: theme.grey)
          //           ],
          //         ))
          //     : reUse.reUsePendingList(pkc: pendingList),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        itemCount: forDisplay!.length,
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
                                      reUse.reUseText(
                                          weight: FontWeight.w400,
                                          size: 12.0,
                                          color: theme.grey,
                                          content: 'SHIPPING ID :'),
                                      reUse.reUseText(
                                          weight: FontWeight.bold,
                                          size: 16.0,
                                          color: theme.blue,
                                          content:
                                          forDisplay[index]['packageID'] ?? 'No ID'),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(reUseReturnPadding),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  padding: EdgeInsets.all(reUseReturnPadding),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      reUse.reUseText(
                                          size: 14.0,
                                          color: theme.black,
                                          content: forDisplay[index]['location'],
                                          weight: FontWeight.w500),
                                      reUse.reUseText(
                                          size: 14.0,
                                          color: theme.black,
                                          weight: FontWeight.w500,
                                          content: forDisplay[index]['phoneNumber']),
                                      reUse.reUseText(
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
                                      reUse.reUseText(
                                          size: 12.0,
                                          weight: FontWeight.bold,
                                          color: theme.grey,
                                          content: 'Status'),
                                      reUse.reUseText(
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
          )
        ],
      ),
    ));
  }
}
