import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/models/vendorsModel.dart';
import 'package:hair_main_street/services/database.dart';

class VendorController extends GetxController {
  var productList = <Product>[].obs;
  Rx<Vendors?> vendor = Rx<Vendors?>(null);
  StreamSubscription<List<Product>>? _subscription;
  num screenHeight = Get.height;
  var vendorUID = "".obs;

  @override
  void onInit() async {
    super.onInit();

    vendor.bindStream(getVendorDetails());
    //print(vendor.value!.firstVerification);
  }

  @override
  void onReady() {
    super.onReady();
    if (vendorUID.value.isNotEmpty) {
      productList.bindStream(getVendorsProducts(vendorUID.value));
    } else {
      print("e choke");
    }
    // _subscription?.cancel();
    // _subscription = getVendorsProducts(vendorUID.value).listen((products) {
    //   print("products:${products.first.name}");
    //   productList.assignAll(products);
    // });
  }

  // @override
  // void onClose() {
  //   _subscription?.cancel();
  //   super.onClose();
  // }

  // Stream<List<Vendors>> getVendors() {
  //   return DataBaseService().getVendors();
  // }

  Stream<List<Product>> getVendorsProducts(String vendorID) {
    //print(DataBaseService().getVendorProducts(vendorID));
    return DataBaseService().getVendorProducts(vendorID);
  }

  //getVendor
  Stream<Vendors?> getVendorDetails() {
    return DataBaseService().getVendorDetails();
  }

  //create or update vendor
  createOrUpdateVendor(Vendors vendor) async {
    var result = await DataBaseService().createOrUpdateVendor(vendor);
    if (result == 'success') {
      Get.snackbar(
        "Success",
        "",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1, milliseconds: 800),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Colors.green[200],
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: screenHeight * 0.08,
        ),
      );
    } else {
      Get.snackbar(
        "Error",
        "A problem occured",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1, milliseconds: 800),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Colors.red[200],
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: screenHeight * 0.08,
        ),
      );
    }
  }

  //become a seller
  becomeASeller(Vendors vendor) async {
    var result = await DataBaseService().becomeASeller(vendor);
    if (result == 'success') {
      Get.snackbar(
        "Success",
        "",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1, milliseconds: 800),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Colors.green[200],
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: screenHeight * 0.08,
        ),
      );
    } else {
      Get.snackbar(
        "Error",
        "A problem occured",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1, milliseconds: 800),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Colors.red[200],
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: screenHeight * 0.08,
        ),
      );
    }
  }
}
