import 'package:flutter/material.dart';
import 'package:wooiproject/WidgetReUse/WidGetReUse.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // wdTextField(),
            // wdTextField(),
            // wdTextField(),
            wr.topButtonLeft(icon: Icons.arrow_back_ios_sharp),
            wr.unitProfile(),
            wr.signInForm(),

          ],

        ),
      ),
    );
  }

  final gettext = TextEditingController();
  final wr = WidgetReUse();


  wdTextField() {
    return TextField(
      controller: gettext,
    );
  }
}
