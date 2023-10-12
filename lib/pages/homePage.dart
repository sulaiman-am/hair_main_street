//import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hair_main_street/controllers/productController.dart';
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
  var controller = Get.put(ProductController());
  num screenHeight = Get.height;
  num screenWidth = Get.width;
  List tabs = [FeedPage(), CartPage(), MenuPage()];
  var _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    // if (controller.products.value.isEmpty && _selectedTab == 0) {
    //   Timer.periodic(Duration(seconds: 5), (timer) {
    //     Get.showSnackbar(
    //       GetSnackBar(
    //         messageText: Text(
    //           "Error Loading Products",
    //           style: TextStyle(
    //             color: Colors.black,
    //           ),
    //         ),
    //         icon: Icon(
    //           Icons.error_outline_rounded,
    //           color: Colors.black,
    //         ),
    //         backgroundColor: Colors.grey.shade300,
    //         snackPosition: SnackPosition.BOTTOM,
    //         margin: EdgeInsets.only(
    //           left: screenWidth * .20,
    //           right: screenWidth * .20,
    //           bottom: screenWidth * .16,
    //         ),
    //         forwardAnimationCurve: Curves.linear,
    //         reverseAnimationCurve: Curves.linear,
    //         borderRadius: 16,
    //         duration: Duration(seconds: 3),
    //       ),
    //     );
    //     // Fluttertoast.showToast(
    //     //     msg: "Error Loading Products",
    //     //     toastLength: Toast.LENGTH_LONG,
    //     //     backgroundColor: Colors.grey[400],
    //     //     fontSize: 16,
    //     //     gravity: ToastGravity.CENTER);
    //   });
    // } else {}
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
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Color(0xFF9DD9D2),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: SafeArea(
            child: GNav(
              style: GnavStyle.google,
              //color: Colors.green,
              tabBackgroundColor: Color(0xFFF4D06F),
              tabBorderRadius: 16,
              tabBorder: Border.all(color: Colors.black, width: 2),
              //tabMargin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              padding: EdgeInsets.all(6),
              gap: 4,
              selectedIndex: _selectedTab,
              onTabChange: (value) {
                setState(() {
                  _selectedTab = value;
                });
              },
              textStyle: TextStyle(
                fontSize: 20,
              ),
              tabs: [
                /// Home
                GButton(
                  icon: Icons.home_outlined,
                  iconSize: 28,
                  text: "Home",
                ),

                /// Likes
                GButton(
                  icon: Icons.shopping_cart_outlined,
                  iconSize: 28,
                  text: "Cart",
                ),

                /// Profile
                GButton(
                  icon: Icons.menu,
                  iconSize: 28,
                  text: "Menu",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
