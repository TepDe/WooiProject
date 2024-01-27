import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wooiproject/CompleteDetail.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/GlobalControl/clsField.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';

class RevenueList extends StatefulWidget {
  const RevenueList({super.key});

  @override
  State<RevenueList> createState() => _RevenueListState();
}

class _RevenueListState extends State<RevenueList> {
  final clsLan = ClsLanguage();
  final field = FieldData();
  final reUse = ReUseWidget();
  final theme = ThemesApp();
  final glb = GlobalController();
  final search = TextEditingController();
  var argumentData = Get.arguments;
  List lstComplete = [];
  List forDisplay = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lstComplete = glb.sortNewest(argumentData['data'], 'completeDate');
    forDisplay = List.from(lstComplete);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
              decoration: BoxDecoration(
                color: theme.liteBlue,
                // image: DecorationImage(
                //   image: AssetImage("assets/images/CompleteHead.png"),
                //   fit: BoxFit.cover,
                // ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Get.back();
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: theme.blue,
                          ),
                          label: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                clsLan.revenue,
                                style: TextStyle(
                                    color: theme.blue,
                                    fontSize: 18,
                                    // color: titleColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              reUse.reUseText(
                                  content: "${argumentData['price']} \$",
                                  size: 14.0,
                                  weight: FontWeight.bold,
                                  color: theme.blue),
                            ],
                          ),
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.only(left: 18.0),
                        //   child: Text(
                        //     clsLan.stCom,
                        //     style: TextStyle(
                        //         color: theme.green,
                        //         fontSize: 18,
                        //         // color: titleColor,
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
                                  forDisplay = lstComplete;
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
                              color: theme.btnBlue,
                              blurRadius: 6,
                              offset: const Offset(0, 0), // Shadow position
                            ),
                          ],
                        ),
                        child: IconButton(
                            splashRadius: 20,
                            onPressed: () {
                              forDisplay = glb.onSearch(lstComplete, search.text);
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  reUse.reUseText(content: '${clsLan.totalPackage} : ${forDisplay.length}'),
                  const Flexible(child: Divider()),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.liteBlue,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: PopupMenuButton<String>(
                      icon: Icon(
                        Icons.sort_rounded,
                        color: theme.blue,
                      ),
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem<String>(
                            value: 'new',
                            child: Text("ថ្មីបំផុត"),
                          ),
                          const PopupMenuItem<String>(
                            value: 'old',
                            child: Text("ចាស់បំផុត"),
                          ),
                          const PopupMenuItem<String>(
                            value: 'today',
                            child: Text("ថ្ងៃនេះ"),
                          ),
                        ];
                      },
                      onSelected: (String value) {
                        List lstData = List.from(lstComplete);
                        if (value == "old") {
                          forDisplay = glb.sortOldest(lstData, "date");
                        } else if (value == "new") {
                          forDisplay = glb.sortNewest(lstData, "date");
                        } else {
                          forDisplay = glb.onSortToday(lstData, "date");
                        }
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            forDisplay.isNotEmpty
                ? Flexible(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: forDisplay.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: Get.width,
                            margin: const EdgeInsets.all(6),
                            // padding: const EdgeInsets.all(6),
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
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(6),
                                onTap: () {
                                  Get.to(() => const CompleteDetail(),
                                      arguments: {"data": forDisplay[index], "from": "revenue"});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          reUse.reUseText(
                                              weight: FontWeight.w400,
                                              size: 12.0,
                                              color: theme.grey,
                                              content: clsLan.packageID),
                                          Row(
                                            children: [
                                              reUse.reUseText(
                                                  weight: FontWeight.bold,
                                                  size: 16.0,
                                                  color: theme.blue,
                                                  content: forDisplay[index]['packageID']),
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
                                        padding: const EdgeInsets.all(6.0),
                                        child: Divider(
                                          height: 1,
                                          color: theme.grey,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            reUse.reUseColumnText(
                                                titleColor: theme.grey,
                                                title: clsLan.receiverLocation,
                                                lableSize: 11,
                                                size: 14.0,
                                                color: theme.black,
                                                content: forDisplay[index]['location'],
                                                weight: FontWeight.w500),
                                            reUse.reUseColumnText(
                                                titleColor: theme.grey,
                                                title: clsLan.receiverPhoneNumber,
                                                lableSize: 11,
                                                size: 14.0,
                                                color: theme.black,
                                                content: forDisplay[index]['phoneNumber'],
                                                weight: FontWeight.w500),
                                            reUse.reUseColumnText(
                                                titleColor: theme.grey,
                                                title: clsLan.price,
                                                lableSize: 11,
                                                size: 14.0,
                                                color: theme.black,
                                                content: forDisplay[index]['price'] + " \$",
                                                weight: FontWeight.w500),
                                            // reUse.reUseText(
                                            //     weight: FontWeight.bold,
                                            //     size: 12.0,
                                            //     color: theme.grey,
                                            //     content: 'Location'),
                                            // reUse.reUseText(
                                            //     size: 12.0,
                                            //     weight: FontWeight.bold,
                                            //     color: theme.grey,
                                            //     content: 'Phone number'),
                                            // reUse.reUseText(
                                            //     size: 12.0,
                                            //     weight: FontWeight.bold,
                                            //     color: theme.grey,
                                            //     content: 'Qty'),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        height: 1,
                                        color: theme.grey,
                                      ),
                                      reUse.reUseRowText(
                                          lableSize: 12.0,
                                          titleColor: theme.grey,
                                          title: clsLan.complete,
                                          size: 12.0,
                                          color: theme.black,
                                          content: glb.formatDateTime(forDisplay[index][field.completeDate]),
                                          weight: FontWeight.w500),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                : const Expanded(child: Center(child: Text("មិនមាន")))
          ],
        ),
      ),
    );
  }
}
