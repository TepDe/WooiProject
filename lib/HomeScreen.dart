import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wooiproject/GlobalControl/GlobalController.dart';
import 'package:wooiproject/GlobalControl/StorageKey.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final reUse = ReUseWidget();
  final theme = ThemesApp();
  final glb = GlobalController();

  exitApp() {
    SystemNavigator.pop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userid();
  }

  String getUserID = '';
  String package = '';
  final str = StorageKey();

  userid() async {
    final prefs = await SharedPreferences.getInstance();
    getUserID = prefs.getString(str.userID).toString();
    package = prefs.getString(str.totalPackage).toString();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    var viewHeight = MediaQuery.of(context).size.height * 0.3;

    return WillPopScope(
        onWillPop: () => exitApp(),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Container(
                  height: viewHeight,
                  decoration: BoxDecoration(
                    color: theme.liteOrange,
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(
                            MediaQuery.of(context).size.width, 100.0)),
                  ),
                ),
                Column(
                  children: [
                    reUse.topBarHomeScreen(),
                    reUse.unitOneHomeScreen(userID: 'ID $getUserID'),
                    reUse.unitTwoHomeScreen(package),
                    //wr.unitThreeHomeScreen(icon: Icons.directions_car, lable: 'Car',price: '2143', funtion: 'motor',context: context),
                    // wr.unitThreeHomeScreen(icon: Icons.motorcycle, lable: 'Motorcycle',price: '2143', funtion: '',context: context),
                    //reUse.renderListView(),
                    reUse.reUseCustomizeButton(context)
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
