import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/productController.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/pages/menu.dart';
import 'package:hair_main_street/widgets/loading.dart';
import 'package:string_validator/string_validator.dart' as validator;
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:recase/recase.dart';

class EditProductPage extends StatefulWidget {
  final String? productID;
  const EditProductPage({this.productID, super.key});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  GlobalKey<FormState> formKey = GlobalKey();
  ProductController productController = Get.find<ProductController>();

  String? _initialCategoryValue;
  String? _initialAvailability;

  bool checkbox1 = true;
  String? hello;
  bool checkbox2 = false;
  int listItems = 1;
  TextEditingController? productName,
      productPrice,
      productDescription,
      quantity = TextEditingController();
  List<TextEditingController> lengthControllers = [];
  List<TextEditingController> colorControllers = [];
  List<TextEditingController> priceControllers = [];
  List<TextEditingController> stockControllers = [];
  List<ProductOption> options = [];

  @override
  void initState() {
    var product = productController.getSingleProduct(widget.productID!);
    if (product!.category == null) {
      _initialCategoryValue = "natural hairs";
    } else {
      _initialCategoryValue = product.category;
    }

    if (product.isAvailable == null) {
      _initialAvailability = "Yes";
    } else {
      if (product.isAvailable!) {
        _initialAvailability = "Yes";
      } else {
        _initialAvailability = "No";
      }
    }

    if (product.hasOptions == true) {
      if (product.options != null) {
        for (var option in product.options!) {
          lengthControllers.add(TextEditingController());
          colorControllers.add(TextEditingController());
          priceControllers.add(TextEditingController());
          stockControllers.add(TextEditingController());
          print(option.color);
          print(option.length);
        }
        options = product.options!;
      }
    }
    super.initState();
  }

