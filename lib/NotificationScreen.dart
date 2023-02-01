import 'package:flutter/material.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final themes = ThemesApp();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [Text('NotificationScreen'), renderListView()],
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
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 100,
                width: 100,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      // borderRadius: BorderRadius.only(
                      //     topLeft: Radius.circular(25),
                      //     topRight: Radius.circular(25),
                      //     bottomRight: Radius.circular(10),
                      //     bottomLeft: Radius.circular(10))),
                      borderRadius: BorderRadius.circular(12)),
                  tileColor: themes.orange,
                  title: Text('title'),
                  leading: CircleAvatar(
                    backgroundColor: Color(0xff764abc),
                    child: Text('h'),
                  ),
                  // trailing: Text('trailing'),
                  subtitle: Text('subtitle'),
                ),
              ),
            );
          }),
    );
  }
}
