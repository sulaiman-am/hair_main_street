// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/pages/messages.dart';
import 'package:hair_main_street/pages/product_page.dart';
import 'package:hair_main_street/pages/refund.dart';
import 'package:material_symbols_icons/symbols.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              size: 24, color: Colors.white),
        ),
        title: const Text(
          'Order Details',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Color(
              0xFFFF8811,
            ),
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
          padding: const EdgeInsets.only(top: 12),
          children: [
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
                    offset: Offset.zero,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      HeaderText(
                        text: "Delivery Status: ",
                      ),
                      Expanded(
                        child: Text(
                          "Awaiting Confirmation",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w600),
                          //overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "Complying with company policy, all deliveries are automatically confirmed 72hrs after order placement",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
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
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Product Name",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text("Product Price"),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Quantity"),
                                SizedBox(
                                  width: 30,
                                ),
                                Text("x 1")
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
                        Text("12/08/2023"),
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
                    children: [Text("Order ID: "), Text("287637287673")],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [Text("Placed at: "), Text("09/08/2023")],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [Text("Payment Status: "), Text("Paid")],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text("Delivery Address: "),
                      Expanded(
                        child: Text(
                          "No 224 Darmanawa Gabas Kano, Kano State, Nigeria",
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
