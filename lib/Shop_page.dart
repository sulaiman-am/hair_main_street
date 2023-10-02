import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/symbols.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

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
          'Shop Page',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Color(
              0xFFFF8811,
            ),
          ),
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
            gradient: myGradient,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: const Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 1000,
                height: 100.0,
                child: Text(
                  'Shop Name',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 21, 21, 20),
                  ),
                ),
              ),
              SizedBox(
                width: 1000,
                height: 100.0,
                child: Text(
                  'Shop Address',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 21, 21, 20),
                  ),
                ),
              ),
              SizedBox(
                width: 1000,
                height: 100.0,
                child: Text(
                  'Phone number',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 21, 21, 20),
                  ),
                ),
              ),
              SizedBox(
                width: 1000,
                height: 100.0,
                child: Text(
                  'Installments allowed',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 21, 21, 20),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
