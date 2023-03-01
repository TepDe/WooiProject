import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wooiproject/HomeScreen.dart';
import 'package:wooiproject/MapScreen.dart';
import 'package:wooiproject/ProfileScreen.dart';
import 'package:wooiproject/RenderListDetail.dart';
import 'package:wooiproject/ViewScreen.dart';
import 'package:wooiproject/WidgetReUse/SuperController.dart';
import 'package:wooiproject/WidgetReUse/Themes.dart';

class ReUseWidget extends GetxController {
  topButtonLeft({function, icon}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.yellow,
          ),
          child: Center(
            child: IconButton(
                splashColor: Colors.grey,
                color: Colors.black,
                onPressed: () {
                  if (function == 'home') {
                    Get.to(ViewScreen());
                  }
                },
                icon: Icon(icon)),
          ),
        ),
      ),
    );
  }

  final msc = Get.put(MapScreenController());
  late GoogleMapController mapController;
  final theme = ThemesApp();

  topButtonRight({function, icon}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.yellow,
          ),
          child: IconButton(
              splashColor: Colors.grey,
              color: Colors.black,
              onPressed: () {
                if (function == 'crlocation') {
                  msc.request();
                  msc.moveCamera();
                }
              },
              icon: Icon(icon)),
        ),
      ),
    );
  }

  topBarHomeScreen() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          // IconButton(
          //     iconSize: 40,
          //     splashRadius: 30,
          //     onPressed: () {},
          //     icon: Center(
          //       child: Icon(
          //         Icons.menu,
          //         color: theme.deepOrange,
          //       ),
          //     )),
          // Align(
          //     alignment: Alignment.topCenter,
          //     child: Image.asset(
          //       'assets/images/WooiIcon.png',
          //       height: 100,
          //       width: 100,
          //     )),
          SizedBox(
            height: 0,
            width: 0,
          )
        ],
      ),
    );
  }

  unitOneHomeScreen({function}) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, top: 20, right: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning',
                style: TextStyle(
                    color: theme.darkGrey, fontWeight: FontWeight.bold),
              ),
              Text('ID 003121',
                  style: TextStyle(
                      fontSize: 20,
                      color: theme.black,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          InkWell(
            onTap: () {
              if (function == 'profile') {
                Get.to(ProfileScreen());
              }
            },
            child: Icon(
              Icons.account_circle,
              size: 60,
            ),
          )
        ],
      ),
    );
  }

  reUseTopBar({name}) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
                color: theme.deepOrange,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: TextStyle(
                  color: theme.deepOrange,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            color: theme.deepOrange,
          )
        ],
      ),
    );
  }

  unitTwoHomeScreen() {
    return Container(
      width: Get.width,
      margin: EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: InkWell(
                  onTap: () {
                    Get.to(
                      RenderListDetail(),
                      arguments: 0,
                    );
                  },
                  child: unitTwoText(label: "Total package", qty: '21'),
                ),
              ),
              Flexible(
                child: InkWell(
                  onTap: () {
                    Get.to(
                      RenderListDetail(),
                      arguments: 1,
                    );
                  },
                  child: unitTwoText(label: "In process", qty: '14'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                  child: InkWell(
                onTap: () {
                  Get.to(
                    RenderListDetail(),
                    arguments: 2,
                  );
                },
                child: unitTwoText(label: "Complete", qty: '14'),
              )),
              Flexible(
                  child: InkWell(
                onTap: () {
                  Get.to(
                    RenderListDetail(),
                    arguments: 3,
                  );
                },
                child: unitTwoText(label: "Return Ship", qty: '14'),
              )),
            ],
          )
        ],
      ),
    );
  }

  unitTwoText({label, qty}) {
    return Container(
      width: Get.width,
      height: 100,
      padding: EdgeInsets.all(9),
      margin: EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: theme.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2,
            //offset: Offset(4, 8), // Shadow position
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label',
            style: TextStyle(
                fontSize: 12, color: theme.grey, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/box.png',
                height: 30,
                width: 30,
                color: theme.orange,
              ),
              Row(
                children: [
                  Text('$qty',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 25,
                          color: theme.black,
                          fontWeight: FontWeight.bold)),
                  Text('pc',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 10,
                          color: theme.minGrey,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  unitThreeHomeScreen(
      {icon, lable, price, funtion, context, latitude, longitude}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 18, right: 18),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.transparent,
        onTap: () {
          Get.to(MapScreen());
        },
        child: Container(
          decoration: BoxDecoration(
            color: theme.midGrey,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2,
                //offset: Offset(4, 8), // Shadow position
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    icon,
                    size: 60,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(lable,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 15,
                                color: theme.black,
                                fontWeight: FontWeight.bold)),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(price,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 15,
                                color: theme.black,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  unitProfile() {
    return const Padding(
      padding: EdgeInsets.all(18.0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        leading: Icon(
          Icons.account_circle,
          size: 80,
        ),
        title: Center(
          child: Text(
            '',
          ),
        ),
        subtitle: Text(
          'Name',
        ),
        trailing: Icon(
          Icons.edit,
        ),
      ),
    );
  }

  signInForm() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: nameControl,
            decoration: InputDecoration(
              fillColor: Colors.blue,
              border: OutlineInputBorder(),
              hintText: 'Name',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: phoneControl,
            decoration: InputDecoration(
              fillColor: Colors.blue,
              border: OutlineInputBorder(),
              hintText: 'Phone Number',
            ),
          ),
        ),
        // reuseTextField(label: 'Phone Number'),
        reuseButton(label: 'Confirm', function: 'storeUserLogin')
      ],
    );
  }

  final nameControl = TextEditingController();
  final phoneControl = TextEditingController();

  reUseSearchBox({label}) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          //color: theme.liteOrange,
          //borderRadius: BorderRadius.circular(6),
          // boxShadow: [
          //   BoxShadow(
          //     color: theme.grey,
          //     blurRadius: 4,
          //     offset: Offset(0, 1), // Shadow position
          //   ),
          // ],
          ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  splashRadius: 25,
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back)),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Total Package',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: Colors.transparent,
                  )),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Flexible(
                flex: 8,
                child: TextField(
                  controller: nameControl,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.minGrey,
                    hintText: 'Search',

                    // contentPadding:
                    // EdgeInsets.only(left: 14.0, bottom: 12.0, top: 12.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                  ),
                ),
              ),
              Flexible(
                  child: IconButton(onPressed: () {}, icon: Icon(Icons.search)))
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Flexible(
                  child: Container(
                color: theme.grey,
                width: Get.width,
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 10),
              )),
              const Text('Total: 12')
            ],
          ),
        ],
      ),
    );
  }

  final gsc = Get.put(GlbSuperController());

  reuseButton({label, function}) {
    return Container(
      width: Get.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: theme.deepOrange),
        child: Text(
          "$label",
          style: const TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          if (function == 'storeUserLogin') {
            print('${nameControl.text} ${phoneControl.text}');
            gsc.storeUserLogin(
                name: nameControl.text, phone: phoneControl.text);
            // gsc.storeUserLogin(name: '',phone:'' );
          }
          if (function == 'requestDriver') {
            if (gsc.requestStatus == 'Request') {
              gsc.onRequestLocation();
              gsc.requestStatus.value = 'Cancel';
            } else if (gsc.requestStatus == 'Cancel') {
              gsc.removeRequest();
            }
          }
        },
      ),
    );
  }

  ruTextBox({hind, icon, controller, obscureText}) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 3, bottom: 3),
      decoration: BoxDecoration(
          color: theme.liteGrey, borderRadius: BorderRadius.circular(9)),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          //<-- SEE HERE
          fillColor: theme.liteGrey,
          //iconColor: theme.grey,
          //enabled: true,
          //focusColor: Colors.grey,
          //prefix: Icon(Icons.phone),
          border: InputBorder.none,
          icon: icon,
          hintText: hind,
        ),
      ),
    );
  }

  renderListView() {
    return Expanded(
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: 12,
          itemBuilder: (BuildContext context, int index) {
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      height: constraints.maxWidth / 3.9,
                      width: constraints.maxWidth / 3.9,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: theme.litestOrange),
                      child: Align(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Text(
                              "Done",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: theme.liteGreen,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Lipsum generator',
                            style: TextStyle(
                                fontSize: constraints.maxWidth / 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          ///color: Colors.red,
                          width: constraints.maxWidth / 1.45,
                          child: Text(
                            'Lorem ipsum គ្រាន់តែជាអត្ថបទអត់ចេះសោះនៃឧស្សាហកម្មបោះពុម្ពនិងកំណត់ប្រភេទ។ Lorem Ipsum គឺជាអត្ថបទថុមស',
                            style: TextStyle(
                              fontSize: constraints.maxWidth / 30,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        )
                      ],
                    ),
                  ],
                );
              },
            );
          }),
    );
  }

  reUseCustomizeButton() {
    return Container(
      width: Get.width,
      height: 50,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.liteOrange,
        borderRadius: BorderRadius.circular(6),
        // boxShadow: [
        //   BoxShadow(
        //     color: theme.grey,
        //     blurRadius: 4,
        //     offset: Offset(0, 1), // Shadow position
        //   ),
        // ],
      ),
      child: TextButton.icon(
        // style: ButtonStyle(
        //   // overlayColor:
        //   //     MaterialStateColor.resolveWith((states) => Colors.white70),
        //
        // ),
        onPressed: () {},
        icon: Image.asset(
          'assets/images/box.png',
          height: 20,
          width: 20,
          color: theme.orange,
        ),
        label: Text(
          'Create',
          style: TextStyle(
            color: theme.orange,
          ),
        ),
      ),
    );
  }

  reuseTextField({label}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: nameControl,
        decoration: InputDecoration(
          fillColor: Colors.blue,
          border: OutlineInputBorder(),
          hintText: '$label',
        ),
      ),
    );
  }

  reUseListTotalPackage() {
    return Column(
      children: [reUseSearchBox(label: 'Search')],
    );
  }
}
