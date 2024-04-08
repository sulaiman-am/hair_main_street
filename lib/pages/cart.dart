import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/blankPage.dart';
import 'package:hair_main_street/controllers/cartController.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/models/auxModels.dart';
import 'package:hair_main_street/models/cartItemModel.dart';
import 'package:hair_main_street/pages/homePage.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:hair_main_street/widgets/cards.dart';
import 'package:material_symbols_icons/symbols.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();
    CartController cartController = Get.find<CartController>();
    UserController userController = Get.find<UserController>();
    CheckOutController checkOutController = Get.find<CheckOutController>();
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    if (userController.userState.value != null) {
      cartController.fetchCart();
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
    return userController.userState.value == null
        ? BlankPage(
            text: userController.userState.value != null &&
                    cartController.cartItems.isEmpty
                ? "You have no items in your Cart"
                : "Your are not logged In",
            pageIcon: userController.userState.value != null &&
                    cartController.cartItems.isEmpty
                ? const Icon(
                    Icons.remove_shopping_cart_outlined,
                    size: 48,
                  )
                : const Icon(
                    Icons.person_off_outlined,
                    size: 48,
                  ),
          )
        : StreamBuilder(
            stream: DataBaseService().fetchCartItems(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
              }
              return GetX<UserController>(
                builder: (controller) {
                  //print(checkOutController.checkoutList);
                  return userController.userState.value == null ||
                          cartController.cartItems.isEmpty
                      ? BlankPage(
                          text: userController.userState.value != null &&
                                  cartController.cartItems.isEmpty
                              ? "You have no items in your Cart"
                              : "Your are not logged In",
                          pageIcon: userController.userState.value != null &&
                                  cartController.cartItems.isEmpty
                              ? const Icon(
                                  Icons.remove_shopping_cart_outlined,
                                  size: 48,
                                )
                              : const Icon(
                                  Icons.person_off_outlined,
                                  size: 48,
                                ),
                        )
                      : Scaffold(
                          appBar: AppBar(
                            leading: IconButton(
                              onPressed: () => Get.back(),
                              icon: const Icon(
                                  Symbols.arrow_back_ios_new_rounded,
                                  size: 24,
                                  color: Colors.black),
                            ),
                            title: const Text(
                              'Cart',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                            centerTitle: true,
                            bottom: PreferredSize(
                              preferredSize:
                                  Size.fromHeight(screenHeight * .05),
                              child: CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 28, vertical: 1),
                                side: const BorderSide(
                                    width: 2, color: Colors.black),
                                title: const Text(
                                  "Add All",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                                value: checkOutController
                                    .isMasterCheckboxChecked.value,
                                onChanged: (val) {
                                  checkOutController.toggleMasterCheckbox();
                                  // for (var item
                                  //     in checkOutController.checkoutList) {
                                  //   //print(item.price);
                                  //   print(item.quantity);
                                  // }
                                  checkOutController
                                      .getTotalPriceAndTotalQuantity();
                                  // Future.delayed(Duration(seconds: 2), () {
                                  //   checkOutController
                                  //       .getTotalPriceAndTotalQuantity();
                                  // });
                                },
                              ),
                            ),
                            // flexibleSpace: Container(
                            //   decoration: BoxDecoration(gradient: appBarGradient),
                            // ),
                            //backgroundColor: Color(0xFF0E4D92),
                          ),
                          extendBody: false,
                          extendBodyBehindAppBar: false,
                          body: Container(
                            //decoration: BoxDecoration(gradient: myGradient),
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            //padding: EdgeInsets.all(8),
                            child: Form(
                              key: formKey,
                              child: ListView.builder(
                                //physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return CartCard(
                                    id: cartController
                                        .cartItems.value[index].productID,
                                  );
                                },
                                itemCount: cartController.cartItems.length,
                                // shrinkWrap: true,
                              ),
                            ),
                          ),
                          // floatingActionButton: Container(
                          //   //width: double.infinity,
                          //   margin: EdgeInsets.only(bottom: screenHeight * .056),
                          //   color: Colors.transparent,
                          //   child: ElevatedButton(
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: Color(0xFF392F5A),
                          //       padding: EdgeInsets.symmetric(
                          //           vertical: 8, horizontal: screenWidth * 0.12),
                          //       //maximumSize: Size(screenWidth * 0.70, screenHeight * 0.10),
                          //       shape: RoundedRectangleBorder(
                          //         side: const BorderSide(
                          //           width: 1.2,
                          //           color: Colors.black,
                          //         ),
                          //         borderRadius: BorderRadius.circular(16),
                          //       ),
                          //     ),
                          //     onPressed: () {
                          //       DataBaseService().addProduct();
                          //     },
                          //     child: const Text(
                          //       "Proceed",
                          //       style: TextStyle(
                          //         fontSize: 24,
                          //         color: Colors.white,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        );
                },
              );
            });
  }
}
