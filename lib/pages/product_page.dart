import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/blankPage.dart';
import 'package:hair_main_street/controllers/cartController.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/models/cartItemModel.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/models/review.dart';
import 'package:hair_main_street/controllers/productController.dart';
import 'package:hair_main_street/pages/authentication/authentication.dart';
import 'package:hair_main_street/pages/authentication/sign_in.dart';
import 'package:hair_main_street/pages/chats_page.dart';
import 'package:hair_main_street/pages/client_shop_page.dart';
import 'package:hair_main_street/pages/menu/profile.dart';
import 'package:hair_main_street/pages/menu/wishlist.dart';
import 'package:hair_main_street/pages/messages.dart';
import 'package:hair_main_street/pages/orders_stuff/checkout%20copy.dart';
import 'package:hair_main_street/pages/review_page.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:hair_main_street/widgets/bottom_sheet.dart';
import 'package:hair_main_street/widgets/cards.dart';
import 'package:hair_main_street/widgets/loading.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/uil.dart';
import 'package:like_button/like_button.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:share_plus/share_plus.dart';

class ProductPage extends StatefulWidget {
  final String? id;
  //final int? index;
  const ProductPage({this.id, super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  ProductController productController = Get.find<ProductController>();
  //VendorController vendorController = Get.find<VendorController>();
  UserController userController = Get.find<UserController>();
  CartController cartController = Get.find<CartController>();
  WishListController wishListController = Get.find<WishListController>();
  CheckOutController checkOutController = Get.put(CheckOutController());

  bool? isVisible = false;
  num? quantity;
  String? productID;
  List<bool>? lengthToggleSelection = [false];
  List<bool>? colourToggleSelection = [false];
  Product? product;
  ProductOption? selectedOptionHere;

  void onOptionSelected(ProductOption selectedOption) {
    setState(() {
      selectedOptionHere = selectedOption;
      productController.isOptionVisible.value = true;
      print('Selected option: ${selectedOption.price}');
    });
  }

  @override
  void initState() {
    super.initState();
    productID = widget.id ?? Get.arguments['id'];
    productController.getReviews(productID);
    product = productController.getSingleProduct(productID!);
    //productController.selectedProductOption.value = product!.options![0];

    if (product!.options != null && product!.options!.isNotEmpty) {
      var totalLength = 0;
      var totalColour = 0;
      for (var option in product!.options!) {
        if (option.length != null) {
          totalLength += 1;
        } else if (option.color != null) {
          totalColour += 1;
        }
      }
      lengthToggleSelection = List.filled(totalLength, false);
      colourToggleSelection = List.filled(totalColour, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    //productController.getReviews(widget.id!);

    showPaymentDialog() {
      return Get.dialog(
        AlertDialog(
          alignment: Alignment.center,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(8),
          elevation: 0,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    radius: 40,
                    onTap: () {
                      Get.back();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.clear,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              const Text(
                "How would you like to pay?",
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "You can decide to make payments in installments or pay at once",
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 3,
                textAlign: TextAlign.center,
              ),
              const Divider(
                height: 12,
                color: Colors.grey,
                thickness: 1,
              ),
              GestureDetector(
                child: const SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Text(
                      "Pay Installmentally",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  if (userController.userState.value == null) {
                    Get.to(() => BlankPage(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          buttonStyle: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF673AB7),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 1.2,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          pageIcon: const Icon(
                            Icons.person_off_outlined,
                            size: 48,
                          ),
                          text: "Your are not Logged In",
                          interactionText: "Register or Sign In",
                          interactionIcon: const Icon(
                            Icons.person_2_outlined,
                            size: 24,
                            color: Colors.white,
                          ),
                          interactionFunction: () =>
                              Get.to(() => SignInUpPage()),
                        ));
                  } else if (product!.hasOptions == true) {
                    if (selectedOptionHere == null) {
                      productController
                          .showMyToast("Please Select a product Option First");
                    } else {
                      var val = checkOutController.createCheckBoxItem(
                          product!.productID,
                          productController.quantity.value,
                          (selectedOptionHere?.price!)! *
                              (productController.quantity.value),
                          userController.userState.value!);
                      Get.to(
                        () => CheckOutPage2(
                          method: "installment",
                          products: [val],
                        ),
                      );
                    }
                  } else {
                    var val = checkOutController.createCheckBoxItem(
                        product!.productID,
                        productController.quantity.value,
                        (product!.price! as num) *
                            (productController.quantity.value),
                        userController.userState.value!);
                    Get.back();
                    Get.to(
                      () => CheckOutPage2(
                        method: "installment",
                        products: [val],
                      ),
                    );
                  }

                  print(checkOutController.checkOutItem.value.address);
                },
              ),
              const Divider(
                height: 4,
                color: Colors.grey,
                thickness: 1,
              ),
              GestureDetector(
                onTap: () {
                  if (userController.userState.value == null) {
                    Get.to(() => BlankPage(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          buttonStyle: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF673AB7),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 1.2,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          pageIcon: const Icon(
                            Icons.person_off_outlined,
                            size: 48,
                          ),
                          text: "Your are not Logged In",
                          interactionText: "Register or Sign In",
                          interactionIcon: const Icon(
                            Icons.person_2_outlined,
                            size: 24,
                            color: Colors.white,
                          ),
                          interactionFunction: () =>
                              Get.to(() => SignInUpPage()),
                        ));
                  } else if (product!.hasOptions == true) {
                    if (selectedOptionHere == null) {
                      productController
                          .showMyToast("Please Select a product Option First");
                    } else {
                      var val = checkOutController.createCheckBoxItem(
                          product!.productID,
                          productController.quantity.value,
                          (selectedOptionHere?.price!)! *
                              (productController.quantity.value),
                          userController.userState.value!);
                      Get.to(() => CheckOutPage2(
                            method: "once",
                            products: [val],
                          ));
                    }
                  } else {
                    var val = checkOutController.createCheckBoxItem(
                        product!.productID,
                        productController.quantity.value,
                        (product!.price! as num) *
                            (productController.quantity.value),
                        userController.userState.value!);

                    print(checkOutController.checkOutItem.value.price);
                    Get.back();
                    Get.to(
                      () => CheckOutPage2(
                        method: "once",
                        products: [val],
                      ),
                    );
                  }
                },
                child: const SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: Text(
                      "Pay Once",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              // const SizedBox(
              //   width: 4,
              // ),
            ],
          ),
        ),
      );
    }

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

    averageRating() {
      double sum = 0;
      for (var review in productController.reviews) {
        sum += review!.stars;
      }
      double average = sum / productController.reviews.length;
      //print(average);
      return average;
    }

    String generateProductLink(String productID, String productName) {
      // Replace 'your_domain.com' with your actual domain
      final formattedName = productName.toLowerCase().replaceAll(' ', '_');
      return 'https://hairmainstreet.com/products/$productID/$formattedName';
    }

    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;

    CarouselController carouselController = CarouselController();
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          productController.isOptionVisible.value = false;
          productController.quantity.value = 1;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Symbols.arrow_back_ios_new_rounded,
                size: 24, color: Colors.black),
          ),
          // title: const Text(
          //   'Details',
          //   style: TextStyle(
          //     fontSize: 32,
          //     fontWeight: FontWeight.w900,
          //     color: Colors.black87,
          //   ),
          // ),
          // centerTitle: true,
          // flexibleSpace: Container(
          //   decoration: BoxDecoration(gradient: appBarGradient),
          // ),
          actions: [
            IconButton(
              tooltip: "Share",
              onPressed: () {
                var productLink =
                    generateProductLink(productID!, product!.name!);
                String message =
                    "Hey, I am shopping on Hair Main Street\nCheck out this cool product with the link below\n$productLink";
                Share.share(message, subject: "Product Listing");
              },
              icon: const Icon(
                Symbols.share,
                size: 24,
                color: Colors.black,
              ),
            ),
            // IconButton(
            //   tooltip: "Chat with Vendor",
            //   onPressed: () {
            //     if (userController.userState.value == null) {
            //       Get.to(() => BlankPage(
            //             haveAppBar: true,
            //             textStyle: const TextStyle(
            //               color: Colors.white,
            //               fontSize: 18,
            //             ),
            //             buttonStyle: ElevatedButton.styleFrom(
            //               backgroundColor: Colors.black,
            //               shape: RoundedRectangleBorder(
            //                 side: const BorderSide(
            //                   width: 1.2,
            //                   color: Colors.black,
            //                 ),
            //                 borderRadius: BorderRadius.circular(16),
            //               ),
            //             ),
            //             pageIcon: const Icon(
            //               Icons.person_off_outlined,
            //               size: 48,
            //             ),
            //             text: "Your are not Logged In",
            //             interactionText: "Register or Sign In",
            //             interactionIcon: const Icon(
            //               Icons.person_2_outlined,
            //               size: 24,
            //               color: Colors.white,
            //             ),
            //             interactionFunction: () => Get.to(() => SignInUpPage()),
            //           ));
            //     } else {
            //       Get.to(
            //         () => MessagesPage(
            //           senderID: userController.userState.value!.uid,
            //           receiverID: product!.vendorId,
            //         ),
            //       );
            //     }
            //   },
            //   icon: const Icon(Symbols.message_rounded,
            //       size: 24, color: Colors.black),
            // ),
            PopupMenuButton<String>(
              color: Colors.white.withOpacity(0.80),
              tooltip: "More Option",
              position: PopupMenuPosition.under,
              icon: const Icon(
                Icons.more_vert,
                size: 24,
                color: Colors.black,
              ), // Three dots icon
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'wishlist',
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.favorite_border_rounded,
                        size: 18,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        'Wishlist',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Raleway',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'chats',
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        'assets/chat.svg',
                        height: 18,
                        width: 18,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text(
                        'Chats',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Raleway',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'profile',
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        'assets/user.svg',
                        height: 18,
                        width: 18,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Raleway',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              onSelected: (String value) async {
                switch (value) {
                  case 'wishlist':
                    // Handle 'Wishlist' option
                    if (userController.userState.value == null) {
                      Get.to(() => BlankPage(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            buttonStyle: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF673AB7),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1.2,
                                  color: Color(0xFF673AB7),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            pageIcon: const Icon(
                              Icons.person_off_outlined,
                              size: 48,
                            ),
                            text: "Your are not Logged In",
                            interactionText: "Sign In or Register",
                            interactionIcon: const Icon(
                              Icons.person_2_outlined,
                              size: 24,
                              color: Colors.white,
                            ),
                            interactionFunction: () =>
                                Get.to(() => const SignIn()),
                          ));
                    } else {
                      // var wishlistItem = WishlistItem(productID: productID);
                      // await wishListController.addToWishlist(wishlistItem);
                      Get.to(() => const WishListPage());
                    }
                    break;
                  case 'chats':
                    // Handle 'chats' option
                    if (userController.userState.value == null) {
                      Get.to(() => BlankPage(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            buttonStyle: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF673AB7),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1.2,
                                  color: Color(0xFF673AB7),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            pageIcon: const Icon(
                              Icons.person_off_outlined,
                              size: 48,
                            ),
                            text: "Your are not Logged In",
                            interactionText: "Sign In or Register",
                            interactionIcon: const Icon(
                              Icons.person_2_outlined,
                              size: 24,
                              color: Colors.white,
                            ),
                            interactionFunction: () =>
                                Get.to(() => const SignIn()),
                          ));
                    } else {
                      // var wishlistItem = WishlistItem(productID: productID);
                      // await wishListController.addToWishlist(wishlistItem);
                      Get.to(() => const ChatPage());
                    }
                    break;
                  case 'profile':
                    // Handle 'profile' option
                    if (userController.userState.value == null) {
                      Get.to(() => BlankPage(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            buttonStyle: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF673AB7),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1.2,
                                  color: Color(0xFF673AB7),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            pageIcon: const Icon(
                              Icons.person_off_outlined,
                              size: 48,
                            ),
                            text: "Your are not Logged In",
                            interactionText: "Sign In or Register",
                            interactionIcon: const Icon(
                              Icons.person_2_outlined,
                              size: 24,
                              color: Colors.white,
                            ),
                            interactionFunction: () =>
                                Get.to(() => const SignIn()),
                          ));
                    } else {
                      // var wishlistItem = WishlistItem(productID: productID);
                      // await wishListController.addToWishlist(wishlistItem);
                      Get.to(() => ProfilePage());
                    }
                    break;
                }
              },
            ),
          ],
          //backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: StreamBuilder(
              stream: DataBaseService().getReviews(productID!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //print("hello");
                  return SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product!.image == null || product!.image!.isEmpty)
                          Stack(
                            children: [
                              CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: double.infinity,
                                  height: screenHeight * 0.40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                imageUrl:
                                    'https://firebasestorage.googleapis.com/v0/b/hairmainstreet.appspot.com/o/productImage%2FImage%20Not%20Available.jpg?alt=media&token=0104c2d8-35d3-4e4f-a1fc-d5244abfeb3f',
                                errorWidget: ((context, url, error) =>
                                    const Text("Failed to Load Image")),
                                placeholder: ((context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    )),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: Container(
                                  width: 40,
                                  height: 30,
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      width: 0.8,
                                      color: const Color(0xFF673AB7),
                                    ),
                                  ),
                                  child: FutureBuilder(
                                      future: DataBaseService()
                                          .isProductInWishlist(widget.id!),
                                      builder: (context, snapshot) {
                                        bool isLiked = false;
                                        if (snapshot.hasData) {
                                          isLiked = snapshot.data!;
                                        }
                                        return LikeButton(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          size: 16,
                                          bubblesSize: 48,
                                          isLiked: isLiked,
                                          onTap: (isTapped) async {
                                            // Only proceed if the user is logged in
                                            if (isUserLoggedIn) {
                                              if (isLiked) {
                                                await wishListController
                                                    .removeFromWishlistWithProductID(
                                                        widget.id!);
                                              } else {
                                                WishlistItem wishlistItem =
                                                    WishlistItem(
                                                        wishListItemID:
                                                            widget.id!);
                                                await wishListController
                                                    .addToWishlist(
                                                        wishlistItem);
                                              }
                                            }
                                            return isUserLoggedIn
                                                ? !isLiked
                                                : false;
                                          },
                                          likeBuilder: (isLiked) {
                                            if (isLiked) {
                                              return const Icon(
                                                Icons.favorite,
                                                color: Color(0xFF673AB7),
                                                size: 20,
                                              );
                                            } else {
                                              return const Icon(
                                                Icons.favorite_outline_rounded,
                                                color: Color(0xFF673AB7),
                                                size: 20,
                                              );
                                            }
                                          },
                                          bubblesColor: BubblesColor(
                                            dotPrimaryColor:
                                                const Color(0xFF673AB7),
                                            dotSecondaryColor:
                                                const Color(0xFF673AB7)
                                                    .withOpacity(0.70),
                                            dotThirdColor: Colors.white,
                                            dotLastColor: Colors.black,
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ],
                          )
                        else if (product!.image!.length == 1)
                          Stack(
                            children: [
                              CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: double.infinity,
                                  height: screenHeight * 0.40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                imageUrl: product!.image!.first,
                                errorWidget: ((context, url, error) =>
                                    const Text("Failed to Load Image")),
                                placeholder: ((context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    )),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  width: 40,
                                  height: 30,
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "1/${product!.image!.length}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Raleway',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: Container(
                                  width: 40,
                                  height: 30,
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: FutureBuilder(
                                    future: DataBaseService()
                                        .isProductInWishlist(widget.id!),
                                    builder: (context, snapshot) {
                                      bool isLiked = false;
                                      if (snapshot.hasData) {
                                        isLiked = snapshot.data!;
                                      }
                                      return LikeButton(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        size: 16,
                                        bubblesSize: 48,
                                        isLiked: isLiked,
                                        onTap: (isTapped) async {
                                          // Only proceed if the user is logged in
                                          if (isUserLoggedIn) {
                                            if (isLiked) {
                                              await wishListController
                                                  .removeFromWishlistWithProductID(
                                                      widget.id!);
                                            } else {
                                              WishlistItem wishlistItem =
                                                  WishlistItem(
                                                      wishListItemID:
                                                          widget.id!);
                                              await wishListController
                                                  .addToWishlist(wishlistItem);
                                            }
                                          }
                                          return isUserLoggedIn
                                              ? !isLiked
                                              : false;
                                        },
                                        likeBuilder: (isLiked) {
                                          if (isLiked) {
                                            return const Icon(
                                              Icons.favorite,
                                              color: Color(0xFF673AB7),
                                              size: 20,
                                            );
                                          } else {
                                            return const Icon(
                                              Icons.favorite_outline_rounded,
                                              color: Color(0xFF673AB7),
                                              size: 20,
                                            );
                                          }
                                        },
                                        bubblesColor: BubblesColor(
                                          dotPrimaryColor:
                                              const Color(0xFF673AB7),
                                          dotSecondaryColor:
                                              const Color(0xFF673AB7)
                                                  .withOpacity(0.70),
                                          dotThirdColor: Colors.white,
                                          dotLastColor: Colors.black,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          Stack(
                            children: [
                              CarouselSlider(
                                items: List.generate(
                                  product!.image!.length,
                                  (index) => Stack(
                                    children: [
                                      CachedNetworkImage(
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: double.infinity,
                                          height: screenHeight * 0.40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        fit: BoxFit.fill,
                                        imageUrl: "${product!.image![index]}",
                                        errorWidget: ((context, url, error) =>
                                            const Text("Failed to Load Image")),
                                        placeholder: ((context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator())),
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: Container(
                                          width: 40,
                                          height: 30,
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "${index + 1}/${product!.image!.length}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Raleway',
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                carouselController: carouselController,
                                options: CarouselOptions(
                                  enlargeFactor: 0.1,
                                  height: screenHeight * 0.40,
                                  autoPlay: true,
                                  pauseAutoPlayOnManualNavigate: true,
                                  enlargeCenterPage: true,
                                  viewportFraction: 0.9,
                                  autoPlayInterval:
                                      const Duration(milliseconds: 2000),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: Container(
                                  width: 40,
                                  height: 30,
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: FutureBuilder(
                                    future: DataBaseService()
                                        .isProductInWishlist(widget.id!),
                                    builder: (context, snapshot) {
                                      bool isLiked = false;
                                      if (snapshot.hasData) {
                                        isLiked = snapshot.data!;
                                      }
                                      return LikeButton(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        size: 16,
                                        bubblesSize: 48,
                                        isLiked: isLiked,
                                        onTap: (isTapped) async {
                                          // Only proceed if the user is logged in
                                          if (isUserLoggedIn) {
                                            if (isLiked) {
                                              await wishListController
                                                  .removeFromWishlistWithProductID(
                                                      widget.id!);
                                            } else {
                                              WishlistItem wishlistItem =
                                                  WishlistItem(
                                                      wishListItemID:
                                                          widget.id!);
                                              await wishListController
                                                  .addToWishlist(wishlistItem);
                                            }
                                          }
                                          return isUserLoggedIn
                                              ? !isLiked
                                              : false;
                                        },
                                        likeBuilder: (isLiked) {
                                          if (isLiked) {
                                            return const Icon(
                                              Icons.favorite,
                                              color: Color(0xFF673AB7),
                                              size: 20,
                                            );
                                          } else {
                                            return const Icon(
                                              Icons.favorite_outline_rounded,
                                              color: Color(0xFF673AB7),
                                              size: 20,
                                            );
                                          }
                                        },
                                        bubblesColor: BubblesColor(
                                          dotPrimaryColor:
                                              const Color(0xFF673AB7),
                                          dotSecondaryColor:
                                              const Color(0xFF673AB7)
                                                  .withOpacity(0.70),
                                          dotThirdColor: Colors.white,
                                          dotLastColor: Colors.black,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "${product!.name}",
                          style: const TextStyle(
                            fontSize: 21,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "NGN${formatCurrency(product!.price.toString())}",
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF673AB7),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Text(
                              "(Price per unit)",
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Visibility(
                          visible: product!.description!.isEmpty != true,
                          child: Text(
                            "${product!.description}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Raleway',
                              color: Colors.black,
                            ),
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Visibility(
                          visible: product!.hasOptions! == true,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFFF5F5F5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Options",
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 21,
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                // Visibility(
                                //   visible: product!.options != null &&
                                //       product!.options!.any(
                                //           (element) => element.length != null),
                                //   child: ToggleButtons(
                                //     isSelected: lengthToggleSelection!,
                                //     children: List.generate(
                                //       lengthToggleSelection!.length,
                                //       (index) => Toggles(
                                //         name: product!.options![index].length,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Center(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.4,
                                  color: Colors.black45,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Get.bottomSheet(
                                ProductOptionBottomSheetWidget(
                                    product: product,
                                    onOptionSelected: onOptionSelected),
                              );
                            },
                            child: const Text(
                              "Select Specs",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Obx(
                          () {
                            return Visibility(
                              visible: productController.isOptionVisible.value,
                              child: Container(
                                //width: screenWidth * 0.5,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black45, width: 0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Option Name: ",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "${selectedOptionHere != null ? selectedOptionHere!.length : 'hello'}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Option Price: ",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "${selectedOptionHere != null ? selectedOptionHere!.price : 100}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Quantity Selected: ",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "${productController.quantity}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(
                          height: 4,
                          thickness: 1.5,
                        ),
                        GestureDetector(
                          onTap: () {
                            print("tapped");
                          },
                          child: Container(
                            color: Colors.transparent,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: const Row(
                              children: [
                                Text(
                                  "Specifications",
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 21,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 2.5,
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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
                                color: Colors.transparent,
                                width: screenWidth * 0.60,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/shop.svg',
                                          color: Color(0xFF673AB7),
                                          height: 18,
                                          width: 18,
                                        ),
                                        const Text(
                                          "Store",
                                          style: TextStyle(
                                            color: Color(0xFF673AB7),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Flexible(
                                      child: Text(
                                        "${productController.clientGetVendorName(product!.vendorId).shopName}",
                                        style: const TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF673AB7),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.30,
                              child: TextButton(
                                onPressed: () {
                                  if (userController.userState.value == null) {
                                    Get.to(() => BlankPage(
                                          haveAppBar: true,
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                          buttonStyle: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF673AB7),
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                width: 1.2,
                                                color: Colors.black,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          pageIcon: const Icon(
                                            Icons.person_off_outlined,
                                            size: 48,
                                          ),
                                          text: "Your are not Logged In",
                                          interactionText:
                                              "Sign In or Register",
                                          interactionIcon: const Icon(
                                            Icons.person_2_outlined,
                                            size: 24,
                                            color: Colors.white,
                                          ),
                                          interactionFunction: () =>
                                              Get.to(() => const SignIn()),
                                        ));
                                  } else {
                                    Get.to(
                                      () => MessagesPage(
                                        senderID:
                                            userController.userState.value!.uid,
                                        receiverID: product!.vendorId,
                                      ),
                                    );
                                  }
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      Colors.black.withOpacity(0.70),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 8),
                                ),
                                child: const Text(
                                  "Message",
                                  style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                        const Divider(
                          thickness: 1.5,
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Reviews(${productController.reviews.length})",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                            // SizedBox(
                            //   width: screenWidth * 0.32,
                            // ),
                            // SizedBox(
                            //   width: 4,
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: List.generate(
                                    productController.reviews.isNotEmpty
                                        ? averageRating().round()
                                        : 1,
                                    (index) => const Icon(
                                      Icons.star,
                                      size: 26,
                                      color: Color(0xFF673AB7),
                                    ),
                                  ),
                                ),
                                Text(
                                  productController.reviews.isNotEmpty
                                      ? "${averageRating()}"
                                      : "0",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                // SizedBox(
                                //   width: 8,
                                // ),
                                Visibility(
                                  visible: productController.reviews.isNotEmpty,
                                  child: IconButton(
                                    onPressed: () {
                                      Get.to(() => ReviewPage(productController
                                          .reviews
                                          .cast<Review>()));
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Visibility(
                          visible: productController.reviews.isNotEmpty,
                          child: SingleChildScrollView(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                productController.reviews.length,
                                (index) => ReviewCard(
                                  index: index,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                }
              }),
        ),
        bottomNavigationBar: SafeArea(
          child: BottomAppBar(
            height: kToolbarHeight * 1.5,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            elevation: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 2,
                      color: const Color(0xFF673AB7).withOpacity(0.30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Total Price:",
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      product!.hasOptions == true
                          ? Text(
                              "NGN ${formatCurrency(selectedOptionHere != null ? ((selectedOptionHere!.price!) * (productController.quantity.value)).toString() : "0")}",
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            )
                          : GetX<ProductController>(builder: (controller) {
                              return Text(
                                "NGN ${formatCurrency(((product!.price!) * (productController.quantity.value)).toString())}",
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Color(0xFF673AB7),
                                ),
                              );
                            }),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.47,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          // padding: EdgeInsets.symmetric(
                          //     vertical: 8, horizontal: screenWidth * 0.26),
                          //maximumSize: Size(screenWidth * 0.70, screenHeight * 0.10),
                          shape: const RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1.5,
                              color: Color(0xFF673AB7),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (userController.userState.value == null) {
                            Get.to(() => BlankPage(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                  buttonStyle: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF673AB7),
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        width: 1.2,
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  pageIcon: const Icon(
                                    Icons.person_off_outlined,
                                    size: 48,
                                  ),
                                  text: "Your are not Logged In",
                                  interactionText: "Register or Sign In",
                                  interactionIcon: const Icon(
                                    Icons.person_2_outlined,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                  interactionFunction: () =>
                                      Get.to(() => SignInUpPage()),
                                ));
                          } else if (product!.hasOptions == false) {
                            print("run 1");
                            cartController.addToCart(
                              CartItem(
                                price: product!.price! *
                                    (productController.quantity.value),
                                quantity: productController.quantity.value,
                                productID: product!.productID,
                              ),
                            );
                          } else {
                            print("run 2");
                            if (selectedOptionHere == null) {
                              productController.showMyToast(
                                  "Please Select a product Option First");
                            } else {
                              cartController.addToCart(
                                CartItem(
                                  price: (selectedOptionHere?.price!)! *
                                      (productController.quantity.value),
                                  quantity: productController.quantity.value,
                                  productID: product!.productID,
                                ),
                              );
                            }
                          }
                          // checkOutController.checkoutList.add(
                          //   CheckOutTickBoxModel(
                          //       productID: product.productID,
                          //       price: product.price!,
                          //       quantity: productController.quantity.value,
                          //       user: userController.userState.value),
                          // );
                        },
                        child: const Text(
                          "Add to Cart",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   width: 4,
                    // ),
                    SizedBox(
                      width: screenWidth * 0.47,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF673AB7),
                          // padding: EdgeInsets.symmetric(
                          //   vertical: 8,
                          //   horizontal: screenWidth * 0.26,
                          // ),
                          //maximumSize: Size(screenWidth * 0.70, screenHeight * 0.10),
                          shape: const RoundedRectangleBorder(
                            // side: BorderSide(
                            //   width: 0.5,
                            //   color: Colors.white,
                            // ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () {
                          showPaymentDialog();
                        },
                        child: const Text(
                          "Buy Now",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // floatingActionButton: IconButton(
        //   style: IconButton.styleFrom(
        //     backgroundColor: Color(0xFF392F5A),
        //     shape: CircleBorder(
        //       side: BorderSide(width: 2, color: Colors.white),
        //     ),
        //   ),
        //   onPressed: () => Get.bottomSheet(
        //     Container(
        //       color: Colors.white,
        //       height: screenHeight * .5,
        //     ),
        //   ),
        //   icon: const Icon(
        //     Icons.filter_alt_rounded,
        //     color: Colors.white,
        //   ),
        // ),
        extendBody: true,
      ),
    );
  }
}
