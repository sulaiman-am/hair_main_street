import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/services/database.dart';

class CartController extends GetxController {
  var cartItems = [].obs;
  num screenHeight = Get.height;

  @override
  onInit() async {
    super.onInit();
    cartItems.bindStream(fetchCart());
    print("${cartItems}");
  }

  addToCart(Product product) async {
    var result = await DataBaseService().addToCart(product);
    if (result != "Success") {
      Get.snackbar(
        "Error",
        "Problem adding to cart",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1, milliseconds: 800),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Colors.red[200],
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: screenHeight * 0.16,
        ),
      );
    } else {
      Get.snackbar(
        "Success",
        "Added to cart",
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

  Stream<List<dynamic>> fetchCart() {
    var result = DataBaseService().fetchCartItems();
    if (result.runtimeType == Object) {
      Get.snackbar(
        "Error",
        "Failed to Fetch Cart",
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
    } else {}
    return result;
  }
}
