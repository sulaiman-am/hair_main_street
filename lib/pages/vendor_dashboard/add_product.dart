import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/models/product_model.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:material_symbols_icons/symbols.dart';

class AddproductPage extends StatefulWidget {
  const AddproductPage({super.key});

  @override
  State<AddproductPage> createState() => _AddproductPageState();
}

class _AddproductPageState extends State<AddproductPage> {
  GlobalKey<FormState> formKey = GlobalKey();

  bool checkbox1 = true;
  String? hello;
  bool checkbox2 = false;
  int listItems = 1;
  ProductModel? product = ProductModel();
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
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
                onTap: () {},
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
                  child: Column(
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
                onSubmit: (val) {
                  product!.productName = val;
                  hello = val;
                  debugPrint(product!.productName);
                  return null;
                },
              ),
              SizedBox(
                height: 8,
              ),
              TextInputWidget(
                labelText: "Price",
                hintText: "",
                textInputType: TextInputType.text,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox(
                      value: checkbox1,
                      onChanged: (val) {
                        setState(() {
                          checkbox1 = val!;
                        });
                      }),
                  Text(
                    "Available for Installment",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox(
                      value: checkbox2,
                      onChanged: (val) {
                        setState(() {
                          checkbox2 = val!;
                        });
                      }),
                  Text(
                    "Product Has Options?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
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
              SizedBox(
                height: 8,
              ),
              TextInputWidget(
                maxLines: 5,
                labelText: "Product Description",
                hintText: "Add a Descrption here",
              ),
              SizedBox(
                height: 8,
              ),
              TextInputWidget(
                //maxLines: 5,
                labelText: "In Stock Quantity",
                hintText: "1",
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        bool? validate = formKey.currentState!.validate();
                        if (validate) {
                          formKey.currentState!.save();
                          debugPrint(product!.productName);
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
                        "Create",
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
    );
  }
}
