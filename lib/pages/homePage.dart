//import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'dart:async';

import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hair_main_street/controllers/cartController.dart';
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
  void initState() {
    Get.put(CartController());
    super.initState();
  }

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
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: BottomBarFloating(
            iconSize: 24,
            titleStyle: TextStyle(fontSize: 12),
            pad: 1,
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF000000),
                blurStyle: BlurStyle.outer,
                offset: Offset.zero,
                blurRadius: 3,
              ),
            ],
            top: 6,
            //paddingVertical: 24,
            bottom: 6,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            backgroundColor: Colors.white,
            //blur: 1,
            color: Colors.black,
            colorSelected: Color(0xFF0E4D92),
            items: const [
              TabItem(icon: Icons.home_outlined, title: "Home"),
              TabItem(icon: Icons.shopping_cart_outlined, title: "Cart"),
              TabItem(icon: Icons.menu, title: "Menu"),
            ],
            indexSelected: _selectedTab,
            onTap: (int index) {
              setState(() {
                _selectedTab = index;
              });
            },
          ),
        ),
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
    );
  }
}
