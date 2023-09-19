import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/symbols.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

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
        backgroundColor: const Color(0xFFF4D06F),
        // title: const Text(
        //   'Wallet',
        //   style: TextStyle(
        //     fontSize: 32,
        //     fontWeight: FontWeight.w900,
        //     color: Color(
        //       0xFFFF8811,
        //     ),
        //   ),
        // ),
        centerTitle: true,
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(gradient: appBarGradient),
        // ),
        //backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          Container(
            height: screenHeight * 1,
            //padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(gradient: myGradient),
            child: Stack(
              //padding: EdgeInsets.only(top: 8),
              children: [
                Container(
                  height: screenHeight * 0.27,
                  padding: EdgeInsets.fromLTRB(12, 8, 12, 12),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(0),
                    ),
                    color: const Color(0xFFF4D06F),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Color(0xFF000000),
                    //     blurStyle: BlurStyle.normal,
                    //     offset: Offset.fromDirection(-4.0),
                    //     blurRadius: 4,
                    //   ),
                    // ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "My Wallet",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "#50000000",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Balance",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF000000),
                              blurStyle: BlurStyle.normal,
                              offset: Offset.fromDirection(-4.0),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: screenWidth * 0.1,
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 1,
                  right: 0,
                  //right: ,
                  width: screenWidth * 1,
                  height: screenHeight * .73,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(12, 48, 12, 0),
                    color: Colors.grey,
                    child: Text(
                      "Transaction History",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * .21,
                  left: screenWidth * 0.17,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      //alignment: Alignment.centerLeft,
                      backgroundColor: Color(0xFF9DD9D2),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    icon: Icon(
                      Icons.wallet,
                      size: 20,
                      color: Colors.black,
                    ),
                    label: const Text(
                      "Request Withdrawal",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
