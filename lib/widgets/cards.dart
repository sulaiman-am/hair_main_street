import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/extras/colors.dart';
import 'package:hair_main_street/pages/product_page.dart';
import 'package:hair_main_street/pages/vendor_dashboard/order_details.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../pages/order_detail.dart';
import 'package:flutter_svg/flutter_svg.dart';

bool isRed = false;

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

class ProductCard extends StatefulWidget {
  const ProductCard({super.key});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    Color buttonColor = isRed ? Colors.red : primaryAccent;
    bool showSocialMediaIcons = false;
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Get.to(() => ProductPage(), transition: Transition.fadeIn);
      },
      splashColor: Theme.of(context).primaryColorDark,
      child: Container(
        padding: EdgeInsets.fromLTRB(4, 12, 4, 4),
        height: screenHeight * 0.50,
        width: screenWidth * 0.15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
          color: Color(0xFFF4D06F),
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
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                "Product Name",
                style: TextStyle(
                  fontSize: 20,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text("Product Price"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ShareCard(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isRed = !isRed;
                    });
                  },
                  icon: Icon(
                    EvaIcons.heart,
                    color: buttonColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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

class CartCard extends StatelessWidget {
  const CartCard({super.key});

  @override
  Widget build(BuildContext context) {
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    return Container(
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
          ),
          const SizedBox(
            width: 12,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Product Name",
                style: TextStyle(
                  fontSize: 20,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 8,
              ),
              Text("Product Price"),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Symbols.remove,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    color: const Color(0xFF392F5A),
                    child: Center(
                      child: Text(
                        "1",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          //backgroundColor: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Symbols.add,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
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
  const WishListCard({super.key});

  @override
  Widget build(BuildContext context) {
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
          ),
          const SizedBox(
            width: 12,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Product Name",
                style: TextStyle(
                  fontSize: 20,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 8,
              ),
              Text("Product Price"),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Symbols.remove,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    color: const Color(0xFF392F5A),
                    child: Center(
                      child: Text(
                        "1",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          //backgroundColor: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Symbols.add,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
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
  const OrderCard({this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => Get.to(
        () => OrderDetailsPage(),
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
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Product Name",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 8,
                ),
                Text("Product Price"),
                SizedBox(
                  height: 8,
                ),
                Container(
                  padding: EdgeInsets.all(4),
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
                  child: Text("Payment Status"),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  padding: EdgeInsets.all(4),
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
                  child: Text("Delivery Status"),
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
  const VendorOrderCard({this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => Get.to(
        () => VendorOrderDetailsPage(),
        transition: Transition.fadeIn,
      ),
      child: Container(
        // height: screenHeight * 0.20,
        // width: screenWidth * 0.88,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    "Order ID",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Product Name",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text("Product Price"),
                  SizedBox(
                    height: 8,
                  ),
                  Text("x5"),
                  SizedBox(
                    height: 4,
                  ),
                  Text("Payment Method"),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    padding: EdgeInsets.all(4),
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
                    child: Text("Payment Status"),
                  ),
                  SizedBox(
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
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "30th jun 2023",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "This product is amazing and in great shape, i recommend this vendor. Kudos",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
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
    GlobalKey<FormState>? formKey = GlobalKey();
    TextEditingController? installmentController = TextEditingController();
    String? installment;
    return Container(
      child: Column(children: [
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Column(children: [
                  Text(
                    "Name",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "Sulaiman Abubakar",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
              ),
              SizedBox(
                height: 40,
              ),
              const Card(
                child: Column(children: [
                  Text(
                    "Address",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
                height: 40,
              ),
              const Card(
                child: Column(children: [
                  Text(
                    "Phone number",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
                height: 20,
              ),
              const SizedBox(
                height: 40,
              ),
              Form(
                  key: formKey,
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
                                bool? validate =
                                    formKey?.currentState!.validate();
                                if (validate!) {
                                  formKey?.currentState!.save();
                                }
                              },
                              style: TextButton.styleFrom(
                                // padding: EdgeInsets.symmetric(
                                //     horizontal: screenWidth * 0.24),
                                backgroundColor: Color(0xFF392F5A),
                                side: const BorderSide(
                                    color: Colors.white, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Save",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ]),
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
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8), // Add padding around the entire card
        child: Row(
          children: <Widget>[
            // Child 1: Product Image
            Container(
              width: 100,
              height: 100,
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