  void addOption() {
    setState(() {
      options.add(
          ProductOption(length: "", color: "", price: 0, stockAvailable: 0));
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
      options.removeAt(index);
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

    return PopScope(
      canPop: false,
      onPopInvoked: (bool val) async {
        if (val) {
          return;
        } else {
          return await showCancelDialog();
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
            'Edit Product',
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
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          //decoration: BoxDecoration(gradient: myGradient),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GetX<ProductController>(
                    builder: (_) {
                      return Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  product!.image!.length,
                                  (index) => InkWell(
                                    onTap: () {
                                      Get.dialog(
                                        AlertDialog(
                                          elevation: 0,
                                          backgroundColor: Colors.white,
                                          contentPadding: EdgeInsets.zero,
                                          content: SizedBox(
                                            height: screenHeight * 0.60,
                                            width: screenWidth * 0.64,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Image.network(
                                                    "${product.image![index]}",
                                                    fit: BoxFit.contain,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return const Text(
                                                        "Error \nLoading \nImage...",
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await productController
                                                        .deleteProductImage(
                                                      product.image![index],
                                                      "products",
                                                      "image",
                                                      product.productID,
                                                      index,
                                                    );
                                                    Get.back();
                                                  },
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.black,
                                                    shape:
                                                        RoundedRectangleBorder(
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
                                                    "Delete Image",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
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
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          _.imageList.isEmpty
                              ? const SizedBox.shrink()
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(
                                      productController.imageList.length,
                                      (index) => InkWell(
                                        onTap: () {
                                          Get.dialog(
                                            AlertDialog(
                                              elevation: 0,
                                              backgroundColor: Colors.white,
                                              contentPadding: EdgeInsets.zero,
                                              content: SizedBox(
                                                //height: screenHeight * 0.60,
                                                width: screenWidth * 0.64,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Image.file(
                                                        productController
                                                            .imageList[index],
                                                        fit: BoxFit.contain,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return const Text(
                                                            "Error \nLoading \nImage...",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        _.deleteLocalImage(
                                                            index);
                                                        Get.back();
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.black,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 4,
                                                          vertical: 2,
                                                        ),
                                                        elevation: 2,
                                                      ),
                                                      child: const Text(
                                                        "Delete Image",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
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
                                          child: Image.file(
                                            productController.imageList[index],
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
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                productController.selectImage();
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
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
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
                      if (val!.isEmpty) {
                      } else {
                        product!.name = val;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextInputWidget(
                    controller: productPrice,
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
                      if (val!.isEmpty) {
                      } else {
                        product.price = int.parse(val);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
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
                              _initialCategoryValue = value;
                              product.category = _initialCategoryValue;
                              //_updateSelectedValue(value); // Update Firestore with the new value
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
                              _initialCategoryValue.toString().titleCase,
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
                    children: [
                      const Expanded(
                        flex: 1,
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
                              _initialAvailability = value;
                              if (_initialAvailability == "Yes") {
                                product.isAvailable = true;
                              } else if (_initialAvailability == "No") {
                                product.isAvailable = false;
                              }
                              print(_initialAvailability);
                              //_updateSelectedValue(value); // Update Firestore with the new value
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
                              _initialAvailability.toString().titleCase,
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
                  // CheckboxListTile(
                  //   contentPadding:
                  //       const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  //   value: product.allowInstallment,
                  //   onChanged: (val) {
                  //     setState(() {
                  //       checkbox1 = val!;
                  //       product.allowInstallment = val;
                  //     });
                  //   },
                  //   title: const Text(
                  //     "Available for Installment",
                  //     style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  CheckboxListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    value: product.hasOptions,
                    onChanged: (val) {
                      setState(() {
                        checkbox2 = val!;
                        product.hasOptions = val;
                        if (val == true) {
                          addOption();
                        } else {
                          options.clear();
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
                    visible: product.hasOptions!,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: List.generate(
                        options.length,
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
                                        initialValue:
                                            options[index].length ?? "",
                                        controller: lengthControllers[index],
                                        fontSize: 14,
                                        labelText: "Length",
                                        hintText: "24 inch",
                                        validator: (val) {
                                          if (val!.isEmpty &&
                                              options[index].color == null) {
                                            return "You must at least fill this";
                                          } else if (val.isEmpty &&
                                              options[index].color!.isEmpty) {
                                            return "You must at least fill this";
                                          }
                                          return null;
                                        },
                                        onChanged: (val) {
                                          setState(() {
                                            if (val!.isEmpty) {
                                              options[index].length = null;
                                            } else {
                                              options[index].length = val;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.maxFinite,
                                      child: TextInputWidget(
                                        initialValue:
                                            options[index].color ?? "",
                                        controller: colorControllers[index],
                                        fontSize: 14,
                                        labelText: "Colour",
                                        hintText: "Blue",
                                        validator: (val) {
                                          if (val!.isEmpty &&
                                              options[index].length == null) {
                                            return "You must at least fill this";
                                          } else if (val.isEmpty &&
                                              options[index].length!.isEmpty) {
                                            return "You must at least fill this";
                                          }
                                          return null;
                                        },
                                        onChanged: (val) {
                                          setState(() {
                                            if (val!.isEmpty) {
                                              options[index].color = null;
                                            } else {
                                              options[index].color = val;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    // SizedBox(
                                    //   width: 8,
                                    // ),
                                    SizedBox(
                                      width: double.maxFinite,
                                      child: TextInputWidget(
                                        textInputType: TextInputType.number,
                                        controller: priceControllers[index],
                                        initialValue:
                                            options[index].price.toString(),
                                        fontSize: 14,
                                        labelText: "Price",
                                        hintText: "200",
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return "Please Enter a Value";
                                          } else if (!val.isNum) {
                                            return "Must be a Number";
                                          }
                                          return null;
                                        },
                                        onChanged: (val) {
                                          setState(() {
                                            if (val!.isEmpty) {
                                            } else {
                                              options[index].price =
                                                  num.parse(val);
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.maxFinite,
                                      child: TextInputWidget(
                                        controller: stockControllers[index],
                                        initialValue: options[index]
                                            .stockAvailable
                                            .toString(),
                                        textInputType: TextInputType.number,
                                        fontSize: 14,
                                        labelText: "Stock Available",
                                        hintText: "10",
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return "Please Enter a Value";
                                          } else if (!val.isNum) {
                                            return "Must be a Number";
                                          }
                                          return null;
                                        },
                                        onChanged: (val) {
                                          setState(() {
                                            if (val!.isEmpty) {
                                            } else {
                                              options[index].stockAvailable =
                                                  int.parse(val);
                                            }
                                          });
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
                                          // listItems++;
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
                                          if (options.length > 1) {
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
                    initialValue: product.description,
                    maxLines: 5,
                    labelText: "Product Description",
                    //hintText: "Add a Descrption here",
                    onChanged: (val) {
                      setState(() {
                        val!.isEmpty
                            ? product.description = ""
                            : product.description = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextInputWidget(
                    controller: productPrice,
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
                      if (val!.isEmpty) {
                      } else {
                        product.quantity = int.parse(val);
                      }
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
                              productController.isLoading.value = true;
                              if (productController.isLoading.value == true) {
                                Get.dialog(const LoadingWidget());
                              }
                              if (productController.imageList.isNotEmpty) {
                                await productController.uploadImage();
                              }
                              if (productController.downloadUrls.isNotEmpty) {
                                for (String? url
                                    in productController.downloadUrls) {
                                  product.image!.add(url!);
                                }
                              }
                              formKey.currentState!.save();
                              if (options.isNotEmpty) {
                                print(options.first.color);
                                product.options ??= options;
                              }
                              await productController.updateProduct(product);
                              //debugPrint(hello);
                            }
                          },
                          style: TextButton.styleFrom(
                            // padding: EdgeInsets.symmetric(
                            //     horizontal: screenWidth * 0.24),
                            backgroundColor: Colors.black,
                            side:
                                const BorderSide(color: Colors.white, width: 2),
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
      ),
    );
  }
}
