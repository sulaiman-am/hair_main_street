import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/models/vendorsModel.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:string_validator/string_validator.dart' as validator;

class BecomeAVendorPage extends StatelessWidget {
  const BecomeAVendorPage({super.key});

  @override
  Widget build(BuildContext context) {
    Vendors vendor =
        Vendors(shopName: '', accountInfo: {}, contactInfo: {}, userID: "");
    TextEditingController? shopNameController,
        bankNameController,
        accountNumberController,
        accountNameController,
        streetAddressController,
        phoneNumberController,
        stateController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey();
    UserController userController = Get.find<UserController>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Become A Vendor',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
            size: 24,
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          children: [
            TextInputWidget(
              controller: shopNameController,
              labelText: "Shop Name",
              hintText: "",
              maxLines: 3,
              textInputType: TextInputType.text,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please Enter Your Shop Name";
                }
                return null;
              },
              onChanged: (val) {
                vendor.shopName = val;
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextInputWidget(
              controller: streetAddressController,
              labelText: "Street Address",
              hintText: "",
              maxLines: 2,
              textInputType: TextInputType.text,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter the address of your shop";
                }
                return null;
              },
              onChanged: (val) {
                vendor.contactInfo!['street address'] = val!;
                return null;
              },
            ),
            TextInputWidget(
              controller: stateController,
              labelText: "State",
              hintText: "Lagos",
              maxLines: 1,
              textInputType: TextInputType.text,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter the state of your shop";
                }
                return null;
              },
              onChanged: (val) {
                vendor.contactInfo!['state'] = val;
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextInputWidget(
              controller: phoneNumberController,
              labelText: "Phone Number",
              hintText: "",
              maxLines: 1,
              textInputType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter your business phone number";
                } else if (!validator.isNumeric(value)) {
                  return "Phone number must be numbers only";
                } else if (value.length < 10) {
                  return "Phone Number must be > 10 characters";
                }
                return null;
              },
              onChanged: (val) {
                vendor.contactInfo!['phone number'] = val;
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextInputWidget(
              controller: bankNameController,
              labelText: "Bank Name",
              hintText: "First Bank",
              maxLines: 1,
              textInputType: TextInputType.text,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter your bank name";
                }
                return null;
              },
              onChanged: (val) {
                vendor.accountInfo!['bank name'] = val;
                return null;
              },
            ),
            TextInputWidget(
              controller: accountNumberController,
              labelText: "Account Number",
              hintText: "",
              maxLines: 1,
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
                vendor.accountInfo!['account number'] = val;
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextInputWidget(
              controller: accountNameController,
              labelText: "Account Name",
              hintText: "",
              maxLines: 1,
              textInputType: TextInputType.text,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter your account name";
                }
                return null;
              },
              onChanged: (val) {
                vendor.accountInfo!['account name'] = val;
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                bool? validate = formKey.currentState!.validate();
                if (validate) {
                  vendor.userID = userController.userState.value!.uid;
                  formKey.currentState!.save();
                }
              },
              style: TextButton.styleFrom(
                // padding: EdgeInsets.symmetric(
                //     horizontal: screenWidth * 0.24),
                backgroundColor: Colors.black,
                side: const BorderSide(color: Colors.white, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Submit Request",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
