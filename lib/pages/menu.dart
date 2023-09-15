//ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

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
        Color.fromARGB(255, 255, 224, 139),
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
        title: const Text(
          'Menu',
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
        //backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: false,
      body: Container(
        decoration: BoxDecoration(gradient: myGradient),
        child: ListView(
          padding: EdgeInsets.fromLTRB(8, screenHeight * 0.16, 8, 0),
          children: [
            MenuButton(
              text: "Profile",
              iconData: Symbols.person_2_rounded,
            ),
            const SizedBox(
              height: 12,
            ),
            MenuButton(
              text: "Wish List",
              iconData: Symbols.favorite_rounded,
            ),
            const SizedBox(
              height: 12,
            ),
            MenuButton(
              text: "Orders",
              iconData: Symbols.local_shipping_rounded,
            ),
            const SizedBox(
              height: 12,
            ),
            MenuButton(
              text: "Referral",
              iconData: Symbols.redeem_rounded,
            ),
            const SizedBox(
              height: 12,
            ),
            MenuButton(
              text: "Wallet",
              iconData: Symbols.wallet_rounded,
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String? text;
  final IconData? iconData;
  const MenuButton({
    this.iconData,
    this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Theme.of(context).primaryColorDark
          //side: BorderSide(width: 0.5),
          ),
      onPressed: () {},
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            iconData!,
            color: Colors.black,
            size: 28,
          ),
          SizedBox(
            width: 12,
          ),
          Text(
            text!,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          // SizedBox(
          //   width: screenWidth * 0.30,
          // ),
          // Icon(
          //   Symbols.arrow_forward_ios_rounded,
          //   size: 28,
          //   color: Colors.black,
          // ),
        ],
      ),
    );
  }
}
