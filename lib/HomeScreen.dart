import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';
import 'package:wooiproject/WidgetReUse/WidGetReUse.dart';

class HomeScreen extends StatelessWidget {
  final wr = WidgetReUse();
  final theme = ThemesApp();

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
          children: [
            wr.topBarHomeScreen(),
            wr.unitOneHomeScreen(function: 'profile'),
            wr.unitTwoHomeScreen(),
            wr.unitThreeHomeScreen(icon: Icons.directions_car, lable: 'Car',price: '2143', funtion: 'motor'),
            wr.unitThreeHomeScreen(icon: Icons.motorcycle, lable: 'Motorcycle',price: '2143', funtion: ''),
          ],
        ),
      ),
    );
  }
}

class HomeScreenController extends GetxController {}
