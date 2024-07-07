// ignore_for_file: prefer_const_constructors
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/models/vendorsModel.dart';
import 'package:hair_main_street/pages/cancellation_page.dart';
import 'package:hair_main_street/pages/orders_stuff/payment_page.dart';
import 'package:hair_main_street/pages/product_page.dart';
import 'package:hair_main_street/pages/submit_review_page.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:hair_main_street/widgets/loading.dart';

import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/models/orderModel.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/pages/messages.dart';
import 'package:hair_main_street/pages/refund.dart';
import 'package:material_symbols_icons/symbols.dart';

class OrderDetailsPage extends StatefulWidget {
  final DatabaseOrderResponse? orderDetails;
  final Product? product;
  const OrderDetailsPage({this.product, this.orderDetails, super.key});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  CheckOutController checkOutController = Get.find<CheckOutController>();
  UserController userController = Get.find<UserController>();
  num? installmentDuration;

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
      String formattedDate = DateFormat('dd-MM-yyyy').format(newDateTime);

      return formattedDate;
    }

    Orders order = Orders(
      orderId: widget.orderDetails!.orderId,
      paymentStatus: widget.orderDetails!.paymentStatus,
      paymentMethod: widget.orderDetails!.paymentMethod,
      shippingAddress: widget.orderDetails!.shippingAddress != null
          ? widget.orderDetails!.shippingAddress!
          : Address(),
    );

    String formatCurrency(String numberString) {
      final number =
          double.tryParse(numberString) ?? 0.0; // Handle non-numeric input
      final formattedNumber =
          number.toStringAsFixed(2); // Format with 2 decimals

      // Split the number into integer and decimal parts
      final parts = formattedNumber.split('.');
      final intPart = parts[0];
      final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

      // Format the integer part with commas for every 3 digits
      final formattedIntPart = intPart.replaceAllMapped(
        RegExp(r'\d{1,3}(?=(\d{3})+(?!\d))'),
        (match) => '${match.group(0)},',
      );

      // Combine the formatted integer and decimal parts
      final formattedResult = formattedIntPart + decimalPart;

      return formattedResult;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded,
              size: 24, color: Colors.black),
        ),
        title: const Text(
          'Order Detail',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            fontFamily: 'Lato',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // Adjust height as needed
          child: Divider(
            thickness: 1.0, // Adjust thickness as needed
            color: Colors.black.withOpacity(0.2), // Adjust color as needed
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: DataBaseService()
              .getVendorDetailsFuture(userID: widget.orderDetails!.vendorId!),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadingWidget();
            }
            return SingleChildScrollView(
              //padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => ProductPage(
                                id: widget
                                    .orderDetails!.orderItem![0].productId,
                              ),
                              transition: Transition.fadeIn,
                            );
                            //debugPrint("Clicked");
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                // decoration: BoxDecoration(
                                //   color: Colors.black45,
                                // ),
                                // width: screenWidth * 0.32,
                                // height: screenHeight * 0.16,
                                child: CachedNetworkImage(
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 140,
                                    width: 123,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  fit: BoxFit.fill,
                                  imageUrl: widget.product?.image == null ||
                                          widget.product?.image!.isNotEmpty ==
                                              true
                                      ? widget.product?.image!.first
                                      : 'https://firebasestorage.googleapis.com/v0/b/hairmainstreet.appspot.com/o/productImage%2FImage%20Not%20Available.jpg?alt=media&token=0104c2d8-35d3-4e4f-a1fc-d5244abfeb3f',
                                  errorWidget: ((context, url, error) =>
                                      Text("Failed to Load Image")),
                                  placeholder: ((context, url) => const Center(
                                        child: CircularProgressIndicator(),
                                      )),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 140,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${widget.product!.name}",
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: 'Lato',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Order Quantity:",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Raleway',
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Text(
                                            "${widget.orderDetails!.orderItem!.first.quantity}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Raleway',
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          widget.orderDetails!.paymentStatus ==
                                                  "paid"
                                              ? Icon(
                                                  Icons
                                                      .check_circle_outline_outlined,
                                                  color: Colors.green[400],
                                                  size: 20,
                                                )
                                              : Icon(
                                                  Icons.pending_outlined,
                                                  color: Colors.black,
                                                  size: 20,
                                                ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Text(
                                            "${widget.orderDetails!.paymentStatus}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Raleway',
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        ExpansionTile(
                          initiallyExpanded: true,
                          tilePadding: EdgeInsets.symmetric(horizontal: 0),
                          backgroundColor: Colors.white,
                          iconColor: Colors.black,
                          collapsedIconColor: Colors.black,
                          childrenPadding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 0),
                          title: const Text(
                            "Order Info",
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Order ID: ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
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
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        "${resolveTimestampWithoutAdding(widget.orderDetails!.createdAt)}")
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text("Payment Method: ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        "${widget.orderDetails!.paymentMethod}")
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text("Payment Price: ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        "₦${widget.orderDetails!.paymentPrice}")
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text("Delivery Address: ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                    // Expanded(
                                    //   child: Text(
                                    //     "${widget.orderDetails?.shippingAddress!.landmark ?? ""},${widget.orderDetails?.shippingAddress!.streetAddress},${widget.orderDetails?.shippingAddress!.lGA},${widget.orderDetails?.shippingAddress!.state}.${widget.orderDetails?.shippingAddress!.zipCode ?? ""}",
                                    //     maxLines: 3,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            )
                          ],
                          // subtitle: Text(
                          //   "${product?.options?.length ?? 0} product options",
                          //   style: TextStyle(
                          //     fontFamily: 'Lato',
                          //     fontSize: 13,
                          //     fontWeight: FontWeight.w500,
                          //     color: Colors.black.withOpacity(0.50),
                          //   ),
                          // ),
                        ),
                        const SizedBox(
                          height: 20,
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
                                        paymentAmount:
                                            widget.orderDetails!.paymentPrice!,
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
                                        paymentAmount:
                                            widget.orderDetails!.paymentPrice!,
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
                  //         offset: Offset.fromDirection(-4.0),
                  //         blurRadius: 2,
                  //       ),
                  //     ],
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       HeaderText(
                  //         text: "Order Info",
                  //       ),
                  //       SizedBox(
                  //         height: 8,
                  //       ),
                  //       Row(
                  //         children: [
                  //           Text(
                  //             "Order ID: ",
                  //             style: TextStyle(
                  //                 fontSize: 16, fontWeight: FontWeight.w600),
                  //           ),
                  //           Text("${widget.orderDetails!.orderId}")
                  //         ],
                  //       ),
                  //       SizedBox(
                  //         height: 8,
                  //       ),
                  //       Row(
                  //         children: [
                  //           Text(
                  //             "Order Status: ",
                  //             style: TextStyle(
                  //                 fontSize: 16, fontWeight: FontWeight.w600),
                  //           ),
                  //           Text("${widget.orderDetails!.orderStatus}")
                  //         ],
                  //       ),
                  //       SizedBox(
                  //         height: 8,
                  //       ),
                  //       Row(
                  //         children: [
                  //           Text("Placed at: ",
                  //               style: TextStyle(
                  //                   fontSize: 16, fontWeight: FontWeight.w600)),
                  //           Text(
                  //               "${resolveTimestampWithoutAdding(widget.orderDetails!.createdAt)}")
                  //         ],
                  //       ),
                  //       SizedBox(
                  //         height: 8,
                  //       ),
                  //       Row(
                  //         children: [
                  //           Text("Payment Status: ",
                  //               style: TextStyle(
                  //                   fontSize: 16, fontWeight: FontWeight.w600)),
                  //           Text("${widget.orderDetails!.paymentStatus}")
                  //         ],
                  //       ),
                  //       SizedBox(
                  //         height: 8,
                  //       ),
                  //       Row(
                  //         children: [
                  //           Text("Payment Method: ",
                  //               style: TextStyle(
                  //                   fontSize: 16, fontWeight: FontWeight.w600)),
                  //           Text("${widget.orderDetails!.paymentMethod}")
                  //         ],
                  //       ),
                  //       SizedBox(
                  //         height: 8,
                  //       ),
                  //       Row(
                  //         children: [
                  //           Text("Payment Price: ",
                  //               style: TextStyle(
                  //                   fontSize: 16, fontWeight: FontWeight.w600)),
                  //           Text("₦${widget.orderDetails!.paymentPrice}")
                  //         ],
                  //       ),
                  //       SizedBox(
                  //         height: 8,
                  //       ),
                  //       Row(
                  //         children: [
                  //           Text("Delivery Address: ",
                  //               style: TextStyle(
                  //                   fontSize: 16, fontWeight: FontWeight.w600)),
                  //           Expanded(
                  //             child: Text(
                  //               "${widget.orderDetails!.shippingAddress}",
                  //               maxLines: 3,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       Divider(
                  //         height: 7,
                  //         color: Colors.black,
                  //       ),
                  //       SizedBox(
                  //         width: double.infinity,
                  //         child: TextButton(
                  //           onPressed: () {
                  //             Get.to(
                  //               () => MessagesPage(
                  //                 senderID: widget.orderDetails!.buyerId,
                  //                 receiverID: widget.orderDetails!.vendorId,
                  //               ),
                  //             );
                  //           },
                  //           style: TextButton.styleFrom(
                  //             backgroundColor: Colors.black,
                  //             padding: EdgeInsets.symmetric(
                  //                 horizontal: 8, vertical: 4),
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(12),
                  //               side: const BorderSide(
                  //                 width: 1.5,
                  //                 color: Colors.black,
                  //               ),
                  //             ),
                  //           ),
                  //           child: Text(
                  //             "Contact Vendor",
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 20,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
                                    "${calculateDateTime(installmentDuration as int, widget.orderDetails!.updatedAt!)}"),
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
                                            installmentDuration as int,
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
