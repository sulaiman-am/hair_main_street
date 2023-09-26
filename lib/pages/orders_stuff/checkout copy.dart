import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:material_symbols_icons/symbols.dart';

class CheckOutPage2 extends StatefulWidget {
  final String? method;
  const CheckOutPage2({this.method, super.key});

  @override
  State<CheckOutPage2> createState() => _CheckOutPage2State();
}

class _CheckOutPage2State extends State<CheckOutPage2>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool? isVisible = true;
  List<bool>? isSelected = [true, false];
  String? dropdownValue;
  GlobalKey<FormState>? formKey = GlobalKey();
  TextEditingController amountController = TextEditingController();
  bool checkValue = true;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded,
              size: 24, color: Colors.black),
        ),
        title: const Text(
          'Check Out',
          style: TextStyle(
            fontSize: 32,
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
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, screenHeight * 0.08),
          child: AbsorbPointer(
            child: TabBar(
              controller: tabController,
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              indicator: BoxDecoration(
                color: Color(0xFF392F5A),
                borderRadius: BorderRadius.circular(12),
              ),
              tabs: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    "Confirm Order",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28, vertical: 4),
                  child: Text(
                    "Payment",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              indicatorColor: Colors.white,
            ),
          ),
        ),
        //backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
        height: screenHeight * 1,
        decoration: BoxDecoration(
          gradient: myGradient,
        ),
        child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: tabController,
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        width: 2,
                        color: Color(0xFF392F5A),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF000000),
                          blurStyle: BlurStyle.normal,
                          offset: Offset.fromDirection(-4.0),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Shipping To:",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "No 224 Darmanawa Gabas Kano",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Full name: ",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Muhammad Murtala Abdullahi",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Delivery Date:",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "30/09/2023",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 8,
                          color: Colors.black,
                          thickness: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              "Product Name:",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            )),
                            Expanded(
                                child: Text(
                              "Price",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              "Delivery Fee:",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            )),
                            Expanded(
                                child: Text(
                              "Price",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Tax:",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Price",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              "Order Total:",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            )),
                            Expanded(
                                child: Text(
                              "Price",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: checkValue,
                        onChanged: (newV) {
                          setState(() {
                            checkValue = newV!;
                            // debugPrint("$checkValue");
                            // debugPrint("$newV");
                          });
                        },
                      ),
                      Text(
                        "I agree with the",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "terms",
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                        ),
                      ),
                      Text(
                        "and",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "conditions",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      //alignment: Alignment.centerLeft,
                      backgroundColor: Color(0xFF392F5A),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                    ),
                    onPressed: () {
                      tabController.animateTo(1);
                    },
                    child: const Text(
                      "Proceed",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              Builder(builder: (context) {
                if (widget.method == "installment") {
                  return Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[200],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              child: Text(
                                "Pay \nInstallmentally",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Order Total Amount:",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                "Price",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Number of Installments:",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Expanded(
                                    child: DropdownMenu(
                                      // trailingIcon: Icon(
                                      //   Icons.arrow_drop_down_rounded,
                                      //   color: Colors.white,
                                      // ),
                                      // textStyle: TextStyle(
                                      //   color: Colors.white,
                                      // ),
                                      hintText: "Select",
                                      menuStyle: MenuStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color>(
                                          Colors.grey.shade200,
                                        ),
                                      ),
                                      //initialSelection: dropdownValue,
                                      onSelected: (val) {
                                        setState(() {
                                          dropdownValue = val!;
                                        });
                                      },
                                      dropdownMenuEntries:
                                          List.generate(3, (index) {
                                        int newIndex = index + 1;
                                        return DropdownMenuEntry(
                                          value: newIndex.toString(),
                                          label: "$newIndex",
                                        );
                                      }),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextInputWidget(
                                labelText: "Initial Installment Amount(NGN)",
                                hintText: "1000",
                                textInputType: TextInputType.number,
                                controller: amountController,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Enter an Amount";
                                  }
                                  return null;
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    tabController.animateTo(0);
                                  },
                                  style: TextButton.styleFrom(
                                    // padding: EdgeInsets.symmetric(
                                    //     horizontal: screenWidth * 0.24),
                                    backgroundColor: Colors.white,
                                    side: BorderSide(
                                        color: Color(0xFF392F5A), width: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Back",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: TextButton(
                                  onPressed: () {
                                    if (isVisible == true) {
                                      bool? validate =
                                          formKey?.currentState!.validate();
                                      if (validate!) {
                                        formKey?.currentState!.save();
                                        debugPrint("isVible true");
                                      }
                                    } else {
                                      debugPrint("isVible false");
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    // padding: EdgeInsets.symmetric(
                                    //     horizontal: screenWidth * 0.24),
                                    backgroundColor: Color(0xFF392F5A),
                                    side: BorderSide(
                                        color: Colors.white, width: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Proceed to Pay",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (widget.method == "once") {
                  return Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: screenHeight * 0.20,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[200],
                        ),
                        // padding: EdgeInsets.symmetric(
                        //   horizontal: 100,
                        // ),
                        child: Text(
                          "Pay Once",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order Total Amount:",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "Price",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                tabController.animateTo(0);
                              },
                              style: TextButton.styleFrom(
                                // padding: EdgeInsets.symmetric(
                                //     horizontal: screenWidth * 0.24),
                                backgroundColor: Colors.white,
                                side: BorderSide(
                                    color: Color(0xFF392F5A), width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Back",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: TextButton(
                              onPressed: () {},
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
                                "Proceed to Pay",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return Text("hello");
              }),
            ]),
      ),
    );
  }
}
