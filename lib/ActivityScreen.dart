import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    onDisplayDriver();
  }

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

  final List<LatLng> _latLen = <LatLng>[];
  List itemQty=[];

  onDisplayDriver() async {
    DatabaseReference refs = FirebaseDatabase.instance.ref('Driver');
    refs.onValue.listen((event) async {
      _latLen.clear();
      DataSnapshot location = event.snapshot;
      Map drvData = location.value as Map;
      drvData.forEach((key, value) async {
        _latLen.add(LatLng(value['latitude'], value['longitude']));
        //loadData(_latLen);
      });
    });
  }

  renderListView() {
    return Flexible(
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _latLen.length,
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
                    reuseText(content: itemQty[index]),
                    reuseText(),
                  ],
                ),
              ),
            );
          }),
    );
  }

  reuseText({label,content}) {
    return Text(
      '$label : $content',
      style: TextStyle(color: themes.black, fontSize: 16),
    );
  }
}
