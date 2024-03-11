import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/blankPage.dart';
import 'package:hair_main_street/controllers/vendorController.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/pages/vendor_dashboard/add_product.dart';
import 'package:hair_main_street/pages/vendor_dashboard/edit_product.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../widgets/cards.dart';

// ignore: must_be_immutable
class InventoryPage extends StatelessWidget {
  InventoryPage({super.key});

  VendorController vendorController = Get.find<VendorController>();

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
            icon: Icon(
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
              color: Color(0xFF0E4D92),
            ),
          ),
          centerTitle: true,
          // flexibleSpace: Container(
          //   decoration: BoxDecoration(gradient: appBarGradient),
          // ),
        ),
        backgroundColor: Colors.grey[200],
        body: StreamBuilder(
            stream: vendorController
                .getVendorsProducts(vendorController.vendorUID.value),
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
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        pageIcon: const Icon(
                          Icons.do_disturb_alt_rounded,
                          size: 48,
                        ),
                        text: "You dont have any product in your Inventory",
                        interactionText: "Add Products",
                        interactionIcon: Icon(
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
                            imageUrl: productList.value[index].image!.first,
                            productName: productList.value[index].name!,
                            stock: productList.value[index].quantity!,
                            onEdit: () {
                              // Implement the edit action
                              Get.to(() => EditProductPage(
                                    productID:
                                        productList.value[index].productID,
                                  ));
                            },
                            onDelete: () {
                              // Implement the delete action
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
