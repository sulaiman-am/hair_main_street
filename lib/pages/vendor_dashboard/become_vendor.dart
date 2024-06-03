import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/controllers/vendorController.dart';
import 'package:hair_main_street/extras/country_state.dart';
import 'package:hair_main_street/models/vendorsModel.dart';
import 'package:hair_main_street/widgets/loading.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:string_validator/string_validator.dart' as validator;

class BecomeAVendorPage extends StatefulWidget {
  const BecomeAVendorPage({super.key});

  @override
  State<BecomeAVendorPage> createState() => _BecomeAVendorPageState();
}

class _BecomeAVendorPageState extends State<BecomeAVendorPage> {
  Vendors vendor =
      Vendors(shopName: '', accountInfo: {}, contactInfo: {}, userID: "");
  CountryAndStatesAndLocalGovernment countryAndStatesAndLocalGovernment =
      CountryAndStatesAndLocalGovernment();
  TextEditingController? shopNameController,
      bankNameController,
      accountNumberController,
      accountNameController,
      streetAddressController,
      phoneNumberController,
      stateController = TextEditingController();
  String? country, state, localGovernment = "";
  GlobalKey<FormState> formKey = GlobalKey();
  UserController userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    Widget buildPicker(String label, List<String> items, String? selectedValue,
        Function(String?) onChanged) {
      return Card(
        color: Colors.white,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue,
                isDense: true,
                onChanged: onChanged,
                items: [
                  const DropdownMenuItem(
                    value: 'select',
                    child: Text('Select'),
                  ),
                  ...items.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      );
    }

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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurStyle: BlurStyle.normal,
                      offset: Offset.fromDirection(-4.0),
                      blurRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.black,
                      blurStyle: BlurStyle.normal,
                      offset: Offset.fromDirection(-2.0),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Shop Info",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextInputWidget(
                      controller: shopNameController,
                      labelText: "Shop Name",
                      hintText: "",
                      maxLines: 3,
                      minLines: 1,
                      textInputType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Your Shop Name";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          vendor.shopName = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurStyle: BlurStyle.normal,
                      offset: Offset.fromDirection(-4.0),
                      blurRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.black,
                      blurStyle: BlurStyle.normal,
                      offset: Offset.fromDirection(-2.0),
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Contact Info",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    buildPicker(
                      "Country",
                      countryAndStatesAndLocalGovernment.countryList,
                      vendor.contactInfo!["country"] ?? "select",
                      (val) => setState(() {
                        country = val;
                        vendor.contactInfo!["country"] = country;
                        vendor.contactInfo!["state"] = null;
                      }),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    buildPicker(
                      "State",
                      countryAndStatesAndLocalGovernment.statesList,
                      vendor.contactInfo!["state"] ?? "select",
                      (val) => setState(() {
                        state = val;
                        vendor.contactInfo!["state"] = state;
                        vendor.contactInfo!["local government"] = null;
                      }),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    buildPicker(
                      "Local Government",
                      countryAndStatesAndLocalGovernment
                              .stateAndLocalGovernments["$state"] ??
                          [],
                      vendor.contactInfo!["local government"] ?? "select",
                      (val) => setState(() {
                        localGovernment = val;
                        vendor.contactInfo!["local government"] =
                            localGovernment;
                      }),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    TextInputWidget(
                      controller: streetAddressController,
                      labelText: "Street Address",
                      hintText: "",
                      maxLines: 3,
                      minLines: 1,
                      textInputType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter the address of your shop";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          vendor.contactInfo!['street address'] = val!;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 4,
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
                        setState(() {
                          vendor.contactInfo!['phone number'] = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurStyle: BlurStyle.normal,
                      offset: Offset.fromDirection(-4.0),
                      blurRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.black,
                      blurStyle: BlurStyle.normal,
                      offset: Offset.fromDirection(-2.0),
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        setState(() {
                          vendor.accountInfo!['bank name'] = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 4,
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
                        setState(() {
                          vendor.accountInfo!['account number'] = val;
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
                      textInputType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your account name";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        vendor.accountInfo!['account name'] = val;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    bool? validate = formKey.currentState!.validate();
                    if (validate) {
                      if (state == null ||
                          country == null ||
                          localGovernment == null) {
                        userController
                            .showMyToast("Please Select a Country and State");
                      } else if (state == "select" ||
                          country == "select" ||
                          localGovernment == "select") {
                        userController
                            .showMyToast("Please Select a Country and State");
                      } else {
                        userController.isLoading.value = true;
                        if (userController.isLoading.value) {
                          Get.dialog(const LoadingWidget(),
                              barrierDismissible: false);
                        }
                        vendor.userID = userController.userState.value!.uid;
                        formKey.currentState!.save();
                        await userController.becomeASeller(vendor);
                      }
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
