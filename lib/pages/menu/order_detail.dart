// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/models/vendorsModel.dart';
import 'package:hair_main_street/pages/cancellation_page.dart';
import 'package:hair_main_street/pages/orders_stuff/payment_page.dart';
import 'package:hair_main_street/pages/submit_review_page.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:hair_main_street/widgets/loading.dart';

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

class OrderDetailsPage extends StatefulWidget {
  DatabaseOrderResponse? orderDetails;
  Product? product;
  OrderDetailsPage({this.product, this.orderDetails, super.key});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  CheckOutController checkOutController = Get.find<CheckOutController>();
  UserController userController = Get.find<UserController>();
  var installmentDuration;

  @override
  void initState() {
    getVendorDetails();
    super.initState();
  }

  getVendorDetails() async {
    Vendors? response = await userController
        .getVendorDetailsFuture(widget.orderDetails!.vendorId!);
    installmentDuration = response!.installmentDuration!;
  }

  @override
  Widget build(BuildContext context) {
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    var isVisible = (widget.orderDetails!.orderStatus == "delivered").obs;
    var isVisible2 = (widget.orderDetails!.orderStatus == "confirmed").obs;

    DateTime calculateDateTime(int timeInMilliseconds, Timestamp timestamp) {
      // Convert the Timestamp object to milliseconds since epoch
      int timestampMilliseconds =
          timestamp.seconds * 1000 + timestamp.nanoseconds ~/ 1000000;

      // Add the time in milliseconds to the timestamp milliseconds
      int totalMilliseconds = timestampMilliseconds + timeInMilliseconds;

      // Create a DateTime object from the total milliseconds
      return DateTime.fromMillisecondsSinceEpoch(totalMilliseconds);
    }

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
      orderId: widget.orderDetails!.orderId,
      paymentStatus: widget.orderDetails!.paymentStatus,
      paymentMethod: widget.orderDetails!.paymentMethod,
      shippingAddress: widget.orderDetails!.shippingAddress,
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
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(gradient: appBarGradient),
        // ),
        //backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder(
          future: DataBaseService()
              .getVendorDetailsFuture(userID: widget.orderDetails!.vendorId!),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadingWidget();
            }
            return Container(
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
                                child: Image.network(
                                  widget.product?.image?.isNotEmpty == true
                                      ? widget.product!.image!.first
                                      : "https://firebasestorage.googleapis.com/v0/b/hairmainstreet.appspot.com/o/productImage%2Fnot%20available.jpg?alt=media&token=ea001edd-ec0f-4ffb-9a2d-efae1a28fc40",
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.product!.name}",
                                      maxLines: 4,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "NGN ${widget.product!.price}",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                          "x${widget.orderDetails!.orderItem!.first.quantity}",
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
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
                              Text(resolveTimestamp(
                                  widget.orderDetails!.createdAt, 3)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment:
                              widget.orderDetails!.orderStatus != "confirmed"
                                  ? MainAxisAlignment.spaceBetween
                                  : MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: widget.orderDetails!.orderStatus !=
                                  "confirmed",
                              child: Expanded(
                                flex: 1,
                                child: TextButton(
                                  onPressed: () {
                                    Get.to(
                                      () => CancellationPage(
                                        orderId: widget.orderDetails!.orderId!,
                                      ),
                                      transition: Transition.fadeIn,
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: const BorderSide(
                                        width: 1.5,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Cancel Order",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            widget.orderDetails!.orderStatus != "confirmed"
                                ? const SizedBox(
                                    width: 10,
                                  )
                                : SizedBox.shrink(),
                            Visibility(
                              visible: widget.orderDetails!.orderStatus ==
                                  'confirmed',
                              child: Expanded(
                                flex: 1,
                                child: TextButton(
                                  onPressed: () {
                                    Get.to(
                                      () => RefundPage(
                                        orderId: widget.orderDetails!.orderId!,
                                      ),
                                      transition: Transition.fadeIn,
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
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
                            Text("${widget.orderDetails!.orderId}")
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
                            Text("${widget.orderDetails!.orderStatus}")
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
                                "${resolveTimestampWithoutAdding(widget.orderDetails!.createdAt)}")
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
                            Text("${widget.orderDetails!.paymentStatus}")
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
                            Text("${widget.orderDetails!.paymentMethod}")
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
                            Text("₦${widget.orderDetails!.paymentPrice}")
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
                                "${widget.orderDetails!.shippingAddress}",
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 7,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              Get.to(
                                () => MessagesPage(
                                  senderID: widget.orderDetails!.buyerId,
                                  receiverID: widget.orderDetails!.vendorId,
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
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
                    visible: widget.orderDetails!.paymentPrice !=
                        widget.orderDetails!.totalPrice,
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
                                  "₦${widget.orderDetails!.totalPrice! - widget.orderDetails!.paymentPrice!.toInt()}")
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Text(
                                "Installment Remaining: ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "₦${(widget.orderDetails?.installmentNumber?.toInt() ?? 0) - (widget.orderDetails?.installmentPaid?.toInt() ?? 0)}",
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Text(
                                "To be Paid Before: ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Expanded(
                                child: Text(
                                    "${calculateDateTime(installmentDuration, widget.orderDetails!.updatedAt!)}"),
                              )
                            ],
                          ),
                          Divider(
                            height: 7,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                Get.to(
                                  () => PaymentPage(
                                    orderDetails: widget.orderDetails,
                                    expectedTimeToPay: calculateDateTime(
                                            installmentDuration,
                                            widget.orderDetails!.updatedAt!)
                                        .toString(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.black,
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 2,
                              color: Colors.black,
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
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
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
                  const SizedBox(
                    height: 8,
                  ),
                  Obx(
                    () {
                      return Visibility(
                        visible: isVisible2.value,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 2,
                              color: Colors.black,
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
                                "Care to Write a Review?",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: Colors.white,
                                        width: 1.2,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.to(() => SubmitReviewPage(
                                          productID: widget.product!.productID,
                                        ));
                                    // order.orderStatus = "confirmed";
                                    // await checkOutController.updateOrder(order);
                                    // isVisible.value = false;
                                  },
                                  child: Text(
                                    "Write a Review",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
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
            );
          }),
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
