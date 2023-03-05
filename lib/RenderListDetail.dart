import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';

import 'WidgetReUse/Themes.dart';

class RenderListDetail extends StatefulWidget {
  const RenderListDetail({Key? key}) : super(key: key);

  @override
  State<RenderListDetail> createState() => _RenderListDetailState();
}

class _RenderListDetailState extends State<RenderListDetail> {
  final reUse = ReUseWidget();
  var argumentData = Get.arguments;
  final theme = ThemesApp();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (argumentData == 0) {
      renderList = reUse.reUseListPackage(removeFoot: true,Title: 'Total Package',headerColor: theme.dirt);
    } else if (argumentData == 1) {
      renderList = reUse.reUseListPackage(Title: 'Pending',headerColor: theme.orange);
    } else if (argumentData == 2) {
      renderList = reUse.reUseListPackage(Title: 'Complete',headerColor: theme.liteGreen);
    } else if (argumentData == 3) {
      renderList = reUse.reUseListPackage(Title: 'Return',headerColor: theme.liteRed);
    }
  }

  var renderList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: renderList),
    );
  }
}
