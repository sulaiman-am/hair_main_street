import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/productController.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/pages/menu.dart';
import 'package:string_validator/string_validator.dart' as validator;
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:material_symbols_icons/symbols.dart';

class EditProductPage extends StatefulWidget {
  final String? productID;
  const EditProductPage({this.productID, super.key});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  GlobalKey<FormState> formKey = GlobalKey();
  ProductController productController = Get.find<ProductController>();

  bool checkbox1 = true;
  String? hello;
  bool checkbox2 = false;
  int listItems = 1;
  // Product? product = Product(
  //   name: "",
  //   price: 0,
  //   quantity: 0,
  //   hasOption: false,
  //   allowInstallment: true,
  //   image: [],
  //   description: "",
  // );
  TextEditingController? productName,
      productPrice,
      productDescription,
      quantity = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var product = productController.getSingleProduct(widget.productID!);
    num screenHeight = Get.height;
    num screenWidth = Get.width;

    showCancelDialog() {
      return Get.dialog(
        Center(
          child: Container(
            height: screenHeight * .24,
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
                const Text(
                  "Are you sure you want to cancel \nproduct Edit?",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green.shade200,
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
                        return Get.close(2);
                      },
                      child: const Text(
                        "YES",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 4,
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
                        Get.back();
                      },
                      child: const Text(
                        "NO",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async => await showCancelDialog(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => showCancelDialog(),
            icon: const Icon(Symbols.arrow_back_ios_new_rounded,
                size: 24, color: Colors.black),
          ),
          title: const Text(
            'Edit Product',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0E4D92),
            ),
          ),
          centerTitle: true,
          // flexibleSpace: Container(
          //   decoration: BoxDecoration(gradient: appBarGradient),
          // ),
          //backgroundColor: Colors.transparent,
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          //decoration: BoxDecoration(gradient: myGradient),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: SingleChildScrollView(
                        child: Row(
                          children: List.generate(
                            product!.image!.length,
                            (index) => InkWell(
                              onTap: () {
                                Get.dialog(
                                  Center(
                                    child: Container(
                                      height: screenHeight * .44,
                                      width: screenWidth * .64,
                                      padding: EdgeInsets.all(12),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.network(
                                            "${product.image![index]}",
                                            fit: BoxFit.contain,
                                            // loadingBuilder:
                                            //     (context, child, loadingProgress) =>
                                            //         const Text(
                                            //   "Loading...",
                                            //   style: TextStyle(
                                            //     color: Colors.white,
                                            //   ),
                                            // ),
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Text(
                                                "Error \nLoading \nImage...",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              );
                                            },
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                onPressed: () {},
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      Color(0xFF392F5A),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 4,
                                                    vertical: 2,
                                                  ),
                                                  elevation: 2,
                                                ),
                                                child: const Text(
                                                  "Change Image",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              IconButton.outlined(
                                                style: IconButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    side: const BorderSide(
                                                      color: Colors.black,
                                                      width: 6,
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.delete_rounded,
                                                  color: Colors.red,
                                                  size: 24,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                color: Colors.black,
                                width: screenWidth * 0.16,
                                height: screenHeight * .08,
                                child: Image.network(
                                  "${product.image![index]}",
                                  fit: BoxFit.fill,
                                  // loadingBuilder:
                                  //     (context, child, loadingProgress) =>
                                  //         const Text(
                                  //   "Loading...",
                                  //   style: TextStyle(
                                  //     color: Colors.white,
                                  //   ),
                                  // ),
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Text(
                                      "Error \nLoading \nImage...",
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          productController.uploadImage();
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFF392F5A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 2,
                              vertical: 2,
                            ),
                            elevation: 2),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: 24,
                              color: Colors.white,
                            ),
                            Text(
                              "Add \nImage",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                TextInputWidget(
                  controller: productName,
                  labelText: "Product Name",
                  initialValue: product!.name,
                  textInputType: TextInputType.text,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please enter the product name";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    product.name = val;
                    hello = val;
                    debugPrint(product.name);
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextInputWidget(
                  initialValue: product.price.toString(),
                  labelText: "Price",
                  //hintText: "",
                  textInputType: TextInputType.text,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Cannot be empty, set a price";
                    } else if (validator.isNumeric(val) == false) {
                      return "Must be a Number";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    product.price = int.parse(val!);
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                CheckboxListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  value: product.allowInstallment,
                  onChanged: (val) {
                    setState(() {
                      checkbox1 = val!;
                      product.allowInstallment = val;
                    });
                  },
                  title: const Text(
                    "Available for Installment",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                CheckboxListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  value: product.hasOption,
                  onChanged: (val) {
                    setState(() {
                      checkbox2 = val!;
                      product.hasOption = val;
                    });
                  },
                  title: const Text(
                    "Product Has Options?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Visibility(
                  visible: product.hasOption!,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(
                      listItems,
                      (index) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            flex: 2,
                            child: TextInputWidget(
                              labelText: "Option",
                              hintText: "Blue",
                            ),
                          ),
                          // SizedBox(
                          //   width: 8,
                          // ),
                          const Expanded(
                            flex: 2,
                            child: TextInputWidget(
                              labelText: "Price",
                              hintText: "200",
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        listItems++;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.add_circle_outline_rounded,
                                      size: 20,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (listItems > 1) {
                                          listItems--;
                                        }
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle_outline_rounded,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextInputWidget(
                  initialValue: product.description,
                  maxLines: 5,
                  labelText: "Product Description",
                  //hintText: "Add a Descrption here",
                  onChanged: (val) {
                    return val!.isEmpty
                        ? product.description = ""
                        : product.description = val;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextInputWidget(
                  initialValue: product.quantity.toString(),
                  //maxLines: 5,
                  labelText: "In Stock Quantity",
                  //hintText: "1",
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Cannot be empty, enter a quantity";
                    } else if (validator.isNumeric(val) == false) {
                      return "Must be a number";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    product.quantity = int.parse(val!);
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          bool? validate = formKey.currentState!.validate();
                          if (validate) {
                            if (productController.isProductadded.value ==
                                false) {
                              Get.dialog(
                                const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            }
                            if (productController.downloadUrls.isNotEmpty) {
                              for (String? url
                                  in productController.downloadUrls) {
                                product.image!.add(url!);
                              }
                            }
                            formKey.currentState!.save();
                            productController.addAProduct(product!);
                            //debugPrint(hello);
                          }
                        },
                        style: TextButton.styleFrom(
                          // padding: EdgeInsets.symmetric(
                          //     horizontal: screenWidth * 0.24),
                          backgroundColor: Color(0xFF392F5A),
                          side: const BorderSide(color: Colors.white, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Edit Product",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
