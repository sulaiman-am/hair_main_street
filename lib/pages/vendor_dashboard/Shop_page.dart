import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/blankPage.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/controllers/vendorController.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/pages/vendor_dashboard/add_product.dart';
import 'package:hair_main_street/pages/vendor_dashboard/edit_product.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../widgets/cards.dart';

// ignore: must_be_immutable
class ShopSetupPage extends StatefulWidget {
  ShopSetupPage({super.key});

  @override
  State<ShopSetupPage> createState() => _ShopSetupPageState();
}

class _ShopSetupPageState extends State<ShopSetupPage> {
  VendorController vendorController = Get.find<VendorController>();

  UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    var productList = vendorController.productList;

    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Symbols.arrow_back_ios_new_rounded,
            size: 24,
            color: Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          "Shop Setup",
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0.7), // Adjust height as needed
          child: Divider(
            thickness: 0.5, // Adjust thickness as needed
            color: Colors.black.withOpacity(0.2), // Adjust color as needed
          ),
        ),
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(gradient: appBarGradient),
        // ),
      ),
      backgroundColor: Colors.white,
      body: ShopDetailsCard(),
    );
  }
}
