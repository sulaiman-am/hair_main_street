import 'package:flutter/material.dart';
import 'package:hair_main_street/models/productModel.dart';

import '../../widgets/cards.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Product> products = [
      Product(name: 'Product 1', quantity: 10, image: [
        'https://i.pinimg.com/474x/f3/37/50/f33750dd5252106014adcb57fabcdd31.jpg'
      ]),
      Product(name: 'Product 2', quantity: 20, image: [
        'https://i.pinimg.com/474x/b3/85/e8/b385e8fbdc4750181da2505589ca6651.jpg'
      ]),
      Product(name: 'Product 3', quantity: 5, image: [
        'https://i.pinimg.com/474x/51/34/26/513426886614183378a1cbef8d448f16.jpg'
      ]),
      // Add more products as needed
    ];

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
        title: const Text(
          "Inventory",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: Color(
              0xFFFF8811,
            ),
          ),
        ),
        centerTitle: true,
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(gradient: appBarGradient),
        // ),
      ),
      body: Container(
        //decoration: BoxDecoration(gradient: myGradient),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (BuildContext context, int index) {
            return InventoryCard(
              imageUrl: products[index].image!.first,
              productName: products[index].name!,
              stock: products[index].quantity!,
              onEdit: () {
                // Implement the edit action
              },
              onDelete: () {
                // Implement the delete action
              },
            );
          },
        ),
      ),
    );
  }
}
