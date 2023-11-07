import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/symbols.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    void _showBottomSheet(BuildContext context) {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: screenHeight * 0.75,
            // Add your bottom sheet content here
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text('Option 1'),
                    onTap: () {
                      // Implement functionality for Option 1
                    },
                  ),
                  ListTile(
                    title: Text('Option 2'),
                    onTap: () {
                      // Implement functionality for Option 2
                    },
                  ),
                  // Add more items as needed
                ],
              ),
            ),
          );
        },
      );
    }

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
        backgroundColor: const Color(0xFF0E4D92),
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
        physics: NeverScrollableScrollPhysics(),
        children: [
          Container(
            height: screenHeight * 1,
            //padding: EdgeInsets.symmetric(horizontal: 12),
            //decoration: BoxDecoration(gradient: myGradient),
            child: Stack(
              //padding: EdgeInsets.only(top: 8),
              children: [
                Container(
                  height: screenHeight * 0.27,
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(0),
                    ),
                    color: Color(0xFF0E4D92),
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
                              color: Colors.white,
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
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Balance",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
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
                    padding: EdgeInsets.fromLTRB(12, 52, 12, 0),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Transaction History",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                //alignment: Alignment.centerLeft,
                                //backgroundColor: Colors.red[400],
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.black,
                                      width: 1.6,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                _showBottomSheet(context);
                              },
                              child: const Text(
                                "See all",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * .01,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black38,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Text(
                            "Lorem Ipsum",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * .21,
                  left: screenWidth * 0.08,
                  right: screenWidth * 0.08,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 30),
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
                    ],
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
