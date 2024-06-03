import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';
import 'package:hair_main_street/controllers/productController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/models/auxModels.dart';
import 'package:hair_main_street/models/cartItemModel.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:hair_main_street/widgets/loading.dart';

class CartController extends GetxController {
  RxList<CartItem> cartItems = <CartItem>[].obs;
  num screenHeight = Get.height;
  RxBool isLoading = false.obs;

  // @override
  // onInit() async {
  //   super.onInit();
  //   cartItems.bindStream(fetchCart());
  //   print("${cartItems}");
  // }

  updateCheckoutList(CartItem cartitem) {
    //fetchCart();
    CheckOutController checkOutController = Get.find<CheckOutController>();
    UserController userController = Get.find<UserController>();
    MyUser user = userController.myUser.value;

    var index = checkOutController.checkoutList
        .indexWhere((element) => element.productID == cartitem.productID);

    if (index != -1) {
      print("after executing function: ${cartitem.price}");
      checkOutController.checkoutList[index] = CheckOutTickBoxModel(
        price: cartitem.price,
        quantity: cartitem.quantity,
        productID: cartitem.productID,
        user: user,
      );
      print(
          "checkoutlist data: ${checkOutController.checkoutList[index].price}");
      //checkOutController.checkoutList.refresh();
    } else {
      print("cannot update");
    }
  }

  addToCart(CartItem cartItem) async {
    isLoading.value = true;
    if (isLoading.value == true) {
      Get.dialog(
        const LoadingWidget(),
        barrierDismissible: false,
      );
    }
    var result = await DataBaseService().addToCart(cartItem);
    if (result != "Success") {
      isLoading.value = false;
      Get.back();
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
      isLoading.value = false;
      Get.back();
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
    } else {
      cartItems.bindStream(result);
      //cartItems.refresh();
    }
  }

  //update cart items
  Future updateCartItem({
    String? cartItemID,
    int? newQuantity,
    String? productID,
  }) async {
    CheckOutController checkOutController = Get.find<CheckOutController>();
    isLoading.value = true;
    if (isLoading.value == true) {
      Get.dialog(
        const LoadingWidget(),
        barrierDismissible: false,
      );
    }
    var result = await DataBaseService().updateCartItemQuantityandPrice(
      cartItemID!,
      newQuantity!,
    );
    if (result == "success") {
      isLoading.value = false;
      Get.back();
      showMyToast("Operation Success");
      fetchCart();

      // CartItem cartItem =
      //     cartItems.firstWhere((element) => element.cartItemID == cartItemID);
      // print(cartItem.price);
      // if (checkOutController.checkoutList
      //     .any((element) => element.productID == productID)) {
      //   CartItem cartItem =
      //       cartItems.firstWhere((element) => element.cartItemID == cartItemID);
      //   print(cartItem.price);
      //   updateCheckoutList(cartItem);
      // } else {
      //   print("Not inside");
      // }
    } else {
      isLoading.value = false;
      Get.back();
      showMyToast("Operation Failed");
    }
    update();
  }

  void showMyToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT, // 3 seconds by default, adjust if needed
      gravity: ToastGravity.BOTTOM, // Position at the bottom of the screen
      //timeInSec: 0.3, // Display for 0.3 seconds (300 milliseconds)
      backgroundColor: const Color(0xFF673AB7)
          .withOpacity(0.70), // Optional: Set background color
      textColor: Colors.white, // Optional: Set text color
      fontSize: 14.0,
      // Optional: Set font size
    );
  }
}

class WishListController extends GetxController {
  RxList<WishlistItem> wishListItems = <WishlistItem>[].obs;
  num screenHeight = Get.height;
  RxBool isEditingMode = false.obs;
  RxBool isLoading = false.obs;
  RxList<String> deletableItems = <String>[].obs;
  RxMap<String, RxBool> itemCheckboxState = RxMap<String, RxBool>();
  RxBool masterCheckboxState = false.obs;
  RxMap<String, bool> isLikedMap = RxMap<String, bool>();

  // @override
  // onInit() async {
  //   super.onInit();
  //   wishListItems.bindStream(fetchWishList());
  //   print("${wishListItems}");
  // }
  // Future<void> initializeIsLikedState(
  //     String productId, bool isUserLoggedIn) async {
  //   //print("is Called");
  //   print("calling productID: $productId");
  //   if (isUserLoggedIn) {
  //     await fetchWishList();
  //     if (wishListItems.isNotEmpty) {
  //       isLikedMap.putIfAbsent(
  //         productId,
  //         () => wishListItems.any((item) {
  //           print("executing now");
  //           return item.productID == productId;
  //         }),
  //       );
  //     } else {
  //       print("its empty");
  //     }
  //     update();
  //   }
  // }

  // Method to toggle wishlist status for a product
  // Future<void> toggleWishlistStatus(String productId) async {
  //   if (isLikedMap[productId] == true) {
  //     await removeFromWishlistWithProductID(productId);
  //     isLikedMap[productId] = false;
  //   } else {
  //     WishlistItem item = WishlistItem(productID: productId);
  //     await addToWishlist(item);
  //     isLikedMap[productId] = true;
  //   }
  // }

  addToWishlist(WishlistItem wishlistItem) async {
    isLoading.value = true;
    var result = await DataBaseService().addToWishList(wishlistItem);
    if (result == 'not authorized') {
      isLoading.value = false;
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
      isLoading.value = false;
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
      isLoading.value = false;
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

  fetchWishList() {
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
    update();
  }

  deleteFromWishlist() async {
    isLoading.value = true;
    //print(deletableItems.length);
    var result = await DataBaseService().removeFromWishList(deletableItems);
    if (result == 'success') {
      isLoading.value = false;
      Get.snackbar(
        "Deleted",
        "Successfully Deleted Items from Wishlist",
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
      return "success";
    } else {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Error Deleting Items from Wishlist",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1, milliseconds: 800),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Colors.red[300],
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: screenHeight * 0.08,
        ),
      );
    }
    update();
  }

  removeFromWishlistWithProductID(String productID) async {
    isLoading.value = true;
    //print(deletableItems.length);
    var result =
        await DataBaseService().removeFromWishlistWithProductID(productID);
    if (result == 'success') {
      isLoading.value = false;
      showMyToast("Removed from wishlist");
      return "success";
    } else {
      isLoading.value = false;
      showMyToast("Problems removing from wishlist");
    }
    update();
  }

  toggleMasterCheckbox() {
    masterCheckboxState.value = !masterCheckboxState.value;
    itemCheckboxState.forEach((itemId, checkboxValue) {
      checkboxValue.value = masterCheckboxState.value;
      toggleCheckBox(checkboxValue.value, itemId);
    });
  }

  toggleCheckBox(bool value, String itemID) {
    print('pressed');
    itemCheckboxState[itemID]!.value = value;
    if (value) {
      bool itemExists = deletableItems.any((id) => id == itemID);

      if (!itemExists) {
        deletableItems.add(itemID);
      } else {}
    } else {
      deletableItems.removeWhere((id) => id == itemID);
    }
    update();
  }

  void showMyToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT, // 3 seconds by default, adjust if needed
      gravity: ToastGravity.BOTTOM, // Position at the bottom of the screen
      //timeInSec: 0.3, // Display for 0.3 seconds (300 milliseconds)
      backgroundColor: const Color(0xFF673AB7)
          .withOpacity(0.70), // Optional: Set background color
      textColor: Colors.white, // Optional: Set text color
      fontSize: 14.0,
      // Optional: Set font size
    );
  }
}
