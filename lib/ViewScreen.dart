import 'package:flutter/material.dart';
import 'package:wooiproject/AccountScreen.dart';
import 'package:wooiproject/ActivityScreen.dart';
import 'package:wooiproject/HomeScreen.dart';
import 'package:wooiproject/NotificationScreen.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';


class ViewScreen extends StatefulWidget {
  const ViewScreen({Key? key}) : super(key: key);

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {

  var viewScreen = [
    HomeScreen(),
    ActivityScreen(),
    NotificationScreen(),
    AccountScreen(),
  ];

  final themes = ThemesApp();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: ()async=> false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,

          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: reUseIcon(icons: Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: reUseIcon(icons: Icons.menu),
                label: 'Activity',
              ),
              BottomNavigationBarItem(
                icon: reUseIcon(icons: Icons.notifications),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: reUseIcon(icons: Icons.account_circle),
                label: 'Account',
              ),
            ],
            unselectedFontSize: 12,
            unselectedLabelStyle: TextStyle(color: themes.deepOrange),
            selectedLabelStyle: TextStyle(color: themes.deepOrange,),
            selectedItemColor: themes.deepOrange,
            elevation: 5.0,
            unselectedItemColor: themes.grey,
            currentIndex: selectedIndex,
            backgroundColor: themes.liteOrange,
            type: BottomNavigationBarType.fixed, // Fixed

            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          body:viewScreen[selectedIndex]
        ),
      ),
    );
  }

  int selectedIndex = 0;

  reUseIcon({icons}) {
    return Icon(
      icons,
      size: 40,
    );
  }
}
