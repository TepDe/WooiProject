import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';

// class HomeScreenFull extends StatefulWidget {
//   const HomeScreenFull({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreenFull> createState() => _HomeScreenFullState();
// }
//
// class _HomeScreenFullState extends State<HomeScreenFull> {
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope( onWillPop: ()=>  _controller, child: const Placeholder());
//   }
// }


class HomeScreen extends StatelessWidget {
  final wr = ReUseWidget();
  final theme = ThemesApp();
  var _controller;
  @override
  void dispose() {

    _controller.dispose();

  }
  exitApp(){
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () =>exitApp(),
      child: SafeArea(

        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
            children: [

              wr.topBarHomeScreen(),
              wr.unitOneHomeScreen(function: 'profile'),
              wr.unitTwoHomeScreen(),
              wr.unitThreeHomeScreen(icon: Icons.directions_car, lable: 'Car',price: '2143', funtion: 'motor',context: context),
              wr.unitThreeHomeScreen(icon: Icons.motorcycle, lable: 'Motorcycle',price: '2143', funtion: '',context: context),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreenController extends GetxController {}
