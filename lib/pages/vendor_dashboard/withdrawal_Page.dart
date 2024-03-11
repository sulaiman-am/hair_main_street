import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/vendorController.dart';
import 'package:hair_main_street/controllers/walletController.dart';
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
  @override
  Widget build(BuildContext context) {
    var screenHeight = Get.height;
    var vendorAccountDetails = vendorController.vendor.value!.accountInfo;
    TextEditingController? withdrawalAmountController = TextEditingController();
    TextEditingController? bankNameController = TextEditingController();
    TextEditingController? accountNumberController = TextEditingController();
    TextEditingController? accountNameController = TextEditingController();
    bool checkBoxVisible = vendorAccountDetails != null;
    bool formVisible = checkboxValue == true ? true : false;
    String? withdrawalAmount;
    String? bankName;
    String? accountNumber;
    String? accountName;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded,
              size: 24, color: Colors.black),
        ),
        title: const Text(
          'Request Withdrawal',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0E4D92),
          ),
        ),
        centerTitle: true,

        //backgroundColor: Colors.transparent,
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(8),
        //   color: Colors.white,
        // ),
        // margin:
        //     EdgeInsets.symmetric(horizontal: 12, vertical: screenHeight * 0.12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Amount Withdrawable: ",
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "₦${walletController.wallet.value.withdrawableBalance}",
                      style: const TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                TextInputWidgetWithoutLabelForDialog(
                  validator: (val) {
                    if (!validator.isNumeric(val!)) {
                      return "Must Be a Number";
                    }
                    if (num.parse(val) >
                        num.parse(walletController
                            .wallet.value.withdrawableBalance!)) {
                      return "Amount must be less or equal to withdrawable balance";
                    }
                    return null;
                  },
                  controller: withdrawalAmountController,
                  maxLines: 1,
                  hintText: "Amount to Withdraw",
                  onChanged: (val) {
                    withdrawalAmountController.text = val!;
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                Visibility(
                  visible: checkBoxVisible,
                  child: CheckboxListTile(
                    value: checkboxValue,
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
                        fontSize: 18,
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
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black38,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Account Name:",
                          style: TextStyle(
                            fontSize: 18,
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
                            border: Border.all(
                              color: Colors.black54,
                              width: 0.8,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${vendorController.vendor.value!.accountInfo?["account name"]}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Divider(
                          height: 8,
                          color: Colors.transparent,
                        ),
                        const Text(
                          "Account Number:",
                          style: TextStyle(
                            fontSize: 18,
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
                            border: Border.all(
                              color: Colors.black54,
                              width: 0.8,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${vendorController.vendor.value!.accountInfo?["account number"]}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Divider(
                          height: 8,
                          color: Colors.transparent,
                        ),
                        const Text(
                          "Bank Name:",
                          style: TextStyle(
                            fontSize: 18,
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
                            border: Border.all(
                              color: Colors.black54,
                              width: 0.8,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${vendorController.vendor.value!.accountInfo?["bank name"]}",
                            style: const TextStyle(
                              fontSize: 16,
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
                  child: Column(
                    children: [
                      TextInputWidgetWithoutLabelForDialog(
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Cannot be empty";
                          }
                          return null;
                        },
                        controller: accountNameController,
                        maxLines: 1,
                        hintText: "Account Name",
                        onChanged: (val) {
                          accountNameController.text = val!;
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextInputWidgetWithoutLabelForDialog(
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
                        maxLines: 1,
                        hintText: "Account Number",
                        onChanged: (val) {
                          accountNumberController.text = val!;
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextInputWidgetWithoutLabelForDialog(
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Cannot be empty";
                          }
                          return null;
                        },
                        controller: bankNameController,
                        maxLines: 1,
                        hintText: "Bank Name",
                        onChanged: (val) {
                          bankNameController.text = val!;
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF392F5A),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1.2,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      var isValid = formKey.currentState!.validate();
                      if (isValid) {
                        // print(
                        //     "${bankNameController.text} + ${accountNameController.text} + ${accountNumberController.text},");
                        if (checkboxValue == true) {
                          walletController.withdrawalRequest(
                              withdrawalAmountController.text,
                              {
                                "account name": vendorController
                                    .vendor.value!.accountInfo?["account name"],
                                "account number": vendorController.vendor.value!
                                    .accountInfo?["account number"],
                                "bank name": vendorController
                                    .vendor.value!.accountInfo?["bank name"],
                              },
                              vendorController.vendor.value!.userID!);
                        } else {
                          walletController.withdrawalRequest(
                              withdrawalAmountController.text,
                              {
                                "account name": accountNameController.text,
                                "account number": accountNumberController.text,
                                "bank name": bankNameController.text,
                              },
                              vendorController.vendor.value!.userID!);
                        }
                        if (walletController.isLoading.value) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const Center(
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                );
                              });
                        } else {
                          Get.back();
                        }
                        // Get.back();
                      }
                    },
                    child: const Text(
                      "Submit Request",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
