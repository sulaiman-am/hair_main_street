// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';

import 'dart:ffi';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/models/orderModel.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/pages/messages.dart';
import 'package:hair_main_street/pages/product_page.dart';
import 'package:hair_main_street/pages/refund.dart';
import 'package:material_symbols_icons/symbols.dart';

class OrderDetailsPage extends StatelessWidget {
  DatabaseOrderResponse? orderDetails;
  Product? product;
  OrderDetailsPage({this.product, this.orderDetails, super.key});

  @override
  Widget build(BuildContext context) {
    CheckOutController checkOutController = Get.find<CheckOutController>();
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    var isVisible = (orderDetails!.orderStatus == "delivered").obs;

    DateTime resolveTimestampWithoutAdding(Timestamp timestamp) {
      DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime

      // Add days to the DateTime
      //DateTime newDateTime = dateTime.add(Duration(days: daysToAdd));

      return dateTime;
    }

    String resolveTimestamp(Timestamp timestamp, int daysToAdd) {
      DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime

      // Add days to the DateTime
      DateTime newDateTime = dateTime.add(Duration(days: daysToAdd));

      // Format the DateTime without the time part
      String formattedDate = DateFormat('yyyy-MM-dd').format(newDateTime);

      return formattedDate;
    }

    Orders order = Orders(
      orderId: orderDetails!.orderId,
      paymentStatus: orderDetails!.paymentStatus,
      paymentMethod: orderDetails!.paymentMethod,
      shippingAddress: orderDetails!.shippingAddress,
    );

    Gradient myGradient = const LinearGradient(
      colors: [
        Color.fromARGB(255, 255, 224, 139),
        Color.fromARGB(255, 200, 242, 237)
      ],
      stops: [
        0.05,
        0.99,
      ],
      end: Alignment.topCenter,
      begin: Alignment.bottomCenter,
      //transform: GradientRotation(math.pi / 4),
    );
    Gradient appBarGradient = const LinearGradient(
      colors: [
        Color.fromARGB(255, 200, 242, 237),
        Color.fromARGB(255, 255, 224, 139)
      ],
      stops: [
        0.05,
        0.99,
      ],
      end: Alignment.topCenter,
      begin: Alignment.bottomCenter,
      //transform: GradientRotation(math.pi / 4),
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded,
              size: 24, color: Colors.black),
        ),
        title: const Text(
          'Order Details',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0E4D92),
          ),
        ),
        centerTitle: true,
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(gradient: appBarGradient),
        // ),
        //backgroundColor: Colors.transparent,
      ),
      body: Container(
        //decoration: BoxDecoration(gradient: myGradient),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          children: [
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            //   decoration: BoxDecoration(
            //     color: Colors.grey[200],
            //     borderRadius: BorderRadius.circular(12),
            //     border: Border.all(
            //       width: 2,
            //       color: Color(0xFF392F5A),
            //     ),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Color(0xFF000000),
            //         blurStyle: BlurStyle.normal,
            //         offset: Offset.zero,
            //         blurRadius: 2,
            //       ),
            //     ],
            //   ),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         children: [
            //           HeaderText(
            //             text: "Delivery Status: ",
            //           ),
            //           Expanded(
            //             child: Text(
            //               "Awaiting Confirmation",
            //               style: TextStyle(
            //                   color: Colors.black,
            //                   fontSize: 16,
            //                   overflow: TextOverflow.ellipsis,
            //                   fontWeight: FontWeight.w600),
            //               //overflow: TextOverflow.ellipsis,
            //               maxLines: 2,
            //             ),
            //           ),
            //         ],
            //       ),
            //       const Text(
            //         "Complying with company policy, all deliveries are automatically confirmed 72hrs after order placement",
            //         style: TextStyle(
            //           color: Colors.black,
            //           fontSize: 16,
            //         ),
            //         maxLines: 3,
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(
            //   height: 16,
            // ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 2,
                  color: Color(0xFF392F5A),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF000000),
                    blurStyle: BlurStyle.normal,
                    offset: Offset.fromDirection(-4.0),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Get.to(
                      //   () => ProductPage(),
                      //   transition: Transition.fadeIn,
                      // );
                      //debugPrint("Clicked");
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          width: screenWidth * 0.32,
                          height: screenHeight * 0.16,
                          child: Image.network(product!.image!.first),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${product!.name}",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "₦${product!.price}",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Quantity",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  "x${orderDetails!.orderItem!.first.quantity}",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                      color: Colors.grey[400],
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Color(0xFF000000),
                      //     blurStyle: BlurStyle.normal,
                      //     offset: Offset.fromDirection(-2.0),
                      //     blurRadius: 2,
                      //   ),
                      // ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Estimated Delivery Date: "),
                        Text("${resolveTimestamp(orderDetails!.createdAt, 3)}"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        //margin: EdgeInsets.only(left: 270),
                        child: TextButton(
                          onPressed: () {
                            Get.to(
                              () => RefundPage(),
                              transition: Transition.fadeIn,
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF392F5A),
                            padding: EdgeInsets.all(4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                width: 1.5,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          child: Text(
                            "Refund",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 2,
                  color: Color(0xFF392F5A),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF000000),
                    blurStyle: BlurStyle.normal,
                    offset: Offset.fromDirection(-4.0),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderText(
                    text: "Order Info",
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text(
                        "Order ID: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text("${orderDetails!.orderId}")
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text(
                        "Order Status: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text("${orderDetails!.orderStatus}")
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text("Placed at: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      Text(
                          "${resolveTimestampWithoutAdding(orderDetails!.createdAt)}")
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text("Payment Status: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      Text("${orderDetails!.paymentStatus}")
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text("Payment Method: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      Text("${orderDetails!.paymentMethod}")
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text("Payment Price: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      Text("₦${orderDetails!.paymentPrice}")
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text("Delivery Address: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      Expanded(
                        child: Text(
                          "${orderDetails!.shippingAddress}",
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 7,
                    color: Colors.black,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Get.to(
                          () => MessagesPage(
                            senderID: orderDetails!.buyerId,
                            receiverID: orderDetails!.vendorId,
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF392F5A),
                        padding: EdgeInsets.all(4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            width: 1.5,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      child: Text(
                        "Contact Vendor",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Visibility(
              visible: orderDetails!.paymentPrice != orderDetails!.totalPrice,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 2,
                    color: Color(0xFF392F5A),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF000000),
                      blurStyle: BlurStyle.normal,
                      offset: Offset.fromDirection(-4.0),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderText(
                      text: "Remaining Payment",
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          "Amount Remaining: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                            "₦${orderDetails!.totalPrice! - orderDetails!.paymentPrice!.toInt()}")
                      ],
                    ),
                    Divider(
                      height: 7,
                      color: Colors.black,
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Get.to(() => MessagesPage());
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFF392F5A),
                          padding: EdgeInsets.all(4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              width: 1.5,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        child: Text(
                          "Pay Amount",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () {
                return Visibility(
                  visible: isVisible.value,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        width: 2,
                        color: Color(0xFF392F5A),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF000000),
                          blurStyle: BlurStyle.normal,
                          offset: Offset.fromDirection(-4.0),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Your Order has been marked as delivered by the vendor",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF392F5A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Colors.white,
                                  width: 1.2,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              order.orderStatus = "confirmed";
                              await checkOutController.updateOrder(order);
                              isVisible.value = false;
                            },
                            child: Text(
                              "Confirm",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  final String? text;
  const HeaderText({
    this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      padding: EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
      ),
      child: Text(
        text!,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
