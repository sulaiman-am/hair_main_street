import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/productController.dart';
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

    // Filter products based on the query and create a list of suggestions
    var suggestions = products
        .where((product) =>
            product!.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]!.name!),
          onTap: () {
            // When a suggestion is tapped, update the query and display the results.
            query = suggestions[index]!.name!;
            showResults(context);
          },
        );
      },
    );
  }
}
