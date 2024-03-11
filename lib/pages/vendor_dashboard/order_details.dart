import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/models/orderModel.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/pages/feed.dart';
import 'package:hair_main_street/pages/messages.dart';
import 'package:hair_main_street/pages/product_page.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorOrderDetailsPage extends StatefulWidget {
  DatabaseOrderResponse? orderDetails;
  Product? product;
  VendorOrderDetailsPage({this.orderDetails, this.product, super.key});

  @override
  State<VendorOrderDetailsPage> createState() => _VendorOrderDetailsPageState();
}

class _VendorOrderDetailsPageState extends State<VendorOrderDetailsPage> {
  final GetStorage box = GetStorage();

  late String? dropDownValue;

  UserController userController = Get.find<UserController>();
  CheckOutController checkOutController = Get.find<CheckOutController>();

  ///String selectedStatus = "created";

  @override
  void initState() {
    super.initState();
    _loadSelectedStatus();
  }

  Future<void> _loadSelectedStatus() async {
    dropDownValue = widget.orderDetails!.orderStatus;
    box.write('dropDownValue', dropDownValue);
    setState(() {});
  }

  Future<void> _saveSelectedStatus(String value) async {
    await box.write('dropDownValue', value);
  }

  @override
  Widget build(BuildContext context) {
    userController.getBuyerDetails(widget.orderDetails!.buyerId!);
    //MyUser? buyerDetails = userController.buyerDetails.value;

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

    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
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
      body: Obx(() {
        MyUser? buyerDetails = userController.buyerDetails.value;
        return userController.buyerDetails.value == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                //decoration: BoxDecoration(gradient: myGradient),
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 12),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            // padding: EdgeInsets.symmetric(
                            //     horizontal: screenWidth * 0.24),
                            backgroundColor: const Color(0xFF392F5A),
                            side:
                                const BorderSide(color: Colors.white, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Print",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * .006,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 2,
                          color: const Color(0xFF392F5A),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF000000),
                            blurStyle: BlurStyle.normal,
                            offset: Offset.fromDirection(-4.0),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "User Info",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 8,
                          ),
                          Row(
                            children: [
                              const Text("Name: "),
                              Expanded(child: Text("${buyerDetails?.fullname}"))
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              const Text("Phone Number: "),
                              Text("${buyerDetails?.phoneNumber}")
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              const Text("Email: "),
                              Expanded(child: Text("${buyerDetails?.email}"))
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              const Text("Delivery Address: "),
                              Expanded(
                                child: Text(
                                  "${buyerDetails?.address}",
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 7,
                            color: Colors.black,
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Get.to(
                                  () => MessagesPage(
                                    senderID: widget.orderDetails!.vendorId,
                                    receiverID: widget.orderDetails!.buyerId,
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF392F5A),
                                padding: const EdgeInsets.all(4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    width: 1.5,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              child: const Text(
                                "Contact Customer",
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
                    SizedBox(
                      height: screenHeight * .02,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 2,
                          color: const Color(0xFF392F5A),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF000000),
                            blurStyle: BlurStyle.normal,
                            offset: Offset.fromDirection(-4.0),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Order Info",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Divider(
                            height: 7,
                            color: Colors.black,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Order ID: ",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "${widget.orderDetails!.orderId}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Order Date: ",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "${resolveTimestampWithoutAdding(widget.orderDetails!.createdAt)}",
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Total Price: ",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "${widget.orderDetails!.paymentPrice}",
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Quantity: ",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "x${widget.orderDetails!.orderItem!.first.quantity}",
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Payment Method: ",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "${widget.orderDetails!.paymentMethod}",
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Payment Status: ",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "${widget.orderDetails!.paymentStatus}",
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Visibility(
                            visible: widget.orderDetails!.paymentPrice ==
                                widget.orderDetails!.totalPrice,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Order Status: ",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                dropDownValue == "confirmed"
                                    ? Expanded(
                                        flex: 2,
                                        child: Text(
                                          dropDownValue!.capitalizeFirst!,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      )
                                    : Expanded(
                                        child: DropdownButton(
                                          isExpanded: true,
                                          //hint: Text("Hello"),
                                          //style: TextStyle(color: Colors.black),
                                          value: dropDownValue,
                                          items: [
                                            "created",
                                            "not delivered",
                                            "delivered"
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                              onTap: () async =>
                                                  await checkOutController
                                                      .updateOrderStatus(
                                                          widget.orderDetails!
                                                              .orderId!,
                                                          value),
                                            );
                                          }).toList(),
                                          onChanged: (val) {
                                            _saveSelectedStatus(val as String);
                                            setState(() {
                                              if (val != null) {
                                                dropDownValue = val as String;
                                                print(dropDownValue);
                                              }
                                            });
                                            // _loadSelectedStatus();
                                          },
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * .02,
                    ),
                    Visibility(
                      visible: widget.orderDetails!.paymentPrice !=
                          widget.orderDetails!.totalPrice,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                            const Text(
                              "Remaining Payment",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Divider(
                              height: 7,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Amount Remaining: ",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                    "₦${widget.orderDetails!.totalPrice! - widget.orderDetails!.paymentPrice!.toInt()}")
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Installments Paid: ",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "${widget.orderDetails!.installmentPaid} out of ${widget.orderDetails!.installmentNumber}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            // Visibility(
                            //   visible: widget.orderDetails!.paymentPrice ==
                            //       widget.orderDetails!.totalPrice,
                            //   child: Center(
                            //     child: GetX<CheckOutController>(
                            //       builder: (_) {
                            //         return DropdownButton(
                            //           value: dropDownValue,
                            //           items: dropDownItems.map((item) {
                            //             return DropdownMenuItem(
                            //               value: item,
                            //               child: Text("$item"),
                            //             );
                            //           }).toList(),
                            //           onChanged: (val) {
                            //             dropDownValue = val as String;
                            //             print(dropDownValue);
                            //           },
                            //         );
                            //       },
                            //     ),
                            //   ),
                            // ),

                            // Divider(
                            //   height: 7,
                            //   color: Colors.black,
                            // ),
                            // Center(
                            //   child: TextButton(
                            //     onPressed: () {
                            //       Get.to(() => MessagesPage());
                            //     },
                            //     style: TextButton.styleFrom(
                            //       backgroundColor: Color(0xFF392F5A),
                            //       padding: EdgeInsets.all(4),
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(12),
                            //         side: const BorderSide(
                            //           width: 1.5,
                            //           color: Colors.black,
                            //         ),
                            //       ),
                            //     ),
                            //     child: Text(
                            //       "Pay Amount",
                            //       style: TextStyle(
                            //         color: Colors.white,
                            //         fontSize: 20,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * .02,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 2,
                          color: const Color(0xFF392F5A),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF000000),
                            blurStyle: BlurStyle.normal,
                            offset: Offset.fromDirection(-4.0),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Product Info",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Divider(
                            height: 8,
                            color: Colors.black,
                          ),
                          GestureDetector(
                            onTap: () {
                              // Get.to(
                              //   () => ProductPage(),
                              //   transition: Transition.fadeIn,
                              // );
                              //debugPrint("Clicked");
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
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
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${widget.product!.name}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text("₦${widget.product!.price}"),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Quantity Available"),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          Text("x ${widget.product!.quantity}")
                                        ],
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
                      height: screenHeight * .02,
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
