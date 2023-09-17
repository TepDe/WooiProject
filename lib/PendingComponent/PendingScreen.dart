import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/GlobalControl/clsField.dart';
import 'package:wooiproject/PendingComponent/PendingDetail.dart';
import 'package:wooiproject/ViewScreen.dart';
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

  var labelSize = 14.0;
  var valueSize = 14.0;
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

  double padding = 2.0;
  final field = FieldData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // reUse.reUseHeader(
            //     label: 'Pending', title: 'Pending', headercolor: theme.orange),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/PendingHeadUser.png"),
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
                            color: theme.orange,
                          ),
                          label: Text(
                            clsLan.stPend,
                            style: TextStyle(
                                fontSize: 18,
                                color: theme.orange,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 18.0),
                        //   child: Text(
                        //     clsLan.stPend,
                        //     style: TextStyle(
                        //         fontSize: 18,
                        //         color: theme.orange,
                        //         fontWeight: FontWeight.w400),
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
                            controller: searchController,
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
                          color: theme.litestOrange,
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
                                  .where((user) => user['packageID']
                                      .toLowerCase()
                                      .contains(searchController.text
                                          .toString()
                                          .toLowerCase()))
                                  .toList();
                              if (results.isEmpty) {
                                results = pendingList
                                    .where((user) => user['phoneNumber']
                                        .toLowerCase()
                                        .contains(searchController.text
                                            .toString()
                                            .toLowerCase()))
                                    .toList();
                              }
                              forDisplay = results;
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.search,
                              color: theme.deepOrange,
                            )),
                      )
                    ],
                  ),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(padding),
                    child: reUse.reUseText(
                        content:
                            '${clsLan.totalPackage} : ${forDisplay.length}'),
                  ),

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
            ),
            forDisplay.isNotEmpty
                ? Flexible(
                    child: Scrollbar(
                      thickness: 6,
                      radius: const Radius.circular(6.0),
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      width: Get.width,
                                      margin: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: theme.liteGrey,
                                        borderRadius: BorderRadius.circular(6),
                                        boxShadow: [
                                          BoxShadow(
                                            color: theme.grey,
                                            blurRadius: 4,
                                            offset: const Offset(
                                                0, 1), // Shadow position
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(() => const PendingDetail(),
                                                arguments: forDisplay[index]);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                reUse.reUseRowText(
                                                    lableSize: labelSize,
                                                    titleColor: theme.grey,
                                                    title: "${index + 1}./  " +
                                                        clsLan.packageID,
                                                    size: 16.0,
                                                    color: theme.blue,
                                                    content: forDisplay[index]
                                                        ['packageID'],
                                                    weight: FontWeight.w500),
                                                Divider(
                                                  color: theme.grey,
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.all(padding),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      reUse.reUseColumnText(
                                                          titleColor:
                                                              theme.grey,
                                                          title: clsLan
                                                              .receiverLocation,
                                                          lableSize: 11,
                                                          size: 14.0,
                                                          color: theme.black,
                                                          content:
                                                              forDisplay[index]
                                                                  ['location'],
                                                          weight:
                                                              FontWeight.w500),
                                                      reUse.reUseColumnText(
                                                          lableSize: 11,
                                                          titleColor:
                                                              theme.grey,
                                                          title: clsLan
                                                              .receiverPhoneNumber,
                                                          size: 14.0,
                                                          color: theme.black,
                                                          content: forDisplay[
                                                                  index]
                                                              ['phoneNumber'],
                                                          weight:
                                                              FontWeight.w500),
                                                      reUse.reUseColumnText(
                                                          lableSize: 11,
                                                          titleColor:
                                                              theme.grey,
                                                          title: clsLan.qty,
                                                          size: 14.0,
                                                          color: theme.black,
                                                          content: '1',
                                                          weight:
                                                              FontWeight.w500),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    reUse.reUseColumnText(
                                                        lableSize: 12,
                                                        titleColor: theme.grey,
                                                        title: clsLan.assignBy +
                                                            " :",
                                                        size: 0.0,
                                                        color: theme.black,
                                                        content: '',
                                                        weight:
                                                            FontWeight.w500),
                                                    reUse.reUseColumnText(
                                                        lableSize: 12,
                                                        titleColor: theme.grey,
                                                        title:
                                                            clsLan.driverPhone,
                                                        size: 14.0,
                                                        color: theme.black,
                                                        content:
                                                            forDisplay[index]
                                                                [field.dPhone],
                                                        weight:
                                                            FontWeight.w500),
                                                    reUse.reUseColumnText(
                                                        lableSize: 12,
                                                        titleColor: theme.grey,
                                                        title:
                                                            clsLan.driverName,
                                                        size: 14.0,
                                                        color: theme.black,
                                                        content: forDisplay[
                                                                    index][
                                                                field
                                                                    .dLastName] +
                                                            ' ' +
                                                            forDisplay[index][
                                                                field
                                                                    .dFirstName],
                                                        weight:
                                                            FontWeight.w500),
                                                  ],
                                                ),
                                                Divider(
                                                  color: theme.grey,
                                                ),
                                                reUse.reUseRowText(
                                                    lableSize: labelSize,
                                                    titleColor: theme.grey,
                                                    title: clsLan.date,
                                                    size: valueSize,
                                                    color: theme.black,
                                                    content: forDisplay[index]
                                                        [field.assignDate],
                                                    weight: FontWeight.w500),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Flexible(child: Center(child: Text(clsLan.notHave)))
          ],
        ),
      ),
    );
  }

  final clsLan = ClsLanguage();
}
