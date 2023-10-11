import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/models/review.dart';
import 'package:hair_main_street/pages/cart.dart';
import 'package:hair_main_street/pages/orders_stuff/checkout%20copy.dart';
import 'package:hair_main_street/pages/orders_stuff/checkout.dart';
import 'package:hair_main_street/pages/orders_stuff/confirm_order.dart';
import 'package:hair_main_street/pages/review_page.dart';
import 'package:hair_main_street/widgets/cards.dart';
import 'package:material_symbols_icons/symbols.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<bool> toggleSelection = [true, false, false];
  bool? isVisible = false;
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
              size: 24, color: Colors.black),
        ),
        title: const Text(
          'Details',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Color(
              0xFFFF8811,
            ),
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: appBarGradient),
        ),
        actions: [
          IconButton(
            tooltip: "Cart",
            onPressed: () =>
                Get.to(() => CartPage(), transition: Transition.fade),
            icon: const Icon(Symbols.shopping_cart_rounded,
                size: 28, color: Colors.black),
          ),
          IconButton(
            tooltip: "Chat with Vendor",
            onPressed: () {},
            icon: const Icon(Symbols.message_rounded,
                size: 28, color: Colors.black),
          ),
        ],
        //backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: myGradient,
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: ListView(
          children: [
            Container(
              width: screenWidth * 0.95,
              height: screenHeight * 0.30,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Product Name",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Product Description JHgshgdg jksiuudh jkshdhsuio rekgjoieij akhsckakah akfhwyfnjkwj",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Options",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ToggleButtons(
                    selectedBorderColor: Colors.black,
                    borderWidth: 2.4,
                    //selectedColor: Colors.red[50],
                    fillColor: Colors.grey[200],
                    isSelected: toggleSelection,
                    children: [Toggles(), Toggles(), Toggles()],
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < toggleSelection.length; i++) {
                          toggleSelection[i] = i == index;
                        }
                      });
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Quantity",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
                Divider(
                  thickness: 1.5,
                  color: Colors.transparent,
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Symbols.remove,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      width: 28,
                      height: 28,
                      color: const Color.fromARGB(255, 200, 242, 237),
                      child: Center(
                        child: Text(
                          "1",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            //backgroundColor: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Symbols.add,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Reviews(12)",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
                // SizedBox(
                //   width: screenWidth * 0.32,
                // ),
                // SizedBox(
                //   width: 4,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.star_half_outlined,
                      size: 36,
                      color: Colors.amber[600],
                    ),
                    const Text(
                      "4.6",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                    // SizedBox(
                    //   width: 8,
                    // ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReviewPage(reviews)),
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            ReviewCard(),
            const SizedBox(
              height: 2,
            ),
            ReviewCard(),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Vendor",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 8,
            ),
            TextButton(
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                //elevation: 4,
                backgroundColor: Colors.white60,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {},
              child: const Text(
                "Vendor name",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Wrap(children: [
          Container(
            alignment: Alignment.topCenter,
            // height:
            //     isVisible == true ? screenHeight * 0.136 : screenHeight * 0.08,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: myGradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Visibility(
                  visible: isVisible!,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isVisible = false;
                          });
                        },
                        icon: Icon(
                          Icons.cancel_outlined,
                          color: Colors.red[400],
                          size: 32,
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 127, 116, 166),
                              // padding: EdgeInsets.symmetric(
                              //     vertical: 8, horizontal: screenWidth * 0.26),
                              //maximumSize: Size(screenWidth * 0.70, screenHeight * 0.10),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.only(
                                  // topRight: Radius.circular(16),
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Get.to(
                                () => const CheckOutPage2(
                                  method: "installment",
                                ),
                              );
                            },
                            child: const Text(
                              "Pay Installmentally",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 127, 116, 166),
                              // padding: EdgeInsets.symmetric(
                              //     vertical: 8, horizontal: screenWidth * 0.26),
                              //maximumSize: Size(screenWidth * 0.70, screenHeight * 0.10),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.only(
                                    //topLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                    topRight: Radius.circular(16)),
                              ),
                            ),
                            onPressed: () {
                              Get.to(() => const CheckOutPage2(
                                    method: "once",
                                  ));
                            },
                            child: const Text(
                              "Pay Once",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Price",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                    // SizedBox(
                    //   width: screenWidth * .12,
                    // ),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF392F5A),
                            // padding: EdgeInsets.symmetric(
                            //     vertical: 8, horizontal: screenWidth * 0.26),
                            //maximumSize: Size(screenWidth * 0.70, screenHeight * 0.10),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 1,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Add to Cart",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 127, 116, 166),
                            // padding: EdgeInsets.symmetric(
                            //   vertical: 8,
                            //   horizontal: screenWidth * 0.26,
                            // ),
                            //maximumSize: Size(screenWidth * 0.70, screenHeight * 0.10),
                            shape: const RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 1,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isVisible = true;
                            });
                            // Get.to(() => CheckOutPage());
                          },
                          child: const Text(
                            "Buy",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
      extendBody: true,
    );
  }
}

class Toggles extends StatelessWidget {
  const Toggles({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Option Name",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
          const Divider(
            thickness: 2,
            color: Colors.green,
            height: 4,
          ),
          Text(
            "Price",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
          Divider(
            thickness: 1.5,
            color: Colors.transparent,
            height: 4,
          ),
          Text(
            "In Stock",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.green[200],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
