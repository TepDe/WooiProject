import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/GlobalControl/clsField.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';

class PendingDetail extends StatefulWidget {
  const PendingDetail({Key? key}) : super(key: key);

  @override
  State<PendingDetail> createState() => _PendingDetailState();
}

class _PendingDetailState extends State<PendingDetail> {
  final reUse = ReUseWidget();
  final theme = ThemesApp();
  final glb = GlobalController();
  final search = TextEditingController();
  final clsLan = ClsLanguage();
  final field = FieldData();
  final fieldInfo = FieldInfo();

  var forDisplay;

  var labelSize = 14.0;
  var valueSize = 14.0;

  var argumentData = Get.arguments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    forDisplay = argumentData;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.liteOrange,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: TextButton.icon(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              color: theme.white,
            ),
            label: Text(
              "${forDisplay[field.packageID]}",
              style: TextStyle(
                  fontSize: 18,
                  color: theme.white,
                  //color: titleColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                reUse.reUseRowText(
                    titleColor: theme.grey,
                    title: clsLan.packageID,
                    size: valueSize,
                    lableSize: labelSize,
                    color: theme.black,
                    content: forDisplay[field.packageID],
                    weight: FontWeight.w500),
                reUse.reUseRowText(
                    titleColor: theme.grey,
                    title: clsLan.createDate,
                    size: valueSize,
                    lableSize: labelSize,
                    color: theme.black,
                    content: forDisplay[field.date],
                    weight: FontWeight.w500),
                reUse.reUseRowText(
                    titleColor: theme.grey,
                    title: clsLan.receiverLocation,
                    size: valueSize,
                    lableSize: labelSize,
                    color: theme.black,
                    content: forDisplay['location'],
                    weight: FontWeight.w500),
                reUse.reUseRowText(
                    titleColor: theme.grey,
                    title: clsLan.qty,
                    size: valueSize,
                    lableSize: labelSize,
                    color: theme.black,
                    content: forDisplay[field.qty],
                    weight: FontWeight.w500),
                reUse.reUseRowText(
                    titleColor: theme.grey,
                    title: clsLan.assignDate,
                    size: valueSize,
                    lableSize: labelSize,
                    color: theme.black,
                    content: forDisplay[field.assignDate],
                    weight: FontWeight.w500),
                reUse.reUseRowText(
                    lableSize: labelSize,
                    titleColor: theme.grey,
                    title: clsLan.receiverPhoneNumber,
                    size: valueSize,
                    color: theme.black,
                    content: forDisplay['phoneNumber'],
                    weight: FontWeight.w500),
                reUse.reUseRowText(
                    lableSize: labelSize,
                    titleColor: theme.grey,
                    title: clsLan.bankCode,
                    size: valueSize,
                    color: theme.black,
                    content: forDisplay[field.bankCode],
                    weight: FontWeight.w500),
                reUse.reUseText(
                    weight: FontWeight.w500, size: labelSize, color: theme.grey, content: '${clsLan.note} : '),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Container(
                        width: Get.width,
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(8.0),
                        // decoration: BoxDecoration(
                        //     border: Border.all(color: theme.grey)),
                        child: reUse.reUseTextNote(
                            weight: FontWeight.w400, size: 14.0, color: theme.black, content: forDisplay['note'] ?? ""),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: Get.width,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: theme.minGrey,
                        blurRadius: 1,
                        //offset: Offset(4, 8), // Shadow position
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      reUse.reUseRowText(
                          titleColor: theme.grey,
                          title: clsLan.driverName,
                          size: valueSize,
                          lableSize: labelSize,
                          color: theme.black,
                          content: forDisplay[field.dFirstName]+forDisplay[field.dLastName],
                          weight: FontWeight.w500),
                      reUse.reUseRowText(
                          titleColor: theme.grey,
                          title: clsLan.driverPhone,
                          size: valueSize,
                          lableSize: labelSize,
                          color: theme.black,
                          content: forDisplay[field.dPhone] ?? "No Phone",
                          weight: FontWeight.w500),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          reUse.reUseText(
                              size: labelSize, weight: FontWeight.w500, color: theme.grey, content: clsLan.price),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.blue,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            child: Center(
                                child: reUse.reUseText(
                                    weight: FontWeight.bold,
                                    size: 16.0,
                                    color: theme.white,
                                    content: forDisplay['price'] + " \$")),
                          )
                        ],
                      ),
                      reUse.reUseRowText(
                          titleColor: theme.grey,
                          title: clsLan.status,
                          size: valueSize,
                          lableSize: labelSize,
                          color: theme.black,
                          content: clsLan.stPend,
                          weight: FontWeight.w500),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Row(
                      //       children: [
                      //         reUse.reUseText(
                      //             weight: FontWeight.w400,
                      //             size: labelSize,
                      //             color: theme.grey,
                      //             content: '${clsLan.complete} : '),
                      //         reUse.reUseText(
                      //             weight: FontWeight.bold,
                      //             size: valueSize,
                      //             color: theme.black,
                      //             content: forDisplay['completeDate']),
                      //       ],
                      //     ),
                      //     // Container(
                      //     //   decoration: BoxDecoration(
                      //     //     color: theme.litestGreen,
                      //     //     borderRadius: BorderRadius.circular(6),
                      //     //   ),
                      //     //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      //     //   child: reUse.reUseText(
                      //     //       weight: FontWeight.bold, size: 12.0, color: theme.liteGreen, content: clsLan.stCom),
                      //     // )
                      //   ],
                      // ),
                      // reUse.reUseRowText(
                      //     titleColor: theme.grey,
                      //     title: clsLan.qty,
                      //     size: valueSize,
                      //     lableSize: labelSize,
                      //     color: theme.black,
                      //     content: forDisplay['price'],
                      //     weight: FontWeight.w500),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}