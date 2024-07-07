import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:hair_main_street/controllers/cartController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/models/auxModels.dart';
import 'package:hair_main_street/models/cartItemModel.dart';
import 'package:hair_main_street/models/orderModel.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/services/database.dart';

class CheckOutController extends GetxController {
  CartController cartController = Get.find<CartController>();
  Rx<CheckoutItem> checkOutItem = CheckoutItem().obs;
  Rx<DatabaseOrderResponse> singleOrder = DatabaseOrderResponse().obs;
  //var checkoutList = <CheckOutTickBoxModel>[].obs;
  RxList<DatabaseOrderResponse> buyerOrderList =
      RxList<DatabaseOrderResponse>([]);
  RxList<DatabaseOrderResponse> vendorOrderList =
      RxList<DatabaseOrderResponse>([]);
  Rx<Orders?> order = Rx<Orders?>(null);
  Rx<OrderItem?> orderItem = Rx<OrderItem?>(null);
  RxMap<String, List<DatabaseOrderResponse>> buyerOrderMap =
      RxMap<String, List<DatabaseOrderResponse>>({});
  RxMap<String, List<DatabaseOrderResponse>> vendorOrdersMap =
      RxMap<String, List<DatabaseOrderResponse>>({});
  var orderUpdateStatus = "".obs;
  num screenHeight = Get.height;
  RxString userUID = "".obs;
  var isLoading = false.obs;
  var isChecked = false.obs;
  var checkOutTickBoxModel = CheckOutTickBoxModel().obs;
// Map to store the checkbox state for each productID
  final Map<String, RxBool> itemCheckboxState = {};
  RxList<String> deletableCartItems = <String>[].obs;

  // List to store selected items
  RxList<CheckOutTickBoxModel> checkoutList = <CheckOutTickBoxModel>[].obs;

  // RxBool for the master checkbox
  final RxBool isMasterCheckboxChecked = false.obs;

  RxMap totalPriceAndQuantity = {}.obs;

  // @override
  // void onReady() {
  //   super.onReady();
  //   //isChecked.value = isCheckedFunction(checkOutTickBoxModel.value);
  //   vendorOrderList.bindStream(getSellerOrders(userUID.value));
  //   buyerOrderList.bindStream(getBuyerOrders(userUID.value));
  //   print(vendorOrderList);
  // }
  @override
  void onInit() {
    super.onInit();
    initCartItemsListener();
  }

  void initCartItemsListener() {
    final cartController = Get.find<CartController>();
    cartController.cartItems.listen((cartItems) {
      updateCheckoutItemFromCartItems(cartItems);
    });
  }

  //function to filter the buyer order list
  void filterTheBuyerOrderList(List<DatabaseOrderResponse> buyerOrder) {
    // No filter
    buyerOrderMap["All"] = buyerOrder;

    // Filter the once only payment method
    buyerOrderMap["Once"] = buyerOrder
        .where((order) =>
            order.paymentMethod != null && order.paymentMethod == "once")
        .toList();

    // Filter the installment only payment method
    buyerOrderMap["Installment"] = buyerOrder
        .where((order) =>
            order.paymentMethod != null && order.paymentMethod == "installment")
        .toList();

    // Filter the completed orders
    buyerOrderMap["Confirmed"] = buyerOrder
        .where((order) =>
            order.orderStatus != null && order.orderStatus == "confirmed")
        .toList();

    // Filter the cancelled orders
    buyerOrderMap["Cancelled"] = buyerOrder
        .where((order) =>
            order.orderStatus != null && order.orderStatus == "cancelled")
        .toList();

    // Filter the deleted orders
    buyerOrderMap["Deleted"] = buyerOrder
        .where((order) =>
            order.orderStatus != null && order.orderStatus == "deleted")
        .toList();

    // Filter the expired orders
    buyerOrderMap["Expired"] = buyerOrder
        .where((order) =>
            order.orderStatus != null && order.orderStatus == "expired")
        .toList();

    //print(buyerOrderMap["once"]!.length);
    // Update listeners after filtering
    // Assuming `buyerOrderMap` is an RxMap or similar reactive object
    buyerOrderMap.refresh();
  }

