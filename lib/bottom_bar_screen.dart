import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie_customer/AppGlobal.dart';
import 'package:foodie_customer/constants.dart';
import 'package:foodie_customer/main.dart';
import 'package:foodie_customer/model/CurrencyModel.dart';
import 'package:foodie_customer/services/FirebaseHelper.dart';
import 'package:foodie_customer/services/helper.dart';
import 'package:foodie_customer/ui/cartScreen/CartScreen.dart';
import 'package:foodie_customer/ui/container/ContainerScreen.dart';
import 'package:foodie_customer/ui/home/HomeScreen.dart';
import 'package:foodie_customer/ui/home/home_screen_two.dart';
import 'package:foodie_customer/ui/profile/ProfileScreen.dart';
import 'package:geocoding/geocoding.dart';

import 'model/User.dart';

class BottomBar extends StatefulWidget {
  final int? selectedTab;
  final User? user;

  const BottomBar({Key? key, this.selectedTab, this.user}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selectIndex = 0;
  final fireStoreUtils = FireStoreUtils();

  @override
  void initState() {
    super.initState();

    if (widget.selectedTab != null) {
      selectIndex = widget.selectedTab!;
    }

    setCurrency();

    //getKeyHash();
    /// On iOS, we request notification permissions, Does nothing and returns null on Android
    FireStoreUtils.firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    fireStoreUtils.getplaceholderimage().then((value) {
      AppGlobal.placeHolderImage = value;
    });
    setState(() {});

  }

  setCurrency() async {
    await FirebaseFirestore.instance.collection(Setting).doc("home_page_theme").get().then((value) {
      if (value.exists) {
        homePageThem = value.data()!["theme"];
      }
    });

    await FireStoreUtils().getCurrency().then((value) {
      if (value != null) {
        currencyModel = value;
      } else {
        currencyModel = CurrencyModel(id: "", code: "USD", decimal: 2, isactive: true, name: "US Dollar", symbol: "\$", symbolatright: false);
      }
    });

    MyAppState.selectedPosotion = await getCurrentLocation();
    List<Placemark> placeMarks = await placemarkFromCoordinates(MyAppState.selectedPosotion.latitude, MyAppState.selectedPosotion.longitude);
    country = placeMarks.first.country;

    await FireStoreUtils().getTaxList().then((value) {
      if (value != null) {
        taxList = value;
      }
    });




    await FireStoreUtils().getRazorPayDemo();
    await FireStoreUtils.getPaypalSettingData();
    await FireStoreUtils.getStripeSettingData();
    await FireStoreUtils.getPayStackSettingData();
    await FireStoreUtils.getFlutterWaveSettingData();
    await FireStoreUtils.getPaytmSettingData();
    await FireStoreUtils.getWalletSettingData();
    await FireStoreUtils.getPayFastSettingData();
    await FireStoreUtils.getMercadoPagoSettingData();
    // await FireStoreUtils.getReferralAmount();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = <Widget>[
      HomeScreen(user: widget.user),
      HomeScreenTwo(user: widget.user,),
      CartScreen(),
      ContainerScreen(user: widget.user),
      ProfileScreen(user: widget.user),
    ];
    return Scaffold(
      body: Center(child: _pages.elementAt(selectIndex)),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(19),
          topLeft: Radius.circular(10),
        ),
        child:  Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black,
                blurRadius: 10,
                // spreadRadius: 200
              ),
            ],
          ),
          child:  Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(

              type: BottomNavigationBarType.fixed,
              selectedFontSize: 12,
              backgroundColor:  isDarkMode(context) ? Colors.black : Colors.white,
              currentIndex: selectIndex,
              onTap: _onItemTapped,
              showUnselectedLabels: true,
              selectedItemColor: Color(COLOR_PRIMARY),
              unselectedItemColor: Color(0XFFC0C0C0),
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Column(
                      children: [
                        Container(
                          height: 5,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: selectIndex == 0 ? Color(COLOR_PRIMARY) : Colors.transparent,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        ImageIcon(
                          Image.asset(
                            "assets/images/home (1).png",
                          ).image,
                          size: 24,
                        ),
                      ],
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Column(
                      children: [
                        Container(
                          height: 5,
                          width: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: selectIndex == 1 ? Color(COLOR_PRIMARY) : Colors.transparent,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        ImageIcon(
                          Image.asset(
                            "assets/images/bottom2.png",
                          ).image,
                          size: 24,
                        ),
                      ],
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Column(
                      children: [
                        Container(
                          height: 5,
                          width: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: selectIndex == 2 ? Color(COLOR_PRIMARY) : Colors.transparent,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        ImageIcon(
                          Image.asset(
                            "assets/images/bottom3.png",
                          ).image,
                          size: 24,
                        ),
                      ],
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Column(
                      children: [
                        Container(
                          height: 5,
                          width: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: selectIndex == 3 ? Color(COLOR_PRIMARY) : Colors.transparent,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        ImageIcon(
                          Image.asset(
                            "assets/images/bottom4.png",
                          ).image,
                          size: 24,
                        ),
                      ],
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Column(
                      children: [
                        Container(
                          height: 5,
                          width: 15,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: selectIndex == 4 ? Color(COLOR_PRIMARY) : Colors.transparent,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        ImageIcon(
                          Image.asset(
                            "assets/images/bottom5.png",
                          ).image,
                          size: 24,
                        ),
                      ],
                    ),
                    label: ""),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      selectIndex = index;
    });
  }
}
