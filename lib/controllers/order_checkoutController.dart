import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:hair_main_street/controllers/cartController.dart';
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
  var orderUpdateStatus = "".obs;
  num screenHeight = Get.height;
  RxString userUID = "".obs;
  var isLoading = false.obs;
  var isChecked = false.obs;
  var checkOutTickBoxModel = CheckOutTickBoxModel().obs;
// Map to store the checkbox state for each productID
  final Map<String, RxBool> itemCheckboxState = {};

  // List to store selected items
  List<CheckOutTickBoxModel> checkoutList = <CheckOutTickBoxModel>[].obs;

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

    // Toggle the state of all other checkboxes
    itemCheckboxState.forEach((productID, checkboxState) {
      checkboxState.value = isMasterCheckboxChecked.value;
      var item;
      for (var cartItem in cartController.cartItems) {
        if (cartItem.productID == productID) {
          //print("ding ding");'
          item = cartItem;
        }
      }
      toggleCheckbox(
          productID: productID,
          value: isMasterCheckboxChecked.value,
          quantity: item.quantity,
          price: item.price);
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

  void toggleCheckbox({
    String? productID,
    bool? value,
    quantity,
    price,
    user,
  }) {
    itemCheckboxState[productID]?.value = value!;
    if (value!) {
      // Check if the item already exists in the checkout list
      bool itemExists = checkoutList.any((item) => item.productID == productID);

      // If the item doesn't exist, add it to the checkout list
      if (!itemExists) {
        checkoutList.add(
          CheckOutTickBoxModel(
            productID: productID,
            price: price,
            quantity: quantity,
            user: user,
            // Add other necessary properties
          ),
        );
      }
    } else {
      // Remove the item from the checkoutList if it exists
      checkoutList.removeWhere((item) => item.productID == productID);
    }

    // Update the state
    update();
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
  createCheckBoxItem(
    String productID,
    int quantity,
    num price,
    MyUser user,
  ) {
    var value = CheckOutTickBoxModel(
      productID: productID,
      quantity: quantity,
      price: price,
      user: user,
    );
    return value;
  }

  //create order
  createOrder(
      {String? paymentMethod,
      String? productPrice,
      String? orderQuantity,
      String? productID,
      String? vendorID,
      String? shippingAddress,
      num? totalPrice,
      MyUser? user,
      int? paymentPrice,
      int? installmentNumber,
      int? installmentPaid}) async {
    order.value = Orders(
      buyerId: user!.uid,
      vendorId: vendorID,
      installmentNumber: installmentNumber,
      paymentPrice: paymentPrice,
      installmentPaid: installmentPaid,
      shippingAddress: shippingAddress,
      totalPrice: totalPrice,
      paymentMethod: paymentMethod,
      paymentStatus: "paid",
      orderStatus: "created",
    );
    orderItem.value = OrderItem(
        productId: productID, quantity: orderQuantity, price: productPrice);

    var response =
        await DataBaseService().createOrder(order.value!, orderItem.value!);
    isLoading.value = true;
    if (response.keys.contains('Order Created')) {
      isLoading.value = false;
      Get.snackbar(
        "Success",
        "Order has been placed",
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
    var resultStream = DataBaseService().getBuyerOrders(userID);
    resultStream.listen((buyerOrders) {
      buyerOrderList.assignAll(buyerOrders);
      filterTheBuyerOrderList(buyerOrders);
    });
    return resultStream;
  }

  //get sellers orders
  void getSellerOrders(String userID) {
    var result = DataBaseService().getVendorsOrders(userID);
    vendorOrderList.bindStream(result);
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
  Future verifyTransaction({required String reference}) async {
    var response =
        await DataBaseService().verifyTransaction(reference: reference);
    return response;
  }
}