  //filter vendor orders
  void filterVendorOrdersList(List<DatabaseOrderResponse> vendorOrders) {
    // No filter
    vendorOrdersMap["All"] = vendorOrders;

    // Filter the once only payment method
    vendorOrdersMap["Active"] = vendorOrders
        .where(
          (order) =>
              order.orderStatus != null &&
              order.orderStatus != "expired" &&
              order.orderStatus != 'confirmed',
        )
        .toList();

    // Filter the expired orders
    vendorOrdersMap["Expired"] = vendorOrders
        .where((order) =>
            order.orderStatus != null && order.orderStatus == "expired")
        .toList();

    // Filter the cancelled orders
    vendorOrdersMap["Cancelled"] = vendorOrders
        .where((order) =>
            order.orderStatus != null && order.orderStatus == "cancelled")
        .toList();

    // Filter the completed orders
    vendorOrdersMap["Completed"] = vendorOrders
        .where((order) =>
            order.orderStatus != null && order.orderStatus == "confirmed")
        .toList();

    vendorOrdersMap.refresh();
  }

  //update checkoutlist based on cart items
  void updateCheckoutItemFromCartItems(List<CartItem> cartItems) {
    UserController userController = Get.find<UserController>();
    MyUser user = userController.userState.value!;

    for (var cartItem in cartItems) {
      int index = checkoutList
          .indexWhere((element) => element.productID == cartItem.productID);

      if (index != -1) {
        checkoutList[index] = CheckOutTickBoxModel(
          price: cartItem.price,
          quantity: cartItem.quantity,
          productID: cartItem.productID,
          user: user,
        );
      }
    }

    // Update the total price and quantity
    getTotalPriceAndTotalQuantity();
  }

  //get total sales
  Map<String, num> getTotalSales() {
    DateTime now = DateTime.now();
    Map<String, num> completedOrdersMap = {
      "this week": 0,
      "last week": 0,
      "this month": 0,
      "older": 0,
    };

    List<DatabaseOrderResponse>? completedOrders = vendorOrdersMap["Completed"];

    if (completedOrders != null) {
      for (var order in completedOrders) {
        DateTime updatedAt = order.updatedAt.toDate();
        int daysDifference = now.difference(updatedAt).inDays;

        if (order.paymentPrice != null) {
          if (daysDifference <= 7) {
            completedOrdersMap["this week"] =
                (completedOrdersMap["this week"] ?? 0) + order.paymentPrice!;
          } else if (daysDifference > 7 && daysDifference <= 14) {
            completedOrdersMap["last week"] =
                (completedOrdersMap["last week"] ?? 0) + order.paymentPrice!;
          } else if (daysDifference > 14 && daysDifference <= 30) {
            completedOrdersMap["this month"] =
                (completedOrdersMap["this month"] ?? 0) + order.paymentPrice!;
          } else {
            completedOrdersMap["older"] =
                (completedOrdersMap["older"] ?? 0) + order.paymentPrice!;
          }
        }
      }
    }

    return completedOrdersMap;
  }

  //update checkoutlist
  updateCheckoutList(CartItem cartitem) {
    //fetchCart();
    UserController userController = Get.find<UserController>();
    MyUser user = userController.userState.value!;

    var index = checkoutList
        .indexWhere((element) => element.productID == cartitem.productID);

    if (index != -1) {
      print("after executing function: ${cartitem.price}");
      checkoutList[index] = CheckOutTickBoxModel(
        price: cartitem.price,
        quantity: cartitem.quantity,
        productID: cartitem.productID,
        user: user,
      );
      print("checkoutlist data: ${checkoutList[index].price}");
      //update();
      getTotalPriceAndTotalQuantity();
      //checkOutController.checkoutList.refresh();
    } else {
      print("cannot update");
    }
  }

