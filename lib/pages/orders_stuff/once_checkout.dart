import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';
import 'package:hair_main_street/controllers/productController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/models/auxModels.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/pages/orders_stuff/payment_successful_page.dart';
import 'package:hair_main_street/pages/profile/add_delivery_address.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:hair_main_street/widgets/loading.dart';
import 'package:material_symbols_icons/symbols.dart';

class OnceCheckoutPage extends StatefulWidget {
  final List<CheckOutTickBoxModel> products;
  const OnceCheckoutPage({required this.products, super.key});

  @override
  State<OnceCheckoutPage> createState() => _OnceCheckoutPageState();
}

class _OnceCheckoutPageState extends State<OnceCheckoutPage> {
  UserController userController = Get.find<UserController>();
  ProductController productController = Get.find<ProductController>();
  CheckOutController checkOutController = Get.find<CheckOutController>();
  String? publicKey = dotenv.env["PAYSTACK_PUBLIC_KEY"];
  final plugin = PaystackPlugin();
  Address? selectedAddress;
  num totalPrice = 0.0;
  Stream? myStream;

  //calculate total Price
  calculateTotal() {
    for (var product in widget.products) {
      totalPrice += product.price!;
    }
  }

  @override
  void initState() {
    myStream = DataBaseService()
        .getDeliveryAddresses(userController.userState.value!.uid!);
    userController.getDeliveryAddresses(userController.userState.value!.uid!);
    plugin.initialize(publicKey: publicKey!);
    calculateTotal();
    if (userController.userState.value!.address != null) {
      selectedAddress = userController.userState.value!.address;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Product? product;
    for (var item in widget.products) {
      product = productController.getSingleProduct(item.productID!);
    }

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

    //error dialog handler
    void showErrorDialog(String message) {
      Get.dialog(
        AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          elevation: 0,
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          content: Text(
            message,
            style: const TextStyle(
              decoration: TextDecoration.none,
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.shade300,
              ),
              child: const Text(
                'Close',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.end,
        ),
      );
    }

    //initiate paystack payment and then create order
    Future<void> initiatePayment(
        {int? paymentPrice,
        String? email,
        String? paymentMethod,
        String? orderQuantity,
        MyUser? user,
        String? vendorID,
        Product? product,
        int? installmentNumber}) async {
      Charge charge = Charge()
        ..amount = paymentPrice! * 100
        ..reference = _getReference()
        ..email = email;

      CheckoutResponse response = await plugin.checkout(
        context,
        method: CheckoutMethod.card,
        charge: charge,
      );

      // Handle the response
      if (response.status) {
        bool verified = await checkOutController.verifyTransaction(
            reference: response.reference!);
        print(response);
        print(response.reference);
        print("verified:$verified");
        if (verified) {
          try {
            int installmentPaid;
            if (installmentNumber != 0) {
              installmentPaid = 1;
            } else {
              installmentPaid = 0;
            }
            var totalPrice = product!.price!;
            var productPrice = (product.price!) / int.parse(orderQuantity!);
            var result = checkOutController.createOrder(
              deliveryAddress: selectedAddress ?? user!.address!,
              totalPrice: totalPrice,
              orderQuantity: orderQuantity,
              installmentPaid: installmentPaid,
              productID: product.productID,
              productPrice: productPrice.toString(),
              paymentMethod: paymentMethod,
              paymentPrice: paymentPrice,
              transactionID: response.reference,
              user: user,
              vendorID: vendorID,
              installmentNumber: installmentNumber,
              optionName: widget.products[0].optionName,
            );
            if (result == 'success') {
              Get.to(() => const PaymentSuccessfulPage());
            }
          } catch (e) {
            print("error: $e");
          }
        } else {
          showErrorDialog("An Error Occured in Payment");
        }
      } else {
        showErrorDialog("You Cancelled Your Payment");
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded,
              size: 20, color: Colors.black),
        ),
        title: const Text(
          'One Time Payment',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            fontFamily: 'Lato',
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(gradient: appBarGradient),
        // ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: myStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget();
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order Summary",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF673AB7).withOpacity(0.75),
                          fontFamily: 'Lato'),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Column(
                      children: List.generate(widget.products.length, (index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: const Color(0xFF673AB7).withOpacity(0.45),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: product?.image?.isNotEmpty == true
                                      ? product!.image!.first
                                      : 'https://firebasestorage.googleapis.com/v0/b/hairmainstreet.appspot.com/o/productImage%2FImage%20Not%20Available.jpg?alt=media&token=0104c2d8-35d3-4e4f-a1fc-d5244abfeb3f',
                                  errorWidget: ((context, url, error) =>
                                      const Text("Failed to Load Image")),
                                  placeholder: ((context, url) => const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                        ),
                                      )),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 140,
                                    width: 130,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${product!.name}',
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontFamily: 'Lato',
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Visibility(
                                      visible:
                                          widget.products[index].optionName !=
                                                  null &&
                                              widget.products[index].optionName!
                                                  .isNotEmpty,
                                      child: Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Text(
                                          '${widget.products[index].optionName}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Lato',
                                            color:
                                                Colors.black.withOpacity(0.65),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      'Qty:${widget.products[index].quantity}pcs',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Lato',
                                        color: Colors.black.withOpacity(0.65),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "NGN ${formatCurrency(widget.products[index].price.toString())}",
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Lato',
                                        color: Color(0xFF673AB7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Text(
                      "Delivery Address",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF673AB7).withOpacity(0.75),
                        fontFamily: 'Lato',
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => const AddDeliveryAddressPage());
                            // Get.dialog(
                            //   ChangeAddressWidget(
                            //     text: "Delivery Address",
                            //     onFilled: onFilled,
                            //   ),
                            // );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Color(0xFF673AB7).withOpacity(0.65),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 130,
                            width: 120,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 35,
                                  color: Color(0xFF673AB7),
                                ),
                                Text(
                                  "Add new\naddress",
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: userController.deliveryAddresses.isEmpty
                                  ? [
                                      Container(
                                        margin: const EdgeInsets.only(left: 4),
                                        color: Colors.white,
                                        padding: const EdgeInsets.all(8),
                                        height: 130,
                                        child: Center(
                                          child: Text(
                                            "You need to \nadd a \nDelivery Address",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Lato',
                                              color: Colors.red[300],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]
                                  : List.generate(
                                      userController.deliveryAddresses.length,
                                      (index) {
                                        return userController.isLoading.value ==
                                                true
                                            ? const LoadingWidget()
                                            : GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedAddress =
                                                        userController
                                                                .deliveryAddresses[
                                                            index];
                                                  });
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 4),
                                                  height: 130,
                                                  width: 250,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: selectedAddress ==
                                                            userController
                                                                    .deliveryAddresses[
                                                                index]!
                                                        ? Border.all(
                                                            color: const Color(
                                                                0xFF673AB7),
                                                            width: 2.5,
                                                          )
                                                        : Border.all(
                                                            color: Colors.black,
                                                            width: 0.5),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${userController.deliveryAddresses[index]!.landmark ?? ""},${userController.deliveryAddresses[index]!.streetAddress},${userController.deliveryAddresses[index]!.lGA},${userController.deliveryAddresses[index]!.state}.${userController.deliveryAddresses[index]!.zipCode ?? ""}",
                                                        style: const TextStyle(
                                                          fontFamily: 'Lato',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                          fontSize: 17,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Text(
                                                        "${userController.deliveryAddresses[index]!.contactName ?? ""},${userController.deliveryAddresses[index]!.contactPhoneNumber}",
                                                        style: const TextStyle(
                                                          fontFamily: 'Raleway',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                      },
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Text(
                      "Payment",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF673AB7).withOpacity(0.75),
                        fontFamily: 'Lato',
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      //margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Colors.grey[200],
                        // border: Border.all(
                        //     width: 0.5, color: Colors.black.withOpacity(0.1)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Amount:",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Lato',
                            ),
                          ),
                          Text(
                            formatCurrency(totalPrice.toString()),
                            style: const TextStyle(
                              color: Color(0xFF673AB7),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Lato',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              );
            }),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          elevation: 0,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: kToolbarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total: ${formatCurrency(totalPrice.toString())}",
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF673AB7),
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                  //maximumSize: Size(screenWidth * 0.70, screenHeight * 0.10),
                  shape: RoundedRectangleBorder(
                    // side: const BorderSide(
                    //   width: 1.2,
                    //   color: Colors.black,
                    // ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  if (selectedAddress == null) {
                    userController
                        .showMyToast("Please Enter Your Delivery Address");
                  } else {
                    //checkOutController.isLoading.value = true;
                    await initiatePayment(
                      orderQuantity: widget.products.first.quantity.toString(),
                      product: product,
                      vendorID: product!.vendorId,
                      paymentMethod: "once",
                      user: userController.userState.value,
                      paymentPrice: widget.products.first.price!.toInt(),
                      installmentNumber: 0,
                      email: userController.userState.value!.email!,
                    );
                  }
                },
                child: const Text(
                  "Pay Now",
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }
}
