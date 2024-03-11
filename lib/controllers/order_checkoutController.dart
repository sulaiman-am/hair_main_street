import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/models/auxModels.dart';
import 'package:hair_main_street/models/cartItemModel.dart';
import 'package:hair_main_street/models/orderModel.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/services/database.dart';

class CheckOutController extends GetxController {
  Rx<CheckoutItem> checkOutItem = CheckoutItem().obs;
  Rx<DatabaseOrderResponse> singleOrder = DatabaseOrderResponse().obs;
  //var checkoutList = <CheckOutTickBoxModel>[].obs;
  RxList<DatabaseOrderResponse> buyerOrderList =
      RxList<DatabaseOrderResponse>([]);
  RxList<DatabaseOrderResponse> vendorOrderList =
      RxList<DatabaseOrderResponse>([]);
  Rx<Orders?> order = Rx<Orders?>(null);
  Rx<OrderItem?> orderItem = Rx<OrderItem?>(null);
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

  // @override
  // void onReady() {
  //   super.onReady();
  //   //isChecked.value = isCheckedFunction(checkOutTickBoxModel.value);
  //   vendorOrderList.bindStream(getSellerOrders(userUID.value));
  //   buyerOrderList.bindStream(getBuyerOrders(userUID.value));
  //   print(vendorOrderList);
  // }

  // Method to toggle the state of the master checkbox
  void toggleMasterCheckbox() {
    isMasterCheckboxChecked.value = !isMasterCheckboxChecked.value;

    // Toggle the state of all other checkboxes
    itemCheckboxState.forEach((productID, checkboxState) {
      checkboxState.value = isMasterCheckboxChecked.value;
      toggleCheckbox(
          productID: productID, value: isMasterCheckboxChecked.value);
    });
  }

  void toggleCheckbox({
    String? productID,
    bool? value,
    quantity,
    price,
    user,
  }) {
    itemCheckboxState[productID]?.value = value!;
    if (value!) {
      // Add the item to the checkoutList
      checkoutList.add(
        CheckOutTickBoxModel(
          productID: productID,
          price: price,
          quantity: quantity,
          user: user,
          // Add other necessary properties
        ),
      );
    } else {
      // Remove the item from the checkoutList
      checkoutList.removeWhere((item) => item.productID == productID);
    }
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

  //create order
  createOrder(
      {String? paymentMethod,
      String? vendorID,
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
      shippingAddress: checkOutItem.value.address,
      totalPrice: int.parse(checkOutItem.value.price!),
      paymentMethod: paymentMethod,
      paymentStatus: "paid",
      orderStatus: "created",
    );
    orderItem.value = OrderItem(
        productId: checkOutItem.value.productId,
        quantity: checkOutItem.value.quantity,
        price: checkOutItem.value.price);

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
      Timer(const Duration(seconds: 3), () {
        DataBaseService().updateWalletAfterOrderPlacement(
            order.value!.vendorId!,
            order.value!.paymentPrice!,
            response["Order Created"],
            "credit");
      });
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
  getBuyerOrders(String userID) {
    var result = DataBaseService().getBuyerOrders(userID);
    buyerOrderList.bindStream(result);
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
