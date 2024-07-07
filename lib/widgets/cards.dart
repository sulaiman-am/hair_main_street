import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/cartController.dart';
import 'package:hair_main_street/controllers/chatController.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';
import 'package:hair_main_street/controllers/productController.dart';
import 'package:hair_main_street/controllers/review_controller.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/controllers/vendorController.dart';
import 'package:hair_main_street/extras/colors.dart';
import 'package:hair_main_street/extras/country_state.dart';
import 'package:hair_main_street/models/auxModels.dart';
import 'package:hair_main_street/models/cartItemModel.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/models/review.dart';
import 'package:hair_main_street/models/vendorsModel.dart';
import 'package:hair_main_street/pages/client_shop_page.dart';
import 'package:hair_main_street/pages/messages.dart';
import 'package:hair_main_street/pages/product_page.dart';
import 'package:hair_main_street/pages/refund.dart';
import 'package:hair_main_street/pages/review_page.dart';
import 'package:hair_main_street/pages/vendor_dashboard/order_details.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:hair_main_street/widgets/loading.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:share_plus/share_plus.dart';
import '../pages/menu/order_detail.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recase/recase.dart';
import 'package:string_validator/string_validator.dart' as validator;

class WhatsAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  WhatsAppButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: SvgPicture.asset(
            'assets/Icons/whatsapp_icon.svg', // Replace with the path to your WhatsApp icon SVG file
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
  final String? mapKey;
  const ProductCard({required this.index, this.id, this.mapKey, super.key});
  @override
  Widget build(BuildContext context) {
    ProductController productController = Get.find<ProductController>();
    UserController userController = Get.find<UserController>();
    WishListController wishListController = Get.find<WishListController>();
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    //print(id);

    bool isUserLoggedIn = userController.userState.value != null;

    String formatCurrency(String numberString) {
      final number =
          double.tryParse(numberString) ?? 0.0; // Handle non-numeric input
      final formattedNumber =
          number.toStringAsFixed(2); // Format with 2 decimals

      // Split the number into integer and decimal parts
      final parts = formattedNumber.split('.');
      final intPart = parts[0];
      final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

      // Format the integer part with commas for every 3 digits
      final formattedIntPart = intPart.replaceAllMapped(
        RegExp(r'\d{1,3}(?=(\d{3})+(?!\d))'),
        (match) => '${match.group(0)},',
      );

      // Combine the formatted integer and decimal parts
      final formattedResult = formattedIntPart + decimalPart;

      return formattedResult;
    }

    return FutureBuilder(
      future: DataBaseService().isProductInWishlist(id!),
      builder: (context, snapshot) {
        bool isLiked = false;
        if (snapshot.hasData) {
          isLiked = snapshot.data!;
        }
        return GetX<WishListController>(
          builder: (controller) {
            return InkWell(
              onTap: () {
                Get.to(
                    () => ProductPage(
                          id: id,
                          //index: index,
                        ),
                    transition: Transition.fadeIn);
              },
              splashColor: Colors.black,
              child: Card(
                elevation: 1,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  // side: BorderSide(
                  //   color: Colors.white,
                  //   width: 0.5,
                  // ),
                ),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: productController.productMap[mapKey]![index]
                                    ?.image?.isNotEmpty ==
                                true
                            ? productController
                                .productMap[mapKey]![index]!.image!.first
                            : 'https://firebasestorage.googleapis.com/v0/b/hairmainstreet.appspot.com/o/productImage%2FImage%20Not%20Available.jpg?alt=media&token=0104c2d8-35d3-4e4f-a1fc-d5244abfeb3f',
                        errorWidget: ((context, url, error) => const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Failed to Load Image"),
                            )),
                        imageBuilder: (context, imageProvider) => Container(
                          width: double.infinity,
                          height: 154,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: ((context, url) => const SizedBox(
                              width: double.infinity,
                              height: 154,
                              child: Center(child: CircularProgressIndicator()),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    SizedBox(
                      height: screenHeight * 0.055,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        child: Text(
                          ReCase("${productController.productMap[mapKey]![index]!.name}")
                              .titleCase,
                          style: const TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        "NGN ${formatCurrency(productController.productMap[mapKey]![index]!.price.toString())}",
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
                      child: LikeButton(
                        mainAxisAlignment: MainAxisAlignment.end,
                        size: 20,
                        bubblesSize: 48,
                        isLiked: isLiked,
                        onTap: (isTapped) async {
                          // Only proceed if the user is logged in
                          if (isUserLoggedIn) {
                            if (isLiked) {
                              await wishListController
                                  .removeFromWishlistWithProductID(id!);
                            } else {
                              WishlistItem wishlistItem =
                                  WishlistItem(wishListItemID: id!);
                              await wishListController
                                  .addToWishlist(wishlistItem);
                            }
                          }
                          return isUserLoggedIn ? !isLiked : false;
                        },
                        likeBuilder: (isLiked) {
                          if (isLiked) {
                            return const Icon(
                              Icons.favorite,
                              color: Color(0xFF673AB7),
                            );
                          } else {
                            return const Icon(
                              Icons.favorite_outline_rounded,
                              color: Color(0xFF673AB7),
                            );
                          }
                        },
                        bubblesColor: BubblesColor(
                          dotPrimaryColor: const Color(0xFF673AB7),
                          dotSecondaryColor:
                              const Color(0xFF673AB7).withOpacity(0.70),
                          dotThirdColor: Colors.white,
                          dotLastColor: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
                  vendorID:
                      productController.filteredVendorsList[index]!.userID,
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
              "${productController.filteredVendorsList[index]!.shopName}",
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

// for vendor highlights
class VendorHighlightsCard extends StatelessWidget {
  final int index;
  const VendorHighlightsCard({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = Get.height;
    var screenWidth = Get.width;
    ProductController productController = Get.find<ProductController>();
    var imageUrl = productController
            .clientGetVendorName(productController.vendorsList[index]!.userID!)
            .shopPicture ??
        "https://firebasestorage.googleapis.com/v0/b/hairmainstreet.appspot.com/o/productImage%2FImage%20Not%20Available.jpg?alt=media&token=0104c2d8-35d3-4e4f-a1fc-d5244abfeb3f";
    return InkWell(
      onTap: () {
        Get.to(
            () => ClientShopPage(
                  vendorID: productController.vendorsList[index]!.userID,
                ),
            transition: Transition.fadeIn);
      },
      splashColor: Theme.of(context).primaryColorDark,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: CachedNetworkImage(
                //color: Colors.white,
                //repeat: ImageRepeat.repeat,
                imageBuilder: (context, imageProvider) => Container(
                  width: double.infinity,
                  height: 154,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                fit: BoxFit.contain,
                imageUrl: imageUrl,
                errorWidget: ((context, url, error) => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Failed to Load Image"),
                    )),
                placeholder: ((context, url) => const Center(
                      child: CircularProgressIndicator(),
                    )),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Container(
              width: double.infinity,
              //height: 50,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF673AB7).withOpacity(0.20),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Text(
                ReCase("${productController.vendorsList[index]!.shopName}")
                    .titleCase,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
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
    UserController userController = Get.find<UserController>();
    WishListController wishListController = Get.find<WishListController>();
    //bool showSocialMediaIcons = false;
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    Product? product = productController.products[index!]!;

    bool isUserLoggedIn = userController.userState.value != null;

    String formatCurrency(String numberString) {
      final number =
          double.tryParse(numberString) ?? 0.0; // Handle non-numeric input
      final formattedNumber =
          number.toStringAsFixed(2); // Format with 2 decimals

      // Split the number into integer and decimal parts
      final parts = formattedNumber.split('.');
      final intPart = parts[0];
      final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

      // Format the integer part with commas for every 3 digits
      final formattedIntPart = intPart.replaceAllMapped(
        RegExp(r'\d{1,3}(?=(\d{3})+(?!\d))'),
        (match) => '${match.group(0)},',
      );

      // Combine the formatted integer and decimal parts
      final formattedResult = formattedIntPart + decimalPart;

      return formattedResult;
    }

    return FutureBuilder(
      future: DataBaseService().isProductInWishlist(product.productID!),
      builder: (context, snapshot) {
        bool isLiked = false;
        if (snapshot.hasData) {
          isLiked = snapshot.data!;
        }

        return InkWell(
          onTap: () {
            Get.to(
                () => ProductPage(
                      id: product.productID,
                      //index: index,
                    ),
                transition: Transition.fadeIn);
          },
          splashColor: Colors.black,
          child: Card(
            elevation: 1,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              // side: BorderSide(
              //   color: Colors.white,
              //   width: 0.5,
              // ),
            ),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: product.image?.isNotEmpty == true
                        ? product.image!.first
                        : 'https://firebasestorage.googleapis.com/v0/b/hairmainstreet.appspot.com/o/productImage%2FImage%20Not%20Available.jpg?alt=media&token=0104c2d8-35d3-4e4f-a1fc-d5244abfeb3f',
                    errorWidget: ((context, url, error) => const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Failed to Load Image"),
                        )),
                    imageBuilder: (context, imageProvider) => Container(
                      width: double.infinity,
                      height: 154,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: ((context, url) => const Center(
                          child: CircularProgressIndicator(),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                SizedBox(
                  height: screenHeight * 0.055,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    child: Text(
                      ReCase("${product.name}").titleCase,
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    "NGN ${formatCurrency(product.price.toString())}",
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
                  child: LikeButton(
                    mainAxisAlignment: MainAxisAlignment.end,
                    size: 20,
                    bubblesSize: 48,
                    isLiked: isLiked,
                    onTap: (isTapped) async {
                      // Only proceed if the user is logged in
                      if (isUserLoggedIn) {
                        if (isLiked) {
                          await wishListController
                              .removeFromWishlistWithProductID(
                                  product.productID!);
                        } else {
                          WishlistItem wishlistItem =
                              WishlistItem(wishListItemID: product.productID!);
                          await wishListController.addToWishlist(wishlistItem);
                        }
                      }
                      return isUserLoggedIn ? !isLiked : false;
                    },
                    likeBuilder: (isLiked) {
                      if (isLiked) {
                        return const Icon(
                          Icons.favorite,
                          color: Color(0xFF673AB7),
                        );
                      } else {
                        return const Icon(
                          Icons.favorite_outline_rounded,
                          color: Color(0xFF673AB7),
                        );
                      }
                    },
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: const Color(0xFF673AB7),
                      dotSecondaryColor:
                          const Color(0xFF673AB7).withOpacity(0.70),
                      dotThirdColor: Colors.white,
                      dotLastColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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

class CartCard extends StatefulWidget {
  final String? id;
  final String? cartId;
  final String? optionName;
  CartCard({this.cartId, this.id, this.optionName, super.key});

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  //bool isChecked = false;
  UserController userController = Get.find<UserController>();

  CartController cartController = Get.find<CartController>();

  ProductController productController = Get.find<ProductController>();

  CheckOutController checkOutController = Get.find<CheckOutController>();

  // late bool isChecked;
  @override
  Widget build(BuildContext context) {
    Product? product = productController.products
        .firstWhere((element) => element!.productID! == widget.id);

    CartItem cartItem = cartController.cartItems.firstWhere((element) {
      if (widget.optionName != null) {
        return element.optionName == widget.optionName &&
            element.productID == widget.id;
      } else {
        return element.optionName == widget.optionName;
      }
    });

    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (checkOutController.checkoutList
    //       .any((element) => element.productID == cartItem.productID)) {
    //     print("cartItem price: ${cartItem.price}");
    //     checkOutController.updateCheckoutList(cartItem);
    //     checkOutController.getTotalPriceAndTotalQuantity();
    //     //checkOutController.getTotalPriceAndTotalQuantity();
    //     WidgetsBinding.instance.addPostFrameCallback((_) {});
    //   } else {
    //     print("Not inside");
    //   }
    // });

    // Initialize the checkbox state for this item
    if (!checkOutController.itemCheckboxState.containsKey(product!.productID)) {
      checkOutController.itemCheckboxState[product.productID] = false.obs;
    }

    String formatCurrency(String numberString) {
      final number =
          double.tryParse(numberString) ?? 0.0; // Handle non-numeric input
      final formattedNumber =
          number.toStringAsFixed(2); // Format with 2 decimals

      // Split the number into integer and decimal parts
      final parts = formattedNumber.split('.');
      final intPart = parts[0];
      final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

      // Format the integer part with commas for every 3 digits
      final formattedIntPart = intPart.replaceAllMapped(
        RegExp(r'\d{1,3}(?=(\d{3})+(?!\d))'),
        (match) => '${match.group(0)},',
      );

      // Combine the formatted integer and decimal parts
      final formattedResult = formattedIntPart + decimalPart;

      return formattedResult;
    }

    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          //height: screenHeight * 0.18,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          //margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: const BoxDecoration(
            // borderRadius: BorderRadius.all(
            //   Radius.circular(16),
            // ),
            color: Colors.white,
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
            //crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GetX<CheckOutController>(
                builder: (_) {
                  return Checkbox(
                    shape: const CircleBorder(side: BorderSide()),
                    value: checkOutController
                        .itemCheckboxState[product.productID]!.value,
                    onChanged: (val) {
                      //print(object)
                      checkOutController.toggleCheckbox(
                        productID: cartItem.productID,
                        quantity: cartItem.quantity,
                        price: cartItem.price,
                        user: userController.userState.value,
                        cartID: widget.cartId,
                        value: val!,
                        optionName: cartItem.optionName,
                      );
                      //print(checkOutController.checkoutList.first.price);
                      checkOutController.getTotalPriceAndTotalQuantity();
                      // Optionally, you can notify listeners here if needed
                      // checkOutController.itemCheckboxState[widget.id!]!.notifyListeners();
                    },
                  );
                },
              ),
              const SizedBox(
                width: 0,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                // decoration: BoxDecoration(
                //   color: Colors.black45,
                // ),
                // width: screenWidth * 0.32,
                // height: screenHeight * 0.16,
                child: CachedNetworkImage(
                  imageBuilder: (context, imageProvider) => Container(
                    height: 140,
                    width: 123,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  fit: BoxFit.fill,
                  imageUrl: product.image!.isNotEmpty == true
                      ? product.image!.first
                      : 'https://firebasestorage.googleapis.com/v0/b/hairmainstreet.appspot.com/o/productImage%2FImage%20Not%20Available.jpg?alt=media&token=0104c2d8-35d3-4e4f-a1fc-d5244abfeb3f',
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
              Expanded(
                child: SizedBox(
                  height: 140,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${product.name}",
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Raleway',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        "NGN${formatCurrency(cartItem.price.toString())}",
                        style: const TextStyle(
                          fontSize: 17,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF673AB7),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            radius: 17,
                            onTap: () async {
                              if (cartItem.quantity! > 1) {
                                await cartController.updateCartItem(
                                  cartItemID: widget.cartId,
                                  newQuantity: -1,
                                  productID: widget.id,
                                );
                                setState(() {});
                              } else {
                                cartController
                                    .showMyToast("Cannot be less than 1");
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(0.5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    const Color(0xFF673AB7).withOpacity(0.10),
                              ),
                              child: const Icon(
                                Icons.remove,
                                size: 24,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            "${cartItem.quantity}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                              //backgroundColor: Colors.blue,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          InkWell(
                            radius: 50,
                            onTap: () async {
                              await cartController.updateCartItem(
                                cartItemID: widget.cartId,
                                newQuantity: 1,
                                productID: widget.id,
                              );

                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.all(0.5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    const Color(0xFF673AB7).withOpacity(0.10),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 24,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            () => ClientShopPage(
                              vendorID: productController
                                  .clientGetVendorName(product.vendorId)
                                  .userID,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          color: Colors.transparent,
                          //width: screenWidth * 0.60,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/Icons/shop.svg',
                                height: 16,
                                width: 16,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Flexible(
                                child: Text(
                                  "${productController.clientGetVendorName(product.vendorId).shopName}",
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 17,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 4,
          thickness: 1,
        ),
      ],
    );
  }
}

class WishListCard extends StatelessWidget {
  final String? productID;
  const WishListCard({this.productID, super.key});

  @override
  Widget build(BuildContext context) {
    ProductController productController = Get.find<ProductController>();
    CartController cartController = Get.find<CartController>();
    WishListController wishListController = Get.find<WishListController>();
    Product? product;
    productController.products.forEach((element) {
      if (element!.productID == productID) {
        product = element;
      }
    });
    String formatCurrency(String numberString) {
      final number =
          double.tryParse(numberString) ?? 0.0; // Handle non-numeric input
      final formattedNumber =
          number.toStringAsFixed(2); // Format with 2 decimals

      // Split the number into integer and decimal parts
      final parts = formattedNumber.split('.');
      final intPart = parts[0];
      final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

      // Format the integer part with commas for every 3 digits
      final formattedIntPart = intPart.replaceAllMapped(
        RegExp(r'\d{1,3}(?=(\d{3})+(?!\d))'),
        (match) => '${match.group(0)},',
      );

      // Combine the formatted integer and decimal parts
      final formattedResult = formattedIntPart + decimalPart;

      return formattedResult;
    }

    if (!wishListController.itemCheckboxState.containsKey(productID)) {
      wishListController.itemCheckboxState[productID!] = false.obs;
    }

    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          //height: screenHeight * 0.20,
          width: screenWidth * 0.88,
          padding: const EdgeInsets.all(6),
          //margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              wishListController.isEditingMode.value
                  ? GetX<WishListController>(builder: (controller) {
                      return Checkbox(
                        shape: const CircleBorder(side: BorderSide()),
                        value: wishListController
                            .itemCheckboxState[productID]!.value,
                        onChanged: (val) {
                          wishListController.toggleCheckBox(val!, productID!);
                        },
                      );
                    })
                  : const SizedBox.shrink(),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                // decoration: BoxDecoration(
                //   color: Colors.black45,
                // ),
                // width: screenWidth * 0.36,
                // height: screenHeight * 0.20,
                child: CachedNetworkImage(
                  //fit: BoxFit.contain,
                  imageUrl: product?.image?.isNotEmpty == true
                      ? product!.image!.first
                      : 'https://firebasestorage.googleapis.com/v0/b/hairmainstreet.appspot.com/o/productImage%2FImage%20Not%20Available.jpg?alt=media&token=0104c2d8-35d3-4e4f-a1fc-d5244abfeb3f',
                  errorWidget: ((context, url, error) =>
                      const Text("Failed to Load Image")),
                  placeholder: ((context, url) => const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      )),
                  imageBuilder: (context, imageProvider) => Container(
                    height: 140,
                    width: 130,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product!.name ?? "",
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "NGN${formatCurrency(product!.price.toString())}",
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF673AB7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => ClientShopPage(
                            vendorID: productController
                                .clientGetVendorName(product!.vendorId)
                                .userID,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        color: Colors.transparent,
                        //width: screenWidth * 0.60,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/Icons/shop.svg',
                              height: 16,
                              width: 16,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Flexible(
                              child: Text(
                                "${productController.clientGetVendorName(product!.vendorId).shopName}",
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 17,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
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
                    wishListController.isEditingMode.value
                        ? const SizedBox.shrink()
                        : Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () async {
                                await cartController.addToCart(CartItem(
                                    quantity: 1,
                                    productID: productID,
                                    price: product!.price));
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(12),
                                //   side: const BorderSide(
                                //     width: 1.5,
                                //     color: Colors.black,
                                //   ),
                                // ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF673AB7),
                                    ),
                                    child: const Icon(
                                      Icons.shopping_cart_outlined,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    "Add to Cart",
                                    style: TextStyle(
                                      color: Color(0xFF673AB7),
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 2,
          thickness: 0.5,
          color: Colors.black.withOpacity(0.3),
        ),
      ],
    );
  }
}

class VendorArrivalCard extends StatelessWidget {
  final String? productID;
  const VendorArrivalCard({this.productID, super.key});

  @override
  Widget build(BuildContext context) {
    ProductController productController = Get.find<ProductController>();
    Product? product;
    product = productController.products
        .firstWhere((product) => product?.productID == productID);
    String formatCurrency(String numberString) {
      final number =
          double.tryParse(numberString) ?? 0.0; // Handle non-numeric input
      final formattedNumber =
          number.toStringAsFixed(2); // Format with 2 decimals

      // Split the number into integer and decimal parts
      final parts = formattedNumber.split('.');
      final intPart = parts[0];
      final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

      // Format the integer part with commas for every 3 digits
      final formattedIntPart = intPart.replaceAllMapped(
        RegExp(r'\d{1,3}(?=(\d{3})+(?!\d))'),
        (match) => '${match.group(0)},',
      );

      // Combine the formatted integer and decimal parts
      final formattedResult = formattedIntPart + decimalPart;

      return formattedResult;
    }

    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ProductPage(
            id: productID,
          ),
        );
      },
      child: Container(
        color: Colors.white,
        //height: screenHeight * 0.20,
        width: double.infinity,
        padding: const EdgeInsets.all(6),
        //margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              // decoration: BoxDecoration(
              //   color: Colors.black45,
              // ),
              // width: screenWidth * 0.36,
              // height: screenHeight * 0.20,
              child: CachedNetworkImage(
                //fit: BoxFit.contain,
                imageUrl: product?.image?.isNotEmpty == true
                    ? product!.image!.first
                    : 'https://firebasestorage.googleapis.com/v0/b/hairmainstreet.appspot.com/o/productImage%2FImage%20Not%20Available.jpg?alt=media&token=0104c2d8-35d3-4e4f-a1fc-d5244abfeb3f',
                errorWidget: ((context, url, error) =>
                    const Text("Failed to Load Image")),
                placeholder: ((context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    )),
                imageBuilder: (context, imageProvider) => Container(
                  height: 140,
                  width: 130,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: SizedBox(
                height: 140,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product!.name ?? "",
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "NGN${formatCurrency(product!.price.toString())}",
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF673AB7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Function? onTap;
  int? index;
  String? mapKey;
  OrderCard({this.onTap, this.index, this.mapKey, super.key});
  CheckOutController checkOutController = Get.find<CheckOutController>();
  ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    String formatCurrency(String numberString) {
      final number =
          double.tryParse(numberString) ?? 0.0; // Handle non-numeric input
      final formattedNumber =
          number.toStringAsFixed(2); // Format with 2 decimals

      // Split the number into integer and decimal parts
      final parts = formattedNumber.split('.');
      final intPart = parts[0];
      final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

      // Format the integer part with commas for every 3 digits
      final formattedIntPart = intPart.replaceAllMapped(
        RegExp(r'\d{1,3}(?=(\d{3})+(?!\d))'),
        (match) => '${match.group(0)},',
      );

      // Combine the formatted integer and decimal parts
      final formattedResult = formattedIntPart + decimalPart;

      return formattedResult;
    }

    var orderDetails = checkOutController.buyerOrderMap[mapKey]![index!];
    var product = productController.getSingleProduct(checkOutController
        .buyerOrderMap[mapKey]![index!].orderItem!.first.productId!);
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
        //height: screenHeight * 0.20,
        width: screenWidth * 0.88,
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(
            width: 0.5,
            color: Colors.black.withOpacity(0.80),
          ),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 145,
                      height: 140,
                      child: Image.network(
                        product?.image?.isNotEmpty == true
                            ? product!.image!.first
                            : "https://firebasestorage.googleapis.com/v0/b/hairmainstreet.appspot.com/o/productImage%2Fnot%20available.jpg?alt=media&token=ea001edd-ec0f-4ffb-9a2d-efae1a28fc40",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${product!.name}",
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "NGN ${formatCurrency(orderDetails.totalPrice.toString())}",
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          color: Color(0xFF673AB7),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      // Container(
                      //   padding:
                      //       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      //   decoration: const BoxDecoration(
                      //     borderRadius: BorderRadius.all(
                      //       Radius.circular(12),
                      //     ),
                      //     color: Colors.black,
                      //     // boxShadow: [
                      //     //   BoxShadow(
                      //     //     color: Color(0xFF000000),
                      //     //     blurStyle: BlurStyle.normal,
                      //     //     offset: Offset.fromDirection(-4.0),
                      //     //     blurRadius: 1.2,
                      //     //   ),
                      //     // ],
                      //   ),
                      //   child: Text(
                      //     "${orderDetails.paymentStatus}",
                      //     style: TextStyle(color: Colors.white),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 8,
                      // ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          color: Colors.white70,
                          border: Border.all(
                            width: 0.3,
                            color: Colors.black.withOpacity(0.85),
                          ),
                        ),
                        child: Text(
                          "${orderDetails.orderStatus}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          color: Colors.white70,
                          border: Border.all(
                            width: 0.3,
                            color: Colors.black.withOpacity(0.85),
                          ),
                        ),
                        child: Text(
                          "${orderDetails.paymentMethod}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Visibility(
                        visible: orderDetails.paymentMethod == "installment",
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: const Color(0xFF673AB7).withOpacity(0.30),
                          ),
                          child: Text(
                            "Amount Paid: NGN${formatCurrency(orderDetails.paymentPrice.toString())}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Lato',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Visibility(
                        visible: orderDetails.orderStatus == "confirmed",
                        child: GestureDetector(
                          onTap: () {
                            Get.to(
                              () => RefundPage(
                                orderId: orderDetails.orderId!,
                                paymentAmount: orderDetails.paymentPrice!,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Color(0xFF673AB7),
                            ),
                            child: const Text(
                              "Request Refund",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Lato',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // setState(() {
                    //   itemCount = itemCount! + 2;
                    // });
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Remove",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Lato',
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class VendorOrderCard extends StatelessWidget {
  final Function? onTap;
  String? mapKey;
  int? index;
  VendorOrderCard({this.onTap, this.mapKey, this.index, super.key});
  CheckOutController checkOutController = Get.find<CheckOutController>();
  ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    var orderDetails = checkOutController.vendorOrdersMap[mapKey]![index!];
    var product = productController.getSingleProduct(checkOutController
        .vendorOrdersMap[mapKey]![index!].orderItem!.first.productId!);
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    String formatCurrency(String numberString) {
      final number =
          double.tryParse(numberString) ?? 0.0; // Handle non-numeric input
      final formattedNumber =
          number.toStringAsFixed(2); // Format with 2 decimals

      // Split the number into integer and decimal parts
      final parts = formattedNumber.split('.');
      final intPart = parts[0];
      final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

      // Format the integer part with commas for every 3 digits
      final formattedIntPart = intPart.replaceAllMapped(
        RegExp(r'\d{1,3}(?=(\d{3})+(?!\d))'),
        (match) => '${match.group(0)},',
      );

      // Combine the formatted integer and decimal parts
      final formattedResult = formattedIntPart + decimalPart;

      return formattedResult;
    }

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
        //padding: EdgeInsets.fromLTRB(),
        margin: const EdgeInsets.fromLTRB(0, 4, 0, 8),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              // decoration: BoxDecoration(
              //   color: Colors.black45,
              // ),
              // width: screenWidth * 0.32,
              // height: screenHeight * 0.16,
              child: CachedNetworkImage(
                imageBuilder: (context, imageProvider) => Container(
                  height: 140,
                  width: 123,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                fit: BoxFit.fill,
                imageUrl: product!.image != null &&
                        product.image!.isNotEmpty == true
                    ? product.image!.first
                    : 'https://firebasestorage.googleapis.com/v0/b/hairmainstreet.appspot.com/o/productImage%2FImage%20Not%20Available.jpg?alt=media&token=0104c2d8-35d3-4e4f-a1fc-d5244abfeb3f',
                errorWidget: ((context, url, error) =>
                    Text("Failed to Load Image")),
                placeholder: ((context, url) => Container(
                      alignment: Alignment.center,
                      height: 140,
                      width: 123,
                      child: CircularProgressIndicator(),
                    )),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${product.name}",
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Raleway',
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Qty:${orderDetails.orderItem!.first.quantity}pcs",
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Amount Paid:${formatCurrency(orderDetails.paymentPrice.toString())}",
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Payment Method: ${orderDetails.paymentMethod}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          fontFamily: 'Lato',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          "Total: ${formatCurrency(orderDetails.totalPrice.toString())}",
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFF673AB7),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "${orderDetails.orderStatus}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Raleway',
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Container(
                  //       padding:
                  //           EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  //       decoration: BoxDecoration(
                  //         borderRadius: const BorderRadius.all(
                  //           Radius.circular(12),
                  //         ),
                  //         color: Color.fromARGB(255, 200, 242, 237),
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: Color(0xFF000000),
                  //             blurStyle: BlurStyle.normal,
                  //             offset: Offset.fromDirection(-4.0),
                  //             blurRadius: 1.2,
                  //           ),
                  //         ],
                  //       ),
                  //       child: Text("${orderDetails.paymentStatus}"),
                  //     ),
                  //     const SizedBox(
                  //       height: 2,
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 8,
                  // ),
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
            const SizedBox(
              width: 4,
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  int? index;
  ReviewCard({super.key, this.index});

  @override
  Widget build(BuildContext context) {
    String resolveTimestampWithoutAdding(Timestamp timestamp) {
      DateTime dateTime = timestamp.toDate();
      String formattedDate =
          DateFormat('dd MMM yyyy', 'en_US').format(dateTime);
      return formattedDate;
    }

    ProductController productController = Get.find<ProductController>();
    Review review = productController.reviews[index!]!;
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    return Card(
      //height: screenHeight * 0.16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      color: Colors.grey[300],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                review.stars.round(),
                (index) => const Icon(
                  Icons.star,
                  size: 24,
                  color: Color(0xFF673AB7),
                ),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              resolveTimestampWithoutAdding(review.createdAt),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Raleway',
                color: Color(0xFF673AB7),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              review.comment,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Raleway',
                color: Color(0xFF673AB7),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "-${review.displayName}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Raleway',
                  color: Color(0xFF673AB7),
                ),
              ),
            ),
          ],
        ),
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

class ShopDetailsCard extends StatefulWidget {
  const ShopDetailsCard({super.key});

  @override
  State<ShopDetailsCard> createState() => _ShopDetailsCardState();
}

class _ShopDetailsCardState extends State<ShopDetailsCard> {
  String _selectedUnit = "Week(s)";
  final TextEditingController _controller = TextEditingController();
  VendorController vendorController = Get.find<VendorController>();
  UserController userController = Get.find<UserController>();

  void _initializeInputFromMilliseconds(int milliseconds) {
    int number;
    String unit;
    if (milliseconds % (7 * 24 * 60 * 60 * 1000) == 0) {
      number = milliseconds ~/ (7 * 24 * 60 * 60 * 1000);
      unit = "Week(s)";
    } else if (milliseconds % (30 * 24 * 60 * 60 * 1000) == 0) {
      number = milliseconds ~/ (30 * 24 * 60 * 60 * 1000);
      unit = "Month(s)";
    } else {
      number = milliseconds ~/ (365 * 24 * 60 * 60 * 1000);
      unit = "Year(s)";
    }
    setState(() {
      _controller.text = number.toString();
      _selectedUnit = unit;
    });
  }

  @override
  void initState() {
    _initializeInputFromMilliseconds(
        vendorController.vendor.value!.installmentDuration!.toInt());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    GlobalKey<FormState>? formKey = GlobalKey();
    GlobalKey<FormState>? formKey2 = GlobalKey();
    CountryAndStatesAndLocalGovernment countryAndStatesAndLocalGovernment =
        CountryAndStatesAndLocalGovernment();
    TextEditingController? bankNameController = TextEditingController();
    TextEditingController? streetController = TextEditingController();
    TextEditingController? accountNumberController = TextEditingController();
    TextEditingController? accountNameController = TextEditingController();
    TextEditingController? phoneNumberController = TextEditingController();
    TextEditingController? shopNameController = TextEditingController();
    Vendors vendor = vendorController.vendor.value!;
    String? accountName,
        accountNumber,
        street,
        country = countryAndStatesAndLocalGovernment.countryList[0],
        state = vendor.contactInfo!["state"],
        localGovernment = vendor.contactInfo!["local government"],
        phoneNumber,
        shopName,
        bankName;
    String message =
        "Hello there, I am on Hair Main Street, Visit my shop using this link below:\n${vendorController.vendor.value!.shopLink}";
    Text? referralText = Text(
      vendorController.vendor.value!.shopLink!,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      maxLines: 3,
      overflow: TextOverflow.clip,
    );
    double determineHeight(String label) {
      double theScreen;
      if (label == 'account info') {
        theScreen = screenHeight * .40;
      } else if (label == 'contact info') {
        theScreen = screenHeight * .60;
      } else {
        theScreen = screenHeight * .24;
      }
      return theScreen;
    }

    showImageUploadDialog() {
      return Get.dialog(
        Obx(() {
          return Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              height: vendorController.isImageSelected.value
                  ? screenHeight * 0.80
                  : screenHeight * 0.30,
              width: screenWidth * 0.9,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: vendorController.isImageSelected.value,
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.45,
                            width: screenWidth * 0.70,
                            child: vendorController
                                    .selectedImage.value.isNotEmpty
                                ? Image.file(
                                    File(vendorController.selectedImage.value),
                                    fit: BoxFit.fill,
                                  )
                                : const Text("Hello"),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                    side: const BorderSide(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  await vendorController.shopImageUpload([
                                    File(vendorController.selectedImage.value)
                                  ], "shop photo");
                                },
                                child: const Text(
                                  "Done",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                    side: const BorderSide(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  vendorController.selectedImage.value = "";
                                  vendorController.isImageSelected.value =
                                      false;
                                },
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                side: const BorderSide(
                                  width: 2,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              await vendorController.selectShopImage(
                                  ImageSource.camera, "shop_photo");
                            },
                            child: const Text(
                              "Take\nPhoto",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
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
                            onPressed: () async {
                              await vendorController.selectShopImage(
                                  ImageSource.gallery, "shop_photo");
                            },
                            child: const Text(
                              "Choose From Gallery",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
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
                        onPressed: () async {
                          if (vendor.shopPicture != null) {
                            vendorController.isLoading.value = true;
                            if (vendorController.isLoading.value) {
                              Get.dialog(const LoadingWidget());
                            }
                            await vendorController.deleteShopPicture(
                                vendor.shopPicture!,
                                "vendors",
                                "shop picture",
                                vendor.userID);
                          } else {
                            vendorController.showMyToast("No Shop Image");
                          }
                        },
                        child: const Text(
                          "Delete Photo",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
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
                        onPressed: () async {
                          Get.back();
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        barrierColor: Colors.transparent,
        barrierDismissible: true,
      );
    }

    showCancelDialog(String text, {String? label}) {
      return Get.dialog(
        StatefulBuilder(
          builder: (context, StateSetter setState) => AlertDialog(
            scrollable: true,
            backgroundColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
            content: SizedBox(
              width: double.infinity,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
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
                      if (label == "contact info")
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildPicker(
                                "State",
                                countryAndStatesAndLocalGovernment.statesList,
                                state, (val) {
                              setState(() {
                                state = val;
                                localGovernment = null;
                              });
                            }),
                            const SizedBox(height: 3),
                            buildPicker(
                                "Local Government",
                                countryAndStatesAndLocalGovernment
                                    .stateAndLocalGovernments[state]!,
                                localGovernment ?? "select", (val) {
                              setState(() {
                                localGovernment = val;
                              });
                            }),
                            const SizedBox(height: 3),
                            TextInputWidgetWithoutLabelForDialog(
                              controller: streetController,
                              initialValue: vendorController.vendor.value!
                                      .contactInfo!["street address"] ??
                                  "",
                              hintText: "Street Address",
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Cannot be Empty";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                streetController.text = val!;
                                street = streetController.text;
                                return null;
                              },
                            ),
                          ],
                        )
                      else if (label == "phone number")
                        TextInputWidgetWithoutLabelForDialog(
                          controller: phoneNumberController,
                          initialValue: vendorController
                              .vendor.value!.contactInfo!["phone number"],
                          hintText: "Phone Number",
                          textInputType: TextInputType.phone,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Cannot be Empty";
                            }
                            return null;
                          },
                          onChanged: (val) {
                            phoneNumberController.text = val!;
                            phoneNumber = phoneNumberController.text;
                            return null;
                          },
                        )
                      else if (label == "account info")
                        Column(
                          children: [
                            TextInputWidgetWithoutLabelForDialog(
                              controller: accountNumberController,
                              initialValue: vendorController
                                  .vendor.value!.accountInfo!["account number"],
                              hintText: "Account Number",
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Cannot be Empty";
                                }
                                if (!validator.isNumeric(val)) {
                                  return "Must Be A Number";
                                }
                                if (val.length < 10) {
                                  return "Account Number must have at least 10 digits";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                accountNumberController.text = val!;
                                accountNumber = accountNumberController.text;
                                return null;
                              },
                            ),
                            TextInputWidgetWithoutLabelForDialog(
                              controller: accountNameController,
                              hintText: "Account Name",
                              initialValue: vendor.accountInfo!["account name"],
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Cannot be Empty";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                accountNameController.text = val!;
                                accountName = accountNameController.text;
                                return null;
                              },
                            ),
                            TextInputWidgetWithoutLabelForDialog(
                              controller: bankNameController,
                              initialValue: vendor.accountInfo!["bank name"],
                              hintText: "Bank Name",
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Cannot be Empty";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                bankNameController.text = val!;
                                bankName = bankNameController.text;
                                return null;
                              },
                            ),
                          ],
                        )
                      else if (label == "name")
                        TextInputWidgetWithoutLabelForDialog(
                          controller: shopNameController,
                          initialValue: vendor.shopName,
                          hintText: text,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Cannot be Empty";
                            }
                            return null;
                          },
                          textInputType: TextInputType.text,
                          onChanged: (val) {
                            shopNameController.text = val!;
                            shopName = shopNameController.text;
                            return null;
                          },
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF673AB7),
                            padding: const EdgeInsets.all(6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            var validated = formKey.currentState!.validate();
                            if (validated) {
                              formKey.currentState!.save();
                              switch (label) {
                                case "Phone Number":
                                  var result = await vendorController
                                      .updateVendor('contact info',
                                          {"phone number": phoneNumber});
                                  if (result == "success") {
                                    Get.close(1);
                                  }
                                  break;
                                case "contact info":
                                  var result = await vendorController
                                      .updateVendor("contact info", {
                                    "country": "Nigeria",
                                    "state": state,
                                    "street address": street,
                                    "local government": localGovernment,
                                  });
                                  if (result == "success") {
                                    Get.close(1);
                                  }
                                case "account info":
                                  var result = await vendorController
                                      .updateVendor("account info", {
                                    "bank name": bankName,
                                    "account name": accountName,
                                    "account number": accountNumber,
                                  });
                                  if (result == "success") {
                                    Get.close(1);
                                  }
                                case "name":
                                  var result = await vendorController
                                      .updateVendor("shop name", shopName);
                                  if (result == "success") {
                                    Get.close(1);
                                  }
                                default:
                              }
                              //Get.back();
                            }
                          },
                          child: const Text(
                            "Confirm Edit",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Lato",
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Obx(
      () => ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Center(
              child: Stack(
                //alignment: AlignmentDirectional.bottomEnd,
                children: [
                  userController.userState.value == null ||
                          vendorController.vendor.value!.shopPicture == null
                      ? CircleAvatar(
                          radius: 68,
                          backgroundColor: Color(0xFFF5f5f5),
                          child: SvgPicture.asset(
                            "assets/Icons/user.svg",
                            color: Colors.black.withOpacity(0.70),
                            height: 50,
                            width: 50,
                          ),
                        )
                      : CircleAvatar(
                          radius: 68,
                          //backgroundColor: Colors.black,
                          backgroundImage: NetworkImage(
                            vendorController.vendor.value!.shopPicture!,
                            scale: 1,
                          ),
                        ),
                  Positioned(
                    bottom: -2,
                    right: 8,
                    child: IconButton(
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            color: Colors.black,
                            width: 0.5,
                          )),
                      onPressed: () {
                        showImageUploadDialog();
                      },
                      icon: Icon(
                        Icons.camera_alt_rounded,
                        size: 28,
                        color: const Color(0xFF673AB7).withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFf5f5f5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.transparent),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      spreadRadius: 0,
                      color: const Color(0xFF673AB7).withOpacity(0.10),
                      offset: const Offset(0, 1),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Shop Details",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Lato',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text(
                      "Shop Link",
                      style: TextStyle(
                        fontFamily: 'Lato',
                        color: Color(0xFF673AB7),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.all(3),
                      child: Column(
                        children: [
                          referralText,
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextButton.icon(
                                  icon: const Icon(
                                    Icons.copy,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Color(0xFF673AB7),
                                    padding: const EdgeInsets.all(4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    FlutterClipboard.copy(referralText.data!);
                                    Get.snackbar(
                                      "Link Copied",
                                      "Successful",
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: Duration(
                                          seconds: 1, milliseconds: 200),
                                      forwardAnimationCurve: Curves.decelerate,
                                      reverseAnimationCurve: Curves.easeOut,
                                      backgroundColor:
                                          Color(0xFF673AB7).withOpacity(0.8),
                                      margin: EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                        bottom: screenHeight * 0.16,
                                      ),
                                    );
                                  },
                                  label: const Text(
                                    "Copy",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                flex: 1,
                                child: TextButton.icon(
                                  icon: const Icon(
                                    Icons.share,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Color(0xFF673AB7),
                                    padding: EdgeInsets.all(4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Share.share(message,
                                        subject: "Hair Main Street Shop Link");
                                  },
                                  label: const Text(
                                    "Share",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Shop Name",
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  color: Color(0xFF673AB7),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              InkWell(
                                child: SvgPicture.asset(
                                  "assets/Icons/edit.svg",
                                  color: Color(0xFF673AB7),
                                  height: 25,
                                  width: 25,
                                ),
                                onTap: () {
                                  showCancelDialog("Name", label: "name");
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(3),
                          child: Text(
                            "${vendorController.vendor.value!.shopName}",
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 12,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFf5f5f5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.transparent),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      spreadRadius: 0,
                      color: const Color(0xFF673AB7).withOpacity(0.10),
                      offset: const Offset(0, 1),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Contact Info",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Lato',
                              color: Color(0xFF673AB7),
                            ),
                          ),
                          InkWell(
                            child: SvgPicture.asset(
                              "assets/Icons/edit.svg",
                              color: Color(0xFF673AB7),
                              height: 25,
                              width: 25,
                            ),
                            onTap: () {
                              showCancelDialog("Contact Info",
                                  label: "contact info");
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.all(3),
                      child: Text(
                        "${vendorController.vendor.value!.contactInfo!['street address']}\n${vendorController.vendor.value!.contactInfo!['local government']} LGA\n${vendorController.vendor.value!.contactInfo!['state']}\n${vendorController.vendor.value!.contactInfo!['country']}",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Phone number",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Lato",
                                  color: Color(0xFF673AB7),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              InkWell(
                                child: SvgPicture.asset(
                                  "assets/Icons/edit.svg",
                                  color: Color(0xFF673AB7),
                                  height: 25,
                                  width: 25,
                                ),
                                onTap: () {
                                  showCancelDialog("Phone Number",
                                      label: "phone number");
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(3),
                          child: Text(
                            "${vendorController.vendor.value?.contactInfo?['phone number']}",
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFf5f5f5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.transparent),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      spreadRadius: 0,
                      color: const Color(0xFF673AB7).withOpacity(0.10),
                      offset: const Offset(0, 1),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Account Info",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF673AB7),
                              fontFamily: "Lato",
                            ),
                          ),
                          InkWell(
                            child: SvgPicture.asset(
                              "assets/Icons/edit.svg",
                              color: Color(0xFF673AB7),
                              width: 25,
                              height: 25,
                            ),
                            onTap: () {
                              showCancelDialog("Account Info",
                                  label: "account info");
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.all(3),
                      child: Text(
                        "${vendorController.vendor.value!.accountInfo!['account number']}\n${vendorController.vendor.value!.accountInfo!['account name']}\n${vendorController.vendor.value!.accountInfo!['bank name']}",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFf5f5f5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.transparent),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      spreadRadius: 0,
                      color: const Color(0xFF673AB7).withOpacity(0.10),
                      offset: const Offset(0, 1),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Choose Installment Duration",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF673AB7),
                        fontFamily: "Lato",
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _controller,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Enter a number",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Enter a Number";
                                } else if (!validator.isNumeric(value)) {
                                  return "Please Enter a Number";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        DropdownButton<String>(
                          value: _selectedUnit,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedUnit = newValue!;
                            });
                          },
                          items: ["Week(s)", "Month(s)", "Year(s)"]
                              .map((unit) => DropdownMenuItem<String>(
                                    value: unit,
                                    child: Text(unit),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // padding: EdgeInsets.symmetric(
                        //     horizontal: screenWidth * 0.24),
                        backgroundColor: const Color(0xFF673AB7),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        _validateAndSend();
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              // Form(
              //   key: formKey2,
              //   child: Column(
              //     //mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: [
              //       TextInputWidget(
              //         textInputType: TextInputType.number,
              //         controller: installmentController,
              //         labelText: "No of Installments:",
              //         hintText: "Enter a number between 1 to 10",
              //         onSubmit: (val) {
              //           installment = val;
              //           debugPrint(installment);
              //         },
              //         validator: (val) {
              //           if (val!.isEmpty) {
              //             return "Please enter a number";
              //           }
              //           num newVal = int.parse(val);
              //           if (newVal > 10) {
              //             return "Must be less than or equal to 10";
              //           } else if (newVal <= 0) {
              //             return "Must be greater than 0";
              //           }
              //           return null;
              //         },
              //       ),
              //       SizedBox(
              //         height: screenHeight * .02,
              //       ),
              //       Row(
              //         children: [
              //           Expanded(
              //             child: TextButton(
              //               onPressed: () {
              //                 bool? validate = formKey2.currentState!.validate();
              //                 if (validate) {
              //                   formKey2.currentState!.save();
              //                   installment = installmentController.text;
              //                 }
              //               },
              //               style: TextButton.styleFrom(
              //                 // padding: EdgeInsets.symmetric(
              //                 //     horizontal: screenWidth * 0.24),
              //                 backgroundColor: Color(0xFF392F5A),
              //                 side:
              //                     const BorderSide(color: Colors.white, width: 2),

              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(12),
              //                 ),
              //               ),
              //               child: const Text(
              //                 "Save",
              //                 textAlign: TextAlign.center,
              //                 style: TextStyle(color: Colors.white, fontSize: 20),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  void _validateAndSend() {
    final input = int.tryParse(_controller.text);
    if (input != null && input > 0) {
      int milliseconds = 0;
      switch (_selectedUnit) {
        case "Week(s)":
          milliseconds = input * 7 * 24 * 60 * 60 * 1000;
          break;
        case "Month(s)":
          milliseconds = input * 30 * 24 * 60 * 60 * 1000;
          break;
        case "Year(s)":
          milliseconds = input * 365 * 24 * 60 * 60 * 1000;
          break;
      }
      // Send milliseconds to the database
      vendorController.updateVendor("installment duration", milliseconds);
      print("Milliseconds: $milliseconds");
    } else {
      // Show error message or handle invalid input
      print("Invalid input");
    }
  }

  Widget buildPicker(String label, List<String> items, String? selectedValue,
      Function(String?) onChanged) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue,
            elevation: 0,
            isExpanded: true,
            isDense: true,
            onChanged: onChanged,
            items: [
              const DropdownMenuItem(
                value: 'select',
                child: Text('Select'),
              ),
              ...items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class InventoryCard extends StatelessWidget {
  final String? imageUrl;
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
                  image: NetworkImage(imageUrl ??
                      "https://firebasestorage.googleapis.com/v0/b/hairmainstreet.appspot.com/o/productImage%2FImage%20Not%20Available.jpg?alt=media&token=0104c2d8-35d3-4e4f-a1fc-d5244abfeb3f"),
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

class ClientReviewCard extends StatelessWidget {
  int? index;

  ClientReviewCard({
    super.key,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    DateTime resolveTimestampWithoutAdding(Timestamp timestamp) {
      DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime

      // Add days to the DateTime
      //DateTime newDateTime = dateTime.add(Duration(days: daysToAdd));

      return dateTime;
    }

    ReviewController reviewController = Get.find<ReviewController>();
    Review review = reviewController.myReviews[index!];
    var screenWidth = Get.width;
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF000000),
              blurStyle: BlurStyle.normal,
              offset: Offset.fromDirection(-4.0),
              blurRadius: 1.2,
            ),
          ],
        ),
        // Add some margin if needed (replace with desired values)
        //margin: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
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
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            "${review.displayName}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () => Get.to(
                                  () => EditReviewPage(
                                    productID: "${review.productID}",
                                    reviewID: "${review.reviewID}",
                                  ),
                                ),
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              Get.dialog(
                                AlertDialog(
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                  title: const Text('Delete Review'),
                                  content: const Text(
                                      'You are about to delete this review.\nAre you sure?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Get.back(); // Close the dialog
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                                Colors.white),
                                      ),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await reviewController
                                            .deleteReview(review.reviewID!);
                                        //Get.back();
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
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
                            icon: const Icon(Icons.delete))
                      ],
                    ),
                    Text(
                      "${resolveTimestampWithoutAdding(review.createdAt)}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      review.comment,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
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
                        Text(
                          "${review.stars}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatsCard extends StatefulWidget {
  int? index;
  String? nameToDisplay;
  Vendors? vendorDetails;
  MessagePageData? member1;
  MessagePageData? member2;

  ChatsCard({
    super.key,
    this.member1,
    this.member2,
    this.index,
    this.nameToDisplay,
    this.vendorDetails,
  });

  @override
  State<ChatsCard> createState() => _ChatsCardState();
}

class _ChatsCardState extends State<ChatsCard> {
  ChatController chatController = Get.find<ChatController>();
  UserController userController = Get.find<UserController>();

  MessagePageData? sender;
  MessagePageData? receiver;

  @override
  void initState() {
    super.initState();
    if (userController.userState.value!.uid! == widget.member2!.id) {
      sender = widget.member2!;
      receiver = widget.member1!;
    } else if (userController.userState.value!.uid! == widget.member1!.id) {
      sender = widget.member1!;
      receiver = widget.member2!;
    }
  }

  @override
  Widget build(BuildContext context) {
    //Vendors? vendors = userController.vendorDetails.value;
    DateTime resolveTimestampWithoutAdding(Timestamp timestamp) {
      final now = DateTime.now();
      final timestampDateTime = timestamp.toDate();

      // Calculate the difference in hours between the timestamp and now
      final hourDifference = now.difference(timestampDateTime).inHours;

      // If the difference is less than 24 hours, return only the time component
      if (hourDifference < 24) {
        return DateTime(
          0,
          0,
          0,
          timestampDateTime.hour,
          timestampDateTime.minute,
        );
      } else {
        // If the difference is 24 hours or more, return only the date component
        // without extra zeros for the time component
        return DateTime(
          timestampDateTime.year,
          timestampDateTime.month,
          timestampDateTime.day,
        );
      }
    }

    //Review review = reviewController.myReviews[index!];
    var screenWidth = Get.width;
    return InkWell(
      onTap: () => Get.to(
        () => MessagesPage(
          senderID: sender!.id,
          receiverID: receiver!.id,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 0.3,
                      color: const Color(0xFF673AB7).withOpacity(0.45),
                    ),
                  ),
                  child:
                      receiver!.imageUrl == null || receiver!.imageUrl!.isEmpty
                          ? CircleAvatar(
                              radius: 50,
                              backgroundColor: const Color(0xFFf5f5f5),
                              child: SvgPicture.asset(
                                "assets/Icons/user.svg",
                                color: Colors.black,
                                height: 24,
                                width: 24,
                              ),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                receiver!.imageUrl!,
                              ),
                            ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 20,
                            child: Text(
                              receiver!.name!,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // Text(
                          //   resolveTimestampWithoutAdding(chatController
                          //           .myChats[widget.index!]!.recentMessageSentAt!)
                          //       .toString()
                          //       .split(" ")[0],
                          //   style: const TextStyle(
                          //     fontSize: 14,
                          //     fontWeight: FontWeight.w500,
                          //     color: Colors.black,
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        chatController
                                .myChats[widget.index!]!.recentMessageText ??
                            "hello",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.star_half_rounded,
                      //       color: Colors.yellow[700],
                      //     ),
                      //     Text(
                      //       "${review.stars}",
                      //       style: const TextStyle(fontSize: 14),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 2,
            thickness: 1,
            color: Colors.black.withOpacity(0.35),
          ),
        ],
      ),
    );
  }
}
