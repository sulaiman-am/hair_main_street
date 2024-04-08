import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/productController.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/pages/menu.dart';
import 'package:recase/recase.dart';
import 'package:string_validator/string_validator.dart' as validator;
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:material_symbols_icons/symbols.dart';

class AddproductPage extends StatefulWidget {
  const AddproductPage({super.key});

  @override
  State<AddproductPage> createState() => _AddproductPageState();
}

class _AddproductPageState extends State<AddproductPage> {
  GlobalKey<FormState> formKey = GlobalKey();
  ProductController productController = Get.find<ProductController>();
  var _categoryValue = "natural hairs";
  var _availableValue = "Yes";

  bool checkbox1 = true;
  String? hello;
  bool checkbox2 = false;
  int listItems = 1;
  Product? product = Product(
    name: "",
    price: 0,
    quantity: 0,
    hasOption: false,
    allowInstallment: true,
    isAvailable: true,
    isDeleted: false,
    category: "",
    image: [],
    description: "",
  );
  TextEditingController? productName,
      productPrice,
      productDescription,
      quantity = TextEditingController();

  @override
  Widget build(BuildContext context) {
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

    showCancelDialog() {
      return Get.dialog(
        Center(
          child: Container(
            height: screenHeight * .24,
            width: screenWidth * .64,
            padding: const EdgeInsets.all(12),
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
                  "Are you sure you want to cancel \nproduct creation?",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
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
                        productController.imageList.clear();
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

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        } else {
          await showCancelDialog();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => showCancelDialog(),
            icon: const Icon(Symbols.arrow_back_ios_new_rounded,
                size: 24, color: Colors.black),
          ),
          title: const Text(
            'Add a Product',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          // flexibleSpace: Container(
          //   decoration: BoxDecoration(gradient: appBarGradient),
          // ),
          //backgroundColor: Colors.transparent,
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
          //decoration: BoxDecoration(gradient: myGradient),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                InkWell(
                  highlightColor: Colors.green,
                  splashColor: Colors.black,
                  onTap: () {
                    productController.selectImage();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    margin: EdgeInsets.fromLTRB(2, 2, 2, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey[200],
                      //shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF000000),
                          blurStyle: BlurStyle.normal,
                          //offset: Offset.fromDirection(16.0),
                          blurRadius: 2,
                        ),
                        // BoxShadow(
                        //   color: Color(0xFF000000),
                        //   blurStyle: BlurStyle.normal,
                        //   //offset: Offset.fromDirection(10),
                        //   blurRadius: 10,
                        // ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 32,
                          color: Colors.black26,
                        ),
                        Text(
                          "Upload up to 5 Images",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "(345x255 or larger recommended, up to 2.5MB each)",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                GetX<ProductController>(builder: (controller) {
                  return controller.imageList.isNotEmpty
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                                controller.imageList.length,
                                (index) => Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      color: Colors.black,
                                      width: screenWidth * 0.16,
                                      height: screenHeight * .08,
                                      child: Image.file(
                                        controller.imageList[index].absolute,
                                        fit: BoxFit.fill,
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
                                    )),
                          ))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: List.generate(4, (index) {
                              return Center(
                                widthFactor: 1,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
                                  alignment: Alignment.center,
                                  color: Colors.black,
                                  width: screenWidth * 0.16,
                                  height: screenHeight * .08,
                                ),
                              );
                            }),
                          ),
                        );
                }),
                const SizedBox(
                  height: 8,
                ),
                TextInputWidget(
                  controller: productName,
                  labelText: "Product Name",
                  hintText: "",
                  textInputType: TextInputType.text,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please enter the product name";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    product!.name = val;
                    hello = val;
                    debugPrint(product!.name);
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextInputWidget(
                  labelText: "Price",
                  hintText: "",
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
                    product!.price = int.parse(val!);
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        "Category:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: PopupMenuButton<String>(
                        //shadowColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        elevation: 10,
                        itemBuilder: (BuildContext context) {
                          return <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'natural hairs',
                              child: Text('Natural Hairs'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'accessories',
                              child: Text('Accessories'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'wigs',
                              child: Text('Wigs'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'lashes',
                              child: Text('Lashes'),
                            ),
                          ];
                        },
                        onSelected: (String value) {
                          setState(() {
                            _categoryValue = value;
                            product!.category = _categoryValue;
                            // _updateSelectedValue(
                            //     value); // Update Firestore with the new value
                          });
                        },
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          title: Text(
                            _categoryValue.titleCase,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_drop_down),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        "Available:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: PopupMenuButton<String>(
                        //shadowColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        elevation: 10,
                        itemBuilder: (BuildContext context) {
                          return <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Yes',
                              child: Text('Yes'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'No',
                              child: Text('No'),
                            ),
                          ];
                        },
                        onSelected: (String value) {
                          setState(() {
                            if (value == "Yes") {
                              _availableValue = value;
                              product!.isAvailable = true;
                            } else if (value == "No") {
                              _availableValue = value;
                              product!.isAvailable = false;
                            }
                            print(product!.isAvailable);
                            // _updateSelectedValue(
                            //     value); // Update Firestore with the new value
                          });
                        },
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          title: Text(
                            _availableValue.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_drop_down),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                CheckboxListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  value: checkbox1,
                  onChanged: (val) {
                    setState(() {
                      checkbox1 = val!;
                      product!.allowInstallment = val;
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
                  value: checkbox2,
                  onChanged: (val) {
                    setState(() {
                      checkbox2 = val!;
                      product!.hasOption = val;
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
                  visible: checkbox2,
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
                  maxLines: 5,
                  labelText: "Product Description",
                  hintText: "Add a Descrption here",
                  onChanged: (val) {
                    return val!.isEmpty
                        ? product!.description = ""
                        : product!.description = val;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextInputWidget(
                  //maxLines: 5,
                  labelText: "In Stock Quantity",
                  hintText: "1",
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Cannot be empty, enter a quantity";
                    } else if (validator.isNumeric(val) == false) {
                      return "Must be a number";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    product!.quantity = int.parse(val!);
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          bool? validate = formKey.currentState!.validate();
                          if (validate) {
                            await productController.uploadImage();
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
                                product!.image!.add(url!);
                              }
                            }
                            formKey.currentState!.save();
                            await productController.addAProduct(product!);
                            //debugPrint(hello);
                          }
                        },
                        style: TextButton.styleFrom(
                          // padding: EdgeInsets.symmetric(
                          //     horizontal: screenWidth * 0.24),
                          backgroundColor: Colors.black,
                          side: const BorderSide(color: Colors.white, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Create Product",
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
