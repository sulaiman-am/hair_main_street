import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/extras/country_state.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/widgets/text_input.dart';

class ChangeAddressWidget extends StatelessWidget {
  final String? text;
  final Function(Address)? onFilled;
  const ChangeAddressWidget({this.onFilled, this.text, super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();
    CountryAndStatesAndLocalGovernment countryAndStatesAndLocalGovernment =
        CountryAndStatesAndLocalGovernment();
    String? state, localGovernment, streetAddress, landmark, zipcode;
    TextEditingController streetAddressController = TextEditingController();
    TextEditingController landmarkController = TextEditingController();
    TextEditingController zipcodeController = TextEditingController();
    return StatefulBuilder(
      builder: (context, StateSetter setState) => AlertDialog(
        scrollable: true,
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(12),
        elevation: 0,
        content: SizedBox(
          height: 700,
          width: double.infinity,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "$text",
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Lato',
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Column(
                    children: [
                      buildPicker(
                          "State",
                          countryAndStatesAndLocalGovernment.statesList,
                          state, (val) {
                        setState(() {
                          state = val;
                          localGovernment = null;
                        });
                      }),
                      const SizedBox(
                        height: 4,
                      ),
                      buildPicker(
                          "Local Government",
                          countryAndStatesAndLocalGovernment
                                  .stateAndLocalGovernments[state] ??
                              [],
                          localGovernment ?? "select", (val) {
                        setState(() {
                          localGovernment = val;
                        });
                      }),
                      const SizedBox(
                        height: 4,
                      ),
                      TextInputWidgetWithoutLabelForDialog(
                        controller: streetAddressController,
                        // initialValue: vendorController
                        //         .vendor.value!.contactInfo!["street address"] ??
                        //     "",
                        hintText: "Enter Street Address",
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Cannot be Empty";
                          }
                          return null;
                        },
                        onChanged: (val) {
                          streetAddressController.text = val!;
                          streetAddress = streetAddressController.text;
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      TextInputWidgetWithoutLabelForDialog(
                        controller: landmarkController,
                        // initialValue: vendorController
                        //         .vendor.value!.contactInfo!["street address"] ??
                        //     "",
                        hintText: "Enter Landmark",
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Cannot be Empty";
                          }
                          return null;
                        },
                        onChanged: (val) {
                          landmarkController.text = val!;
                          landmark = landmarkController.text;
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      TextInputWidgetWithoutLabelForDialog(
                        controller: zipcodeController,
                        // initialValue: vendorController
                        //         .vendor.value!.contactInfo!["street address"] ??
                        //     "",
                        hintText: "Enter Zip Code",
                        textInputType: TextInputType.number,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Cannot be Empty";
                          }
                          return null;
                        },
                        onChanged: (val) {
                          zipcodeController.text = val!;
                          zipcode = zipcodeController.text;
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      TextInputWidgetWithoutLabelForDialog(
                        controller: zipcodeController,
                        // initialValue: vendorController
                        //         .vendor.value!.contactInfo!["street address"] ??
                        //     "",
                        hintText: "Enter Zip Code",
                        textInputType: TextInputType.number,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Cannot be Empty";
                          }
                          return null;
                        },
                        onChanged: (val) {
                          zipcodeController.text = val!;
                          zipcode = zipcodeController.text;
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      TextInputWidgetWithoutLabelForDialog(
                        controller: zipcodeController,
                        // initialValue: vendorController
                        //         .vendor.value!.contactInfo!["street address"] ??
                        //     "",
                        hintText: "Enter Zip Code",
                        textInputType: TextInputType.number,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Cannot be Empty";
                          }
                          return null;
                        },
                        onChanged: (val) {
                          zipcodeController.text = val!;
                          zipcode = zipcodeController.text;
                          return null;
                        },
                      ),
                    ],
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        side: const BorderSide(
                          width: 2,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      var validated = formKey.currentState!.validate();
                      if (validated) {
                        formKey.currentState!.save();
                        Address address = Address(
                          lGA: localGovernment,
                          zipCode: zipcode,
                        );

                        onFilled!(address);
                      }
                      Get.back();
                    },
                    child: const Text(
                      "Confirm Edit",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPicker(String label, List<String> items, String? selectedValue,
      Function(String?) onChanged) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
}

class BuildPicker extends StatelessWidget {
  const BuildPicker({
    super.key,
    this.label,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.labelColor,
    this.labelFontSize,
    this.hintText,
  });

  final String? label;
  final Color? labelColor;
  final double? labelFontSize;
  final List<String> items;
  final String? selectedValue;
  final Function(String? val) onChanged;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label == null
            ? const SizedBox.shrink()
            : Text(
                label!,
                style: TextStyle(
                  color: labelColor ?? Colors.black,
                  fontSize: labelFontSize ?? 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Lato',
                ),
              ),
        const SizedBox(
          height: 4,
        ),
        InputDecorator(
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                width: 0.1,
                color: Colors.black.withOpacity(0.35),
              ),
            ),
            fillColor: const Color(0xFFF5F5F5),
            filled: true,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue ?? hintText,
              isDense: true,
              onChanged: onChanged,
              items: [
                DropdownMenuItem(
                  value: hintText,
                  child: Text(
                    hintText ?? "",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.34),
                      fontSize: 15,
                      fontFamily: "Raleway",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ...items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: "Raleway",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
