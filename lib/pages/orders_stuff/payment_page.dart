import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paystack_payment/flutter_paystack_payment.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/models/orderModel.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:material_symbols_icons/symbols.dart';

class PaymentPage extends StatefulWidget {
  String? expectedTimeToPay;
  DatabaseOrderResponse? orderDetails;
  PaymentPage({this.expectedTimeToPay, this.orderDetails, super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  TextEditingController amountPaidController = TextEditingController();
  UserController userController = Get.find<UserController>();
  CheckOutController checkOutController = Get.find<CheckOutController>();
  num amountPaid = 0;
  GlobalKey<FormState> formKey = GlobalKey();
  String? publicKey = dotenv.env["PAYSTACK_PUBLIC_KEY"];
  final plugin = PaystackPayment();
  Orders orders = Orders();
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: publicKey!);
    getUserEmail();
  }

  getUserEmail() async {
    var user =
        await userController.getUserDetails(widget.orderDetails!.buyerId!);
    userEmail = user!.email!;
  }

  @override
  Widget build(BuildContext context) {
    num screenHeight = Get.height;
    num screenWidth = Get.width;
    String getReference() {
      String platform;
      if (Platform.isIOS) {
        platform = 'iOS';
      } else {
        platform = 'Android';
      }

      return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
    }

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
                  style: const TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.black,
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

    Future<void> initiatePayment({
      num? paymentPrice,
      String? orderID,
      String? email,
    }) async {
      debugPrint(paymentPrice.toString());
      Charge charge = Charge()
        ..amount = int.parse(paymentPrice!.toString()) * 100
        ..reference = getReference()
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
            orders.installmentPaid = widget.orderDetails!.installmentPaid! + 1;
            orders.transactionID = [
              ...widget.orderDetails!.transactionID!,
              ...[response.reference!]
            ];
            orders.paymentPrice =
                widget.orderDetails!.paymentPrice! + paymentPrice;
            orders.orderId = orderID;
            checkOutController.updateOrder(orders);
            Get.back();
          } catch (e) {
            print("error: $e");
          }
        } else {
          _showErrorDialog("An Error Occured in Payment");
        }
      } else {
        _showErrorDialog("You Cancelled Your Payment");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Complete Payment",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded,
              size: 24, color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1,
                    color: Colors.black,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurStyle: BlurStyle.normal,
                      offset: Offset.fromDirection(-4.0),
                      blurRadius: 0.5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "OrderID: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text("${widget.orderDetails!.orderId}")
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Total Product Price: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text("${widget.orderDetails!.totalPrice}")
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Amount Paid: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text("${widget.orderDetails!.paymentPrice}")
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Amount Remaining: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                            "₦${widget.orderDetails!.totalPrice! - widget.orderDetails!.paymentPrice!.toInt()}")
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Installment Remaining: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                            "₦${widget.orderDetails!.installmentNumber! - widget.orderDetails!.installmentPaid!}")
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Text(
                          "To be Paid Before: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Expanded(child: Text("${widget.expectedTimeToPay}"))
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextInputWidget(
                labelText: "Amount to Pay",
                hintText: "1000",
                textInputType: TextInputType.number,
                controller: amountPaidController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Please Enter an Amount";
                  }
                  return null;
                },
                onChanged: (val) {
                  val!.isEmpty ? "" : amountPaidController.text = val;
                  amountPaid = num.parse(amountPaidController.text);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.all(4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(
                  width: 1.5,
                  color: Colors.black,
                ),
              ),
            ),
            onPressed: () async {
              bool validated = formKey.currentState!.validate();
              if (validated) {
                try {
                  initiatePayment(
                    paymentPrice: amountPaid,
                    orderID: widget.orderDetails!.orderId!,
                    email: userEmail,
                  );
                } catch (e) {
                  print(e);
                }
              }
            },
            child: const Text(
              "Pay Now",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
