import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/vendorController.dart';
import 'package:hair_main_street/controllers/walletController.dart';
import 'package:hair_main_street/widgets/loading.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:string_validator/string_validator.dart' as validator;

class WithdrawalPage extends StatefulWidget {
  const WithdrawalPage({super.key});

  @override
  State<WithdrawalPage> createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  VendorController vendorController = Get.find<VendorController>();
  WalletController walletController = Get.find<WalletController>();
  GlobalKey<FormState> formKey = GlobalKey();
  bool checkboxValue = false;
  TextEditingController? withdrawalAmountController = TextEditingController();
  TextEditingController? bankNameController = TextEditingController();
  TextEditingController? accountNumberController = TextEditingController();
  TextEditingController? accountNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String? withdrawalAmount;
    String? bankName;
    String? accountNumber;
    String? accountName;
    var screenHeight = Get.height;
    var vendorAccountDetails = vendorController.vendor.value!.accountInfo;
    bool checkBoxVisible = vendorAccountDetails != null;
    bool formVisible = checkboxValue == true ? true : false;

    String formatCurrency(String numberString) {
      final number =
          double.tryParse(numberString) ?? 0.0; // Handle non-numeric input
      final formattedNumber =
          number.toStringAsFixed(2); // Format with 2 decimals

      // Split the number into integer and decimal parts
      final parts = formattedNumber.split('.');
      final intPart = parts[0];
      final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

      // Format the integer part with commas for every 3 digits
      final formattedIntPart = intPart.replaceAllMapped(
        RegExp(r'\d{1,3}(?=(\d{3})+(?!\d))'),
        (match) => '${match.group(0)},',
      );

      // Combine the formatted integer and decimal parts
      final formattedResult = formattedIntPart + decimalPart;

      return formattedResult;
    }

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded,
              size: 20, color: Colors.black),
        ),
        title: const Text(
          'Withdrawal',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: Color(0xFF673AB7),
            fontFamily: 'Lato',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        //backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF673AB7).withOpacity(0.10),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.30),
                      width: 0.4,
                    ),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Amount Withdrawable:",
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontFamily: 'Lato',
                        ),
                      ),
                      Text(
                        "NGN${formatCurrency(walletController.wallet.value.withdrawableBalance.toString())}",
                        style: const TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF673AB7),
                          fontFamily: 'Lato',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextInputWidget(
                  labelColor: Color(0xFF673AB7).withOpacity(0.50),
                  labelText: 'Amount to Withdraw',
                  fontSize: 15,
                  validator: (val) {
                    if (!validator.isNumeric(val!)) {
                      return "Must Be a Number";
                    }
                    if (num.parse(val) >
                        walletController.wallet.value.withdrawableBalance!) {
                      return "Amount must be less or equal to withdrawable balance";
                    }
                    return null;
                  },
                  controller: withdrawalAmountController,
                  maxLines: 1,
                  hintText: "Enter Amount",
                  onChanged: (val) {
                    setState(() {
                      withdrawalAmountController!.text = val!;
                      withdrawalAmount = val;
                    });
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                Visibility(
                  visible: checkBoxVisible,
                  child: CheckboxListTile(
                    value: checkboxValue,
                    shape: CircleBorder(),
                    controlAffinity: ListTileControlAffinity.leading,
                    //side: BorderSide.none,
                    onChanged: (val) {
                      setState(() {
                        checkboxValue = val!;
                        print("val $val");
                        print("check box $checkboxValue");
                      });
                    },
                    title: const Text(
                      "Use the account details from your vendor profile?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Visibility(
                  visible: formVisible,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black38,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Account Name:",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Raleway',
                            color: Color(0xFF673AB7).withOpacity(0.50),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Divider(
                          height: 4,
                          color: Colors.transparent,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 4),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFFf5f5f5),
                            // border: Border.all(
                            //   color: Colors.black54,
                            //   width: 0.5,
                            // ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${vendorController.vendor.value!.accountInfo?["account name"]}",
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Lato',
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Divider(
                          height: 8,
                          color: Colors.transparent,
                        ),
                        Text(
                          "Account Number:",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Raleway',
                            color: Color(0xFF673AB7).withOpacity(0.50),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Divider(
                          height: 4,
                          color: Colors.transparent,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 4),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFFf5f5f5),
                            // border: Border.all(
                            //   color: Colors.black54,
                            //   width: 0.8,
                            // ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${vendorController.vendor.value!.accountInfo?["account number"]}",
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Lato',
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Divider(
                          height: 8,
                          color: Colors.transparent,
                        ),
                        Text(
                          "Bank Name:",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Raleway',
                            color: Color(0xFF673AB7).withOpacity(0.50),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Divider(
                          height: 4,
                          color: Colors.transparent,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 4),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFFf5f5f5),
                            // border: Border.all(
                            //   color: Colors.black54,
                            //   width: 0.8,
                            // ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${vendorController.vendor.value!.accountInfo?["bank name"]}",
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Lato',
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible:
                      checkboxValue == false || vendorAccountDetails == null,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      border: Border.all(
                        width: 0.5,
                        color: Colors.black.withOpacity(0.50),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Bank Details",
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.70),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        TextInputWidget(
                          labelColor: Color(0xFF673AB7).withOpacity(0.50),
                          fontSize: 15,
                          labelText: 'Account Name',
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Cannot be empty";
                            }
                            return null;
                          },
                          controller: accountNameController,
                          maxLines: 1,
                          hintText: "Enter Account Name",
                          onChanged: (val) {
                            setState(() {
                              accountNameController!.text = val!;
                              accountName = val;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextInputWidget(
                          labelColor: Color(0xFF673AB7).withOpacity(0.50),
                          labelText: 'Account Number',
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Cannot be empty";
                            }
                            if (!validator.isNumeric(val) ||
                                val.length < 10 ||
                                val.length > 10) {
                              return "Must be a number and upto and no more than 10 digits";
                            }
                            return null;
                          },
                          controller: accountNumberController,
                          fontSize: 15,
                          maxLines: 1,
                          hintText: "Enter Account Number",
                          onChanged: (val) {
                            setState(() {
                              accountNumberController!.text = val!;
                              accountNumber = val;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextInputWidget(
                          labelColor: Color(0xFF673AB7).withOpacity(0.50),
                          labelText: 'Bank Name',
                          fontSize: 15,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Cannot be empty";
                            }
                            return null;
                          },
                          controller: bankNameController,
                          maxLines: 1,
                          hintText: "Enter Bank Name",
                          onChanged: (val) {
                            setState(() {
                              bankNameController!.text = val!;
                              bankName = val;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          height: kToolbarHeight,
          color: Colors.white,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 4),
              backgroundColor: const Color(0xFF673AB7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              var isValid = formKey.currentState!.validate();
              if (isValid) {
                walletController.isLoading.value = true;
                if (walletController.isLoading.value) {
                  Get.dialog(const LoadingWidget());
                }
                if (checkboxValue == true) {
                  walletController.withdrawalRequest(
                      num.parse(withdrawalAmountController!.text),
                      {
                        "account name": vendorController
                            .vendor.value!.accountInfo?["account name"],
                        "account number": vendorController
                            .vendor.value!.accountInfo?["account number"],
                        "bank name": vendorController
                            .vendor.value!.accountInfo?["bank name"],
                      },
                      vendorController.vendor.value!.userID!);
                } else {
                  walletController.withdrawalRequest(
                      num.parse(withdrawalAmountController!.text),
                      {
                        "account name": accountNameController!.text,
                        "account number": accountNumberController!.text,
                        "bank name": bankNameController!.text,
                      },
                      vendorController.vendor.value!.userID!);
                }
                // Get.back();
              }
            },
            child: const Text(
              "Submit Request",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
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
