import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wooiproject/Distination/language.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/GlobalControl/clsField.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';

class PendingDetail extends StatefulWidget {
  const PendingDetail({super.key});

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

  Map forDisplay ={};

  var labelSize = 14.0;
  var valueSize = 14.0;

  var argumentData = Get.arguments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      forDisplay = argumentData;
    });
  }
  String getBank() {
    var result = glb.payWay.where((person) => person['name'] == forDisplay['bankName']);
    return result.first['img'].toString();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_outlined,
                color: theme.black,
              ),
              label: Text(
                "វិក្កយបត្រ",
                style: TextStyle(
                    fontSize: 18,
                    color: theme.black,
                    //color: titleColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            reUse.reUseStatusBox(value: clsLan.stPend, color: theme.litestOrange,textColor: theme.orange),

          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                    content: glb.formatDateTime(forDisplay[field.date]),
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
                    content: glb.formatDateTime(forDisplay[field.assignDate]),
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
                    title: clsLan.bankName,
                    size: valueSize,
                    color: theme.black,
                    content: forDisplay["bankName"].toString().toUpperCase(),
                    weight: FontWeight.w500),
                reUse.reUseRowText(
                    lableSize: labelSize,
                    titleColor: theme.grey,
                    title: clsLan.bankCode,
                    size: valueSize,
                    color: theme.black,
                    content: forDisplay[field.bankCode].toString().toUpperCase(),
                    weight: FontWeight.w500),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(height: 100, child: Image(image: AssetImage(getBank()))),
                ),
                reUse.reUseText(
                    weight: FontWeight.w500, size: labelSize, color: theme.grey, content: '${clsLan.note} : '),
                Container(
                  width: Get.width,
                  height: forDisplay['note'] == '' ? 100 : null,
                  margin: const EdgeInsets.symmetric(vertical: 15.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    border: Border.all(color: theme.midGrey, width: 1.5),
                  ),
                  child: reUse.reUseTextNote(
                      weight: FontWeight.w400,
                      size: 14.0,
                      color: theme.black,
                      content: forDisplay['note'] ?? "(មិនមានបញ្ចូល)"),
                ),
                // reUse.reUseText(
                //     weight: FontWeight.w500, size: labelSize, color: theme.grey, content: '${clsLan.returnReason} : '),
                // Container(
                //   width: Get.width,
                //   height: forDisplay['note'] == '' ? 100 : null,
                //   margin: const EdgeInsets.symmetric(vertical: 15.0),
                //   padding: const EdgeInsets.all(10.0),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(5),
                //     color: Colors.white,
                //     border: Border.all(color: theme.midGrey, width: 1.5),
                //   ),
                //   child: reUse.reUseTextNote(
                //       weight: FontWeight.w400,
                //       size: 14.0,
                //       color: theme.black,
                //       content: forDisplay['returnNote'] ?? ""),
                // ),
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
                          content: "${forDisplay[field.dFirstName]} ${forDisplay[field.dLastName]}",
                          weight: FontWeight.w500),
                      reUse.reUseRowText(
                          titleColor: theme.grey,
                          title: clsLan.driverPhone,
                          size: valueSize,
                          lableSize: labelSize,
                          color: theme.black,
                          content: forDisplay["dPhoneNumber"],
                          weight: FontWeight.w500),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          reUse.reUseText(
                              size: labelSize, weight: FontWeight.w500, color: theme.grey, content: clsLan.price),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
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
