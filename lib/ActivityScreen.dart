import 'package:flutter/material.dart';
import 'package:wooiproject/WidgetReUse/ReUseWidget.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final themes = ThemesApp();
  final ru = ReUseWidget();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ru.reUseTopBar(name: 'Activity'), renderListView()],
        ),
      ),
    );
  }

  renderListView() {
    return Flexible(
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: 12,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                height: 120,
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    color: themes.orange,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    reuseText(),
                    reuseText(),
                    reuseText(),
                    reuseText(),
                  ],
                ),
              ),
            );
          }),
    );
  }

  reuseText() {
    return Text(
      'data : ',
      style: TextStyle(color: themes.black, fontSize: 16),
    );
  }
}
