import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/vendorController.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/models/review.dart';
import 'package:hair_main_street/models/vendorsModel.dart';
import 'package:hair_main_street/pages/vendor_dashboard/add_product.dart';
import 'package:hair_main_street/pages/vendor_dashboard/vendor.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:http/http.dart' as http;

class ProductController extends GetxController {
  RxList<Vendors?> vendorsList = RxList<Vendors?>();
  RxList<Vendors?> filteredVendorsList = RxList<Vendors?>();
  Rx<List<Product?>> products = Rx<List<Product?>>([]);
  Rx<List<Product?>> filteredProducts = Rx<List<Product?>>([]);
  Rx<List<Review?>> reviews = Rx<List<Review?>>([]);
  // VendorController vendorController = Get.find<VendorController>();
  var imageList = [].obs;
  var downloadUrls = [].obs;
  var isLoading = false.obs;
  var isProductadded = false.obs;
  var screenHeight = Get.height;
  var screenWidth = Get.width;
  var dismissible = true;
  var quantity = 1.obs;
  var isImageValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    vendorsList.bindStream(getVendors());
    products.bindStream(fetchProducts());
    print(products.value);
    if (products.value.isEmpty) {
      isLoading.value = true;
    } else {
      isLoading.value = false;
    }
  }

  // @override
  // void onReady(){

  // }

  Stream<List<Vendors>> getVendors() {
    return DataBaseService().getVendors();
  }

  checkValidity(String url) async {
    try {
      Uri uri = Uri.parse(url);
      http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        isImageValid.value = true;
      }
    } catch (e) {
      print(e);
    }
  }

  increaseQuantity() {
    quantity.value++;
  }

  decreaseQuantity() {
    if (quantity.value == 1) {
      quantity.value = 1;
    } else {
      quantity.value--;
    }
  }

  //fetch products
  Stream<List<Product?>> fetchProducts() {
    return DataBaseService().fetchProducts();
  }

  //get single product
  Product? getSingleProduct(String id) {
    Product product = Product();
    products.value.forEach((element) {
      if (element!.productID.toString().toLowerCase() == id.toLowerCase()) {
        product = element;
      }
    });
    return product;
  }

  //add a product
  addAProduct(Product product) async {
    var result = await DataBaseService().addProduct(product: product);
    if (result == "success") {
      isProductadded.value = true;
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
          bottom: screenHeight * 0.08,
        ),
      );
      Get.close(2);
      imageList.clear();
      downloadUrls.clear();
    } else {
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
          bottom: screenHeight * 0.08,
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
  updateProduct(Product product) async {
    var result = await DataBaseService().updateProduct(product: product);
    if (result == "success") {
      isProductadded.value = true;
      Get.snackbar(
        "Successful",
        "Product Edited",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1, milliseconds: 800),
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
        "Product Edit Failed",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1, milliseconds: 800),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Colors.red[400],
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: screenHeight * 0.08,
        ),
      );
    }
  }

  //delete a product
  deleteProduct(Product product) async {
    var result = await DataBaseService().deleteProduct(product);
    if (result == "success") {
      isProductadded.value = true;
      Get.snackbar(
        "Successful",
        "Product Deleted",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1, milliseconds: 800),
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
        "Failed to Delete Product",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1, milliseconds: 800),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Colors.red[400],
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: screenHeight * 0.08,
        ),
      );
    }
  }

  //get reviews of products
  dynamic getReviews(String? productID) {
    reviews.bindStream(DataBaseService().getReviews(productID!));
  }

  //get vendors list
  Vendors clientGetVendorName(String vendorID) {
    Vendors vendorDetails = Vendors();
    vendorsList.forEach((vendor) {
      if (vendor!.userID == vendorID) {
        vendorDetails = vendor;
      }
    });
    return vendorDetails;
  }
}
