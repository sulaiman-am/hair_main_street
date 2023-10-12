import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/services/database.dart';

class ProductController extends GetxController {
  Rx<List<Product?>> products = Rx<List<Product?>>([]);
  var imageList = [].obs;
  var downloadUrls = [].obs;
  var isLoading = false.obs;
  var screenHeight = Get.height;
  var screenWidth = Get.width;
  var dismissible = true;

  @override
  void onInit() {
    super.onInit();
    products.bindStream(fetchProducts());
    print(products.value);
    if (products.value.isEmpty) {
      isLoading.value = true;
      // Timer.periodic(
      //   const Duration(seconds: 5),
      //   (timer) {
      //     isLoading.value == false;
      //     Get.snackbar(
      //       "Failed to Load Products",
      //       "Retrying...",
      //       snackPosition: SnackPosition.BOTTOM,
      //       duration: Duration(seconds: 1, milliseconds: 500),
      //       snackStyle: SnackStyle.FLOATING,
      //       forwardAnimationCurve: Curves.easeIn,
      //       reverseAnimationCurve: Curves.easeOut,
      //       backgroundColor: Colors.grey[400],
      //       margin: EdgeInsets.only(
      //         left: screenWidth * 0.10,
      //         right: screenWidth * 0.10,
      //         bottom: screenHeight * 0.08,
      //       ),
      //     );
      //   },
      // );
    } else {
      isLoading.value = false;
    }
  }

  //fetch products
  Stream<List<Product?>> fetchProducts() {
    return DataBaseService().fetchProducts();
  }

  //add a product
  addAProduct(Product product) async {
    var result = await DataBaseService().addProduct(product: product);
    if (result.runtimeType == Object) {
      Get.snackbar(
        "Error",
        "Product Upload Failed",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1, milliseconds: 800),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Colors.red[400],
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: screenHeight * 0.16,
        ),
      );
    } else {
      Get.snackbar(
        "Successful",
        "Product Added",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1, milliseconds: 800),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Colors.green[200],
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: screenHeight * 0.16,
        ),
      );
    }
  }

  //upload a product Image
  uploadImage() async {
    var image = await DataBaseService().uploadProductImage();
    if (image == null) {}
    imageList.value = image ?? [];
    print("imageList:${imageList}");
    for (var imageRef in imageList) {
      if (imageRef.state == TaskState.success) {
        var downloadUrl = await imageRef.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
    }
  }

  //update a product

  //delete a product

  //fetch 1 product
}
