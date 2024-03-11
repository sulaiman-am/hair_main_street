import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';
import 'package:hair_main_street/controllers/productController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/extras/colors.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:string_validator/string_validator.dart' as validator;

class CheckOutPage2 extends StatefulWidget {
  final String? method;
  const CheckOutPage2({this.method, super.key});

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
  TextEditingController amountController = TextEditingController();
  TextEditingController installmentController = TextEditingController();
  CheckOutController checkOutController = Get.find<CheckOutController>();
  UserController userController = Get.find<UserController>();
  ProductController productController = Get.find<ProductController>();
  bool checkValue = true;
  String? dropdownValue;
  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: publicKey!);
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var checkOutItem = checkOutController.checkOutItem.value;
    Product? product =
        productController.getSingleProduct(checkOutItem.productId!);
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    //initiate paystack payment and then create order
    Future<void> _initiatePayment(
        {int? paymentPrice,
        String? email,
        String? paymentMethod,
        MyUser? user,
        String? vendorID,
        int? installmentNumber}) async {
      debugPrint(paymentPrice.toString());
      debugPrint(paymentMethod);
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
            checkOutController.createOrder(
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
          Get.dialog(
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16)),
                height: screenHeight * .16,
                width: screenWidth * .48,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "An Error Occured in Payment",
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
                      child: const Text(
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
      } else {
        Get.dialog(
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16)),
              height: screenHeight * .16,
              width: screenWidth * .48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "An Error Occured in Payment",
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
                    child: const Text(
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
    }

    return Scaffold(
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
            color: Color(0xFF0E4D92),
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
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Shipping To:",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${checkOutItem.address}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Full name: ",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${checkOutItem.fullName}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              "Phone Number:",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${checkOutItem.phoneNumber}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Delivery Date:",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "30/09/2023",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 8,
                        color: Colors.black,
                        thickness: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                              child: Text(
                            "Product Name:",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )),
                          Expanded(
                              child: Text(
                            "${product!.name}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          )),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Expanded(
                      //         child: Text(
                      //       "Delivery Fee:",
                      //       style: TextStyle(
                      //         fontSize: 20,
                      //       ),
                      //     )),
                      //     Expanded(
                      //         child: Text(
                      //       "Price",
                      //       style: TextStyle(
                      //         fontSize: 16,
                      //       ),
                      //     )),
                      //   ],
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Expanded(
                      //       child: Text(
                      //         "Tax:",
                      //         style: TextStyle(
                      //           fontSize: 20,
                      //         ),
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: Text(
                      //         "Price",
                      //         style: TextStyle(
                      //           fontSize: 16,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                              child: Text(
                            "Order Total:",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )),
                          Expanded(
                              child: Text(
                            "₦${checkOutItem.price}.00",
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: checkValue,
                      onChanged: (newV) {
                        setState(() {
                          checkValue = newV!;
                          // debugPrint("$checkValue");
                          // debugPrint("$newV");
                        });
                      },
                    ),
                    const Text(
                      "I agree with the",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "terms",
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                    ),
                    const Text(
                      "and",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "conditions",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    //alignment: Alignment.centerLeft,
                    backgroundColor: const Color(0xFF392F5A),
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                  ),
                  onPressed: () {
                    tabController.animateTo(1);
                  },
                  child: const Text(
                    "Proceed",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
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
                              "Pay \nInstallmentally",
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
                              "₦${checkOutItem.price}.00",
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
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: DropdownButtonFormField<String>(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        isExpanded: true,
                                        value: dropdownValue,
                                        hint: const Text("Select"),
                                        // underline:
                                        //     Container(), // Remove the default underline
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  tabController.animateTo(0);
                                },
                                style: TextButton.styleFrom(
                                  // padding: EdgeInsets.symmetric(
                                  //     horizontal: screenWidth * 0.24),
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                      color: Color(0xFF392F5A), width: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "Back",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 3,
                                child: TextButton(
                                  onPressed: () async {
                                    bool? validate =
                                        formKey?.currentState!.validate();
                                    if (validate!) {
                                      formKey?.currentState!.save();
                                      debugPrint("isVisible true");
                                    }

                                    try {
                                      // Check for empty input
                                      if (amountController.text.isEmpty) {
                                        throw Exception(
                                            'Please enter a valid amount.');
                                      }

                                      // Validate numeric format for amount
                                      if (!RegExp(r'^[0-9]+$')
                                          .hasMatch(amountController.text)) {
                                        throw Exception(
                                            'Amount should be a number.');
                                      }

                                      // Check for null dropdown value
                                      if (dropdownValue == null) {
                                        throw Exception(
                                            'Please select a valid installment number.');
                                      }

                                      // Parse amount and installment number
                                      int amount =
                                          int.parse(amountController.text);
                                      int installmentNumber =
                                          int.parse(dropdownValue!);

                                      // Perform payment initiation
                                      await _initiatePayment(
                                        vendorID: product.vendorId,
                                        paymentMethod: widget.method,
                                        user: userController.userState.value,
                                        paymentPrice: amount,
                                        installmentNumber: installmentNumber,
                                        email: userController
                                            .userState.value!.email!,
                                      );

                                      // Show loading indicator
                                      if (checkOutController.isLoading.value) {
                                        Get.dialog(
                                          const Center(
                                            child: CircularProgressIndicator(
                                              backgroundColor:
                                                  Color(0xFF392F5A),
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
                                  },
                                  style: TextButton.styleFrom(
                                    // padding: EdgeInsets.symmetric(
                                    //     horizontal: screenWidth * 0.24),
                                    backgroundColor: const Color(0xFF392F5A),
                                    side: const BorderSide(
                                        color: Colors.white, width: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "Proceed to Pay",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                )),
                          ],
                        ),
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
                          "₦${checkOutItem.price}.00",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              tabController.animateTo(0);
                            },
                            style: TextButton.styleFrom(
                              // padding: EdgeInsets.symmetric(
                              //     horizontal: screenWidth * 0.24),
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                  color: Color(0xFF392F5A), width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Back",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextButton(
                            onPressed: () async {
                              // debugPrint(product.vendorId);
                              // debugPrint(widget.method);
                              // debugPrint("${int.parse(checkOutItem.price!)}");

                              await _initiatePayment(
                                vendorID: product.vendorId,
                                paymentMethod: widget.method,
                                user: userController.userState.value,
                                paymentPrice: int.parse(checkOutItem.price!),
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
                            },
                            style: TextButton.styleFrom(
                              // padding: EdgeInsets.symmetric(
                              //     horizontal: screenWidth * 0.24),
                              backgroundColor: const Color(0xFF392F5A),
                              side: const BorderSide(
                                  color: Colors.white, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Proceed to Pay",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return const Text("hello");
            }),
          ],
        ),
      ),
    );
  }

  String _getReference() {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#%^&*()-_=+[]{}|;:,.<>?/';
    final random = Random();
    final length = random.nextInt(6) + 25; // Random length between 25 and 30
    return Iterable.generate(
        length, (_) => characters[random.nextInt(characters.length)]).join();
  }
}
