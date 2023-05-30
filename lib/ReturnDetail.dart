import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/GlobalControl/clsField.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';

class ReturnDetail extends StatefulWidget {
  const ReturnDetail({Key? key}) : super(key: key);

  @override
  State<ReturnDetail> createState() => _ReturnDetailState();
}

class _ReturnDetailState extends State<ReturnDetail> {
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
          automaticallyImplyLeading: false,
          elevation: 0,
          title: TextButton.icon(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: theme.black,
            ),
            label: Text(
              clsLan.returns,
              style: TextStyle(
                  fontSize: 18,
                  color: theme.black,
                  //color: titleColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          width: Get.width,
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.liteGrey,
            borderRadius: BorderRadius.circular(6),
            // boxShadow: [
            //   BoxShadow(
            //     color: theme.minGrey,
            //     blurRadius: 4,
            //     offset: const Offset(0, 0), // Shadow position
            //   ),
            // ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      reUse.reUseText(
                          weight: FontWeight.w400,
                          size: 16.0,
                          color: theme.grey,
                          content: '${clsLan.packageID} :'),
                      Row(
                        children: [
                          reUse.reUseText(
                              weight: FontWeight.bold,
                              size: 16.0,
                              color: theme.blue,
                              content: forDisplay['packageID']),
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: PopupMenuButton<int>(
                              onSelected: (item) {
                                // optionSelect(
                                //     opt: item,
                                //     data: forDisplay[index]);
                                setState(() {});
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem<int>(
                                    value: 0, child: Text('Back to Request')),
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // reUse.reSetUseText(
                      //     titleColor: theme.grey,
                      //     title: 'Destination',
                      //     size: 14.0,
                      //     color: theme.black,
                      //     content: forDisplay[index]['location'],
                      //     weight: FontWeight.w500),
                      reUse.reUseRowText(
                          titleColor: theme.grey,
                          title: clsLan.receiverLocation,
                          size: valueSize,
                          lableSize: labelSize,
                          color: theme.black,
                          content: forDisplay['location'],
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
                          titleColor: theme.grey,
                          title: clsLan.qty,
                          size: valueSize,
                          lableSize: labelSize,
                          color: theme.black,
                          content: forDisplay['price'],
                          weight: FontWeight.w500),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        reUse.reUseText(
                            size: labelSize,
                            weight: FontWeight.w500,
                            color: theme.grey,
                            content: clsLan.price),
                        Container(
                          margin: EdgeInsets.all(8),
                           decoration: BoxDecoration(
                            color: theme.blue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          child: Center(
                              child: reUse.reUseText(
                                  weight: FontWeight.bold,
                                  size: 16.0,
                                  color: theme.white,
                                  content: forDisplay['price'] + " \$")),
                        )
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      reUse.reUseText(
                          weight: FontWeight.w500,
                          size: labelSize,
                          color: theme.grey,
                          content: '${clsLan.note} : '),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              color: theme.black,
                              content: forDisplay['note'] ?? "No reason"),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      reUse.reUseText(
                          weight: FontWeight.w400,
                          size: labelSize,
                          color: theme.grey,
                          content: '${clsLan.createDate} : '),
                      reUse.reUseText(
                          weight: FontWeight.bold,
                          size: valueSize,
                          color: theme.black,
                          content: forDisplay['date']),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        reUse.reUseColumnText(
                            lableSize: labelSize,
                            titleColor: theme.grey,
                            title: clsLan.driverName,
                            size: valueSize,
                            color: theme.black,
                            content: forDisplay[field.assignBy] ?? "No price",
                            weight: FontWeight.w500),
                        reUse.reUseColumnText(
                            lableSize: labelSize,
                            titleColor: theme.grey,
                            title: clsLan.driverPhone,
                            size: valueSize,
                            color: theme.black,
                            content: forDisplay[field.dPhone]?? "No Phone",
                            weight: FontWeight.w500),
                        // reUse.reUseColumnText(
                        //     lableSize: labelSize,
                        //     titleColor: theme.grey,
                        //     title: clsLan.price,
                        //     size: valueSize,
                        //     color: theme.black,
                        //     content: forDisplay['price'] + " \$" ?? "No price",
                        //     weight: FontWeight.w500),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      reUse.reUseText(
                          weight: FontWeight.w400,
                          size: labelSize,
                          color: theme.grey,
                          content: '${clsLan.returnReason} : '),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              color: theme.black,
                              content: forDisplay['returnNote']),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            reUse.reUseText(
                                weight: FontWeight.w400,
                                size: labelSize,
                                color: theme.grey,
                                content: '${clsLan.returnTime} : '),
                            reUse.reUseText(
                                weight: FontWeight.bold,
                                size: valueSize,
                                color: theme.black,
                                content: forDisplay['date']),

                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.litestRed,
                            borderRadius:
                            BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          child: reUse.reUseText(
                              weight: FontWeight.bold,
                              size: 12.0,
                              color: theme.liteRed,
                              content: clsLan.stReturn),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
