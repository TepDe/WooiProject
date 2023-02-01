import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wooiproject/HomeScreen.dart';
import 'package:wooiproject/MapScreen.dart';
import 'package:wooiproject/ProfileScreen.dart';
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
                    Get.to(HomeScreen());
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
        children: [
          IconButton(
              iconSize: 40,
              splashRadius: 30,
              onPressed: () {},
              icon: Center(
                child: Icon(
                  Icons.menu,
                  color: theme.deepOrange,
                ),
              )),
          Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/images/WooiIcon.png',
                height: 100,
                width: 100,
              )),
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
                style:
                    TextStyle(color: theme.black, fontWeight: FontWeight.bold),
              ),
              Text('ID 003121',
                  style: TextStyle(
                      fontSize: 20,
                      color: theme.grey,
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

          Divider(color: theme.deepOrange,)
        ],
      ),
    );
  }

  unitTwoHomeScreen() {
    return Padding(
      padding: EdgeInsets.only(left: 18.0, top: 30, right: 18),
      child: Container(
        width: Get.width,
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Flexible(
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: unitTwoText(label: "Total package", qty: '21'),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: unitTwoText(label: "In process", qty: '14'),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Total Shipped',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: theme.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text('102',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 25,
                                    color: theme.grey,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  unitTwoText({label, qty}) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: theme.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                '$label',
                style: TextStyle(
                    fontSize: 15,
                    color: theme.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text('$qty',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 25,
                      color: theme.grey,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  unitThreeHomeScreen({icon, lable, price, funtion, context}) {
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
            color: theme.orange,
            borderRadius: BorderRadius.circular(10),
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


}
