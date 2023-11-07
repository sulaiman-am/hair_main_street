import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/productController.dart';
import 'package:hair_main_street/widgets/cards.dart';
import 'package:material_symbols_icons/symbols.dart';

class SearchPage extends StatelessWidget {
  final String? query;
  const SearchPage({@required this.query, super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = Get.height;
    var screenWidth = Get.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded,
              size: 24, color: Colors.white),
        ),
        title: Text(
          '$query',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            // color: Color(
            //   0xFFFF8811,
            // ),
          ),
        ),
        centerTitle: true,
      ),
      body: GetX<ProductController>(
        builder: (controller) {
          var product = controller.products.value;
          var filteredProducts = product
              .where((product) =>
                  product!.name!.toLowerCase().contains(query!.toLowerCase()))
              .toList();
          controller.filteredProducts.value = filteredProducts;
          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            shrinkWrap: true,
            //physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: screenHeight * 0.295,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
            ),
            itemBuilder: (_, index) => SearchCard(
              index: index,
            ),
            itemCount: filteredProducts.length,
          );
        },
      ),
    );
  }
}