  //get total price and quantity in a checkout list
  void getTotalPriceAndTotalQuantity() {
    num totalPrice = 0.0;
    //num totalQuantity = 0.0;

    for (var item in checkoutList) {
      if (item.price != null && item.quantity != null) {
        totalPrice += item.price!;
        //totalQuantity += item.quantity;
      }
    }

    // Calculate total quantity by summing up all product quantities
    num totalQuantity = checkoutList.length;

    totalPriceAndQuantity.value = {
      "totalPrice": totalPrice,
      "totalQuantity": totalQuantity,
    };
  }

  // Method to toggle the state of the master checkbox
  void toggleMasterCheckbox() {
    isMasterCheckboxChecked.value = !isMasterCheckboxChecked.value;

    CartItem? item;
    // Toggle the state of all other checkboxes
    itemCheckboxState.forEach((productID, checkboxState) {
      checkboxState.value = isMasterCheckboxChecked.value;
      for (var cartItem in cartController.cartItems) {
        if (cartItem.productID == productID) {
          //print("ding ding");
          item = cartItem;
        }
      }
      //print(cartController.cartItems);
      toggleCheckbox(
        productID: productID,
        value: isMasterCheckboxChecked.value,
        quantity: item!.quantity,
        price: item!.price,
        cartID: item!.cartItemID,
        optionName: item!.optionName,
      );
    });
  }

  // void toggleCheckbox({
  //   String? productID,
  //   bool? value,
  //   quantity,
  //   price,
  //   user,
  // }) {
  //   itemCheckboxState[productID]?.value = value!;
  //   if (value!) {
  //     // Add the item to the checkoutList
  //     checkoutList.add(
  //       CheckOutTickBoxModel(
  //         productID: productID,
  //         price: price,
  //         quantity: quantity,
  //         user: user,
  //         // Add other necessary properties
  //       ),
  //     );
  //   } else {
  //     // Remove the item from the checkoutList
  //     checkoutList.removeWhere((item) => item.productID == productID);
  //   }
  //   update();
  // }

