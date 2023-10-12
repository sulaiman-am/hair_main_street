import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/pages/Shop_page.dart';
import 'package:hair_main_street/pages/authentication/authentication.dart';
import 'package:hair_main_street/pages/cart.dart';
import 'package:hair_main_street/pages/product_page.dart';
import 'package:hair_main_street/pages/referral.dart';
import 'package:hair_main_street/pages/vendor_dashboard/Inventory.dart';
import 'package:hair_main_street/pages/vendor_dashboard/add_product.dart';
import 'package:hair_main_street/pages/vendor_dashboard/payment_settings.dart';
import 'package:hair_main_street/pages/vendor_dashboard/vendor_orders.dart';
import 'package:hair_main_street/pages/vendor_dashboard/wallet.dart';
import 'package:hair_main_street/pages/wishlist.dart';
import 'package:material_symbols_icons/symbols.dart';

class VendorPage extends StatefulWidget {
  const VendorPage({super.key});

  @override
  State<VendorPage> createState() => _VendorPageState();
}

class _VendorPageState extends State<VendorPage> {
  @override
  Widget build(BuildContext context) {
    List<String> vendorButtonsText = [
      "Shop Page",
      "My Orders",
      "Inventory",
      "Wallet",
      "Deliveries",
      "Add Product"
    ];

    List? vl = [
      ShopPage(),
      VendorOrdersPage(),
      InventoryPage(),
      WalletPage(),
      PaymentSettingsPage(),
      AddproductPage(),
    ];

    List<IconData> vendorButtonsIcons = [
      Symbols.storefront_rounded,
      Symbols.list_alt_rounded,
      Symbols.inventory_2_rounded,
      Symbols.wallet_rounded,
      Symbols.local_shipping_rounded,
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
    return Scaffold(
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
            color: Color(
              0xFFFF8811,
            ),
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: appBarGradient),
        ),
        //backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
        decoration: BoxDecoration(gradient: myGradient),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
        backgroundColor: Colors.grey[200],
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
