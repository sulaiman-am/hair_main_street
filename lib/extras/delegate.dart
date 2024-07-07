import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/productController.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/models/vendorsModel.dart';
import 'package:hair_main_street/pages/searchPage.dart';

class MySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        color: Colors.black,
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "null");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchPage(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    ProductController productController = Get.find<ProductController>();
    var products = productController.products.value;
    var vendors = productController.vendorsList.value;

    // Filter products and vendors based on the query and create a list of suggestions
    List<Product?> productSuggestions = products
        .where((product) =>
            product!.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    List<Vendors?> vendorSuggestions = vendors
        .where((vendor) =>
            vendor!.shopName!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Flatten the list of lists into a single list of suggestions
    List<dynamic> suggestions = [...productSuggestions, ...vendorSuggestions];

    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        String suggestionReturn() {
          if (suggestions[index] is Product) {
            return (suggestions[index] as Product).name!;
          } else {
            return (suggestions[index] as Vendors).shopName!;
          }
        }

        return ListTile(
          title: Text(suggestionReturn()),
          onTap: () {
            // When a suggestion is tapped, update the query and display the results.
            query = suggestionReturn();
            showResults(context);
          },
        );
      },
    );
  }
}
