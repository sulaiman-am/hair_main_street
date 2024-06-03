import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/productController.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/pages/menu.dart';
import 'package:hair_main_street/widgets/loading.dart';
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
  List<TextEditingController> lengthControllers = [];
  List<TextEditingController> colorControllers = [];
  List<TextEditingController> priceControllers = [];
  List<TextEditingController> stockControllers = [];

  bool checkbox1 = true;
  String? hello;
  bool checkbox2 = false;
  int listItems = 1;
  Product? product = Product(
    name: "",
    price: 0,
    quantity: 0,
    hasOptions: false,
    allowInstallment: true,
    isAvailable: true,
    isDeleted: false,
    category: "",
    image: [],
    description: "",
    options: [],
  );
  TextEditingController? productName,
      productPrice,
      productDescription,
      quantity = TextEditingController();

  void addOption() {
    setState(() {
      product!.options!.add(
          ProductOption(length: '', color: "", price: 0.0, stockAvailable: 0));
      lengthControllers.add(TextEditingController());
      colorControllers.add(TextEditingController());
      priceControllers.add(TextEditingController());
      stockControllers.add(TextEditingController());
    });
  }

  void removeOption(int index) {
    setState(() {
      print("removed");
      lengthControllers.removeAt(index);
      colorControllers.removeAt(index);
      priceControllers.removeAt(index);
      stockControllers.removeAt(index);
      product!.options!.removeAt(index);
    });
  }

  String? validateFields(int index) {
    if (lengthControllers[index].text.isEmpty &&
        colorControllers[index].text.isEmpty) {
      return 'Either length or color must be filled.';
    }
    return null;
  }

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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    highlightColor: Colors.green,
                    splashColor: Colors.black,
                    onTap: () {
                      productController.selectImage();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 28, vertical: 12),
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
                      //hello = val;
                      debugPrint(product!.name);
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextInputWidget(
                    controller: productPrice,
                    labelText: "Price",
                    hintText: "",
                    textInputType: TextInputType.number,
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
                        product!.hasOptions = val;
                        if (val) {
                          addOption();
                        } else {
                          removeOption(0);
                        }
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
                        product!.options!.length,
                        (index) => Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 0.8),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.maxFinite,
                                      child: TextInputWidget(
                                        controller: lengthControllers[index],
                                        fontSize: 14,
                                        labelText: "Length",
                                        hintText: "24 Inches",
                                        validator: (val) {
                                          if (val!.isEmpty &&
                                              product!.options![index].color ==
                                                  null) {
                                            return "You must at least fill this";
                                          } else if (val.isEmpty &&
                                              product!.options![index].color!
                                                  .isEmpty) {
                                            return "You must at least fill this";
                                          }
                                          return null;
                                        },
                                        onChanged: (val) {
                                          setState(() {
                                            if (val!.isEmpty) {
                                              product!.options![index].length =
                                                  null;
                                            }
                                            product!.options![index].length =
                                                val;
                                          });
                                          // return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.maxFinite,
                                      child: TextInputWidget(
                                        controller: lengthControllers[index],
                                        fontSize: 14,
                                        labelText: "Colour",
                                        hintText: "Blue",
                                        validator: (val) {
                                          if (val!.isEmpty &&
                                              product!.options![index].length ==
                                                  null) {
                                            return "You must at least fill this";
                                          } else if (val.isEmpty &&
                                              product!.options![index].length!
                                                  .isEmpty) {
                                            return "You must at least fill this";
                                          }
                                          return null;
                                        },
                                        onChanged: (val) {
                                          setState(() {
                                            if (val!.isEmpty) {
                                              product!.options![index].color =
                                                  null;
                                            }
                                            product!.options![index].color =
                                                val;
                                          });
                                          // return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.maxFinite,
                                      child: TextInputWidget(
                                        textInputType: TextInputType.number,
                                        controller: priceControllers[index],
                                        fontSize: 14,
                                        labelText: "Price",
                                        hintText: "200",
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return 'Please Enter an Option Name';
                                          }
                                          return null;
                                        },
                                        onChanged: (val) {
                                          setState(() {
                                            product!.options![index].price =
                                                num.parse(val!);
                                          });
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.maxFinite,
                                      child: TextInputWidget(
                                        controller: stockControllers[index],
                                        textInputType: TextInputType.number,
                                        fontSize: 14,
                                        labelText: "Stock Available",
                                        hintText: "10",
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return 'Please Enter an Option Name';
                                          }
                                          return null;
                                        },
                                        onChanged: (val) {
                                          setState(() {
                                            product!.options![index]
                                                    .stockAvailable =
                                                int.parse(val!);
                                          });
                                          return;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          addOption();
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
                                          if (product!.options!.length > 1) {
                                            removeOption(index);
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextInputWidget(
                    controller: productDescription,
                    maxLines: 5,
                    labelText: "Product Description",
                    hintText: "Add a Descrption here",
                    onChanged: (val) {
                      setState(() {
                        val!.isEmpty
                            ? product!.description = ""
                            : product!.description = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextInputWidget(
                    controller: quantity,
                    textInputType: TextInputType.number,
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
                              if (productController.imageList.isNotEmpty) {
                                await productController.uploadImage();
                              }
                              if (productController.isProductadded.value ==
                                  false) {
                                Get.dialog(
                                  const LoadingWidget(),
                                );
                              }
                              if (productController.downloadUrls.isNotEmpty) {
                                for (String? url
                                    in productController.downloadUrls) {
                                  product!.image!.add(url!);
                                }
                              }
                              if (product!.category == "") {
                                product!.category = _categoryValue;
                              }
                              formKey.currentState!.save();
                              //print(product!.options);
                              await productController.addAProduct(product!);
                              //debugPrint(hello);
                            }
                          },
                          style: TextButton.styleFrom(
                            // padding: EdgeInsets.symmetric(
                            //     horizontal: screenWidth * 0.24),
                            backgroundColor: Colors.black,
                            side:
                                const BorderSide(color: Colors.white, width: 1),
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
      ),
    );
  }
}