  removeFromCart() async {
    isLoading.value = true;
    //print(deletableItems.length);
    var result = await DataBaseService().removeFromCart(deletableCartItems);
    if (result == 'success') {
      isLoading.value = false;
      Get.snackbar(
        "Deleted",
        "Successfully deleted item(s) from cart ",
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
    itemCheckboxState.clear();
    checkoutList.clear();
    totalPriceAndQuantity.clear();
    update();
  }

  void toggleCheckbox({
    String? productID,
    bool? value,
    quantity,
    price,
    user,
    String? cartID,
    String? optionName,
  }) {
    itemCheckboxState[productID]?.value = value!;
    if (value!) {
      // Check if the item already exists in the checkout list
      bool itemExists = checkoutList.any((item) {
        if (optionName != null) {
          return item.productID == productID && item.optionName == optionName;
        } else {
          return item.productID == productID;
        }
      });
      bool itemExists2 = deletableCartItems.any((item) => item == cartID);
      // If the item doesn't exist, add it to the checkout list
      if (!itemExists && !itemExists2) {
        deletableCartItems.add(cartID!);
        checkoutList.add(
          CheckOutTickBoxModel(
            productID: productID,
            price: price,
            quantity: quantity,
            user: user,
            optionName: optionName,
            // Add other necessary properties
          ),
        );
      }
    } else {
      // Remove the item from the checkoutList if it exists
      checkoutList.removeWhere((item) => item.productID == productID);
      deletableCartItems.removeWhere((item) => item == cartID);
    }
    //print(deletableCartItems);

    // Update the state
    // update();
  }

  createCheckOutItem(
    String productID,
    quantity,
    price,
    MyUser user,
  ) {
    checkOutItem.value = CheckoutItem(
      productId: productID,
      quantity: quantity.toString(),
      price: price.toString(),
      fullName: user.fullname,
      address: user.address,
      phoneNumber: user.phoneNumber,
      createdAt: DateTime.now().toString(),
    );
    return checkOutItem.value;
  }

  //create checkboxItem
  createCheckBoxItem(String productID, int quantity, num price, MyUser user,
      {String? optionName}) {
    var value = CheckOutTickBoxModel(
      productID: productID,
      quantity: quantity,
      price: price,
      user: user,
      optionName: optionName ?? "",
    );
    return value;
  }

  //create order
  createOrder(
      {String? paymentMethod,
      String? transactionID,
      String? productPrice,
      String? orderQuantity,
      String? productID,
      String? vendorID,
      Address? deliveryAddress,
      num? totalPrice,
      String? recipientCode,
      MyUser? user,
      num? paymentPrice,
      int? installmentNumber,
      int? installmentPaid,
      String? optionName}) async {
    order.value = Orders(
        buyerId: user!.uid,
        vendorId: vendorID,
        installmentNumber: installmentNumber,
        paymentPrice: paymentPrice,
        installmentPaid: installmentPaid,
        shippingAddress: deliveryAddress,
        totalPrice: totalPrice,
        paymentMethod: paymentMethod,
        recipientCode: recipientCode,
        paymentStatus: "paid",
        orderStatus: "created",
        transactionID: [transactionID]);
    orderItem.value = OrderItem(
      productId: productID,
      quantity: orderQuantity,
      price: productPrice,
      optionName: optionName,
    );

    var response =
        await DataBaseService().createOrder(order.value!, orderItem.value!);
    isLoading.value = true;
    if (response.keys.contains('Order Created')) {
      isLoading.value = false;
      Get.snackbar(
        "Success",
        "Order has been placed",
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
      return 'success';
      // Timer(const Duration(seconds: 3), () {
      //   DataBaseService().updateWalletAfterOrderPlacement(
      //       order.value!.vendorId!,
      //       order.value!.paymentPrice!,
      //       response["Order Created"],
      //       "credit");
      // });
    } else {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Problem creating your order",
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

  //update order status
  updateOrderStatus(String orderID, String orderStatus) async {
    var result =
        await DataBaseService().updateOrderStatus(orderID, orderStatus);
    if (result == "success") {
      Get.snackbar(
        "Success",
        "Order Status Updated",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1, milliseconds: 500),
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
        "Failed to update Order Status",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1, milliseconds: 500),
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

  //get buyer orders
  Stream<List<DatabaseOrderResponse>> getBuyerOrders(String userID) {
    var resultStream = DataBaseService().getBuyerOrdersStream(userID);
    resultStream.listen((buyerOrders) {
      buyerOrderList.assignAll(buyerOrders);
      filterTheBuyerOrderList(buyerOrders);
    });
    return resultStream;
  }

  //get sellers orders
  Stream<List<DatabaseOrderResponse>> getSellerOrders(String userID) {
    var resultStream = DataBaseService().getVendorsOrders(userID);
    resultStream.listen((buyerOrders) {
      vendorOrderList.assignAll(buyerOrders);
      filterVendorOrdersList(buyerOrders);
      //getTotalSales();
    });
    return resultStream;
  }

  //get single order irrespective of user
  Future getSingleOrder(String orderID) async {
    return await DataBaseService().getSingleOrder(orderID);
  }

  //update order
  Future updateOrder(Orders order) async {
    var result = await DataBaseService().updateOrder(order);
    if (result == "success") {
      orderUpdateStatus.value = result;
      Get.snackbar(
        "Success",
        "Order Status Updated",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1, milliseconds: 500),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Colors.green[200],
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: screenHeight * 0.08,
        ),
      );
      orderUpdateStatus.value = "";
    } else {
      Get.snackbar(
        "Error",
        "Failed to update Order Status",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1, milliseconds: 500),
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

  //verify paystack transaction
  Future<bool> verifyTransaction({required String reference}) async {
    var response =
        await DataBaseService().verifyTransaction(reference: reference);
    return response;
  }
}
