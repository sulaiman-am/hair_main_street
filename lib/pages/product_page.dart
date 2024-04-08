import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/cartController.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/controllers/vendorController.dart';
import 'package:hair_main_street/models/auxModels.dart';
import 'package:hair_main_street/models/cartItemModel.dart';
import 'package:hair_main_street/models/review.dart';
import 'package:hair_main_street/controllers/productController.dart';
import 'package:hair_main_street/pages/cart.dart';
import 'package:hair_main_street/pages/client_shop_page.dart';
import 'package:hair_main_street/pages/messages.dart';
import 'package:hair_main_street/pages/orders_stuff/checkout%20copy.dart';
import 'package:hair_main_street/pages/orders_stuff/checkout.dart';
import 'package:hair_main_street/pages/orders_stuff/confirm_order.dart';
import 'package:hair_main_street/pages/review_page.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:hair_main_street/widgets/cards.dart';
import 'package:material_symbols_icons/symbols.dart';

class ProductPage extends StatefulWidget {
  final String? id;
  final int? index;
  const ProductPage({this.index, this.id, super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  ProductController productController = Get.find<ProductController>();
  //VendorController vendorController = Get.find<VendorController>();
  UserController userController = Get.find<UserController>();
  CartController cartController = Get.find<CartController>();
  CheckOutController checkOutController = Get.put(CheckOutController());

  List<bool> toggleSelection = [true, false, false];
  bool? isVisible = false;
  num? quantity;

  @override
  void initState() {
    super.initState();
    productController.getReviews(widget.id!);
  }

  @override
  Widget build(BuildContext context) {
    var product = productController.getSingleProduct(widget.id!);
    //productController.getReviews(widget.id!);

    averageRating() {
      double sum = 0;
      productController.reviews.value.forEach((review) {
        sum += review!.stars;
      });
      double average = sum / productController.reviews.value.length;
      //print(average);
      return average;
    }

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
    CarouselController carouselController = CarouselController();
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
              productController.reviews.value.clear();
            },
            icon: const Icon(Symbols.arrow_back_ios_new_rounded,
                size: 24, color: Colors.black),
          ),
          title: const Text(
            'Details',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
          // flexibleSpace: Container(
          //   decoration: BoxDecoration(gradient: appBarGradient),
          // ),
          actions: [
            IconButton(
              tooltip: "Cart",
              onPressed: () =>
                  Get.to(() => CartPage(), transition: Transition.fade),
              icon: const Icon(Symbols.shopping_cart_rounded,
                  size: 24, color: Colors.black),
            ),
            IconButton(
              tooltip: "Chat with Vendor",
              onPressed: () {
                Get.to(
                  () => MessagesPage(
                    senderID: userController.userState.value!.uid,
                    receiverID: product!.vendorId,
                  ),
                );
              },
              icon: const Icon(Symbols.message_rounded,
                  size: 24, color: Colors.black),
            ),
            PopupMenuButton<String>(
              color: Colors.white,
              tooltip: "More Option",
              icon: const Icon(
                Icons.more_vert,
                size: 24,
                color: Colors.black,
              ), // Three dots icon
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'addToWishlist',
                  child: Text('Add to Wishlist'),
                ),
                const PopupMenuItem<String>(
                  value: 'options',
                  child: Text('Options'),
                ),
              ],
              onSelected: (String value) {
                switch (value) {
                  case 'addToWishlist':
                    // Handle 'Add to Wishlist' option
                    break;
                  case 'options':
                    // Handle 'Options' option
                    break;
                }
              },
            ),
          ],
          //backgroundColor: Colors.transparent,
        ),
        body: Container(
          // decoration: BoxDecoration(
          //   gradient: myGradient,
          // ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ListView(
            children: [
              Container(
                width: screenWidth * 0.95,
                height: screenHeight * 0.32,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: product!.image!.length == 1
                    ? CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: "${product.image!.first}",
                        errorWidget: ((context, url, error) =>
                            Text("Failed to Load Image")),
                        placeholder: ((context, url) =>
                            CircularProgressIndicator()),
                      )
                    : CarouselSlider(
                        items: List.generate(
                          product.image!.length,
                          (index) => CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: "${product.image![index]}",
                            errorWidget: ((context, url, error) =>
                                Text("Failed to Load Image")),
                            placeholder: ((context, url) =>
                                CircularProgressIndicator()),
                          ),
                        ),
                        carouselController: carouselController,
                        options: CarouselOptions(
                          enlargeFactor: 0.1,
                          height: screenHeight * 0.30,
                          autoPlay: true,
                          pauseAutoPlayOnManualNavigate: true,
                          enlargeCenterPage: true,
                          viewportFraction: 0.70,
                        ),
                      ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "${product.name}",
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "N${product.price}",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 8,
              ),
              Visibility(
                visible: product.description!.isEmpty != true,
                child: Text(
                  "${product.description}",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black45, width: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Details",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(
                            Icons.table_rows_outlined,
                            size: 28,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Length",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "100cm",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(
                            Icons.table_rows_outlined,
                            size: 28,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Texture/Material",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Human Hair",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
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
                      Container(
                        padding: const EdgeInsets.all(12),
                        color: Colors.white,
                        //height: 300, // Adjust the height as needed
                        child: Stack(
                          children: [
                            // Content of the bottom sheet
                            Positioned.fill(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Visibility(
                                      visible: product.hasOption! == true,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Options",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.arrow_forward_rounded,
                                                  size: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                ToggleButtons(
                                                  selectedBorderColor:
                                                      Colors.black,
                                                  borderWidth: 2.4,
                                                  //selectedColor: Colors.red[50],
                                                  fillColor: Colors.grey[200],
                                                  isSelected: toggleSelection,
                                                  children: [
                                                    Toggles(),
                                                    Toggles(),
                                                    Toggles()
                                                  ],
                                                  onPressed: (int index) {
                                                    setState(() {
                                                      for (int i = 0;
                                                          i <
                                                              toggleSelection
                                                                  .length;
                                                          i++) {
                                                        toggleSelection[i] =
                                                            i == index;
                                                      }
                                                    });
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Quantity",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Divider(
                                          thickness: 1.5,
                                          color: Colors.transparent,
                                          height: 4,
                                        ),
                                        GetX<ProductController>(
                                          builder: (_) {
                                            num? quantity = productController
                                                .quantity.value;
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    _.decreaseQuantity();
                                                    print(quantity);
                                                  },
                                                  icon: const Icon(
                                                    Symbols.remove,
                                                    size: 24,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 1,
                                                      horizontal: 2),
                                                  //width: 28,
                                                  //height: 28,
                                                  color: const Color.fromARGB(
                                                      255, 200, 242, 237),
                                                  child: Center(
                                                    child: Text(
                                                      "$quantity",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 24,
                                                        //backgroundColor: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    _.increaseQuantity();
                                                    print(quantity);
                                                  },
                                                  icon: const Icon(
                                                    Symbols.add,
                                                    size: 24,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Button to close the bottom sheet
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    // padding: EdgeInsets.symmetric(
                                    //   vertical: 8,
                                    //   horizontal: screenWidth * 0.26,
                                    // ),
                                    //maximumSize: Size(screenWidth * 0.70, screenHeight * 0.10),
                                    shape: const RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 0.5,
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                  ),
                                  onPressed: () =>
                                      Get.back(), // Close the bottom sheet

                                  child: const Text(
                                    'Done',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Reviews(${productController.reviews.value.length})",
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
                      Icon(
                        Icons.star_half_outlined,
                        size: 36,
                        color: Colors.amber[600],
                      ),
                      Text(
                        productController.reviews.value.isNotEmpty
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
                        visible: productController.reviews.value.isNotEmpty,
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReviewPage(
                                      productController.reviews.value
                                          .cast<Review>())),
                            );
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
                visible: productController.reviews.value.isNotEmpty,
                child: ListView.builder(
                  itemBuilder: (_, index) => ReviewCard(
                    index: index,
                  ),
                  itemCount: productController.reviews.value.length < 2
                      ? productController.reviews.value.length
                      : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Vendor",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 8,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  //elevation: 4,
                  backgroundColor: Colors.white60,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Get.to(
                    () => ClientShopPage(
                      vendorName: productController
                          .clientGetVendorName(product.vendorId)
                          .shopName,
                    ),
                  );
                },
                child: Text(
                  "${productController.clientGetVendorName(product.vendorId).shopName}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Wrap(children: [
            Container(
              alignment: Alignment.topCenter,
              // height:
              //     isVisible == true ? screenHeight * 0.136 : screenHeight * 0.08,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                // boxShadow: const [
                //   BoxShadow(
                //     color: Color(0xFF000000),
                //     blurStyle: BlurStyle.normal,
                //     offset: Offset.zero,
                //     blurRadius: 2,
                //   ),
                // ],
                // //gradient: myGradient,
                // borderRadius: const BorderRadius.only(
                //   topLeft: Radius.circular(12),
                //   topRight: Radius.circular(16),
                // ),
              ),
              child: Column(
                children: [
                  Visibility(
                    visible: isVisible!,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible = false;
                            });
                          },
                          icon: Icon(
                            Icons.cancel_outlined,
                            color: Colors.red[400],
                            size: 32,
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                // padding: EdgeInsets.symmetric(
                                //   vertical: 8,
                                //   horizontal: screenWidth * 0.26,
                                // ),
                                //maximumSize: Size(screenWidth * 0.70, screenHeight * 0.10),
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 0.5,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                var val = checkOutController.createCheckBoxItem(
                                    product.productID,
                                    productController.quantity.value,
                                    (product.price! as num) *
                                        (productController.quantity.value),
                                    userController.userState.value!);

                                print(checkOutController
                                    .checkOutItem.value.address);
                                Get.to(
                                  () => CheckOutPage2(
                                    method: "installment",
                                    products: [val],
                                  ),
                                );
                              },
                              child: const Text(
                                "Pay Installmentally",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                // padding: EdgeInsets.symmetric(
                                //   vertical: 8,
                                //   horizontal: screenWidth * 0.26,
                                // ),
                                //maximumSize: Size(screenWidth * 0.70, screenHeight * 0.10),
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 0.5,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                var val = checkOutController.createCheckBoxItem(
                                    product.productID,
                                    productController.quantity.value,
                                    (product.price! as num) *
                                        (productController.quantity.value),
                                    userController.userState.value!);

                                print(checkOutController
                                    .checkOutItem.value.price);
                                Get.to(() => CheckOutPage2(
                                      method: "once",
                                      products: [val],
                                    ));
                              },
                              child: const Text(
                                "Pay Once",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Obx(
                      //   () => Expanded(
                      //     child: Text(
                      //       "₦${product.price! * (productController.quantity.value)}.00",
                      //       style: const TextStyle(
                      //           fontSize: 20,
                      //           fontWeight: FontWeight.w600,
                      //           color: Colors.black),
                      //       overflow: TextOverflow.ellipsis,
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: screenWidth * .12,
                      // ),
                      SizedBox(
                        width: screenWidth * 0.45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            // padding: EdgeInsets.symmetric(
                            //     vertical: 8, horizontal: screenWidth * 0.26),
                            //maximumSize: Size(screenWidth * 0.70, screenHeight * 0.10),
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
                            cartController.addToCart(
                              CartItem(
                                price: product.price! *
                                    (productController.quantity.value),
                                quantity: productController.quantity.value,
                                productID: product.productID,
                              ),
                            );
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

                      SizedBox(
                        width: screenWidth * 0.45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            // padding: EdgeInsets.symmetric(
                            //   vertical: 8,
                            //   horizontal: screenWidth * 0.26,
                            // ),
                            //maximumSize: Size(screenWidth * 0.70, screenHeight * 0.10),
                            shape: const RoundedRectangleBorder(
                              side: BorderSide(
                                width: 0.5,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isVisible = true;
                            });
                            // Get.to(() => CheckOutPage());
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
          ]),
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

class Toggles extends StatelessWidget {
  const Toggles({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Option Name",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
          const Divider(
            thickness: 2,
            color: Colors.green,
            height: 4,
          ),
          Text(
            "Price",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
          Divider(
            thickness: 1.5,
            color: Colors.transparent,
            height: 4,
          ),
          Text(
            "In Stock",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.green[200],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
