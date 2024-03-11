//ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/pages/notifcation.dart';
import 'package:hair_main_street/pages/vendor_dashboard/Shop_page.dart';
import 'package:hair_main_street/blankPage.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/pages/authentication/authentication.dart';
//import 'package:hair_main_street/Shop_page.dart';
import 'package:hair_main_street/pages/cart.dart';
import 'package:hair_main_street/pages/menu/orders.dart';
import 'package:hair_main_street/pages/menu/profile.dart';
import 'package:hair_main_street/pages/menu/referral.dart';
import 'package:hair_main_street/pages/vendor_dashboard/become_vendor.dart';
import 'package:hair_main_street/pages/vendor_dashboard/vendor.dart';
import 'package:hair_main_street/pages/menu/wishlist.dart';
import 'package:material_symbols_icons/symbols.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find<UserController>();
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    Gradient myGradient = const LinearGradient(
      colors: [
        Color.fromARGB(255, 255, 224, 139),
        Color.fromARGB(255, 200, 242, 237)
      ],
      stops: [
        0.05,
        0.99,
      ],
      end: Alignment.topCenter,
      begin: Alignment.bottomCenter,
      //transform: GradientRotation(math.pi / 4),
    );
    Gradient appBarGradient = const LinearGradient(
      colors: [
        Color.fromARGB(255, 200, 242, 237),
        Color.fromARGB(255, 255, 224, 139),
      ],
      stops: [
        0.05,
        0.99,
      ],
      end: Alignment.topCenter,
      begin: Alignment.bottomCenter,
      //transform: GradientRotation(math.pi / 4),
    );
    return Obx(
      () => userController.userState.value == null
          ? BlankPage(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF392F5A),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1.2,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              pageIcon: Icon(
                Icons.person_off_outlined,
                size: 48,
              ),
              text: "Your are not Logged In",
              interactionText: "Register or Sign In",
              interactionIcon: Icon(
                Icons.person_2_outlined,
                size: 24,
                color: Colors.white,
              ),
              interactionFunction: () => Get.to(() => SignInUpPage()),
            )
          : Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0E4D92),
                  ),
                ),
                centerTitle: true,
                actions: [
                  Transform.rotate(
                    angle: 0.3490659,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconButton(
                        onPressed: () {
                          Get.to(() => NotificationsPage());
                        },
                        icon: const Icon(
                          Icons.notifications_active_rounded,
                          size: 32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
                //backgroundColor: Color(0xFF0E4D92),
                // flexibleSpace: Container(
                //   decoration: BoxDecoration(gradient: appBarGradient),
                // ),
                //backgroundColor: Colors.transparent,
              ),
              backgroundColor: Colors.grey[100],
              extendBodyBehindAppBar: false,
              body: Container(
                //decoration: BoxDecoration(gradient: myGradient),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(8, screenHeight * 0.08, 8, 0),
                  children: [
                    MenuButton(
                      text: "Profile",
                      iconData: Symbols.person_2_rounded,
                      onPressed: () => Get.to(() => ProfilePage()),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    MenuButton(
                      text: "Wish List",
                      iconData: Symbols.favorite_rounded,
                      onPressed: () => Get.to(() => WishListPage(),
                          transition: Transition.fadeIn),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    MenuButton(
                      text: "Orders",
                      iconData: Symbols.local_shipping_rounded,
                      onPressed: () => Get.to(() => OrdersPage(),
                          transition: Transition.fadeIn),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    MenuButton(
                        text: "Referral",
                        iconData: Symbols.redeem_rounded,
                        onPressed: () => Get.to(() => ReferralPage(),
                            transition: Transition.fadeIn)),
                    const SizedBox(
                      height: 12,
                    ),
                    if (userController.userState.value!.isVendor == true)
                      MenuButton(
                        text: "Vendor Dashboard",
                        iconData: Symbols.store,
                        onPressed: () => Get.to(() => VendorPage()),
                      )
                    else
                      MenuButton(
                        text: "Become a Vendor",
                        iconData: Icons.shopping_bag_outlined,
                        onPressed: () {
                          Get.to(() => BecomeAVendorPage());
                          print(userController.userState.value!.isVendor);
                          print(userController.userState.value!.email);
                        },
                      ),
                    //  MenuButton(
                    //  text: "Share Trial",
                    //iconData: Symbols.store,
                    //onPressed: () => Get.to(() => ShareEvery()),
                    // ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ),
    );

    //   centerTitle: true,
    //   flexibleSpace: Container(
    //     decoration: BoxDecoration(gradient: appBarGradient),
    //   ),
    //   //backgroundColor: Colors.transparent,
    // ),
    // extendBodyBehindAppBar: false,
    // body: Container(
    //   decoration: BoxDecoration(gradient: myGradient),
    //   child: ListView(
    //     padding: EdgeInsets.fromLTRB(8, screenHeight * 0.08, 8, 0),
    //     children: [
    //       MenuButton(
    //         text: "Profile",
    //         iconData: Symbols.person_2_rounded,
    //         onPressed: () => Get.to(() => ProfilePage()),
    //       ),
    //       const SizedBox(
    //         height: 12,
    //       ),
    //       MenuButton(
    //         text: "Wish List",
    //         iconData: Symbols.favorite_rounded,
    //         onPressed: () =>
    //             Get.to(() => WishListPage(), transition: Transition.fadeIn),
    //       ),
    //       const SizedBox(
    //         height: 12,
    //       ),
    //       MenuButton(
    //         text: "Orders",
    //         iconData: Symbols.local_shipping_rounded,
    //         onPressed: () =>
    //             Get.to(() => OrdersPage(), transition: Transition.fadeIn),
    //       ),
    //       const SizedBox(
    //         height: 12,
    //       ),
    //       MenuButton(
    //           text: "Referral",
    //           iconData: Symbols.redeem_rounded,
    //           onPressed: () => Get.to(() => ReferralPage(),
    //               transition: Transition.fadeIn)),
    //       const SizedBox(
    //         height: 12,
    //       ),
    //       MenuButton(
    //         text: "Vendors",
    //         iconData: Symbols.store,
    //         onPressed: () => Get.to(() => VendorPage()),
    //       ),
    //       const SizedBox(
    //         height: 12,
    //       ),
    //       const SizedBox(
    //         height: 12,
    //       ),
    //     ],
    //   ),
    // ),
  }
}

class MenuButton extends StatelessWidget {
  final String? text;
  final IconData? iconData;
  final Function? onPressed;
  const MenuButton({
    this.iconData,
    this.onPressed,
    this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: const Color(0xFF0E4D92),
        //side: BorderSide(width: 0.5),
      ),
      onPressed: onPressed == null ? () {} : () => onPressed!(),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            iconData!,
            color: Colors.black,
            size: 28,
          ),
          SizedBox(
            width: 12,
          ),
          Text(
            text!,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          // SizedBox(
          //   width: screenWidth * 0.30,
          // ),
          // Icon(
          //   Symbols.arrow_forward_ios_rounded,
          //   size: 28,
          //   color: Colors.black,
          // ),
        ],
      ),
    );
  }
}
