import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/GlobalControl/clsField.dart';
import 'package:wooiproject/ReturnDetail.dart';
import 'package:wooiproject/ViewScreen.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';

class ReturnScreen extends StatefulWidget {
  const ReturnScreen({super.key});

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
    forDisplay = returnList;
    isShow = true;
  }

  var labelSize = 11.0;
  var valueSize = 14.0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.to(() => const ViewScreen());
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/ReturnHead.png"),
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
                              color: theme.red,
                            ),
                            label: Text(
                              clsLan.returns,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: theme.red,
                                  //color: titleColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
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
                                    forDisplay = returnList;
                                    search.clear();
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
                            color: theme.litestRed,
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
                                forDisplay = glb.onSearch(returnList, search.text);
                                FocusManager.instance.primaryFocus?.unfocus();
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.search,
                                color: theme.red,
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
                        color: theme.litestRed,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: PopupMenuButton<String>(
                        icon: Icon(
                          Icons.sort_rounded,
                          color: theme.red,
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
                          List lstData = List.from(returnList);
                          if (value == "old") {
                            forDisplay = glb.sortOldest(lstData, "returnDate");
                          } else if (value == "new") {
                            forDisplay = glb.sortNewest(lstData, "returnDate");
                          } else {
                            forDisplay = glb.onSortToday(lstData, "returnDate");
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
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      width: Get.width,
                                      margin: const EdgeInsets.all(6),
                                      //padding: const EdgeInsets.all(10),
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
                                            Get.to(() => const ReturnDetail(), arguments: forDisplay[index]);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    reUse.reUseText(
                                                        weight: FontWeight.w400,
                                                        size: 16.0,
                                                        color: theme.grey,
                                                        content: '${index + 1}./  ${clsLan.packageID}'),
                                                    Row(
                                                      children: [
                                                        forDisplay[index]['returnStatus'] != null
                                                            ? Image.asset(
                                                                'assets/images/return-box.png',
                                                                height: Get.height * 0.04,
                                                                width: Get.width * 0.04,
                                                                color: theme.red,
                                                              )
                                                            : const SizedBox(),
                                                        reUse.reUseText(
                                                            weight: FontWeight.bold,
                                                            size: 16.0,
                                                            color: theme.blue,
                                                            content: "    ${forDisplay[index]['packageID']}"),
                                                        SizedBox(
                                                          height: 40,
                                                          width: 40,
                                                          child: PopupMenuButton<int>(
                                                            onSelected: (item) async {
                                                              reUse.reUseWaitingDialog(context);
                                                              await optionSelect(
                                                                  context: context, opt: item, data: forDisplay[index]);
                                                            },
                                                            itemBuilder: (context) => [
                                                              const PopupMenuItem<int>(
                                                                  value: 0, child: Text('ហៅម្ដងទៀត')),
                                                              const PopupMenuItem<int>(value: 1, child: Text('លុប')),
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
                                                    reUse.reUseColumnText(
                                                        titleColor: theme.grey,
                                                        title: clsLan.receiverLocation,
                                                        size: valueSize,
                                                        lableSize: labelSize,
                                                        color: theme.black,
                                                        content: forDisplay[index]['location'],
                                                        weight: FontWeight.w500),
                                                    reUse.reUseColumnText(
                                                        lableSize: labelSize,
                                                        titleColor: theme.grey,
                                                        title: clsLan.receiverPhoneNumber,
                                                        size: valueSize,
                                                        color: theme.black,
                                                        content: forDisplay[index]['phoneNumber'],
                                                        weight: FontWeight.w500),
                                                    reUse.reUseColumnText(
                                                        titleColor: theme.grey,
                                                        title: clsLan.qty,
                                                        size: valueSize,
                                                        lableSize: labelSize,
                                                        color: theme.black,
                                                        content: forDisplay[index]['price'] + " \$",
                                                        weight: FontWeight.w500),
                                                  ],
                                                ),
                                                Divider(
                                                  color: theme.grey,
                                                ),
                                                reUse.reUseRowText(
                                                    lableSize: 12.0,
                                                    titleColor: theme.grey,
                                                    title: clsLan.returnTime,
                                                    size: 12.0,
                                                    color: theme.black,
                                                    content:
                                                        "${glb.formatDateTime(forDisplay[index]['returnDate'])}   ",
                                                    weight: FontWeight.w500),
                                              ],
                                            ),
                                          ),
                                        ),
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
                  : Flexible(child: Center(child: Text(clsLan.notHave)))
            ],
          ),
        ),
      ),
    );
  }

  final clsLan = ClsLanguage();
  final fieldInfo = FieldInfo();
  DatabaseReference requestDB = FirebaseDatabase.instance.ref("PackageRequest");
  DatabaseReference returnDB = FirebaseDatabase.instance.ref("Return");
  DatabaseReference driverReturnDB = FirebaseDatabase.instance.ref("DriverReturn");

  optionSelect({opt, data, context}) async {
    if (opt == 0) {
      //await fetchUserInformation();
      await glb.backToReturn(data: data);
      // await glb.deletePackage(witchDataBase: packageRequest,data:data);
      await glb.deleteFromDriver(data: data, witchDataBase: driverReturnDB);
      await glb.deleteFromReturn(data: data, witchDataBase: returnDB);
      setState(() {
        returnList.removeWhere((item) => item == data);
        forDisplay.removeWhere((item) => item == data);
      });
      Get.back();
      reUse.reUseCircleDialog(
          context: context,
          icon: Icons.check_circle_rounded,
          title: 'Success',
          content: Center(
            child: Text(
              'Your package is successfully request',
              style: TextStyle(
                color: theme.black,
              ),
            ),
          ));
    } else {
      await glb.deleteFromDriver(data: data, witchDataBase: driverReturnDB);
      await glb.deleteFromReturn(data: data, witchDataBase: returnDB);
      setState(() {
        returnList.removeWhere((item) => item == data);
        forDisplay.removeWhere((item) => item == data);
      });
    }
  }
}
