import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/blankPage.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/pages/menu/order_detail.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:hair_main_street/widgets/cards.dart';
import 'package:material_symbols_icons/symbols.dart';

class OrdersPage extends StatelessWidget {
  OrdersPage({super.key});

  CheckOutController checkOutController = Get.find<CheckOutController>();
  UserController userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    checkOutController.getBuyerOrders(userController.userState.value!.uid!);
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
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Symbols.arrow_back_ios_new_rounded,
                size: 24, color: Colors.black),
          ),
          title: const Text(
            'Orders',
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
          //backgroundColor: Colors.transparent,
        ),
        body: StreamBuilder(
          stream: DataBaseService()
              .getBuyerOrders(userController.userState.value!.uid!),
          builder: (context, snapshot) {
            // print(snapshot.data);
            if (snapshot.hasData) {
              return checkOutController.buyerOrderList.isEmpty
                  ? BlankPage(
                      text: "No Orders Currently",
                      textStyle: const TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                      ),
                      pageIcon: const Icon(
                        Icons.do_disturb_alt_rounded,
                        color: Colors.black,
                        size: 40,
                      ),
                    )
                  : Container(
                      //decoration: BoxDecoration(gradient: myGradient),
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: ListView.builder(
                        //shrinkWrap: true,
                        itemBuilder: (context, index) {
                          //print(checkOutController.buyerOrderList.length);
                          return OrderCard(
                            index: index,
                          );
                        },
                        itemCount: checkOutController.buyerOrderList.length,
                      ),
                    );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
