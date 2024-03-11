//import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'dart:async';

import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hair_main_street/controllers/cartController.dart';
import 'package:hair_main_street/controllers/notificationController.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';
import 'package:hair_main_street/controllers/productController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/controllers/vendorController.dart';
import 'package:hair_main_street/pages/cart.dart';
import 'package:hair_main_street/pages/feed.dart';
import 'package:hair_main_street/pages/menu.dart';
//import 'dart:math' as math;

//import 'package:hair_main_street/widgets/cards.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ProductController productController = Get.put(ProductController());
  UserController userController = Get.find<UserController>();

  //var anotherController = Get.put(VendorController());
  List tabs = [FeedPage(), CartPage(), MenuPage()];
  var _selectedTab = 0;

  CartController cartController = Get.put(CartController());
  CheckOutController checkOutController = Get.put(CheckOutController());
  NotificationController notificationController =
      Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = Get.height;
    double screenWidth = Get.width;
    checkOutController.userUID.value =
        userController.userState.value?.uid == null
            ? ""
            : userController.userState.value!.uid!;
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        debugPrint("Back pressed");
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: tabs.elementAt(_selectedTab),
        bottomNavigationBar: SafeArea(
          child: Obx(() {
            if (userController.userState.value != null) {
              // String userType =
              //     userController.userState.value!.isVendor! == true
              //         ? "vendor"
              //         : "buyer";
              if (userController.userState.value!.isVendor == true) {
                notificationController.subscribeToTopics(
                    "vendor", userController.userState.value!.uid!);
                notificationController.subscribeToTopics(
                    "buyer", userController.userState.value!.uid!);
              } else {
                notificationController.subscribeToTopics(
                    "buyer", userController.userState.value!.uid!);
              }
            }
            return Container(
              //color: Colors.purple,
              //margin: EdgeInsets.only(top: screenHeight * 0.7),
              height:
                  _selectedTab != 1 && checkOutController.checkoutList.isEmpty
                      ? screenHeight * .16
                      : screenHeight * 0.16,
              //width: screenWidth * 1,
              // constraints: BoxConstraints(
              //     maxHeight: screenHeight * .45, maxWidth: screenWidth * 1),
              //alignment: Alignment.bottomCenter,
              //padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                children: [
                  Expanded(
                    child: Visibility(
                      visible: _selectedTab == 1 &&
                          checkOutController.checkoutList.isNotEmpty,
                      child: Container(
                        //height: screenHeight * .05,
                        color: Colors.white,
                        //padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF392F5A),
                                padding: EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: screenWidth * 0.04),
                                //maximumSize: Size(screenWidth * 0.70, screenHeight * 0.10),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1.2,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () {
                                // DataBaseService().addProduct();
                              },
                              child: GetX<CheckOutController>(
                                builder: (_) {
                                  return Text(
                                    "Check Out(${checkOutController.checkoutList.length})",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: BottomBarDefault(
                      iconSize: 24,
                      titleStyle: TextStyle(fontSize: 14),
                      pad: 1,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF000000),
                          blurStyle: BlurStyle.outer,
                          offset: Offset.zero,
                          blurRadius: 2,
                        ),
                      ],
                      top: 2,
                      //paddingVertical: 24,
                      bottom: 2,
                      // borderRadius: BorderRadius.all(
                      //   Radius.circular(16),
                      // ),
                      backgroundColor: Colors.white,
                      //blur: 1,
                      color: Colors.grey.shade500,
                      countStyle: CountStyle(color: Colors.black),
                      colorSelected: Colors.black,
                      items: const [
                        TabItem(icon: Icons.home_rounded, title: "Home"),
                        TabItem(
                            icon: Icons.shopping_cart_rounded, title: "Cart"),
                        TabItem(icon: Icons.person_2_rounded, title: "Me"),
                      ],
                      indexSelected: _selectedTab,
                      onTap: (int index) {
                        setState(() {
                          _selectedTab = index;
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
          // bottomNavigationBar: Container(
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.vertical(
          //       top: Radius.circular(16),
          //       bottom: Radius.circular(16),
          //     ),
          //     border: Border.all(color: Colors.black, width: 1.6),
          //   ),
          //   margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          //   padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          //   child: SafeArea(
          //     child: GNav(
          //       style: GnavStyle.google,
          //       //color: Colors.green,
          //       tabBackgroundColor: Color(0xFF0E4D92),
          //       tabBorderRadius: 12,
          //       tabActiveBorder: Border.all(color: Colors.black, width: 1.2),
          //       tabBorder: Border.all(color: Colors.white, width: 1),
          //       //tabMargin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          //       padding: EdgeInsets.all(6),
          //       gap: 4,
          //       selectedIndex: _selectedTab,
          //       onTabChange: (value) {
          //         setState(() {
          //           _selectedTab = value;
          //         });
          //       },
          //       //color: Colors.white,
          //       textStyle: TextStyle(fontSize: 16, color: Colors.white),
          //       tabs: [
          //         /// Home
          //         GButton(
          //           iconActiveColor: Colors.white,
          //           icon: Icons.home_outlined,
          //           iconSize: 28,
          //           text: "Home",
          //         ),

          //         /// Likes
          //         GButton(
          //           iconActiveColor: Colors.white,
          //           icon: Icons.shopping_cart_outlined,
          //           iconSize: 28,
          //           text: "Cart",
          //         ),

          //         /// Profile
          //         GButton(
          //           iconActiveColor: Colors.white,
          //           icon: Icons.menu,
          //           iconSize: 28,
          //           text: "Menu",
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}
