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
    //ActivityScreen(),
    NotificationScreen(),
    AccountScreen(),
  ];

  final themes = ThemesApp();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: reUseIcon(icons: Icons.home),
                  label: 'Home',
                ),
                // BottomNavigationBarItem(
                //   icon: reUseIcon(icons: Icons.menu),
                //   label: 'Activity',
                // ),
                BottomNavigationBarItem(
                  icon: Stack(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/box.png',
                        scale: 16,
                        alignment: Alignment.topRight,
                        color: changeColor ?? themes.grey,
                      ),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: themes.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '+9',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                  label: 'Notifications',
                ),
                BottomNavigationBarItem(
                  icon: reUseIcon(icons: Icons.account_circle),
                  label: 'Account',
                ),
              ],
              iconSize: 60,
              unselectedFontSize: 12,
              unselectedLabelStyle:
                  TextStyle(color: themes.deepOrange, fontSize: 0),
              selectedLabelStyle:
                  TextStyle(color: themes.deepOrange, fontSize: 0),
              selectedItemColor: themes.deepOrange,
              unselectedItemColor: themes.grey,
              currentIndex: selectedIndex,
              backgroundColor: themes.white,
              type: BottomNavigationBarType.fixed,
              //
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                  if (index == 1) {
                    changeColor = themes.deepOrange;
                  } else {
                    changeColor = themes.grey;
                  }
                });
              },
            ),
            body: viewScreen[selectedIndex]),
      ),
    );
  }

  int selectedIndex = 0;
  var changeColor;

  reUseIcon({icons}) {
    return Icon(
      icons,
      size: 40,
    );
  }
}
