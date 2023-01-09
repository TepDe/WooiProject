import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';
import 'package:wooiproject/WidgetReUse/WidGetReUse.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({Key? key}) : super(key: key);

  final wr = WidgetReUse();
  final textphone = TextEditingController();
  final theme = ThemesApp();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
              ),
              Text('Log In',
                  style: TextStyle(
                      fontSize: 24,
                      color: theme.black,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: theme.liteGrey,
                    borderRadius: BorderRadius.circular(6)),
                child: TextField(
                  controller: textphone,
                  decoration: InputDecoration(
                    filled: true,
                    //<-- SEE HERE
                    fillColor: theme.liteGrey,
                    //iconColor: theme.grey,
                    //enabled: true,
                    //focusColor: Colors.grey,
                    //prefix: Icon(Icons.phone),
                    border: InputBorder.none,
                    icon: Icon(Icons.phone),
                    hintText: 'Enter your phone number',
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius:1,
                        blurRadius: 3,
                        //offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                      color: theme.yellow,
                      borderRadius: BorderRadius.circular(6)),
                  child: FlatButton(onPressed: () {}, child: Text('Confirm')))
            ],
          ),
        ),
      ),
    );
  }
}
