import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          wdTextField(),
          wdTextField(),
          wdTextField(),
        ],

      ),
    );
  }

  final gettext = TextEditingController();

  wdTextField() {
    return TextField(
      controller: gettext,
    );
  }
}
