import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/cartController.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';
import 'package:hair_main_street/controllers/productController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/controllers/vendorController.dart';
import 'package:hair_main_street/extras/colors.dart';
import 'package:hair_main_street/models/auxModels.dart';
import 'package:hair_main_street/models/cartItemModel.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/pages/client_shop_page.dart';
import 'package:hair_main_street/pages/product_page.dart';
import 'package:hair_main_street/pages/searchProductPage.dart';
import 'package:hair_main_street/pages/vendor_dashboard/order_details.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../pages/menu/order_detail.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recase/recase.dart';

class WhatsAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  WhatsAppButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: SvgPicture.asset(
            'assets/whatsapp_icon.svg', // Replace with the path to your WhatsApp icon SVG file
            width: 24, // Set the icon width
            height: 24, // Set the icon height
            color: Colors.green, // Set the icon color
          ),
          onPressed: onPressed,
        ),
        const Text("Whatsapp"),
      ],
    );
  }
}

class ShareCard extends StatelessWidget {
  const ShareCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: PopupMenuButton<String>(
      icon: Icon(EvaIcons.share),
      onSelected: (String choice) {
        // Implement sharing logic for the selected option.
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuItem<String>>[
          PopupMenuItem<String>(
            value: 'Facebook',
            child: ListTile(
              leading: Icon(Icons.facebook, color: Colors.blue),
              title: Text('Facebook'),
            ),
          ),
          PopupMenuItem<String>(
            value: 'Twitter',
            child: ListTile(
              leading: Icon(EvaIcons.twitter, color: Colors.blue),
              title: Text('Twitter'),
            ),
          ),
          PopupMenuItem<String>(
              value: 'Whatsapp',
              child: WhatsAppButton(
                onPressed: () {
                  // Handle WhatsApp button press, e.g., open a WhatsApp chat or perform an action
                },
              )),
          // Add more social media options as needed
        ];
      },
    ));
  }
}

class ProductCard extends StatelessWidget {
  final String? id;
  final int index;
  const ProductCard({required this.index, this.id, super.key});
  @override
  Widget build(BuildContext context) {
    ProductController productController = Get.find<ProductController>();
    WishListController wishListController = Get.put(WishListController());
    bool showSocialMediaIcons = false;
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;

    return GetX<ProductController>(builder: (controller) {
      var buttonColor = primaryAccent.obs;
      return InkWell(
        onTap: () {
          Get.to(
              () => ProductPage(
                    id: id,
                    index: index,
                  ),
              transition: Transition.fadeIn);
        },
        splashColor: Colors.black,
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
          height: screenHeight * 0.90,
          width: screenWidth * 0.18,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade400,
              width: 0.5,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
            color: Colors.transparent,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  width: 200,
                  height: 160,
                  child: CachedNetworkImage(
                    //color: Colors.white,
                    //repeat: ImageRepeat.repeat,
                    fit: BoxFit.contain,
                    imageUrl:
                        "${productController.products.value[index]!.image![0]}",
                    errorWidget: ((context, url, error) => const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Failed to Load Image"),
                        )),
                    placeholder: ((context, url) => const Center(
                          child: CircularProgressIndicator(),
                        )),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  ReCase("${productController.products.value[index]!.name}")
                      .titleCase,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child:
                    Text("N ${productController.products.value[index]!.price}"),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     ShareCard(),
              //     GetX<ProductController>(
              //       builder: (_) {
              //         return IconButton(
              //           onPressed: () {
              //             if (buttonColor.value != Colors.red) {
              //               buttonColor.value = Colors.red;
              //               wishListController.addToWishlist(WishlistItem(
              //                   productID: productController
              //                       .products.value[index]!.productID));
              //               //print(buttonColor);
              //             } else {
              //               buttonColor.value = primaryAccent;
              //             }
              //           },
              //           icon: Icon(
              //             EvaIcons.heart,
              //             color: buttonColor.value,
              //           ),
              //         );
              //       },
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      );
    });
  }
}

