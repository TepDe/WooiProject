import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';

class RenderListDetail extends StatefulWidget {
  const RenderListDetail({Key? key}) : super(key: key);

  @override
  State<RenderListDetail> createState() => _RenderListDetailState();
}

class _RenderListDetailState extends State<RenderListDetail> {
  final reUse = ReUseWidget();
  var argumentData = Get.arguments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: reUse.reUseListTotalPackage(),
      ),
    );
  }
}
