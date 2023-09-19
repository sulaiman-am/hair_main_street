import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/pages/product_page.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../pages/order_detail.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Get.to(() => ProductPage(), transition: Transition.fadeIn);
      },
      splashColor: Theme.of(context).primaryColorDark,
      child: Container(
        padding: EdgeInsets.fromLTRB(4, 12, 4, 4),
        height: screenHeight * 0.50,
        width: screenWidth * 0.15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
          color: Color(0xFFF4D06F),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF000000),
              blurStyle: BlurStyle.normal,
              offset: Offset.fromDirection(-4.0),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(16),
                ),
                width: 120,
                height: 106,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                "Product Name",
                style: TextStyle(
                  fontSize: 20,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text("Product Price"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Symbols.share_rounded,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Symbols.favorite_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CarouselCard extends StatelessWidget {
  const CarouselCard({super.key});

  @override
  Widget build(BuildContext context) {
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.24,
      width: screenWidth * 0.70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
        color: Color(0xFFF4D06F),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000),
            blurStyle: BlurStyle.outer,
            blurRadius: 0.4,
          ),
        ],
      ),
      child: Text("Hello"),
    );
  }
}

class CartCard extends StatelessWidget {
  const CartCard({super.key});

  @override
  Widget build(BuildContext context) {
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.20,
      width: screenWidth * 0.88,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        color: Color(0xFFFCF8F2),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000),
            blurStyle: BlurStyle.normal,
            offset: Offset.fromDirection(-4.0),
            blurRadius: 4,
          ),
        ],
      ),
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
                    color: const Color(0xFF392F5A),
                    child: Center(
                      child: Text(
                        "1",
                        style: TextStyle(
                          color: Colors.white,
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
        ],
      ),
    );
  }
}

class WishListCard extends StatelessWidget {
  const WishListCard({super.key});

  @override
  Widget build(BuildContext context) {
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    return Container(
      //height: screenHeight * 0.20,
      width: screenWidth * 0.88,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        color: Color(0xFFFCF8F2),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000),
            blurStyle: BlurStyle.normal,
            offset: Offset.fromDirection(-4.0),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(16),
            ),
            width: screenWidth * 0.36,
            height: screenHeight * 0.20,
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
                    color: const Color(0xFF392F5A),
                    child: Center(
                      child: Text(
                        "1",
                        style: TextStyle(
                          color: Colors.white,
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
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF392F5A),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      width: 1.5,
                      color: Colors.black,
                    ),
                  ),
                ),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Function? onTap;
  const OrderCard({this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => Get.to(
        () => OrderDetailsPage(),
        transition: Transition.fadeIn,
      ),
      child: Container(
        height: screenHeight * 0.20,
        width: screenWidth * 0.88,
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
          color: Color(0xFFFCF8F2),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF000000),
              blurStyle: BlurStyle.normal,
              offset: Offset.fromDirection(-4.0),
              blurRadius: 4,
            ),
          ],
        ),
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
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                    color: Color.fromARGB(255, 200, 242, 237),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF000000),
                        blurStyle: BlurStyle.normal,
                        offset: Offset.fromDirection(-4.0),
                        blurRadius: 1.2,
                      ),
                    ],
                  ),
                  child: Text("Payment Status"),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                    color: Color.fromARGB(255, 200, 242, 237),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF000000),
                        blurStyle: BlurStyle.normal,
                        offset: Offset.fromDirection(-4.0),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text("Delivery Status"),
                )
              ],
            ),
            SizedBox(
              width: 32,
            ),
            Icon(
              Symbols.arrow_forward_ios_rounded,
              size: 20,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.16,
      width: screenWidth * 0.88,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        color: Color(0xFFFCF8F2),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000),
            blurStyle: BlurStyle.normal,
            offset: Offset.fromDirection(-4.0),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }
}

class ReferralCard extends StatelessWidget {
  final String? title;
  final String? text;
  const ReferralCard({this.title, this.text, super.key});

  @override
  Widget build(BuildContext context) {
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.06,
      width: screenWidth * 0.88,
      padding: EdgeInsets.all(8),
      //margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000),
            blurStyle: BlurStyle.normal,
            offset: Offset.fromDirection(-4.0),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${title!}:",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          Text(
            text!,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
