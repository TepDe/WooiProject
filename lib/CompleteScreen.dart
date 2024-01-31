import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wooiproject/CompleteDetail.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/GlobalControl/clsField.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onInitialize();
  }

  onInitialize() {
    completeList = argumentData;
    forDisplay = glb.sortNewest(argumentData, "completeDate");
    setState(() {});
  }

  final search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/CompleteHead.png"),
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
                            color: theme.green,
                          ),
                          label: Text(
                            clsLan.stCom,
                            style: TextStyle(
                                color: theme.green,
                                fontSize: 18,
                                // color: titleColor,
                                fontWeight: FontWeight.bold),
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
                                  forDisplay = completeList;
                                  FocusManager.instance.primaryFocus?.unfocus();
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
                          color: theme.litestGreen,
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
                              forDisplay = glb.onSearch(completeList, search.text);
                              setState(() {});
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            icon: Icon(
                              Icons.search,
                              color: theme.green,
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
                      color: theme.litestGreen,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: PopupMenuButton<String>(
                      icon: Icon(
                        Icons.sort_rounded,
                        color: theme.green,
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
                        List lstData = List.from(completeList);
                        if (value == "old") {
                          forDisplay = glb.sortOldest(lstData, "completeDate");
                        } else if (value == "new") {
                          forDisplay = glb.sortNewest(lstData, "completeDate");
                        } else {
                          forDisplay = glb.onSortToday(lstData, "completeDate");
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
                                              Get.to(() => const CompleteDetail(), arguments: {
                                                "data": forDisplay[index],
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      reUse.reUseText(
                                                          weight: FontWeight.w400,
                                                          size: 12.0,
                                                          color: theme.grey,
                                                          content: "${index + 1}./  ${clsLan.packageID}"),
                                                      Row(
                                                        children: [
                                                          reUse.reUseText(
                                                              weight: FontWeight.bold,
                                                              size: 16.0,
                                                              color: theme.blue,
                                                              content: forDisplay[index]['packageID']),
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
                                                  reUse.reUseRowText(
                                                      lableSize: 12.0,
                                                      titleColor: theme.grey,
                                                      title: clsLan.completeDate,
                                                      size: 14.0,
                                                      color: theme.black,
                                                      // content:
                                                      //     "${forDisplay[index][field.completeDate]}   ",
                                                      content:
                                                          glb.formatDateTime(forDisplay[index][field.completeDate]),
                                                      weight: FontWeight.w500),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    })),
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
  final field = FieldData();

  removeItem({keyIndex, listIndex}) async {
    DatabaseReference packageRequest = FirebaseDatabase.instance.ref("PackageRequest");
    await packageRequest.child(glb.auth.currentUser!.uid).child('package').child(keyIndex).remove();
    completeList.removeWhere((item) => item == listIndex);
    // keyList.removeWhere((item) => item == keyIndex);
    // forDisplay = totalList;
    setState(() {});
  }
}
