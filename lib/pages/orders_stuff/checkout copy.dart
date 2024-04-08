import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';
import 'package:hair_main_street/controllers/productController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/extras/colors.dart';
import 'package:hair_main_street/models/auxModels.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:recase/recase.dart';
import 'package:string_validator/string_validator.dart' as validator;

class CheckOutPage2 extends StatefulWidget {
  final String? method;
  final List<CheckOutTickBoxModel> products;
  const CheckOutPage2({this.method, required this.products, super.key});

  @override
  State<CheckOutPage2> createState() => _CheckOutPage2State();
}

class _CheckOutPage2State extends State<CheckOutPage2>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  String? publicKey = dotenv.env["PAYSTACK_PUBLIC_KEY"];
  final plugin = PaystackPlugin();
  //bool? isVisible = true;
  List<bool>? isSelected = [true, false];
  GlobalKey<FormState>? formKey = GlobalKey();
  GlobalKey<FormState>? formKey2 = GlobalKey();
  TextEditingController amountController = TextEditingController();
  TextEditingController installmentController = TextEditingController();
  CheckOutController checkOutController = Get.find<CheckOutController>();
  UserController userController = Get.find<UserController>();
  ProductController productController = Get.find<ProductController>();
  bool checkValue = true;
  List<Map<String, dynamic>> productStates = [];
  List<TextEditingController> installementControllers = [];
  String? dropdownValue;
  String? shippingAddress;

  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: publicKey!);
    tabController = TabController(length: 2, vsync: this);
    if (widget.method == null) {
      productStates = List.generate(
          widget.products.length,
          (index) => {
                'paymentMethod': 'once',
                'numberOfInstallments': 3,
                'installmentAmountPaid': 0,
              });
      for (var element in productStates) {
        installementControllers.add(TextEditingController());
      }
    } else {
      productStates = [];
    }
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    installementControllers.forEach((controller) => controller.dispose());
  }

  num totalPayableAmount = 0;
  @override
  Widget build(BuildContext context) {
    // var checkOutItem = checkOutController.checkOutItem.value;
    var product;
    num totalPrice = 0;
    for (var item in widget.products) {
      product = productController.getSingleProduct(item.productID!);
    }

    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    num bottomBarHeight = tabController.index != 0 && productStates.isNotEmpty
        ? screenHeight * 0.14
        : screenHeight * 0.08;

    //error dialog handler
    void _showErrorDialog(String message) {
      Get.dialog(
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            height: screenHeight * .16,
            width: screenWidth * .48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Color(0xFF392F5A),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
                TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red.shade300,
                  ),
                  child: Text(
                    'Close',
                    style: TextStyle(
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

    //initiate paystack payment and then create order
    Future<void> _initiatePayment(
        {int? paymentPrice,
        String? email,
        String? paymentMethod,
        String? orderQuantity,
        MyUser? user,
        String? vendorID,
        Product? product,
        int? installmentNumber}) async {
      debugPrint(paymentPrice.toString());
      debugPrint(paymentMethod);
      debugPrint(product!.productID);
      debugPrint(email);
      debugPrint(user!.fullname);
      debugPrint(installmentNumber.toString());
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
            var totalPrice = product.price!;
            var productPrice = (product.price!) / int.parse(orderQuantity!);
            checkOutController.createOrder(
                shippingAddress: shippingAddress ?? user.address,
                totalPrice: totalPrice,
                orderQuantity: orderQuantity,
                installmentPaid: installmentPaid,
                productID: product.productID,
                productPrice: productPrice.toString(),
                paymentMethod: paymentMethod,
                paymentPrice: paymentPrice,
                user: user,
                vendorID: vendorID,
                installmentNumber: installmentNumber);
            Get.close(2);
          } catch (e) {
            print("error: $e");
          }
        } else {
          _showErrorDialog("An Error Occured in Payment");
        }
      } else {
        _showErrorDialog("An Error Occured in Payment");
      }
    }

    //initiate paystack payment for a list of products
    Future<void> _initiatePaymentForProducts(
      List<Map<String, dynamic>> productStates,
      String email,
      MyUser user,
    ) async {
      Charge charge = Charge()
        ..amount = (totalPayableAmount as int) * 100
        ..reference = _getReference()
        ..email = email;

      CheckoutResponse response = await plugin.checkout(
        context,
        method: CheckoutMethod.card,
        charge: charge,
      );
      if (response.status) {
        bool verified = await checkOutController.verifyTransaction(
            reference: response.reference!);
        print(response);
        print(response.reference);
        print("verified:$verified");
        if (verified) {
          try {
            for (var states in productStates) {
              int installmentPaid;
              var totalPrice = states["productPrice"];
              var productPrice =
                  (states["productPrice"]) / states["orderQuantity"];
              if (states["paymentMethod"] == "installment") {
                installmentPaid = 1;
              } else {
                installmentPaid = 0;
              }
              checkOutController.createOrder(
                shippingAddress: shippingAddress ?? user.address,
                installmentPaid: installmentPaid,
                totalPrice: totalPrice,
                paymentMethod: states["paymentMethod"],
                paymentPrice: states["installmentAmountPaid"],
                productID: states["productID"],
                vendorID: states["vendorID"],
                installmentNumber: states["numberOfInstallments"],
                orderQuantity: states["orderQuantity"].toString(),
                productPrice: productPrice.toString(),
                user: user,
              );
            }
            ;
            Get.offNamedUntil("/orders", (route) => route.isFirst);
            checkOutController.checkoutList.clear();
          } catch (e) {
            print("error: $e");
          }
        } else {
          _showErrorDialog("An Error Occured in Payment");
        }
      } else {
        _showErrorDialog("An Error Occured in Payment");
      }
    }

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Symbols.arrow_back_ios_new_rounded,
                size: 24, color: Colors.black),
          ),
          title: const Text(
            'Check Out',
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
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, screenHeight * 0.06),
            child: AbsorbPointer(
              child: TabBar(
                controller: tabController,
                indicatorWeight: 8,
                //padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                // indicator: BoxDecoration(
                //   color: Colors.grey[100],
                //   // border: Border(
                //   //   bottom: BorderSide(
                //   //     color: Colors.black,
                //   //     width: 2,
                //   //   ),
                //   // ),
                //   borderRadius: BorderRadius.circular(10),
                // ),
                labelColor: Colors.black,

                labelStyle: const TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  //color: Colors.black,
                ),
                tabs: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      "Confirm Order",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 4),
                    child: Text(
                      "Payment",
                    ),
                  ),
                ],
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
              ),
            ),
          ),
          //backgroundColor: Colors.transparent,
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          height: screenHeight * 1,
          // decoration: BoxDecoration(
          //   gradient: myGradient,
          // ),
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: tabController,
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  const Text(
                    "Delivery Address",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.20,
                        child: IconButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(8),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                width: 1,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          onPressed: () {},
                          icon: const Center(
                            child: Icon(
                              Icons.add,
                              size: 30,
                              color: Colors.black,
                            ),
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
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      checkValue = !checkValue;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    height: screenHeight * 0.20,
                                    width: screenWidth * 0.72,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //SizedBox(height: 8),
                                            Text(
                                              userController
                                                  .userState.value!.address!,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            // Text('Sample Text 2'),
                                            // Text('Sample Text 3'),
                                            // Text('Sample Text 4'),
                                          ],
                                        ),
                                        if (checkValue)
                                          Positioned(
                                            bottom: 8,
                                            right: 8,
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    "Order Summary",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Form(
                    key: formKey2,
                    child: SingleChildScrollView(
                      child: Column(
                        children:
                            List.generate(widget.products.length, (index) {
                          var myControllers = installementControllers;
                          totalPrice += widget.products[index].price!;
                          var theProduct = productController.getSingleProduct(
                              widget.products[index].productID!);
                          if (productStates.isNotEmpty &&
                              productStates[index]["paymentMethod"] == "once") {
                            productStates[index]["installmentAmountPaid"] =
                                (widget.products[index].price! *
                                    widget.products[index].quantity!);
                          }
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: Offset(0,
                                      3), // changes the position of the shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1, color: Colors.black),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${theProduct!.name}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Price: N${widget.products[index].price}', // Replace with actual price
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      Text(
                                        'Quantity: ${widget.products[index].quantity}', // Replace with actual quantity
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Visibility(
                                    visible: widget.method == null,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Payment Method:',
                                          style: TextStyle(
                                            fontSize: 14,
                                            //fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: PopupMenuButton<String>(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: const BorderSide(
                                                color: Colors.black,
                                                width: 1,
                                              ),
                                            ),
                                            elevation: 10,
                                            itemBuilder:
                                                (BuildContext context) {
                                              return <PopupMenuEntry<String>>[
                                                const PopupMenuItem<String>(
                                                  value: 'once',
                                                  child:
                                                      Text('One Time Payment'),
                                                ),
                                                const PopupMenuItem<String>(
                                                  value: 'installment',
                                                  child: Text('installmently'),
                                                ),
                                              ];
                                            },
                                            onSelected: (String value) {
                                              setState(() {
                                                productStates[index]
                                                    ["paymentMethod"] = value;
                                              });
                                            },
                                            child: ListTile(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: const BorderSide(
                                                  color: Colors.black,
                                                  width: 1,
                                                ),
                                              ),
                                              title: productStates.isNotEmpty
                                                  ? Text(
                                                      productStates[index]
                                                              ["paymentMethod"]
                                                          .toString()
                                                          .titleCase,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    )
                                                  : const Text("hello"),
                                              trailing: const Icon(
                                                  Icons.arrow_drop_down),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Visibility(
                                    visible: productStates.isNotEmpty
                                        ? productStates[index]
                                                ["paymentMethod"] ==
                                            "installment"
                                        : false,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'No of Installments:',
                                          style: TextStyle(
                                            fontSize: 14,
                                            //fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: PopupMenuButton<String>(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: const BorderSide(
                                                color: Colors.black,
                                                width: 1,
                                              ),
                                            ),
                                            elevation: 10,
                                            itemBuilder:
                                                (BuildContext context) {
                                              return <PopupMenuEntry<String>>[
                                                const PopupMenuItem<String>(
                                                  value: "2",
                                                  child: Text('2'),
                                                ),
                                                const PopupMenuItem<String>(
                                                  value: '3',
                                                  child: Text('3'),
                                                ),
                                              ];
                                            },
                                            onSelected: (String value) {
                                              setState(() {
                                                productStates[index][
                                                        "numberOfInstallments"] =
                                                    int.parse(value);
                                              });
                                            },
                                            child: ListTile(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: const BorderSide(
                                                  color: Colors.black,
                                                  width: 1,
                                                ),
                                              ),
                                              title: productStates.isNotEmpty
                                                  ? Text(
                                                      productStates[index][
                                                              "numberOfInstallments"]
                                                          .toString()
                                                          .titleCase,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    )
                                                  : const Text("hello"),
                                              trailing: const Icon(
                                                  Icons.arrow_drop_down),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Visibility(
                                    visible: productStates.isNotEmpty
                                        ? productStates[index]
                                                ["paymentMethod"] ==
                                            "installment"
                                        : false,
                                    child: TextFormField(
                                      controller: myControllers.isNotEmpty
                                          ? myControllers[index]
                                          : null,
                                      decoration: const InputDecoration(
                                        labelText: 'Initial Payment Amount',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "You must specify an initial Amount";
                                        } else if (!validator
                                            .isNumeric(value)) {
                                          return "Must be a Number";
                                        } else if (num.parse(value) >
                                            widget.products[index].price!) {
                                          return "Amount cannot be more than Price";
                                        } else {
                                          return null;
                                        }
                                      },
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                        } else {
                                          myControllers[index].text = value;
                                          productStates[index]
                                                  ["installmentAmountPaid"] =
                                              num.parse(value);
                                        }
                                        print(productStates[index]
                                            ["installmentAmountPaid"]);
                                        // Handle initial payment amount input
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  // Container(
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey[200],
                  //     borderRadius: BorderRadius.circular(12),
                  //     border: Border.all(
                  //       width: 2,
                  //       color: const Color(0xFF392F5A),
                  //     ),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: const Color(0xFF000000),
                  //         blurStyle: BlurStyle.normal,
                  //         offset: Offset.fromDirection(-4.0),
                  //         blurRadius: 2,
                  //       ),
                  //     ],
                  //   ),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Row(
                  //         children: [
                  //           const Expanded(
                  //             child: Text(
                  //               "Shipping To:",
                  //               style: TextStyle(
                  //                 fontSize: 20,
                  //               ),
                  //             ),
                  //           ),
                  //           Expanded(
                  //             child: Text(
                  //               "${checkOutItem.address}",
                  //               style: const TextStyle(
                  //                 fontSize: 16,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       Row(
                  //         children: [
                  //           const Expanded(
                  //             child: Text(
                  //               "Full name: ",
                  //               style: TextStyle(
                  //                 fontSize: 20,
                  //               ),
                  //             ),
                  //           ),
                  //           Expanded(
                  //             child: Text(
                  //               "${checkOutItem.fullName}",
                  //               style: const TextStyle(
                  //                 fontSize: 16,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       Row(
                  //         //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           const Expanded(
                  //             child: Text(
                  //               "Phone Number:",
                  //               style: TextStyle(
                  //                 fontSize: 20,
                  //               ),
                  //             ),
                  //           ),
                  //           Expanded(
                  //             child: Text(
                  //               "${checkOutItem.phoneNumber}",
                  //               style: const TextStyle(
                  //                 fontSize: 16,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       const Row(
                  //         //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Expanded(
                  //             child: Text(
                  //               "Delivery Date:",
                  //               style: TextStyle(
                  //                 fontSize: 20,
                  //               ),
                  //             ),
                  //           ),
                  //           Expanded(
                  //             child: Text(
                  //               "30/09/2023",
                  //               style: TextStyle(
                  //                 fontSize: 16,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       const Divider(
                  //         height: 8,
                  //         color: Colors.black,
                  //         thickness: 2,
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           const Expanded(
                  //               child: Text(
                  //             "Product Name:",
                  //             style: TextStyle(
                  //               fontSize: 20,
                  //             ),
                  //           )),
                  //           Expanded(
                  //               child: Text(
                  //             "${product!.name}",
                  //             style: const TextStyle(
                  //               fontSize: 16,
                  //             ),
                  //           )),
                  //         ],
                  //       ),
                  //       // Row(
                  //       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       //   children: [
                  //       //     Expanded(
                  //       //         child: Text(
                  //       //       "Delivery Fee:",
                  //       //       style: TextStyle(
                  //       //         fontSize: 20,
                  //       //       ),
                  //       //     )),
                  //       //     Expanded(
                  //       //         child: Text(
                  //       //       "Price",
                  //       //       style: TextStyle(
                  //       //         fontSize: 16,
                  //       //       ),
                  //       //     )),
                  //       //   ],
                  //       // ),
                  //       // Row(
                  //       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       //   children: [
                  //       //     Expanded(
                  //       //       child: Text(
                  //       //         "Tax:",
                  //       //         style: TextStyle(
                  //       //           fontSize: 20,
                  //       //         ),
                  //       //       ),
                  //       //     ),
                  //       //     Expanded(
                  //       //       child: Text(
                  //       //         "Price",
                  //       //         style: TextStyle(
                  //       //           fontSize: 16,
                  //       //         ),
                  //       //       ),
                  //       //     ),
                  //       //   ],
                  //       // ),
                  //       const SizedBox(
                  //         height: 12,
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           const Expanded(
                  //               child: Text(
                  //             "Order Total:",
                  //             style: TextStyle(
                  //               fontSize: 20,
                  //             ),
                  //           )),
                  //           Expanded(
                  //               child: Text(
                  //             "₦${checkOutItem.price}.00",
                  //             style: const TextStyle(
                  //               fontSize: 20,
                  //             ),
                  //           )),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(
                    height: 8,
                  ),
                  // Wrap(
                  //   crossAxisAlignment: WrapCrossAlignment.center,
                  //   //mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Checkbox(
                  //       value: checkValue,
                  //       onChanged: (newV) {
                  //         setState(() {
                  //           checkValue = newV!;
                  //           // debugPrint("$checkValue");
                  //           // debugPrint("$newV");
                  //         });
                  //       },
                  //     ),
                  //     const Text(
                  //       "I agree with the",
                  //       style: TextStyle(
                  //         fontSize: 20,
                  //       ),
                  //     ),
                  //     TextButton(
                  //       onPressed: () {},
                  //       child: const Text(
                  //         "terms",
                  //         style: TextStyle(color: Colors.blue, fontSize: 20),
                  //       ),
                  //     ),
                  //     const Text(
                  //       "and",
                  //       style: TextStyle(
                  //         fontSize: 20,
                  //       ),
                  //     ),
                  //     TextButton(
                  //       onPressed: () {},
                  //       child: const Text(
                  //         "conditions",
                  //         style: TextStyle(
                  //           color: Colors.blue,
                  //           fontSize: 20,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  // TextButton(
                  //   style: TextButton.styleFrom(
                  //     //alignment: Alignment.centerLeft,
                  //     backgroundColor: const Color(0xFF392F5A),
                  //     shape: const RoundedRectangleBorder(
                  //       side: BorderSide(color: Colors.white, width: 2),
                  //       borderRadius: BorderRadius.all(
                  //         Radius.circular(12),
                  //       ),
                  //     ),
                  //   ),
                  //   onPressed: () {

                  //   },
                  //   child: const Text(
                  //     "Proceed",
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.w400,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              Builder(builder: (context) {
                if (widget.method == "installment") {
                  return Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[200],
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              child: Text(
                                "Pay \ninstallmentally",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Order Total Amount:",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                "₦${widget.products.first.price}.00",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Number of Installments:",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Container(
                                        width: double
                                            .infinity, // Takes the available width
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: DropdownButtonFormField<String>(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          isExpanded: true,
                                          value: dropdownValue,
                                          hint: const Text("Select"),
                                          // underline:
                                          //     Container(), // Remove the default underline
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select an option';
                                            }
                                            return null;
                                          },
                                          items: List.generate(2, (index) {
                                            int newIndex = index + 2;
                                            return DropdownMenuItem(
                                              value: newIndex.toString(),
                                              child: Text("$newIndex"),
                                            );
                                          }),
                                          onChanged: (String? value) {
                                            // Handle dropdown value change
                                            setState(() {
                                              dropdownValue = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextInputWidget(
                                labelText: "Initial Installment Amount(NGN)",
                                hintText: "1000",
                                textInputType: TextInputType.number,
                                controller: amountController,
                                onChanged: (val) {
                                  setState(() {
                                    amountController.text = val!;
                                  });
                                  return null;
                                },
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Enter an Amount";
                                  } else if (!validator.isNumeric(val)) {
                                    return "Must be a number";
                                  }
                                  return null;
                                },
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Expanded(
                          //       child: TextButton(
                          //         onPressed: () {
                          //           tabController.animateTo(0);
                          //         },
                          //         style: TextButton.styleFrom(
                          //           // padding: EdgeInsets.symmetric(
                          //           //     horizontal: screenWidth * 0.24),
                          //           backgroundColor: Colors.white,
                          //           side: const BorderSide(
                          //               color: Color(0xFF392F5A), width: 2),
                          //           shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(12),
                          //           ),
                          //         ),
                          //         child: const Text(
                          //           "Back",
                          //           textAlign: TextAlign.center,
                          //           style: TextStyle(
                          //               color: Colors.black, fontSize: 20),
                          //         ),
                          //       ),
                          //     ),
                          //     Expanded(
                          //         flex: 3,
                          //         child: TextButton(
                          //           onPressed: () async {
                          //             bool? validate =
                          //                 formKey?.currentState!.validate();
                          //             if (validate!) {
                          //               formKey?.currentState!.save();
                          //               debugPrint("isVisible true");
                          //             }

                          //             try {
                          //               // Check for empty input
                          //               if (amountController.text.isEmpty) {
                          //                 throw Exception(
                          //                     'Please enter a valid amount.');
                          //               }

                          //               // Validate numeric format for amount
                          //               if (!RegExp(r'^[0-9]+$')
                          //                   .hasMatch(amountController.text)) {
                          //                 throw Exception(
                          //                     'Amount should be a number.');
                          //               }

                          //               // Check for null dropdown value
                          //               if (dropdownValue == null) {
                          //                 throw Exception(
                          //                     'Please select a valid installment number.');
                          //               }

                          //               // Parse amount and installment number
                          //               int amount =
                          //                   int.parse(amountController.text);
                          //               int installmentNumber =
                          //                   int.parse(dropdownValue!);

                          //               // Perform payment initiation
                          //               await _initiatePayment(
                          //                 orderQuantity: widget
                          //                     .products.first.quantity
                          //                     .toString(),
                          //                 product: product,
                          //                 vendorID: product.vendorId,
                          //                 paymentMethod: widget.method,
                          //                 user: userController.userState.value,
                          //                 paymentPrice: amount,
                          //                 installmentNumber: installmentNumber,
                          //                 email: userController
                          //                     .userState.value!.email!,
                          //               );

                          //               // Show loading indicator
                          //               if (checkOutController
                          //                   .isLoading.value) {
                          //                 Get.dialog(
                          //                   const Center(
                          //                     child: CircularProgressIndicator(
                          //                       backgroundColor:
                          //                           Color(0xFF392F5A),
                          //                       strokeWidth: 4,
                          //                     ),
                          //                   ),
                          //                 );
                          //               }
                          //             } catch (e) {
                          //               // Handle and display error message
                          //               Get.snackbar(
                          //                 'Error!',
                          //                 e.toString(),
                          //                 snackPosition: SnackPosition.BOTTOM,
                          //               );
                          //             }
                          //           },
                          //           style: TextButton.styleFrom(
                          //             // padding: EdgeInsets.symmetric(
                          //             //     horizontal: screenWidth * 0.24),
                          //             backgroundColor: const Color(0xFF392F5A),
                          //             side: const BorderSide(
                          //                 color: Colors.white, width: 2),
                          //             shape: RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.circular(12),
                          //             ),
                          //           ),
                          //           child: const Text(
                          //             "Proceed to Pay",
                          //             textAlign: TextAlign.center,
                          //             style: TextStyle(
                          //                 color: Colors.white, fontSize: 20),
                          //           ),
                          //         )),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  );
                } else if (widget.method == "once") {
                  return Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: screenHeight * 0.20,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[200],
                        ),
                        // padding: EdgeInsets.symmetric(
                        //   horizontal: 100,
                        // ),
                        child: const Text(
                          "Pay Once",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Order Total Amount:",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "₦${widget.products.first.price!}.00",
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  );
                } else if (productStates.isNotEmpty) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Order Finalization",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w800),
                        ),
                        ...List.generate(widget.products.length, (index) {
                          var theProduct = productController.getSingleProduct(
                              widget.products[index].productID!);
                          productStates[index]["vendorID"] =
                              theProduct!.vendorId;
                          productStates[index]["productID"] =
                              theProduct.productID;
                          productStates[index]["orderQuantity"] =
                              widget.products[index].quantity!;
                          productStates[index]["productPrice"] =
                              widget.products[index].price!;
                          if (productStates[index]["paymentMethod"] == "once") {
                            productStates[index]["numberOfInstallments"] = 0;
                          }
                          // totalPayableAmount +=
                          //     productStates[index]["installmentAmountPaid"];
                          // print(totalPayableAmount);
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: Offset(0,
                                      3), // changes the position of the shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1, color: Colors.black),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${theProduct!.name}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Price: N${widget.products[index].price}', // Replace with actual price
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      Text(
                                        'Quantity: ${widget.products[index].quantity}', // Replace with actual quantity
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Payment Method:',
                                        style: TextStyle(
                                          fontSize: 14,
                                          //fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        productStates[index]["paymentMethod"]
                                            .toString()
                                            .titleCase,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Visibility(
                                    visible: productStates[index]
                                            ["paymentMethod"] ==
                                        "installment",
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'No of Installments:',
                                          style: TextStyle(
                                            fontSize: 14,
                                            //fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          productStates[index]
                                                  ["numberOfInstallments"]
                                              .toString()
                                              .titleCase,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Visibility(
                                    visible: productStates[index]
                                            ["paymentMethod"] ==
                                        "installment",
                                    child: Text(
                                      'Installment Amount: \$${productStates[index]["installmentAmountPaid"]}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }
                return const Text("hello");
              }),
            ],
          ),
        ),
        floatingActionButton: Visibility(
          visible: tabController.index != 0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: EdgeInsets.symmetric(
                  vertical: 2, horizontal: screenWidth * 0.04),
              //maximumSize: Size(screenWidth * 0.70, screenHeight * 0.10),
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1.2,
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              setState(() {
                tabController.animateTo(0);
                totalPayableAmount = 0;
              });
            },
            child: const Text(
              "Back",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0xFF000000),
                blurStyle: BlurStyle.normal,
                offset: Offset.fromDirection(-4.0),
                blurRadius: 4,
              ),
            ],
            color: Colors.white,
          ),
          height: bottomBarHeight as double,

          padding: const EdgeInsets.symmetric(horizontal: 12),
          //height: screenHeight * .05,
          //padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: tabController.index != 0 && productStates.isNotEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Text(
                        "Total Payment Amount:",
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "N$totalPayableAmount",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Total: N$totalPrice",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Text(
                  //     "N$totalPrice",
                  //     style: const TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.w800,
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                            vertical: 2, horizontal: screenWidth * 0.04),
                        //maximumSize: Size(screenWidth * 0.70, screenHeight * 0.10),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1.2,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (tabController.index == 0) {
                          var validated = formKey2!.currentState!.validate();
                          if (validated) {
                            setState(() {
                              tabController.animateTo(1);
                            });
                            for (var element in productStates) {
                              totalPayableAmount +=
                                  element["installmentAmountPaid"];
                            }
                            // print(totalPayableAmount);
                          }
                        } else {
                          if (widget.method == "once") {
                            await _initiatePayment(
                              orderQuantity:
                                  widget.products.first.quantity.toString(),
                              product: product,
                              vendorID: product.vendorId,
                              paymentMethod: widget.method,
                              user: userController.userState.value,
                              paymentPrice: int.parse(product.price!),
                              installmentNumber: 0,
                              email: userController.userState.value!.email!,
                            );

                            if (checkOutController.isLoading.value) {
                              Get.dialog(
                                const Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Color(0xFF392F5A),
                                    strokeWidth: 4,
                                  ),
                                ),
                              );
                            }
                          } else if (widget.method == "installment") {
                            bool? validate = formKey?.currentState!.validate();
                            if (validate!) {
                              formKey?.currentState!.save();
                              debugPrint("isVisible true");
                            }

                            try {
                              // Check for empty input
                              if (amountController.text.isEmpty) {
                                throw Exception('Please enter a valid amount.');
                              }

                              // Validate numeric format for amount
                              if (!RegExp(r'^[0-9]+$')
                                  .hasMatch(amountController.text)) {
                                throw Exception('Amount should be a number.');
                              }

                              // Check for null dropdown value
                              if (dropdownValue == null) {
                                throw Exception(
                                    'Please select a valid installment number.');
                              }

                              // Parse amount and installment number
                              int amount = int.parse(amountController.text);
                              int installmentNumber = int.parse(dropdownValue!);

                              // Perform payment initiation
                              await _initiatePayment(
                                orderQuantity:
                                    widget.products.first.quantity.toString(),
                                product: product,
                                vendorID: product.vendorId,
                                paymentMethod: widget.method,
                                user: userController.userState.value,
                                paymentPrice: amount,
                                installmentNumber: installmentNumber,
                                email: userController.userState.value!.email!,
                              );

                              // Show loading indicator
                              if (checkOutController.isLoading.value) {
                                Get.dialog(
                                  const Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Color(0xFF392F5A),
                                      strokeWidth: 4,
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              // Handle and display error message
                              Get.snackbar(
                                'Error!',
                                e.toString(),
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          } else if (widget.method == null) {
                            //print("i am here");
                            _initiatePaymentForProducts(
                                productStates,
                                userController.userState.value!.email!,
                                userController.userState.value!);
                            if (checkOutController.isLoading.value) {
                              Get.dialog(
                                const Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Color(0xFF392F5A),
                                    strokeWidth: 4,
                                  ),
                                ),
                              );
                            }
                          }
                          //print(totalPayableAmount);
                        }
                      },
                      child: tabController.index == 0
                          ? const Text(
                              "Confirm",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Pay Now",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
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
