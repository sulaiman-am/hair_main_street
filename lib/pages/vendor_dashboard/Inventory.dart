import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/blankPage.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/controllers/vendorController.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/pages/vendor_dashboard/add_product.dart';
import 'package:hair_main_street/pages/vendor_dashboard/edit_product.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../widgets/cards.dart';

// ignore: must_be_immutable
class InventoryPage extends StatelessWidget {
  InventoryPage({super.key});

  VendorController vendorController = Get.find<VendorController>();
  UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    var productList = vendorController.productList;
    // List<Product> products = [
    //   Product(name: 'Product 1', quantity: 10, image: [
    //     'https://i.pinimg.com/474x/f3/37/50/f33750dd5252106014adcb57fabcdd31.jpg'
    //   ]),
    //   Product(name: 'Product 2', quantity: 20, image: [
    //     'https://i.pinimg.com/474x/b3/85/e8/b385e8fbdc4750181da2505589ca6651.jpg'
    //   ]),
    //   Product(name: 'Product 3', quantity: 5, image: [
    //     'https://i.pinimg.com/474x/51/34/26/513426886614183378a1cbef8d448f16.jpg'
    //   ]),
    //   // Add more products as needed
    // ];
    // print(productList);

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
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Symbols.arrow_back_ios_new_rounded,
              size: 24,
              color: Colors.black,
            ),
            onPressed: () => Get.back(),
          ),

          title: const Text(
            "Inventory",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          // flexibleSpace: Container(
          //   decoration: BoxDecoration(gradient: appBarGradient),
          // ),
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder(
            stream: DataBaseService()
                .getVendorProducts(userController.userState.value!.uid!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //print(snapshot.data);
                return productList.isEmpty
                    ? BlankPage(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        buttonStyle: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF392F5A),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1.2,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        pageIcon: const Icon(
                          Icons.do_disturb_alt_rounded,
                          size: 48,
                        ),
                        text: "You dont have any product in your Inventory",
                        interactionText: "Add Products",
                        interactionIcon: const Icon(
                          Icons.person_2_outlined,
                          size: 24,
                          color: Colors.white,
                        ),
                        interactionFunction: () =>
                            Get.to(() => AddproductPage()),
                      )
                    : ListView.builder(
                        itemCount: productList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InventoryCard(
                            // ignore: invalid_use_of_protected_member
                            imageUrl: productList[index].image?.isNotEmpty ==
                                    true
                                ? productList[index].image!.first
                                : 'https://firebasestorage.googleapis.com/v0/b/hairmainstreet.appspot.com/o/productImage%2FImage%20Not%20Available.jpg?alt=media&token=0104c2d8-35d3-4e4f-a1fc-d5244abfeb3f',
                            productName: productList[index].name!,
                            stock: productList[index].quantity!,
                            onEdit: () {
                              // Implement the edit action
                              Get.to(() => EditProductPage(
                                    productID:
                                        productList.value[index].productID,
                                  ));
                            },
                            onDelete: () {
                              // Implement the delete action
                              Get.dialog(
                                AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: const Text('Delete Product'),
                                  content: const Text(
                                      'You are about to delete this product.\nAre you sure?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Get.back(); // Close the dialog
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                      ),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        vendorController.deleteProduct(
                                            vendorController
                                                .productList[index]);
                                        Get.back();
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.red),
                                      ),
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
