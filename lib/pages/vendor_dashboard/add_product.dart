import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/productController.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:hair_main_street/pages/menu.dart';
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
            'Add a Product',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(
                0xFFFF8811,
              ),
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: appBarGradient),
          ),
          //backgroundColor: Colors.transparent,
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
          decoration: BoxDecoration(gradient: myGradient),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                InkWell(
                  highlightColor: Colors.green,
                  splashColor: Colors.black,
                  onTap: () {
                    productController.uploadImage();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    margin: EdgeInsets.fromLTRB(2, 2, 2, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey[200],
                      //shape: BoxShape.circle,
                      boxShadow: [
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
                SizedBox(
                  height: 8,
                ),
                GetX<ProductController>(builder: (controller) {
                  return Visibility(
                    visible: controller.downloadUrls.isNotEmpty,
                    child: SingleChildScrollView(
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(controller.downloadUrls.length,
                            (index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            color: Colors.black,
                            width: screenWidth * 0.25,
                            height: screenHeight * .16,
                            child: Image.network(
                              "${controller.downloadUrls[index]}",
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
                          );
                        }),
                      ),
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
                          Expanded(
                            flex: 2,
                            child: TextInputWidget(
                              labelText: "Option",
                              hintText: "Blue",
                            ),
                          ),
                          // SizedBox(
                          //   width: 8,
                          // ),
                          Expanded(
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
                                    icon: Icon(
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
                                    icon: Icon(
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
                        onPressed: () {
                          bool? validate = formKey.currentState!.validate();
                          if (validate) {
                            if (productController.downloadUrls.isNotEmpty) {
                              for (String? url
                                  in productController.downloadUrls) {
                                product!.image!.add(url!);
                              }
                            }
                            formKey.currentState!.save();
                            productController.addAProduct(product!);
                            debugPrint(product!.name);
                            debugPrint(product!.quantity.toString());
                            debugPrint(product!.price.toString());
                            debugPrint(product!.image.toString());
                            //debugPrint(hello);
                          }
                        },
                        style: TextButton.styleFrom(
                          // padding: EdgeInsets.symmetric(
                          //     horizontal: screenWidth * 0.24),
                          backgroundColor: Color(0xFF392F5A),
                          side: BorderSide(color: Colors.white, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
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