class ShopSearchCard extends StatelessWidget {
  final int index;
  const ShopSearchCard({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = Get.height;
    var screenWidth = Get.width;
    ProductController productController = Get.find<ProductController>();
    return InkWell(
      onTap: () {
        Get.to(
            () => ClientShopPage(
                  vendorName: productController
                      .filteredVendorsList.value[index]!.shopName,
                ),
            transition: Transition.fadeIn);
      },
      splashColor: Theme.of(context).primaryColorDark,
      child: Container(
        padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
        height: screenHeight * 0.15,
        width: screenWidth * 0.15,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
          color: Colors.grey[100],
          boxShadow: [
            BoxShadow(
              color: Color(0xFF000000),
              blurStyle: BlurStyle.normal,
              offset: Offset.fromDirection(10.0),
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.storefront_outlined,
              size: 24,
              color: Colors.black,
            ),
            Text(
              "${productController.filteredVendorsList.value[index]!.shopName}",
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 24,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}

class SearchCard extends StatelessWidget {
  final int index;
  const SearchCard({required this.index, super.key});
  @override
  Widget build(BuildContext context) {
    ProductController productController = Get.find<ProductController>();
    bool showSocialMediaIcons = false;
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;

    return GetX<ProductController>(builder: (controller) {
      var buttonColor = primaryAccent.obs;
      return InkWell(
        onTap: () {
          Get.to(
              () => ProductPage(
                    id: productController
                        .filteredProducts.value[index]!.productID,
                  ),
              transition: Transition.fadeIn);
        },
        splashColor: Theme.of(context).primaryColorDark,
        child: Container(
          padding: EdgeInsets.fromLTRB(4, 12, 4, 4),
          height: screenHeight * 0.50,
          width: screenWidth * 0.15,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(
                color: Color(0xFF000000),
                blurStyle: BlurStyle.normal,
                offset: Offset.fromDirection(10.0),
                blurRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  width: 120,
                  height: 106,
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl:
                        "${productController.filteredProducts.value[index]!.image![0]}",
                    errorWidget: ((context, url, error) =>
                        Text("Failed to Load Image")),
                    placeholder: ((context, url) => const Center(
                          child: CircularProgressIndicator(),
                        )),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  "${productController.filteredProducts.value[index]!.name}",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                    "NGN ${productController.filteredProducts.value[index]!.price}"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ShareCard(),
                  GetX<ProductController>(
                    builder: (_) {
                      return IconButton(
                        onPressed: () {
                          if (buttonColor.value != Colors.red) {
                            buttonColor.value = Colors.red;
                            //print(buttonColor);
                          } else {
                            buttonColor.value = primaryAccent;
                          }
                        },
                        icon: Icon(
                          EvaIcons.heart,
                          color: buttonColor.value,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

class ClientShopCard extends StatelessWidget {
  final int? index;
  const ClientShopCard({this.index, super.key});
  @override
  Widget build(BuildContext context) {
    ProductController productController = Get.find<ProductController>();
    //bool showSocialMediaIcons = false;
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;

    return GetX<ProductController>(builder: (controller) {
      // Color buttonColor =
      //     productController.isRed.value ? Colors.red : primaryAccent;
      return InkWell(
        onTap: () {
          Get.to(
              () => ProductPage(
                    id: productController.products.value[index!]!.productID,
                  ),
              transition: Transition.fadeIn);
        },
        splashColor: Theme.of(context).primaryColorDark,
        child: Container(
          padding: EdgeInsets.fromLTRB(4, 12, 4, 4),
          height: screenHeight * 0.46,
          width: screenWidth * 0.15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0xFF000000),
                blurStyle: BlurStyle.normal,
                offset: Offset.fromDirection(-4.0),
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  width: 120,
                  height: 106,
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl:
                        "${productController.products.value[index!]!.image![0]}",
                    errorWidget: ((context, url, error) =>
                        Text("Failed to Load Image")),
                    placeholder: ((context, url) => const Center(
                          child: CircularProgressIndicator(),
                        )),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  "${productController.products.value[index!]!.name}",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                    "NGN ${productController.products.value[index!]!.price}"),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     ShareCard(),
              //     IconButton(
              //       onPressed: () {
              //         productController.isRed.value =
              //             !productController.isRed.value;
              //       },
              //       icon: Icon(
              //         EvaIcons.heart,
              //         color: buttonColor,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      );
    });
  }
}

class CarouselCard extends StatelessWidget {
  const CarouselCard({super.key});

  @override
  Widget build(BuildContext context) {
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.24,
      width: screenWidth * 0.70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
        color: Color(0xFFF4D06F),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000),
            blurStyle: BlurStyle.outer,
            blurRadius: 0.4,
          ),
        ],
      ),
      child: Text("Hello"),
    );
  }
}

class CartCard extends StatelessWidget {
  final String? id;
  CartCard({this.id, super.key});

  //bool isChecked = false;
  UserController userController = Get.find<UserController>();
  CartController cartController = Get.find<CartController>();
  ProductController productController = Get.find<ProductController>();
  CheckOutController checkOutController = Get.find<CheckOutController>();
  // late bool isChecked;
  @override
  Widget build(BuildContext context) {
    Product? product;
    var cartItem;
    cartController.cartItems.value.forEach((element) {
      if (element!.productID == id) {
        cartItem = element;
      }
    });
    productController.products.value.forEach((element) {
      if (element!.productID == id) {
        product = element;
      }
    });

    // Initialize the checkbox state for this item
    if (!checkOutController.itemCheckboxState.containsKey(product!.productID)) {
      checkOutController.itemCheckboxState[product!.productID] = false.obs;
    }
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenHeight * 0.18,
      width: screenWidth * 0.88,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000),
            blurStyle: BlurStyle.normal,
            offset: Offset.fromDirection(-4.0),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GetX<CheckOutController>(
            builder: (_) {
              return Checkbox(
                value: checkOutController
                    .itemCheckboxState[product!.productID]!.value,
                onChanged: (val) {
                  //print(object)
                  checkOutController.toggleCheckbox(
                      productID: cartItem!.productID,
                      quantity: cartItem!.quantity,
                      price: cartItem!.price,
                      user: userController.userState.value,
                      value: val!);
                  //print(checkOutController.checkoutList.first.price);

                  // Optionally, you can notify listeners here if needed
                  // checkOutController.itemCheckboxState[widget.id!]!.notifyListeners();
                },
              );
            },
          ),
          const SizedBox(
            width: 12,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(16),
            ),
            width: screenWidth * 0.32,
            height: screenHeight * 0.16,
            child: CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: "${product!.image![0]}",
              errorWidget: ((context, url, error) =>
                  Text("Failed to Load Image")),
              placeholder: ((context, url) => const Center(
                    child: CircularProgressIndicator(),
                  )),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${product!.name}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "${cartItem.price}",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: Icon(
                  //     Symbols.remove,
                  //     size: 24,
                  //     color: Colors.black,
                  //   ),
                  // ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    //width: 28,
                    //height: 28,
                    color: const Color(0xFF392F5A),
                    child: Center(
                      child: Text(
                        "${cartItem.quantity}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          //backgroundColor: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: Icon(
                  //     Symbols.add,
                  //     size: 24,
                  //     color: Colors.black,
                  //   ),
                  // ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class WishListCard extends StatelessWidget {
  final String? id;
  const WishListCard({this.id, super.key});

  @override
  Widget build(BuildContext context) {
    ProductController productController = Get.find<ProductController>();
    CartController cartController = Get.find<CartController>();
    Product? product;
    productController.products.value.forEach((element) {
      if (element!.productID == id) {
        product = element;
      }
    });
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    return Container(
      //height: screenHeight * 0.20,
      width: screenWidth * 0.88,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        color: Color(0xFFFCF8F2),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000),
            blurStyle: BlurStyle.normal,
            offset: Offset.fromDirection(-4.0),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(16),
            ),
            width: screenWidth * 0.36,
            height: screenHeight * 0.20,
            child: CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: "${product!.image![0]}",
              errorWidget: ((context, url, error) =>
                  Text("Failed to Load Image")),
              placeholder: ((context, url) => const Center(
                    child: CircularProgressIndicator(),
                  )),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${product!.name}",
                style: TextStyle(
                  fontSize: 20,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 8,
              ),
              Text("${product!.price}"),
              SizedBox(
                height: 8,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     IconButton(
              //       onPressed: () {},
              //       icon: Icon(
              //         Symbols.remove,
              //         size: 24,
              //         color: Colors.black,
              //       ),
              //     ),
              //     Container(
              //       width: 28,
              //       height: 28,
              //       color: const Color(0xFF392F5A),
              //       child: Center(
              //         child: Text(
              //           "1",
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 24,
              //             //backgroundColor: Colors.blue,
              //           ),
              //         ),
              //       ),
              //     ),
              //     IconButton(
              //       onPressed: () {},
              //       icon: Icon(
              //         Symbols.add,
              //         size: 24,
              //         color: Colors.black,
              //       ),
              //     ),
              //   ],
              // ),
              TextButton(
                onPressed: () {
                  cartController.addToCart(CartItem(
                      quantity: 1, productID: id, price: product!.price));
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF392F5A),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      width: 1.5,
                      color: Colors.black,
                    ),
                  ),
                ),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Function? onTap;
  int? index;
  OrderCard({this.onTap, this.index, super.key});
  CheckOutController checkOutController = Get.find<CheckOutController>();
  ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    var orderDetails = checkOutController.buyerOrderList[index!];
    var product = productController.getSingleProduct(
        checkOutController.buyerOrderList[index!].orderItem!.first.productId!);
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => Get.to(
        () => OrderDetailsPage(
          orderDetails: orderDetails,
          product: product,
        ),
        transition: Transition.fadeIn,
      ),
      child: Container(
        height: screenHeight * 0.20,
        width: screenWidth * 0.88,
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
          color: Color(0xFFFCF8F2),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF000000),
              blurStyle: BlurStyle.normal,
              offset: Offset.fromDirection(-4.0),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(16),
              ),
              width: screenWidth * 0.32,
              height: screenHeight * 0.16,
              child: Image.network(product!.image!.first),
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${product.name}",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text("${product.price}"),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                    color: Color.fromARGB(255, 200, 242, 237),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF000000),
                        blurStyle: BlurStyle.normal,
                        offset: Offset.fromDirection(-4.0),
                        blurRadius: 1.2,
                      ),
                    ],
                  ),
                  child: Text("${orderDetails.paymentStatus}"),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                    color: Color.fromARGB(255, 200, 242, 237),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF000000),
                        blurStyle: BlurStyle.normal,
                        offset: Offset.fromDirection(-4.0),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text("${orderDetails.paymentMethod}"),
                )
              ],
            ),
            SizedBox(
              width: screenWidth * 0.04,
            ),
            Icon(
              Symbols.arrow_forward_ios_rounded,
              size: 20,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}

class VendorOrderCard extends StatelessWidget {
  final Function? onTap;
  int? index;
  VendorOrderCard({this.onTap, this.index, super.key});
  CheckOutController checkOutController = Get.find<CheckOutController>();
  ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    var orderDetails = checkOutController.vendorOrderList[index!];
    var product = productController.getSingleProduct(
        checkOutController.vendorOrderList[index!].orderItem!.first.productId!);
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => Get.to(
        () => VendorOrderDetailsPage(
          product: product,
          orderDetails: orderDetails,
        ),
        transition: Transition.fadeIn,
      ),
      child: Container(
        // height: screenHeight * 0.20,
        // width: screenWidth * 0.88,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xFF000000),
              blurStyle: BlurStyle.normal,
              offset: Offset.fromDirection(-4.0),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.black45,
            //     borderRadius: BorderRadius.circular(16),
            //   ),
            //   width: screenWidth * 0.32,
            //   height: screenHeight * 0.16,
            // ),
            // const SizedBox(
            //   width: 12,
            // ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${product!.name}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    "${orderDetails.orderId}",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("₦${orderDetails.paymentPrice}"),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "x${orderDetails.orderItem!.first.quantity}",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          color: Color.fromARGB(255, 200, 242, 237),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF000000),
                              blurStyle: BlurStyle.normal,
                              offset: Offset.fromDirection(-4.0),
                              blurRadius: 1.2,
                            ),
                          ],
                        ),
                        child: Text("${orderDetails.paymentStatus}"),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "${orderDetails.paymentMethod}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // Container(
                  //   padding: EdgeInsets.all(4),
                  //   decoration: BoxDecoration(
                  //     borderRadius: const BorderRadius.all(
                  //       Radius.circular(12),
                  //     ),
                  //     color: Color.fromARGB(255, 200, 242, 237),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Color(0xFF000000),
                  //         blurStyle: BlurStyle.normal,
                  //         offset: Offset.fromDirection(-4.0),
                  //         blurRadius: 4,
                  //       ),
                  //     ],
                  //   ),
                  //   child: Text("Delivery Status"),
                  // )
                ],
              ),
            ),
            // SizedBox(
            //   width: screenWidth * 0.04,
            // ),
            // const Icon(
            //   Symbols.arrow_forward_ios_rounded,
            //   size: 20,
            //   color: Colors.black,
            // )
          ],
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    return Container(
      //height: screenHeight * 0.16,
      width: screenWidth * 0.88,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        color: Color(0xFFFCF8F2),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000),
            blurStyle: BlurStyle.normal,
            offset: Offset.fromDirection(-4.0),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF000000),
                  blurStyle: BlurStyle.normal,
                  offset: Offset.fromDirection(-4.0),
                  blurRadius: 1,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: screenWidth * 0.08,
              backgroundColor: Colors.grey[200],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Reviever Name",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "30th jun 2023",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "This product is amazing and in great shape, i recommend this vendor. Kudos",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star_half_rounded,
                      color: Colors.yellow[700],
                    ),
                    Text("4.3"),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ReferralCard extends StatelessWidget {
  final String? title;
  final String? text;
  const ReferralCard({this.title, this.text, super.key});

  @override
  Widget build(BuildContext context) {
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.06,
      width: screenWidth * 0.88,
      padding: EdgeInsets.all(8),
      //margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000),
            blurStyle: BlurStyle.normal,
            offset: Offset.fromDirection(-4.0),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${title!}:",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          Text(
            text!,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class ShopDetailsCard extends StatelessWidget {
  const ShopDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    VendorController vendorController = Get.find<VendorController>();
    GlobalKey<FormState>? formKey = GlobalKey();
    GlobalKey<FormState>? formKey2 = GlobalKey();
    TextEditingController? installmentController = TextEditingController();
    TextEditingController? textController = TextEditingController();
    TextEditingController? stateController = TextEditingController();
    String? installment;
    Text? referralText = const Text(
      "https://hairmainstreet/referral/w7621581762817/",
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      maxLines: 3,
      overflow: TextOverflow.clip,
    );
    showCancelDialog(String text, {String? label}) {
      return Get.dialog(
        Form(
          key: formKey,
          child: Center(
            child: Container(
              height:
                  label == "Address" ? screenHeight * .36 : screenHeight * .24,
              width: screenWidth * .64,
              padding: EdgeInsets.all(12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Edit $text",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  label == "Address"
                      ? Column(
                          children: [
                            TextInputWidgetWithoutLabelForDialog(
                              controller: textController,
                              hintText: "Street Name",
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Cannot be Empty";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                textController.text = val!;
                                return null;
                              },
                            ),
                            TextInputWidgetWithoutLabelForDialog(
                              controller: stateController,
                              hintText: "State",
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Cannot be Empty";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                stateController.text = val!;
                                return null;
                              },
                            ),
                          ],
                        )
                      : TextInputWidgetWithoutLabelForDialog(
                          controller: textController,
                          hintText: text,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Cannot be Empty";
                            }
                            return null;
                          },
                          textInputType: label == "Phone Number"
                              ? TextInputType.phone
                              : TextInputType.text,
                          onChanged: (val) {
                            textController.text = val!;
                            return null;
                          },
                        ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                        side: const BorderSide(
                          width: 2,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    onPressed: () {
                      var validated = formKey.currentState!.validate();
                      if (validated) {
                        String? string;
                        formKey.currentState!.save();
                        if (label == "Address") {
                          string =
                              "${textController.text} ${stateController.text}";
                        } else {
                          string = textController.text;
                        }
                        //print(text.split(" ").join("").toLowerCase());
                        // userController.editUserProfile(
                        //     text.split(" ").join("").toLowerCase(),
                        //     string.capitalizeFirst);
                        // print(stateController.text);
                        // print("text:${textController.text}");
                        Get.back();
                      }
                    },
                    child: const Text(
                      "Confirm Edit",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.grey[300],
              child: Column(
                children: [
                  const Text(
                    "Shop Link",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF000000),
                          blurStyle: BlurStyle.normal,
                          offset: Offset.fromDirection(-4.0),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: referralText,
                          flex: 3,
                        ),
                        Expanded(
                          flex: 1,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0xFF392F5A),
                              padding: EdgeInsets.all(4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                  width: 1.5,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            onPressed: () {
                              FlutterClipboard.copy(referralText.data!);
                              Get.snackbar(
                                "Link Copied",
                                "Successful",
                                snackPosition: SnackPosition.BOTTOM,
                                duration:
                                    Duration(seconds: 1, milliseconds: 400),
                                forwardAnimationCurve: Curves.decelerate,
                                reverseAnimationCurve: Curves.easeOut,
                                backgroundColor:
                                    Color.fromARGB(255, 200, 242, 237),
                                margin: EdgeInsets.only(
                                  left: 12,
                                  right: 12,
                                  bottom: screenHeight * 0.16,
                                ),
                              );
                            },
                            child: Text(
                              "Copy",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Card(
              color: Colors.grey[300],
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Name",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    IconButton(
                      onPressed: () {
                        showCancelDialog("Name", label: "Name");
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Text(
                  "${vendorController.vendor.value!.shopName}",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ]),
            ),
            const SizedBox(
              height: 16,
            ),
            Card(
              color: Colors.grey[300],
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Address",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    IconButton(
                      onPressed: () {
                        showCancelDialog("Address", label: "Address");
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Text(
                  "C45 Janbulo",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ]),
            ),
            const SizedBox(
              height: 16,
            ),
            Card(
              color: Colors.grey[300],
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Phone number",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    IconButton(
                      onPressed: () {
                        showCancelDialog("Phone Number", label: "Phone Number");
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Text(
                  "08093368178",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ]),
            ),
            const SizedBox(
              height: 16,
            ),
            Form(
              key: formKey2,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextInputWidget(
                    textInputType: TextInputType.number,
                    controller: installmentController,
                    labelText: "No of Installments:",
                    hintText: "Enter a number between 1 to 10",
                    onSubmit: (val) {
                      installment = val;
                      debugPrint(installment);
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter a number";
                      }
                      num newVal = int.parse(val);
                      if (newVal > 10) {
                        return "Must be less than or equal to 10";
                      } else if (newVal <= 0) {
                        return "Must be greater than 0";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: screenHeight * .02,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            bool? validate = formKey2.currentState!.validate();
                            if (validate) {
                              formKey2.currentState!.save();
                              installment = installmentController.text;
                            }
                          },
                          style: TextButton.styleFrom(
                            // padding: EdgeInsets.symmetric(
                            //     horizontal: screenWidth * 0.24),
                            backgroundColor: Color(0xFF392F5A),
                            side:
                                const BorderSide(color: Colors.white, width: 2),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Save",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class InventoryCard extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final int stock;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  InventoryCard({
    required this.imageUrl,
    required this.productName,
    required this.stock,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black, width: 1.2),
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      elevation: 2,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8), // Add padding around the entire card
        child: Row(
          children: <Widget>[
            // Child 1: Product Image
            Container(
              width: 120,
              height: 130,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Add spacing between the image and other content
            const SizedBox(width: 12),

            // Child 2: Product Name and Stock
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    productName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8), // Add vertical spacing

                  Text(
                    'In Stock: $stock',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Child 3: Edit and Delete Buttons
            Column(
              children: <Widget>[
                if (onEdit != null)
                  IconButton(
                    icon: const Icon(EvaIcons.edit2),
                    onPressed: onEdit,
                  ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: onDelete,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
