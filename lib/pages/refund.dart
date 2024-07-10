import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/refund_cancellation_Controller.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/extras/banks_bank_code.dart';
import 'package:hair_main_street/models/refund_request_model.dart';
import 'package:hair_main_street/widgets/loading.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/lucide.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:recase/recase.dart';
import 'package:string_validator/string_validator.dart' as validator;

class RefundPage extends StatefulWidget {
  final String? orderId; // Pass the actual order ID as a String
  final num? paymentAmount;
  final String? reason;

  const RefundPage({
    super.key,
    required this.orderId,
    required this.paymentAmount,
    this.reason,
  });

  @override
  State<RefundPage> createState() => _RefundPageState();
}

class _RefundPageState extends State<RefundPage> {
  TextEditingController othersController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  BanksAndBankCodes banksAndBankCodes = BanksAndBankCodes();
  String? selectedReason; // Initial selected reason
  RefundCancellationController refundCancellationController =
      Get.find<RefundCancellationController>();
  UserController userController = Get.find<UserController>();
  GlobalKey<FormState> formKey = GlobalKey();
  String? bankName;
  String? bankCode;
  String? accountNumber;
  String? accountName;
  num? convenienceFee;
  num? expiredFee;

  @override
  void initState() {
    selectedReason = widget.reason ?? "Defective Product";
    if (userController.adminVariables.value?.convenienceFee != null) {
      convenienceFee =
          userController.adminVariables.value!.convenienceFee! / 100;
    } else {
      convenienceFee = 0;
    }
    if (userController.adminVariables.value?.expiredFee != null) {
      expiredFee = userController.adminVariables.value!.convenienceFee! / 100;
    } else {
      expiredFee = 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> banksandCodes =
        banksAndBankCodes.bankNamesWithBankCodes;
    RefundRequest refundRequest = RefundRequest(
        orderID: widget.orderId, userID: userController.userState.value!.uid!);
    showMyAlertDialog() {
      return Get.dialog(
          AlertDialog(
            elevation: 0,
            backgroundColor: Colors.white,
            titlePadding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            contentPadding: const EdgeInsets.fromLTRB(16, 2, 16, 10),
            title: const Text(
              "Refund Confirmation",
              style: TextStyle(
                fontSize: 19,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            content: Text(
              "Are you sure you want to request the refund? There may be charges",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.65),
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actionsPadding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 32),
                  //maximumSize: Size(screenWidth * 0.70, screenHeight * 0.10),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 1,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF673AB7),
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 32),
                  //maximumSize: Size(screenWidth * 0.70, screenHeight * 0.10),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 1,
                      color: Color(0xFF673AB7),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  refundCancellationController.isLoading.value = true;
                  if (refundCancellationController.isLoading.value == true) {
                    Get.dialog(const LoadingWidget());
                  }
                  await refundCancellationController
                      .submitRefundRequest(refundRequest);
                  // Perform the proceed action here
                  print('Proceed button clicked');
                  //Get.back();
                },
                child: const Text(
                  "Confirm",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          barrierDismissible: true);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded,
              size: 24, color: Colors.black),
        ),
        title: const Text(
          "Refund Request",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order ID Row
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xFF673AB7).withOpacity(0.30),
                ),
                //padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Text(
                      "Order ID:",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      widget.orderId!, // Display the actual order ID
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ],
                ),
              ),

              // Reason for Refund Row
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Reason for Refund:",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10.0),
                  widget.reason != null
                      ? Container(
                          alignment: Alignment.centerLeft,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            selectedReason!.titleCase,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        )
                      : PopupMenuButton<String>(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 0.5,
                            ),
                          ),
                          elevation: 0,
                          color: Colors.white,
                          initialValue: selectedReason,
                          //icon: const Icon(Icons.arrow_drop_down),
                          onSelected: (String? newValue) {
                            setState(() {
                              selectedReason = newValue!;
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: "Defective Product",
                              child: Text("Defective Product"),
                            ),
                            const PopupMenuItem<String>(
                              value: "Changed My Mind",
                              child: Text("Changed My Mind"),
                            ),
                            const PopupMenuItem<String>(
                              value: "Received Wrong Item",
                              child: Text("Received Wrong Item"),
                            ),
                            const PopupMenuItem<String>(
                              value: "Others",
                              child: Text("Others"),
                            ),
                          ],
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 0.6,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(
                                selectedReason!.titleCase,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              trailing: const Icon(Icons.arrow_drop_down),
                            ),
                          ),
                        ),
                ],
              ),
              Visibility(
                visible: selectedReason == "Others",
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: TextInputWidgetWithoutLabel(
                    controller: othersController,
                    hintText: "Specify Reason",
                    onChanged: (value) {
                      setState(() {
                        othersController.text = value!;
                        selectedReason = othersController.text;
                      });
                      return null;
                    },
                    validator: (value) {
                      if (value!.isEmpty && selectedReason == "Others") {
                        return "Please enter your reason";
                      }
                      return null;
                    },
                    maxLines: 3,
                    // decoration: const InputDecoration(
                    //   filled: true,
                    //   fillColor: Colors.white,
                    //   hintText: "Specify Reason",
                    //   border: OutlineInputBorder(
                    //     borderSide: BorderSide(color: Colors.black, width: 1),
                    //     borderRadius: BorderRadius.all(
                    //       Radius.circular(10),
                    //     ),
                    //   ),
                    // ),
                  ),
                ),
              ),

              // Text for additional details (optional)
              widget.reason != null
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            "Please provide additional details about your refund request (optional):",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        TextInputWidgetWithoutLabel(
                          controller: detailsController,
                          hintText: "Add extra details (optional)",
                          onChanged: (value) {
                            setState(() {
                              if (value!.isEmpty) {
                                detailsController.text = "";
                              }
                              detailsController.text = value;
                            });
                            return null;
                          },
                          maxLines: 5,
                          minLines: 3,
                          // decoration: const InputDecoration(
                          //   filled: true,
                          //   fillColor: Colors.white,
                          //   hintText: "Added Details",
                          //   border: OutlineInputBorder(
                          //     borderSide: BorderSide(color: Colors.black, width: 1),
                          //     borderRadius: BorderRadius.all(
                          //       Radius.circular(10),
                          //     ),
                          //   ),
                          // ),
                        ),

                        // Add a TextField or other widgets here for additional details
                      ],
                    ),
              const SizedBox(
                height: 12,
              ),

              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black.withOpacity(0.75),
                    width: 0.6,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Bank Details",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.65),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      "Bank Name",
                      style: TextStyle(
                        color: Color(0xFF673AB7),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Raleway',
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    DropdownSearch(
                      dropdownButtonProps: const DropdownButtonProps(
                        icon: Iconify(
                          Ic.baseline_keyboard_arrow_down,
                          size: 24,
                          color: Colors.black,
                        ),
                      ),
                      dropdownBuilder: (context, selectedItem) =>
                          selectedItem == null
                              ? Text(
                                  "Select Bank",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black.withOpacity(0.45),
                                  ),
                                )
                              : Text(
                                  selectedItem.toString().capitalizeFirst!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                      popupProps: PopupProps.dialog(
                        fit: FlexFit.loose,
                        itemBuilder: (context, item, isSelected) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            "${item.toString().capitalizeFirst}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        containerBuilder: (context, popupWidget) => Container(
                          //height: 400,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: popupWidget,
                        ),
                        searchFieldProps: TextFieldProps(
                          //expands: true,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 6,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            hintText: "Search",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w300,
                              color: Colors.black.withOpacity(0.55),
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              size: 20,
                              color: Colors.black.withOpacity(0.55),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.35),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFF673AB7), width: 1.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        title: const Text(
                          "Select Bank",
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        listViewProps: const ListViewProps(
                          primary: false,
                          shrinkWrap: true,
                        ),
                        showSearchBox: true,
                      ),
                      items: banksandCodes.keys.toList(),
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return "Please choose your Bank name";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          bankName = value.toString();
                        });
                      },
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFf5f5f5),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 10),
                          hintText: "Select Bank",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.35),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFF673AB7), width: 1.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintStyle: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.45),
                          ),
                        ),
                        baseStyle: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    TextInputWidget(
                      controller: accountNumberController,
                      labelText: "Account Number",
                      hintText: "",
                      maxLines: 1,
                      fontSize: 15,
                      labelColor: const Color(0xFF673AB7),
                      textInputType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your account number";
                        } else if (!validator.isNumeric(value)) {
                          return "Account Number must be numbers only";
                        } else if (value.length < 10) {
                          return 'Account Number must be > 10 numbers';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          accountNumber = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextInputWidget(
                      controller: accountNameController,
                      labelText: "Account Name",
                      hintText: "",
                      maxLines: 1,
                      fontSize: 15,
                      labelColor: const Color(0xFF673AB7).withOpacity(0.50),
                      textInputType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your account name";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          accountName = val!;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 14,
              ),

              Row(
                children: [
                  Icon(
                    Icons.info_outlined,
                    color: const Color(0xFF673AB7).withOpacity(0.50),
                    size: 20,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      "Refunds may attract charges and are subject to approval.\nOnce approved, the amount will be sent to the specified within 3 working days.\nThank you",
                      style: TextStyle(
                        fontFamily: 'Lato',
                        color: Colors.black.withOpacity(0.50),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              )

              // Submit button (optional)
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          height: kToolbarHeight,
          elevation: 0,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              // padding: EdgeInsets.symmetric(
              //     horizontal: screenWidth * 0.24),
              backgroundColor: const Color(0xFF673AB7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              var validated = formKey.currentState!.validate();
              if (validated) {
                formKey.currentState!.save();
                refundRequest.reason = selectedReason;
                if (selectedReason == widget.reason) {
                  refundRequest.refundAmount = (widget.paymentAmount! -
                      (widget.paymentAmount! * expiredFee!));
                } else if (selectedReason == "Defective Product" ||
                    selectedReason == "Received Wrong Item") {
                  refundRequest.refundAmount = widget.paymentAmount;
                } else {
                  refundRequest.refundAmount = (widget.paymentAmount! -
                      (widget.paymentAmount! * convenienceFee!));
                }
                refundRequest.refundAccountNumber = accountNumber;
                refundRequest.refundBankCode = banksandCodes[bankName];
                refundRequest.addedDetails = detailsController.text;
                showMyAlertDialog();
              }
              // Handle submit button press (e.g., submit refund request)
            },
            child: const Text(
              "Submit Refund Request",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
