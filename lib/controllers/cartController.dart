import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/productController.dart';
import 'package:hair_main_street/models/cartItemModel.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/services/database.dart';

class CartController extends GetxController {
  var cartItems = [].obs;
  num screenHeight = Get.height;

  // @override
  // onInit() async {
  //   super.onInit();
  //   cartItems.bindStream(fetchCart());
  //   print("${cartItems}");
  // }

  addToCart(CartItem cartItem) async {
    var result = await DataBaseService().addToCart(cartItem);
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
          bottom: screenHeight * 0.08,
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
          bottom: screenHeight * 0.08,
        ),
      );
    }
  }

  void fetchCart() {
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
    cartItems.bindStream(result);
  }
}

class WishListController extends GetxController {
  var wishListItems = [].obs;
  num screenHeight = Get.height;

  // @override
  // onInit() async {
  //   super.onInit();
  //   wishListItems.bindStream(fetchWishList());
  //   print("${wishListItems}");
  // }

  addToWishlist(WishlistItem wishlistItem) async {
    var result = await DataBaseService().addToWishList(wishlistItem);
    if (result == 'not authorized') {
      Get.snackbar(
        "Error",
        "Problem adding to wishlist",
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
    } else if (result == 'new') {
      Get.snackbar(
        "Success",
        "Added to wishList",
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
    } else if (result == 'exists') {
      Get.snackbar(
        "Already in your wishlists",
        "",
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
    }
  }

  void fetchWishList() {
    var result = DataBaseService().fetchWishListItems();
    if (result.runtimeType == Object) {
      Get.snackbar(
        "Error",
        "Failed to Fetch WishList",
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
    }
    wishListItems.bindStream(result);
  }
}
