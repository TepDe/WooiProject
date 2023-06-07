import 'package:flutter/material.dart';
import 'package:wooiproject/AccountScreen.dart';
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
    const HomeScreen(),
    //ActivityScreen(),
    //NotificationScreen(),
    const AccountScreen(),
  ];

  final themes = ThemesApp();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  tooltip: null,
                  icon: Image.asset(
                    'assets/images/home_icon.png',
                    width: 30,
                    height: 30,
                    //alignment: Alignment.topRight,
                    color: changeColor ?? themes.deepOrange,
                  ),
                  label: 'Home',
                ),
                // BottomNavigationBarItem(
                //   icon: reUseIcon(icons: Icons.menu),
                //   label: 'Activity',
                // ),
                // BottomNavigationBarItem(
                //   icon: Stack(
                //     children: <Widget>[
                //       // Image.asset(
                //       //   'assets/images/box.png',
                //       //   scale: 16,
                //       //   alignment: Alignment.topRight,
                //       //   color: changeColor ?? themes.grey,
                //       // ),
                //       Icon(
                //         Icons.notifications,
                //         size: 40,
                //       ),
                //       Positioned(
                //         right: 0,
                //         child: Container(
                //           padding: EdgeInsets.all(3),
                //           decoration: BoxDecoration(
                //             color: themes.red,
                //             borderRadius: BorderRadius.circular(60),
                //           ),
                //           child: const Text(
                //             '+9',
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 8,
                //             ),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                //   label: 'Notifications',
                // ),
                BottomNavigationBarItem(
                  icon: reUseIcon(icons: Icons.account_circle),
                  label: 'Account',
                ),
              ],
              iconSize: 60,
              unselectedFontSize: 12,
              unselectedLabelStyle: TextStyle(
                  color: themes.deepOrange,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              selectedLabelStyle: TextStyle(
                  color: themes.deepOrange,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              selectedItemColor: themes.deepOrange,
              unselectedItemColor: themes.grey,
              currentIndex: selectedIndex,
              backgroundColor: themes.white,
              type: BottomNavigationBarType.fixed,
              //
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                  if (index == 0) {
                    changeColor = themes.deepOrange;
                  } else {
                    changeColor = themes.grey;
                  }
                });
              },
            ),
            body: viewScreen[selectedIndex]),
      ),
    ));
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
