import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/blankPage.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/controllers/vendorController.dart';
import 'package:hair_main_street/pages/vendor_dashboard/Shop_page.dart';
import 'package:hair_main_street/pages/authentication/authentication.dart';
import 'package:hair_main_street/pages/cart.dart';
import 'package:hair_main_street/pages/product_page.dart';
import 'package:hair_main_street/pages/menu/referral.dart';
import 'package:hair_main_street/pages/vendor_dashboard/Inventory.dart';
import 'package:hair_main_street/pages/vendor_dashboard/add_product.dart';
import 'package:hair_main_street/pages/vendor_dashboard/payment_settings.dart';
import 'package:hair_main_street/pages/vendor_dashboard/vendor_orders.dart';
import 'package:hair_main_street/pages/vendor_dashboard/wallet.dart';
import 'package:hair_main_street/pages/menu/wishlist.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:material_symbols_icons/symbols.dart';

class VendorPage extends StatelessWidget {
  VendorPage({super.key});

  UserController userController = Get.find<UserController>();
  VendorController vendorController = Get.find<VendorController>();
  CheckOutController checkOutController = Get.find<CheckOutController>();

  @override
  Widget build(BuildContext context) {
    vendorController.vendorUID.value = userController.userState.value!.uid!;
    checkOutController.userUID.value = userController.userState.value!.uid!;
    vendorController.getVendorDetails(userController.userState.value!.uid!);
    vendorController.getVendorsProducts(userController.userState.value!.uid!);
    //print(vendorController.vendorUID.value);
    List<String> vendorButtonsText = [
      "Shop Page",
      "My Orders",
      "Inventory",
      "Wallet",
      "Add Product"
    ];

    List? vl = [
      ShopPage(),
      VendorOrdersPage(),
      InventoryPage(),
      WalletPage(),
      AddproductPage(),
    ];

    List<IconData> vendorButtonsIcons = [
      Symbols.storefront_rounded,
      Symbols.list_alt_rounded,
      Symbols.inventory_2_rounded,
      Symbols.wallet_rounded,
      Symbols.add,
    ];
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
        Color.fromARGB(255, 255, 224, 139)
      ],
      stops: [
        0.05,
        0.99,
      ],
      end: Alignment.topCenter,
      begin: Alignment.bottomCenter,
      //transform: GradientRotation(math.pi / 4),
    );
    return StreamBuilder(
      stream: DataBaseService()
          .getVendorDetails(userID: userController.userState.value!.uid!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("hello");
          return Obx(
            () => vendorController.vendor.value!.firstVerification == false
                ? BlankPage(
                    pageIcon: const Icon(
                      Icons.cancel,
                      size: 86,
                      color: Colors.black,
                    ),
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                    buttonStyle: TextButton.styleFrom(
                      // padding: EdgeInsets.symmetric(
                      //     horizontal: screenWidth * 0.24),
                      backgroundColor: Colors.black,
                      side: const BorderSide(color: Colors.white, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    text: "You Have not been Verified Yet \nKindly Wait...",
                    interactionIcon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                    interactionText: "Back",
                    interactionFunction: () => Get.back(),
                  )
                : Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Symbols.arrow_back_ios_new_rounded,
                            size: 24, color: Colors.black),
                      ),
                      title: const Text(
                        'Vendor Dashboard',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      centerTitle: true,
                      // flexibleSpace: Container(
                      //   decoration: BoxDecoration(gradient: appBarGradient),
                      // ),
                      //backgroundColor: Colors.transparent,
                    ),
                    body: Container(
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                      //decoration: BoxDecoration(gradient: myGradient),
                      child: GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                        ),
                        children: List.generate(
                          vendorButtonsText.length,
                          (index) => DashboardButton(
                            icon: vendorButtonsIcons[index],
                            page: vl[index],
                            text: vendorButtonsText[index],
                          ),
                        ),
                      ),
                    ),
                  ),
          );
        } else {
          return Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(
                //backgroundColor: Colors.white,
                color: Color(0xFF392F5A),
                strokeWidth: 4,
              ),
            ),
          );
        }
      },
    );
  }
}

class DashboardButton extends StatelessWidget {
  final Widget? page;
  final String? text;
  final IconData? icon;
  const DashboardButton({this.icon, this.page, this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      onPressed: () => Get.to(() => page!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon!,
            size: 40,
            color: Colors.black,
          ),
          Divider(
            height: 8,
            color: Colors.black,
            thickness: 1,
          ),
          Text(
            text!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
