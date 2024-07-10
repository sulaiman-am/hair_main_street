//ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';
import 'package:hair_main_street/controllers/review_controller.dart';
import 'package:hair_main_street/pages/authentication/sign_in.dart';
import 'package:hair_main_street/pages/chats_page.dart';
import 'package:hair_main_street/pages/homePage.dart';
import 'package:hair_main_street/pages/review_page.dart';
import 'package:hair_main_street/blankPage.dart';
import 'package:hair_main_street/controllers/userController.dart';
//import 'package:hair_main_street/Shop_page.dart';
import 'package:hair_main_street/pages/menu/orders.dart';
import 'package:hair_main_street/pages/menu/profile.dart';
import 'package:hair_main_street/pages/vendor_dashboard/become_vendor.dart';
import 'package:hair_main_street/pages/vendor_dashboard/vendor.dart';
import 'package:hair_main_street/pages/menu/wishlist.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:material_symbols_icons/symbols.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find<UserController>();
    ReviewController reviewController = Get.find<ReviewController>();
    CheckOutController checkOutController = Get.find<CheckOutController>();
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;

    return Obx(
      () => userController.userState.value == null
          ? BlankPage(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF673AB7),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1.2,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              pageIcon: const Icon(
                Icons.person_off_outlined,
                size: 48,
              ),
              text: "Your are not Logged In",
              interactionText: "Sign In or Register",
              interactionIcon: const Icon(
                Icons.person_2_outlined,
                size: 24,
                color: Colors.white,
              ),
              interactionFunction: () => Get.to(() => const SignIn()),
            )
          : Scaffold(
              // appBar: AppBar(
              //   title: const Text(
              //     '${userController.userState.value.fullname ?? "Set your Full Name"}',
              //     style: TextStyle(
              //       fontSize: 32,
              //       fontWeight: FontWeight.w900,
              //       color: Colors.black,
              //     ),
              //   ),
              //   centerTitle: true,
              //   actions: [
              //     Transform.rotate(
              //       angle: 0.3490659,
              //       child: Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 4.0),
              //         child: IconButton(
              //           onPressed: () {
              //             Get.to(() => NotificationsPage());
              //           },
              //           icon: const Icon(
              //             Icons.notifications_active_rounded,
              //             size: 32,
              //             color: Colors.black,
              //           ),
              //         ),
              //       ),
              //     )
              //   ],
              //   //backgroundColor: Color(0xFF0E4D92),
              //   // flexibleSpace: Container(
              //   //   decoration: BoxDecoration(gradient: appBarGradient),
              //   // ),
              //   //backgroundColor: Colors.transparent,
              // ),
              backgroundColor: Colors.white,
              extendBodyBehindAppBar: false,
              body: SafeArea(
                child: Container(
                  color: Colors.white,
                  //decoration: BoxDecoration(gradient: myGradient),
                  child: ListView(
                    padding:
                        EdgeInsets.fromLTRB(12, screenHeight * 0.02, 12, 0),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (userController.userState.value!.profilePhoto ==
                                null)
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.brown[300],
                                child: SvgPicture.asset(
                                  "assets/Icons/user.svg",
                                  height: 35,
                                  width: 35,
                                  color: Colors.white,
                                ),
                              )
                            else
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                  userController.userState.value!.profilePhoto!,
                                ),
                              ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                userController.userState.value!.fullname !=
                                            null ||
                                        userController
                                                .userState.value!.fullname! !=
                                            ""
                                    ? userController.userState.value!.fullname!
                                    : "Set your Full Name",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontFamily: 'Lato',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 8,
                        thickness: 1.5,
                        color: Colors.black.withOpacity(0.10),
                      ),
                      MenuButton(
                        text: "Profile",
                        onPressed: () => Get.to(() => ProfilePage()),
                      ),
                      Divider(
                        height: 8,
                        thickness: 1.5,
                        color: Colors.black.withOpacity(0.10),
                      ),
                      MenuButton(
                        text: "Wish List",
                        onPressed: () => Get.to(() => WishListPage(),
                            transition: Transition.fadeIn),
                      ),
                      Divider(
                        height: 8,
                        thickness: 1.5,
                        color: Colors.black.withOpacity(0.10),
                      ),
                      MenuButton(
                        text: "Messages",
                        onPressed: () => Get.to(() => ChatPage(),
                            transition: Transition.fadeIn),
                      ),
                      Divider(
                        height: 8,
                        thickness: 1.5,
                        color: Colors.black.withOpacity(0.10),
                      ),
                      if (userController.userState.value!.isVendor == true)
                        MenuButton(
                          text: "Vendor Dashboard",
                          onPressed: () => Get.to(() => VendorPage()),
                        )
                      else
                        MenuButton(
                          text: "Become a Vendor",
                          onPressed: () {
                            Get.to(() => const BecomeAVendorPage());
                          },
                        ),
                      Divider(
                        height: 8,
                        thickness: 1.5,
                        color: Colors.black.withOpacity(0.10),
                      ),
                      MenuButton(
                        text: "My Orders",
                        onPressed: () => Get.to(() => OrdersPage(),
                            transition: Transition.fadeIn),
                      ),
                      Divider(
                        height: 8,
                        thickness: 1.5,
                        color: Colors.black.withOpacity(0.10),
                      ),
                      MenuButton(
                        text: "Settings",
                        onPressed: () => Get.to(() => ClientReviewPage(),
                            transition: Transition.fadeIn),
                      ),
                      Divider(
                        height: 8,
                        thickness: 1.5,
                        color: Colors.black.withOpacity(0.10),
                      ),
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: InkWell(
                          onTap: () {
                            userController.signOut();
                            checkOutController.checkoutList.clear();
                            checkOutController.itemCheckboxState.clear();
                            checkOutController.isMasterCheckboxChecked.value =
                                false;
                            checkOutController.deletableCartItems.clear();
                            Get.offAll(() => const HomePage());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Iconify(
                                MaterialSymbols.logout,
                                size: 20,
                                color: Color(0xFFEA4335),
                              ),
                              SizedBox(
                                width: screenWidth * 0.02,
                              ),
                              const Text(
                                "Sign Out",
                                style: TextStyle(
                                  color: Color(0xFFEA4335),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Raleway',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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

  final Function? onPressed;
  const MenuButton({
    this.onPressed,
    this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: const Color(0xFF673AB7).withOpacity(0.20),
        //side: BorderSide(width: 0.5),
      ),
      onPressed: onPressed == null ? () {} : () => onPressed!(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text!,
            style: const TextStyle(
              fontSize: 17,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          // SizedBox(
          //   width: screenWidth * 0.30,
          //),
          const Icon(
            Symbols.arrow_forward_ios_rounded,
            size: 20,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
