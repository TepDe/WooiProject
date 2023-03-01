import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  final reUse = ReUseWidget();
  final theme = ThemesApp();
  final hsc = Get.put(HomeScreenController());
  var _controller;

  @override
  void dispose() {
    _controller.dispose();
  }

  exitApp() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exitApp(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  reUse.topBarHomeScreen(),
                  reUse.unitOneHomeScreen(function: 'profile'),
                  reUse.unitTwoHomeScreen(),
                ],
              ),
              reUse.reUseCustomizeButton(),
              //wr.unitThreeHomeScreen(icon: Icons.directions_car, lable: 'Car',price: '2143', funtion: 'motor',context: context),
              // wr.unitThreeHomeScreen(icon: Icons.motorcycle, lable: 'Motorcycle',price: '2143', funtion: '',context: context),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreenController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserLocation();
  }

  late Position position;
  late LatLng currentPostion;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  void getUserLocation() async {
    position = await GeolocatorPlatform.instance.getCurrentPosition();
    update();
    currentPostion = LatLng(position.latitude, position.longitude);
    latitude.value = position.latitude;
    longitude.value = position.longitude;
    update();
  }
}
